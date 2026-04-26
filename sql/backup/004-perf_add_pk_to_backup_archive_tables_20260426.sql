-- Migration: perf_add_pk_to_backup_archive_tables_20260426
-- Purpose: Add surrogate PK to 6 backup/archive tables created in migration #1
-- Author: Phase 10 DB Optimization (2026.04.26)
-- Impact: Resolves remaining 6 "no_primary_key" advisor lints (total 10 tables + PK)

-- ============================================================================
-- Add surrogate PK to backup/archive tables from migration #1
-- ============================================================================

-- _backup_pg_policies_20260426 (132 rows)
ALTER TABLE public._backup_pg_policies_20260426
ADD COLUMN _row_id BIGSERIAL PRIMARY KEY;

-- _backup_pg_indexes_20260426 (315 rows)
ALTER TABLE public._backup_pg_indexes_20260426
ADD COLUMN _row_id BIGSERIAL PRIMARY KEY;

-- _archive_reservation_no_quote_backup_20260426 (1647 rows)
ALTER TABLE public._archive_reservation_no_quote_backup_20260426
ADD COLUMN _row_id BIGSERIAL PRIMARY KEY;

-- _archive_reservation_no_quote_airport_backup_20260426 (2 rows)
ALTER TABLE public._archive_reservation_no_quote_airport_backup_20260426
ADD COLUMN _row_id BIGSERIAL PRIMARY KEY;

-- _archive_reservation_no_quote_cruise_backup_20260426 (0 rows)
ALTER TABLE public._archive_reservation_no_quote_cruise_backup_20260426
ADD COLUMN _row_id BIGSERIAL PRIMARY KEY;

-- _archive_reservation_no_quote_tour_backup_20260426 (2 rows)
ALTER TABLE public._archive_reservation_no_quote_tour_backup_20260426
ADD COLUMN _row_id BIGSERIAL PRIMARY KEY;

-- ============================================================================
-- Final state verification
-- ============================================================================
-- SELECT 
--   schemaname,
--   tablename,
--   CASE 
--     WHEN EXISTS (SELECT 1 FROM pg_indexes WHERE pg_indexes.tablename = pg_tables.tablename AND indexdef ILIKE '%PRIMARY KEY%')
--     THEN 'HAS PK'
--     ELSE 'NO PK'
--   END as pk_status
-- FROM pg_tables
-- WHERE schemaname = 'public' AND (
--   tablename LIKE '%_backup_%' OR tablename LIKE '%_archive_%'
-- )
-- ORDER BY tablename;
-- Expected: All 10 tables marked "HAS PK"

-- Advisor count check (should drop to ~0-2 "no_primary_key" remaining)
-- SELECT type, COUNT(*) FROM pg_policies GROUP BY type;
