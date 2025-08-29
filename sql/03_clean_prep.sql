
--03_clean_prep.sql
BEGIN;

DROP TABLE IF EXISTS prep.cafe_sales_clean;
CREATE TABLE prep.cafe_sales_clean AS
SELECT
  TRIM("Transaction ID") AS transaction_id,
  CASE WHEN UPPER(TRIM("Item")) IN ('ERROR','UNKNOWN','') THEN NULL
       ELSE INITCAP(TRIM("Item")) END AS item,
  CASE WHEN TRIM("Quantity") ~ '^[0-9]+$' THEN TRIM("Quantity")::int ELSE NULL END AS quantity,
  CASE WHEN UPPER(TRIM("Price Per Unit")) IN ('','ERROR','UNKNOWN') THEN NULL
       ELSE REPLACE(TRIM("Price Per Unit"), ',', '')::numeric(12,2) END AS price_per_unit,
  CASE WHEN UPPER(TRIM("Total Spent")) IN ('','ERROR','UNKNOWN') THEN NULL
       ELSE REPLACE(TRIM("Total Spent"), ',', '')::numeric(12,2) END AS total_spent_raw,
  COALESCE(
    CASE WHEN UPPER(TRIM("Total Spent")) IN ('','ERROR','UNKNOWN') THEN NULL
         ELSE REPLACE(TRIM("Total Spent"), ',', '')::numeric(12,2) END,
    CASE WHEN TRIM("Quantity") ~ '^[0-9]+$'
           AND TRIM("Price Per Unit") ~ '^[0-9]+(\.[0-9]+)?$'
         THEN TRIM("Quantity")::int * REPLACE(TRIM("Price Per Unit"), ',', '')::numeric(12,2)
         ELSE NULL END
  ) AS total_spent,
  CASE WHEN UPPER(TRIM("Payment Method")) IN ('ERROR','UNKNOWN','') THEN NULL
       ELSE INITCAP(TRIM("Payment Method")) END AS payment_method,
  CASE WHEN UPPER(TRIM("Location")) IN ('ERROR','UNKNOWN','') THEN NULL
       ELSE INITCAP(TRIM("Location")) END AS location,

  /* 🔧 Hardened date parsing */
  CASE
    WHEN "Transaction Date" IS NULL OR TRIM("Transaction Date") = '' THEN NULL
    WHEN TRIM("Transaction Date") ~ '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
      THEN TO_DATE(TRIM("Transaction Date"), 'YYYY-MM-DD')
    WHEN TRIM("Transaction Date") ~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
      THEN TO_DATE(TRIM("Transaction Date"), 'MM/DD/YYYY')
    ELSE NULL
  END AS transaction_date

FROM raw.cafe_sales;

-- Helpful indexes
CREATE INDEX IF NOT EXISTS ix_prep_date ON prep.cafe_sales_clean (transaction_date);
CREATE INDEX IF NOT EXISTS ix_prep_item ON prep.cafe_sales_clean (item);
CREATE INDEX IF NOT EXISTS ix_prep_loc  ON prep.cafe_sales_clean (location);

COMMIT;

-- Checks

SELECT COUNT(*) FROM prep.cafe_sales_clean;
SELECT * FROM prep.cafe_sales_clean LIMIT 10;

SELECT COUNT(*) AS raw_rows FROM raw.cafe_sales;
SELECT COUNT(*) AS clean_rows FROM prep.cafe_sales_clean;

SELECT
  SUM((item IS NULL)::int) AS null_items,
  SUM((payment_method IS NULL)::int) AS null_payment,
  SUM((location IS NULL)::int) AS null_location,
  SUM((transaction_date IS NULL)::int) AS null_date
FROM prep.cafe_sales_clean;

SELECT *
FROM prep.cafe_sales_clean
WHERE total_spent IS NOT NULL
  AND quantity IS NOT NULL
  AND price_per_unit IS NOT NULL
  AND ABS(total_spent - (quantity * price_per_unit)) > 0.01
LIMIT 20;

SELECT MIN(transaction_date) AS min_date,
       MAX(transaction_date) AS max_date
FROM prep.cafe_sales_clean;


