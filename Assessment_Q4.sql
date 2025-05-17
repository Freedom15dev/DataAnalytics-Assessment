-- STEP 1: Calculate total transaction value per customer
WITH transaction_summary AS (
    SELECT
        s.owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_value
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0  -- Only count inflow transactions
    GROUP BY s.owner_id
),

-- STEP 2: Get account signup date and calculate tenure in months
tenure_data AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
),

-- STEP 3: Combine both and compute estimated CLV
clv_calc AS (
    SELECT
        t.customer_id,
        td.name,
        td.tenure_months,
        t.total_transactions,
        
        -- Avoid division by zero (set tenure to 1 if tenure is 0)
        ROUND(((t.total_value * 0.001) / NULLIF(td.tenure_months, 0)) * 12, 2) AS estimated_clv
    FROM transaction_summary t
    JOIN tenure_data td ON t.customer_id = td.customer_id
)

-- Final output: ordered by highest CLV
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM clv_calc
ORDER BY estimated_clv DESC;
