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
