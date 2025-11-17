-- Final model: Eligible members with claims summary, including providers
{{ config(materialized='table') }}

SELECT
    me.member_id,
    me.name,
    me.plan_name,
    COUNT(c.claim_id) AS total_claims,
    SUM(c.amount) AS total_claim_amount,
    MAX(c.claim_date) AS last_claim_date,
    GROUP_CONCAT(c.service_type, ', ') AS services_claimed,
    GROUP_CONCAT(pr.name, ', ') AS providers_involved  -- New: List of providers
FROM {{ ref('int_member_eligibility') }} me
LEFT JOIN {{ ref('stg_claims') }} c
    ON me.member_id = c.member_id AND me.plan_id = c.plan_id
LEFT JOIN {{ ref('stg_providers') }} pr
    ON c.provider_id = pr.provider_id  -- Join providers via claims
WHERE c.claim_date BETWEEN me.eligibility_start AND me.eligibility_end  -- Claims within eligibility period
GROUP BY
    me.member_id, me.name, me.plan_name
HAVING total_claims > 0