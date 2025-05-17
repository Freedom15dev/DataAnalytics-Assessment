-- STEP 1: i got the most recent inflow (confirmed_amount > 0) per plan
WITH last_inflow_per_plan AS (
    SELECT
        s.plan_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0  -- inflow transactions
    GROUP BY s.plan_id
),

--  Join with the full list of active plans to check activity
plan_activity_check AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        -- Categorize plan type
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        
        -- If a plan has no inflow, fall back to its creation date
        COALESCE(l.last_transaction_date, p.created_on) AS last_transaction_date,

        -- Calculate number of inactive days from last inflow or creation
        DATEDIFF(CURDATE(), COALESCE(l.last_transaction_date, p.created_on)) AS inactivity_days

    FROM plans_plan p
    LEFT JOIN last_inflow_per_plan l ON p.id = l.plan_id

    -- Only include plans that are active (not archived or deleted)
    WHERE p.is_archived = 0 AND p.is_deleted = 0
)

--  Return only plans with over 1 year of inactivity
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM plan_activity_check
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;
