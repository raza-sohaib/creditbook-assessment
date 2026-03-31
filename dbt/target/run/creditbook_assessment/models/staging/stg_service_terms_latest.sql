
  create view "creditbook"."analytics_staging"."stg_service_terms_latest__dbt_tmp"
    
    
  as (
    select * from "creditbook"."raw"."service_terms_latest"
  );