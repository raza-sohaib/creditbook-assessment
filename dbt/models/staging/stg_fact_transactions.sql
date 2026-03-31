{{ config(materialized='ephemeral') }}

select * from {{ source('staging', 'fact_transactions') }}
