-- Staging model for providers
{{ config(materialized='table') }}

SELECT
    provider_id,
    name,
    specialty,
    location,
    license_number
FROM {{ ref('providers') }}
WHERE license_number IS NOT NULL  -- Filter valid providers