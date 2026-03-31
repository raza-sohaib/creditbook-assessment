
  create view "creditbook"."analytics_staging"."stg_dim_entity_products__dbt_tmp"
    
    
  as (
    select * from "creditbook"."raw"."dim_entity_products"
  );