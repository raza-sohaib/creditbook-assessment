
  create view "creditbook"."analytics_staging"."stg_dim_entities__dbt_tmp"
    
    
  as (
    select * from "creditbook"."raw"."dim_entities"
  );