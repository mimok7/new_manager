-- Migration: perf_add_pk_to_no_quote_backup_tables_20260426
-- Purpose: Add surrogate primary keys to 4 reservation_no_quote_*_backup tables
-- Author: Phase 10 DB Optimization (2026.04.26)
-- Impact: Resolves 4 "no_primary_key" advisor lints

-- ============================================================================
-- Add surrogate PK to reservation_no_quote_backup tables
-- ============================================================================

-- reservation_no_quote_backup (1647 rows)
ALTER TABLE public.reservation_no_quote_backup
ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;

-- reservation_no_quote_airport_backup (2 rows)
ALTER TABLE public.reservation_no_quote_airport_backup
ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;

-- reservation_no_quote_cruise_backup (0 rows)
ALTER TABLE public.reservation_no_quote_cruise_backup
ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;

-- reservation_no_quote_tour_backup (2 rows)
ALTER TABLE public.reservation_no_quote_tour_backup
ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;

-- ============================================================================
-- Verification
-- ============================================================================
-- SELECT 
--   schemaname,
--   tablename,
--   column_name,
--   data_type
-- FROM information_schema.columns
-- WHERE tablename IN (
--   'reservation_no_quote_backup',
--   'reservation_no_quote_airport_backup',
--   'reservation_no_quote_cruise_backup',
--   'reservation_no_quote_tour_backup'
-- )
-- AND column_name = '_backup_pk'
-- ORDER BY tablename;
-- Expected: 4 BIGINT rows with bigserial type

-- Check no_primary_key advisor count (should be 2 fewer if only backup tables were the issue)
-- SELECT rule_type, COUNT(*) FROM (
--   SELECT 'no_primary_key' as rule_type FROM pg_tables
--   WHERE schemaname = 'public' AND tablename NOT LIKE '%_backup_%' AND tablename NOT LIKE '%_archive_%'
--   AND NOT EXISTS (SELECT 1 FROM pg_indexes WHERE pg_indexes.tablename = pg_tables.tablename AND indexdef ILIKE '%PRIMARY KEY%')
-- ) advisory
-- GROUP BY rule_type;
