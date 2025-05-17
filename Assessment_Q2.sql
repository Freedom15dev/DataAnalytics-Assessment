-- Step 1: Get each customer’s total transactions and number of active months
-- i use the savings_savingsaccount table to count transactions.
-- To calculate months active, we subtract the first transaction date from the last and convert it into months.

WITH user_monthly_activity AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS active_months
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'  -- Optional: filter only successful transactions
    GROUP BY s.owner_id
),

-- Now i divided the total transactions by active months to get monthly frequency per user.


user_transaction_rate AS (
    SELECT
        owner_id,
        ROUND(total_transactions / active_months, 2) AS avg_tx_per_month
    FROM user_monthly_activity
),

-- i grouped each user into a frequency bucket (High, Medium, or Low) based on how often they transact.
-- Then i  count the users in each category and compute their average monthly transactions.
categorized_users AS (
    SELECT
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM user_transaction_rate
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
