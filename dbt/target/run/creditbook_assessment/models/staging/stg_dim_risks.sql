
  create view "creditbook"."analytics_staging"."stg_dim_risks__dbt_tmp"
    
    
  as (
    select * from "creditbook"."raw"."dim_risks"
  );