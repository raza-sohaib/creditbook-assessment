
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
select *
from "creditbook"."marts"."mart_loan_performance"
where upper(coalesce(current_status, '')) = 'SETTLED'
  and coalesce(dpd, 0) > 0

  
  
      
    ) dbt_internal_test