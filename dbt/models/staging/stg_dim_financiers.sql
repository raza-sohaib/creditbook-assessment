{{ config(materialized='ephemeral') }}

select * from {{ source('staging', 'dim_financiers') }}
