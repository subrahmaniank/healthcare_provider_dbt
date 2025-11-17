-- Staging model for claims
{{ config(materialized='table') }}

SELECT
    claim_id,
    member_id,
    plan_id,
    claim_date,
    service_type,
    amount,
    status,
    provider_id
FROM {{ ref('claims') }}
WHERE amount > 0 AND status != 'Denied' AND provider_id IS NOT NULL  -- Filter valid/approved claims with providers