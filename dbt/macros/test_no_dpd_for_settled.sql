{% test no_dpd_for_settled(model, status_column, dpd_column) %}
select *
from {{ model }}
where upper(coalesce({{ status_column }}, '')) = 'SETTLED'
  and coalesce({{ dpd_column }}, 0) > 0
{% endtest %}
