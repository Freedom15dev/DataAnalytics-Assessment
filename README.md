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



