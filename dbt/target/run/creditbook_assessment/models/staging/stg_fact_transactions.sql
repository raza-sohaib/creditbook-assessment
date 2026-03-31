
  create view "creditbook"."analytics_staging"."stg_fact_transactions__dbt_tmp"
    
    
  as (
    select * from "creditbook"."raw"."fact_transactions"
  );