-- 1. Top 10 selling items by revenue
SELECT item, ROUND(SUM(total_spent),2) AS total_sales
FROM prep.cafe_sales_clean
GROUP BY item
ORDER BY total_sales DESC
LIMIT 10;

-- 2. Total sales by payment method
SELECT payment_method, ROUND(SUM(total_spent),2) AS total_sales
FROM prep.cafe_sales_clean
GROUP BY payment_method
ORDER BY total_sales DESC;

-- 3. Busiest day of week
SELECT TO_CHAR(transaction_date, 'Dy') AS weekday,
       ROUND(SUM(total_spent),2) AS total_sales
FROM prep.cafe_sales_clean
WHERE transaction_date IS NOT NULL
GROUP BY weekday
ORDER BY total_sales DESC;

-- 4. Average order value
WITH orders AS (
  SELECT transaction_id, SUM(total_spent) AS order_total
  FROM prep.cafe_sales_clean
  GROUP BY transaction_id
)
SELECT ROUND(AVG(order_total),2) AS avg_order_value FROM orders;

-- 5. Sales trend by month
SELECT DATE_TRUNC('month', transaction_date) AS month,
       ROUND(SUM(total_spent),2) AS total_sales
FROM prep.cafe_sales_clean
WHERE transaction_date IS NOT NULL
GROUP BY month
ORDER BY month;
