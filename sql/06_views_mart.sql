-- 06_views_mart.sql
CREATE OR REPLACE VIEW mart.vw_sales_by_item AS
SELECT item, ROUND(SUM(total_spent),2) AS sales
FROM prep.cafe_sales_clean
GROUP BY item;

CREATE OR REPLACE VIEW mart.vw_sales_by_weekday AS
SELECT TO_CHAR(transaction_date,'Dy') AS weekday, ROUND(SUM(total_spent),2) AS sales
FROM prep.cafe_sales_clean
GROUP BY weekday;
