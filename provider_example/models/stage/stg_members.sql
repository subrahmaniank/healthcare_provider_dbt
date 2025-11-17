-- Staging model for members
{{ config(materialized='table') }}

SELECT
    member_id,
    name,
    age,
    gender,
    enrollment_date
FROM {{ ref('members') }}
WHERE age >= 18  -- Adults only (example rule)
