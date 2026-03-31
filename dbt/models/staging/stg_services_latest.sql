{{ config(materialized='ephemeral') }}

select * from {{ source('staging', 'services_latest') }}
