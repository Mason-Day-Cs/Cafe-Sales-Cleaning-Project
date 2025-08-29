--02_raw_load.sql
begin;

drop table if exists raw.cafe_sales;
create table raw.cafe_sales(
"Transaction ID"   text,
"Item"			   text,
"Quantity"		   text,
"Price Per Unit"   text,
"Total Spent" 	   text,
"Payment Method"   text,
"Location" 	 	   text,
"Transaction Date" text
);

commit;

--Import Data

-- Checks
--SELECT COUNT(*) FROM raw.cafe_sales;




