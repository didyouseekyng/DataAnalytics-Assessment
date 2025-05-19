--  FIND ACCOUNTS INACTIVE FOR 365+ DAYS

-- Savings: last transaction date per savings plan
SELECT 
  s.plan_id,
  s.owner_id,
  'Savings' AS type,
  MAX(s.transaction_date) AS last_transaction_date,
  DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
WHERE p.is_deleted = 0
GROUP BY s.plan_id, s.owner_id
HAVING MAX(s.transaction_date) < (CURRENT_DATE - INTERVAL 365 DAY)

UNION ALL

-- Investments: last transaction date based on plan.created_on (if no savings records)
SELECT 
  p.id AS plan_id,
  p.owner_id,
  'Investment' AS type,
  MAX(s.transaction_date) AS last_transaction_date,
  DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s ON s.plan_id = p.id
WHERE p.is_deleted = 0 AND p.is_a_fund = 1
GROUP BY p.id, p.owner_id
HAVING MAX(s.transaction_date) IS NULL OR MAX(s.transaction_date) < (CURRENT_DATE - INTERVAL 365 DAY);
