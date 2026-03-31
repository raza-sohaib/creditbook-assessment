{{
  config(
    materialized='incremental',
    unique_key='service_id',
    schema='marts',
    on_schema_change='sync_all_columns'
  )
}}

WITH last_transaction AS (
	SELECT service_id,
	       transaction_date,
	       total_pending_amount
	FROM (
	    SELECT service_id, transaction_date, transaction_order, total_pending_amount,
	           ROW_NUMBER() OVER (
	               PARTITION BY service_id
	               ORDER BY transaction_order DESC
	           ) AS rn
	    FROM {{ ref('stg_fact_transactions') }}
        {% if is_incremental() %}
          WHERE created_at >= CURRENT_TIMESTAMP - interval '2 hours'
        {% endif %}
	) t
	WHERE rn = 1
),

risk AS (
    SELECT
        entity_id,
        financier_id,
        product_id,
        credit_rating,
        probability_of_default
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY entity_id, financier_id, product_id
                ORDER BY updated_at DESC
            ) AS rn
        FROM {{ ref('stg_dim_risks') }}
    ) t
    WHERE rn = 1
),

loan_performance AS (
	SELECT 
		sl.service_id,
		sl.entity_id,
		sl.partner_id,
		sl.financier_id,
		sl.type,
		sl.entity_type,
		sl.current_status,
		sl.requested_amount,
		sl.currency_code,
        sl.updated_at,
		de.business_name,
		de.full_name,
		dp.partner_name,
		dr.credit_rating,
		lt.transaction_date,
		lt.total_pending_amount,
		stl.tenor,
		CASE
	        WHEN COALESCE(lt.total_pending_amount, 0) > 0
	            THEN current_date - lt.transaction_date::date
	        ELSE 0
	    END AS dpd_days,
	    (current_date - stl.disbursement_date::date) as elapsed_days,
	    stl.markup * (1 - dr.probability_of_default) as risk_adjusted_return
	FROM {{ ref('stg_services_latest') }} sl
	JOIN last_transaction lt
		ON sl.service_id = lt.service_id
	LEFT JOIN {{ ref('stg_service_terms_latest') }} stl 
		ON sl.service_id = stl.service_id 
	LEFT JOIN {{ ref('stg_dim_entities') }} de 
		ON sl.entity_id = de.entity_id AND de.valid_to >= '9999-12-31'
	LEFT JOIN {{ ref('stg_dim_partners') }} dp
		ON sl.partner_id = dp.partner_id AND dp.valid_to >= '9999-12-31'
	LEFT JOIN risk dr
		ON sl.entity_id  = dr.entity_id  AND sl.financier_id  = dr.financier_id  AND sl.product_id = dr.product_id 
)

SELECT 
    service_id,
	entity_id,
	partner_id,
	financier_id,
    type,
    business_name,
    full_name,
    entity_type,
    partner_name,
    credit_rating,
    requested_amount,
    currency_code,
    current_status,
    total_pending_amount,
    risk_adjusted_return,
	dpd_days AS dpd,
    CASE
        WHEN dpd_days = 0 THEN '0 Days'
        WHEN dpd_days BETWEEN 1 AND 30 THEN '1-30 Days'
        WHEN dpd_days BETWEEN 31 AND 60 THEN '31-60 Days'
        WHEN dpd_days BETWEEN 61 AND 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END AS dpd_bucket,
    CASE
        WHEN nullif(tenor, 0) IS NOT NULL
             AND (elapsed_days::NUMERIC / nullif(tenor * 365, 0)) < 0.25
             AND dpd_days > 7
        THEN true
        ELSE false
    END AS early_default_risk,
    updated_at
FROM loan_performance