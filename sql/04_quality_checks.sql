-- 04_quality_checks.sql
-- Treat as assertions; return 0 rows = pass, >0 rows = investigate.

-- Row counts
SELECT 'raw' AS tbl, COUNT(*) FROM raw.cafe_sales
UNION ALL
SELECT 'prep', COUNT(*) FROM prep.cafe_sales_clean;

-- Nulls in key fields
SELECT
  SUM((transaction_id   IS NULL)::int) AS null_txn_id,
  SUM((transaction_date IS NULL)::int) AS null_date,
  SUM((quantity         IS NULL)::int) AS null_qty,
  SUM((price_per_unit   IS NULL)::int) AS null_price,
  SUM((total_spent      IS NULL)::int) AS null_total
FROM prep.cafe_sales_clean;

-- Totals that don’t match qty*price when both are present
SELECT *
FROM prep.cafe_sales_clean
WHERE total_spent IS NOT NULL
  AND quantity IS NOT NULL
  AND price_per_unit IS NOT NULL
  AND ABS(total_spent - (quantity*price_per_unit)) > 0.01
LIMIT 50;
