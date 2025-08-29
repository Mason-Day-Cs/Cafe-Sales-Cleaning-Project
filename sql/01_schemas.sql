-- 01_schemas.sql
begin;

create schema if not exists raw;
create schema if not exists prep;
create schema if not exists mart;

commit;

-- Checks
-- Schemas present
--SELECT nspname FROM pg_namespace
--WHERE nspname IN ('raw','prep','mart') ORDER BY 1;

-- Tables present
--SELECT table_schema, table_name
--FROM information_schema.tables
--WHERE table_schema IN ('raw','prep','mart')
--ORDER BY 1,2;
