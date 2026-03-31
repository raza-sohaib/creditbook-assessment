
      
        
        
        delete from "creditbook"."marts"."mart_loan_performance" as DBT_INTERNAL_DEST
        where (service_id) in (
            select distinct service_id
            from "mart_loan_performance__dbt_tmp142617476528" as DBT_INTERNAL_SOURCE
        );

    

    insert into "creditbook"."marts"."mart_loan_performance" ("service_id", "entity_id", "partner_id", "financier_id", "type", "business_name", "full_name", "entity_type", "partner_name", "credit_rating", "requested_amount", "currency_code", "current_status", "total_pending_amount", "risk_adjusted_return", "dpd", "dpd_bucket", "early_default_risk", "updated_at")
    (
        select "service_id", "entity_id", "partner_id", "financier_id", "type", "business_name", "full_name", "entity_type", "partner_name", "credit_rating", "requested_amount", "currency_code", "current_status", "total_pending_amount", "risk_adjusted_return", "dpd", "dpd_bucket", "early_default_risk", "updated_at"
        from "mart_loan_performance__dbt_tmp142617476528"
    )
  