-- 1. Check constraints on reservation table
SELECT con.conname, con.consrc
FROM pg_catalog.pg_constraint con
INNER JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
INNER JOIN pg_catalog.pg_namespace nsp ON nsp.oid = connamespace
WHERE nsp.nspname = 'public'
AND rel.relname = 'reservation';

-- 2. Check column definition including type
SELECT column_name, data_type, udt_name
FROM information_schema.columns
WHERE table_name = 'reservation' AND column_name = 're_type';
