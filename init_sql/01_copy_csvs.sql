COPY staging.dim_entities FROM '/seed_data/dim_entities.csv' WITH (FORMAT csv, HEADER true);
COPY staging.dim_partners FROM '/seed_data/dim_partners.csv' WITH (FORMAT csv, HEADER true);
COPY staging.dim_financiers FROM '/seed_data/dim_financiers.csv' WITH (FORMAT csv, HEADER true);
COPY staging.dim_entity_products FROM '/seed_data/dim_entity_products.csv' WITH (FORMAT csv, HEADER true);
COPY staging.dim_risks FROM '/seed_data/dim_risks.csv' WITH (FORMAT csv, HEADER true);
COPY staging.services_latest FROM '/seed_data/services_latest.csv' WITH (FORMAT csv, HEADER true);
COPY staging.service_terms_latest FROM '/seed_data/service_terms_latest.csv' WITH (FORMAT csv, HEADER true);
COPY staging.fact_transactions FROM '/seed_data/fact_transactions.csv' WITH (FORMAT csv, HEADER true);
