-- Inspect reservation table columns and constraints
SELECT 
    c.column_name, 
    c.data_type, 
    c.is_nullable,
    pg_get_constraintdef(k.oid) as constraint_def
FROM information_schema.columns c
LEFT JOIN pg_constraint k ON k.conrelid = 'reservation'::regclass AND k.conkey[1] = c.ordinal_position
WHERE table_name = 'reservation';

-- Check specifically for all constraints on the table
SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid = 'reservation'::regclass;
