-- Staging model for eligibility
{{ config(materialized='table') }}

SELECT
    eligibility_id,
    member_id,
    plan_id,
    start_date,
    end_date,
    is_eligible
FROM {{ ref('eligibility') }}
WHERE is_eligible = true  -- Filter active eligibilities
