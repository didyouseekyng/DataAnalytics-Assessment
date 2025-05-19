-- CALCULATE AVERAGE MONTHLY TRANSACTIONS PER USER

WITH user_monthly_transactions AS (
  SELECT 
    owner_id,
    DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month,
    COUNT(*) AS txn_count
  FROM savings_savingsaccount
  GROUP BY owner_id, txn_month
),

user_avg_monthly_txns AS (
  SELECT 
    owner_id,
    ROUND(AVG(txn_count), 2) AS avg_transactions_per_month
  FROM user_monthly_transactions
  GROUP BY owner_id
),

categorized_users AS (
  SELECT 
    CASE
      WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
      WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category,
    avg_transactions_per_month
  FROM user_avg_monthly_txns
)

SELECT 
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY 
  CASE 
    WHEN frequency_category = 'High Frequency' THEN 1
    WHEN frequency_category = 'Medium Frequency' THEN 2
    ELSE 3
  END;
