-- Test that eligibility end_date is on or after start_date
{{ config(severity = 'warn') }}

SELECT
    member_id,
    plan_id,
    eligibility_start,
    eligibility_end
FROM {{ ref('int_member_eligibility') }}
WHERE eligibility_end < eligibility_start
