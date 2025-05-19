-- IDENTIFY USERS WITH BOTH A FUNDED SAVINGS AND INVESTMENT PLAN

SELECT 
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS full_name,
  COUNT(DISTINCT s.id) AS savings_count,
  COUNT(DISTINCT p.id) AS investment_count,
  ROUND(COALESCE(SUM(s.confirmed_amount), 0) / 100 + COALESCE(SUM(p.amount), 0) / 100, 2) AS total_deposits
FROM users_customuser u

-- Join funded savings accounts linked to savings plans
JOIN savings_savingsaccount s 
  ON u.id = s.owner_id AND s.confirmed_amount > 0
JOIN plans_plan sp 
  ON s.plan_id = sp.id AND sp.is_regular_savings = 1

-- Join funded investment plans
JOIN plans_plan p 
  ON u.id = p.owner_id AND p.is_a_fund = 1 AND p.amount > 0

GROUP BY u.id, u.first_name, u.last_name
HAVING COUNT(DISTINCT s.id) > 0 AND COUNT(DISTINCT p.id) > 0
ORDER BY total_deposits DESC;

