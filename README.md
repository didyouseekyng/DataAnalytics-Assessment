# SQL Assessment – Savings & Investment Insights

This project involved writing SQL queries to extract business insights from Cowrywise. The tasks focused on customer behavior, account activity, and estimated value. Below is a summary of my approach to each task, challenges encountered, and any assumptions made.

---

## Task 1: Customers with Both Funded Savings & Investment Plans

**Approach:**
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- Used `is_regular_savings = 1` for savings, and `is_a_fund = 1` for investment plans.
- Filtered for funded plans using `confirmed_amount > 0`.
- Aggregated savings and investment counts and total deposit values.

**Challenges:**
- Distinguishing savings vs investment plans from one table.
- Filtering only *funded* plans with transactions.

**Assumptions:**
- Plans with `confirmed_amount > 0` are considered active/funded.
- All amount fields are in **kobo**, so they were converted to **naira**.

---

## Task 2: Categorize Customers by Transaction Frequency

**Approach:**
- Counted monthly transactions per user.
- Averaged transaction counts across all active months.
- Categorized users as:
  - **High Frequency:** ≥10
  - **Medium Frequency:** 3–9
  - **Low Frequency:** ≤2

**Challenges:**
- MySQL doesn’t support `DATE_TRUNC`, so used `DATE_FORMAT(..., '%Y-%m')` instead.
- Handling users with inconsistent transaction activity.

**Assumptions:**
- Only `savings_savingsaccount` transactions were considered.

---

## Task 3: Inactive Accounts in the Last 1 Year

**Approach:**
- Identified accounts with no transactions in the past 365 days.
- Queried both savings and investment plans.
- Used `MAX(transaction_date)` and `DATEDIFF()` to calculate inactivity.

**Challenges:**
- Investment plans may have no transactions at all.
- Had to check for both `NULL` and outdated dates.

**Assumptions:**
- Plans marked as `is_deleted = 1` were ignored.
- Only considered confirmed transactions.

---

## Task 4: Estimate Customer Lifetime Value (CLV)

**Approach:**
- Used formula:  
  `CLV = (total_transactions / tenure_months) × 12 × 0.1% × avg_transaction_value`
- Calculated tenure from `date_joined`.
- Aggregated average `confirmed_amount` (converted to naira).

**Challenges:**
- Avoiding division by zero for tenure (handled using `GREATEST(..., 1)`).
- Confirmed amounts in kobo required conversion.

**Assumptions:**
- Profit per transaction is 0.1% of transaction value.
- Monthly projection assumes even activity distribution.

---

## General Notes

- **Joins:** Most queries required joining `users_customuser`, `plans_plan`, and `savings_savingsaccount` via `owner_id` and `plan_id`.
- **Conversions:** All money amounts are stored in **kobo**, and were converted to **naira** for readability and accuracy.
- **SQL Dialect:** MySQL 5.7+ syntax was used, ensuring compatibility with the `DATE_FORMAT` and `TIMESTAMPDIFF` functions.

---

## Summary

This exercise strengthened my ability to:
- Work with real-world financial data models.
- Apply SQL logic to business scenarios.
- Handle time, currency, and aggregation-based logic.

