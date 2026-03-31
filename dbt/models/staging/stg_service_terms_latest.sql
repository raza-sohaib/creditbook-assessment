{{ config(materialized='ephemeral') }}

select * from {{ source('staging', 'service_terms_latest') }}
