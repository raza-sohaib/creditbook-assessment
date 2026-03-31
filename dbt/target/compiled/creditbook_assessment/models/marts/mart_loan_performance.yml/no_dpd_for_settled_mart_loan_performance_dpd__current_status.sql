
select *
from "creditbook"."marts"."mart_loan_performance"
where upper(coalesce(current_status, '')) = 'SETTLED'
  and coalesce(dpd, 0) > 0
