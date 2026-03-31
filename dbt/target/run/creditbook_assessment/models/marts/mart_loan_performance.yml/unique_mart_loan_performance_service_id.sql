
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    service_id as unique_field,
    count(*) as n_records

from "creditbook"."marts"."mart_loan_performance"
where service_id is not null
group by service_id
having count(*) > 1



  
  
      
    ) dbt_internal_test