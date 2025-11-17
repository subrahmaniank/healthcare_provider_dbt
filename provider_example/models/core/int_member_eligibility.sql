-- Intermediate model: Join members, eligibility, and plans
{{ config(materialized='table') }}

SELECT
    m.member_id,
    m.name,
    m.age,
    m.gender,
    m.enrollment_date,
    e.plan_id,
    p.plan_name,
    e.start_date AS eligibility_start,
    e.end_date AS eligibility_end
FROM {{ ref('stg_members') }} m
INNER JOIN {{ ref('stg_eligibility') }} e
    ON m.member_id = e.member_id
INNER JOIN {{ ref('stg_plans') }} p
    ON e.plan_id = p.plan_id
WHERE CURRENT_DATE BETWEEN e.start_date AND e.end_date  -- Active eligibilities only