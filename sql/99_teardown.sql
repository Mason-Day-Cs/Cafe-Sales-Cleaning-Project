-- ⚠️ WARNING: This will DROP all pipeline objects.
-- Run this in the target database (e.g., cafe_sales_db).

BEGIN;

-- 1) Drop all pipeline schemas (and anything that depends on them)
DROP SCHEMA IF EXISTS mart CASCADE;
DROP SCHEMA IF EXISTS prep CASCADE;
DROP SCHEMA IF EXISTS raw  CASCADE;

COMMIT;

