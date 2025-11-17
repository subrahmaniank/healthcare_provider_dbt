-- Staging model for plans
{{ config(materialized='table') }}

SELECT
    plan_id,
    plan_name,
    coverage_type,
    premium_monthly
FROM {{ ref('plans') }}
WHERE premium_monthly > 0  -- Filter valid plans
