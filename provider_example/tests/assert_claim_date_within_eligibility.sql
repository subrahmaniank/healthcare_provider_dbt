-- Test that claim_date is within the eligibility period for the member
{{ config(severity = 'warn') }}
SELECT
    c.claim_id,
    c.member_id,
    c.claim_date,
    e.start_date,
    e.end_date
FROM {{ ref('stg_claims') }} c
JOIN {{ ref('stg_eligibility') }} e
    ON c.member_id = e.member_id
    AND c.plan_id = e.plan_id
WHERE c.claim_date < e.start_date OR c.claim_date > e.end_date
