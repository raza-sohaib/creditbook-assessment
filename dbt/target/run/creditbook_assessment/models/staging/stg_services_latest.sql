
  create view "creditbook"."analytics_staging"."stg_services_latest__dbt_tmp"
    
    
  as (
    select * from "creditbook"."raw"."services_latest"
  );