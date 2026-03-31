create schema if not exists staging;

create table if not exists staging.dim_entities (
    entity_id text,
    personal_entity_id text,
    business_entity_id text,
    broker_id text,
    relationship_id text,
    relationship text,
    business_name text,
    full_name text,
    phone_number text,
    national_document_id text,
    business_national_document_id text,
    dob text,
    personal_compliance_status text,
    business_compliance_status text,
    street_address text,
    city text,
    state text,
    country text,
    type text,
    business_type text,
    is_registered boolean,
    created_at timestamp,
    updated_at timestamp,
    scd_id text,
    scd_updated_at timestamp,
    valid_from timestamp,
    valid_to timestamp
);

create table if not exists staging.dim_partners (
    partner_id text,
    broker_id text,
    region_id text,
    status text,
    default_product_id text,
    created_at timestamp,
    updated_at timestamp,
    scd_id text,
    scd_updated_at timestamp,
    valid_from timestamp,
    valid_to timestamp,
    partner_name text
);

create table if not exists staging.dim_financiers (
    financier_id text,
    broker_id text,
    region_id text,
    product_id text,
    status text,
    product_revenue_share numeric,
    created_at timestamp,
    updated_at timestamp,
    scd_id text,
    scd_updated_at timestamp,
    valid_from timestamp,
    valid_to timestamp,
    financier_name text
);

create table if not exists staging.dim_entity_products (
    entity_product_id text,
    partner_id text,
    financier_id text,
    entity_id text,
    entity_full_name text,
    external_user_id text,
    external_customer_id text,
    product_id text,
    risk_id text,
    is_suspended boolean,
    activation_date timestamp,
    expiry_date timestamp,
    created_at timestamp,
    updated_at timestamp
);

create table if not exists staging.dim_risks (
    risk_id text,
    broker_id text,
    entity_id text,
    financier_id text,
    product_id text,
    entity_product_id text,
    industry text,
    credit_rating text,
    proposed_credit_limit numeric,
    credit_limit_currency text,
    risk_engine_name text,
    risk_engine_version text,
    probability_of_default numeric,
    expected_loss_given_default numeric,
    aggregate_obligor_score numeric,
    risk_status text,
    status_timestamp timestamp,
    created_at timestamp,
    updated_at timestamp
);

create table if not exists staging.services_latest (
    service_id text,
    broker_id text,
    region_id text,
    financier_id text,
    partner_id text,
    type text,
    entity_id text,
    entity_type text,
    entity_full_name text,
    current_status text,
    status_timestamp timestamp,
    status_actor text,
    requested_amount numeric,
    disbursement_bank_accounts text,
    product_id text,
    product_partner_id text,
    product_region_id text,
    entity_product_id text,
    loan_level_agreements boolean,
    product_fees text,
    currency_code text,
    currency_precision integer,
    __v integer,
    distributor_id text,
    created_at timestamp,
    updated_at timestamp
);

create table if not exists staging.service_terms_latest (
    service_id text,
    broker_id text,
    region_id text,
    row_index integer,
    principal numeric,
    markup numeric,
    tenor integer,
    disbursement_date timestamp,
    due_date timestamp,
    repaid_principal numeric,
    repaid_markup numeric,
    repaid_fee numeric,
    pending_principal numeric,
    pending_markup numeric,
    pending_fee numeric,
    updated_at timestamp
);

create table if not exists staging.fact_transactions (
    service_id text,
    credr_transaction_id text,
    transaction_date timestamp,
    created_at timestamp,
    transaction_order integer,
    transaction_type text,
    transaction_amount numeric,
    payment_method text,
    pending_principal numeric,
    pending_markup numeric,
    pending_fee numeric,
    total_pending_amount numeric,
    repaid_principal numeric,
    repaid_markup numeric,
    repaid_fee numeric,
    total_repaid_amount numeric
);
