Question 1 – High-Value Customers with Multiple Products
Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.



What the Output Shows:
Column Name	Description
owner_id	The user’s unique ID
name	The user's full name
savings_count	Number of regular savings plans
investment_count	Number of investment fund plans
total_deposits	Total amount of confirmed deposits

How the Query Works:
Step 1: Count Each User’s Plans
I started by checking how many savings and investment plans each user has:

A savings plan is marked with is_regular_savings = 1

An investment plan is marked with is_a_fund = 1
I used COUNT(DISTINCT ...) to avoid double-counting any plans.

Step 2: Calculate Total Deposits
Next, I calculated how much each user has actually deposited.
Only confirmed deposits were included (confirmed_amount IS NOT NULL), and I rounded the totals to 2 decimal places for accuracy.

Step 3: Combine Everything and Filter
Finally, I joined the user data with the results from Steps 1 and 2.
Then I filtered to include only users who have both a savings plan and an investment plan.
The results are sorted by deposit amount (from highest to lowest), and I limited the output to the top 100 users.

![Image](https://github.com/user-attachments/assets/a4739a8d-0aa0-4371-9ea9-6b9caa2a1e07)

Question 2 – Transaction Frequency Analysis
Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)


How the Query Works:
Step 1: Get Total Transactions and Active Months
For each user, I counted the number of transactions from the savings_savingsaccount table.
To figure out how long they've been active, I calculated the number of months between their first and last confirmed transaction.

Step 2: Calculate Average Transactions per Month
Here, I divided the total number of transactions by the number of active months.
This gave me the average number of transactions per month for each user — a good measure of how frequently they use their account.

Step 3: Categorize and Summarize
Based on their monthly average, I grouped users into:

High frequency (e.g., very regular transactions)

Medium frequency

Low frequency (minimal or infrequent activity)

Finally, I summarized the data, counting how many users fall into each category and calculating their average monthly transactions.

![Image](https://github.com/user-attachments/assets/f4986451-3794-4f00-976e-c39100f49fa3)


Question 3 – Account Inactivity Alert
Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) 


How the Query Works:
Step 1: Get the Last Inflow per Plan
I checked the savings_savingsaccount table to find the most recent deposit (where confirmed_amount > 0) for each plan.
This gives us the last time money came into each plan.
I grouped the results by plan_id to keep it plan-specific.

Step 2: Join with Active Plans
Next, I pulled in only active plans from the plans_plan table — meaning they are not deleted or archived.
I used a LEFT JOIN so that even plans with no deposit history at all would still be included.
If a plan has never had a deposit, I fall back to using the plan’s created_on date instead.

Step 3: Calculate Days of Inactivity and Filter
I then calculated how many days have passed since the last inflow (or creation date, if no inflow exists).
Finally, I filtered the results to return only plans that have been inactive for more than 365 days.

![Image](https://github.com/user-attachments/assets/2b514461-8456-41fa-adf5-25f63c7fb87e)

Question 4 – Customer Lifetime Value (CLV) Estimation
Objective:
The marketing team wants to know how valuable each customer is over time. So in this query, we estimate Customer Lifetime Value (CLV) using how long they've been active and how often they deposit.

What We Calculated for Each User:
Tenure (in months) – How long the user has been on the platform

Total confirmed transactions – How many valid deposits they’ve made

Estimated CLV – Using a simplified formula based on transaction behavior

The CLV Formula Used:
CLV =(Total Transactions/Tenure (in months)) × 12 × Average Profit per Transaction
We assumed average profit per transaction = 0.1% of the transaction amount.

How the Query Works:
Step 1: Calculate Tenure (Months Since Signup)
We took the number of days between today and the user’s signup date (date_joined) and converted it into months (by dividing by 30).
This gives us how long each user has been with us.

Step 2: Aggregate Confirmed Transactions
We looked at the savings_savingsaccount table to count all confirmed transactions (confirmed_amount > 0) for each user.
These are assumed to be actual deposit inflows.

Step 3: Estimate CLV
We applied the CLV formula above for each user.
To avoid errors, we used NULLIF to make sure we don’t divide by zero (for users with tenure less than 1 month).

![Image](https://github.com/user-attachments/assets/2b514461-8456-41fa-adf5-25f63c7fb87e)





Notes & Challenges


Working on this assessment gave me a solid chance to approach SQL from a real business angle, not just textbook examples. It wasn’t all smooth,I faced a few practical challenges along the way:

Figuring Out Table Relationships
Some tables weren’t clearly connected, especially linking plans_plan to savings_savingsaccount. I had to carefully study column names (like plan_id and owner_id) and use trial and error to connect the dots and get the correct joins.

Understanding the Table Structure
The savings_savingsaccount table had a lot of columns, and it wasn’t obvious how to separate inflows from outflows since there was no column like transaction_type. I later figured out that positive confirmed_amount values meant inflows, that insight became very important for answering Questions 3 and 4.

Fixing SQL Errors from Wrong Assumptions
At first, I tried using columns like created_at or transaction_type, which didn’t actually exist. This led to a few “Unknown column” errors in MySQL. I had to go back, double-check the schema, and use correct names like created_on.

Avoiding Division by Zero
While calculating CLV in Question 4, I realized that some users were too new and had zero months of tenure. Dividing by zero would break the query, so I used NULLIF() to prevent errors and keep things clean.

Keeping Queries Readable
I used CTEs (Common Table Expressions) to break queries into steps. This made the SQL easier to read and debug, even though it might not be the most performance-optimized style for very large datasets. For this kind of project, clarity was more important.





THANK YOU FOR YOUR TIME 



FREEDOM OBOH

