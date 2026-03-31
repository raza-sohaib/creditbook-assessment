
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select financier_id
from "creditbook"."marts"."mart_loan_performance"
where financier_id is null



  
  
      
    ) dbt_internal_test