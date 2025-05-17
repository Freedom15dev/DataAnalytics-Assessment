-- STEP 1: Count how many savings and investment plans each user (owner) has.
-- - A "Regular Savings" plan is identified by the condition: is_regular_savings = 1
-- - An "Investment" plan is identified by the condition: is_a_fund = 1
-- - I use COUNT(DISTINCT ...) to avoid counting duplicate plan IDs
-- - Grouping by owner_id to get one row per user
WITH plan_counts AS (
    SELECT 
        owner_id,
        COUNT(DISTINCT CASE WHEN is_regular_savings = 1 THEN id END) AS savings_count,
        COUNT(DISTINCT CASE WHEN is_a_fund = 1 THEN id END) AS investment_count
    FROM plans_plan
    GROUP BY owner_id
),

-- STEP 2: I Calculated the total confirmed deposit amounts per user.
-- - i only included deposits where `confirmed_amount` is NOT NULL.
-- - Use CASE to skip over NULLs and avoid erros.
-- - ROUND the total to 2 decimal places for consistency.
-- - Grouped by owner_id to get each user’s total deposits.

deposit_totals AS (
    SELECT 
        owner_id,
        ROUND(SUM(CASE WHEN confirmed_amount IS NOT NULL THEN confirmed_amount ELSE 0 END), 2) AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)

-- STEP 3: I Combined the  user data with savings/investment counts and total deposits.
-- - Join `users_customuser` with `plan_counts` and `deposit_totals` to bring everything together.
-- - Filter for users who have at least one regular savings plan AND at least one investment plan.
-- - Sort the final result in descending order of total deposits (highest to lowest).
-- - Limit the result to the top 100 users for performance or reporting purposes.
SELECT 
    u.id AS owner_id,
    u.name,
    pc.savings_count,
    pc.investment_count,
    dt.total_deposits
FROM users_customuser u
JOIN plan_counts pc ON u.id = pc.owner_id
JOIN deposit_totals dt ON u.id = dt.owner_id
WHERE pc.savings_count > 0 AND pc.investment_count > 0
ORDER BY dt.total_deposits DESC
LIMIT 100;
