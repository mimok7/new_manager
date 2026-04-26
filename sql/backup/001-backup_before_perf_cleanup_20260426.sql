-- Migration: backup_before_perf_cleanup_20260426
-- Purpose: Complete snapshot of policies, indexes, and no_quote data before cleanup
-- Author: Phase 10 DB Optimization (2026.04.26)
-- Timestamp: 2026-04-26T15:30:00Z

-- ============================================================================
-- 1. Backup all RLS policies (for potential rollback)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public._backup_pg_policies_20260426 AS
SELECT 
  p.schemaname,
  p.tablename,
  p.policyname,
  p.permissive,
  p.roles,
  p.qual,
  p.with_check,
  p.cmd,
  NOW() as backup_timestamp
FROM pg_policies p
WHERE p.schemaname = 'public'
ORDER BY p.tablename, p.policyname;

COMMENT ON TABLE public._backup_pg_policies_20260426 IS 
  'Backup of all RLS policies before cleanup (132 rows). Use with _archive_* tables for complete rollback.';

-- ============================================================================
-- 2. Backup all index definitions (for potential rollback)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public._backup_pg_indexes_20260426 AS
SELECT 
  schemaname,
  tablename,
  indexname,
  indexdef,
  NOW() as backup_timestamp
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

COMMENT ON TABLE public._backup_pg_indexes_20260426 IS 
  'Backup of all index definitions before cleanup (315 rows). Use pg_indexes view to restore.';

-- ============================================================================
-- 3. Archive no_quote_backup tables (data snapshot before schema changes)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public._archive_reservation_no_quote_backup_20260426 AS
SELECT * FROM public.reservation_no_quote_backup;

CREATE TABLE IF NOT EXISTS public._archive_reservation_no_quote_airport_backup_20260426 AS
SELECT * FROM public.reservation_no_quote_airport_backup;

CREATE TABLE IF NOT EXISTS public._archive_reservation_no_quote_cruise_backup_20260426 AS
SELECT * FROM public.reservation_no_quote_cruise_backup;

CREATE TABLE IF NOT EXISTS public._archive_reservation_no_quote_tour_backup_20260426 AS
SELECT * FROM public.reservation_no_quote_tour_backup;

COMMENT ON TABLE public._archive_reservation_no_quote_backup_20260426 IS 
  'Data snapshot: reservation_no_quote_backup (1647 rows)';
COMMENT ON TABLE public._archive_reservation_no_quote_airport_backup_20260426 IS 
  'Data snapshot: reservation_no_quote_airport_backup (2 rows)';
COMMENT ON TABLE public._archive_reservation_no_quote_cruise_backup_20260426 IS 
  'Data snapshot: reservation_no_quote_cruise_backup (0 rows)';
COMMENT ON TABLE public._archive_reservation_no_quote_tour_backup_20260426 IS 
  'Data snapshot: reservation_no_quote_tour_backup (2 rows)';

-- ============================================================================
-- Verification queries
-- ============================================================================

-- Verify backup table sizes
-- SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
-- FROM pg_tables
-- WHERE tablename IN (
--   '_backup_pg_policies_20260426',
--   '_backup_pg_indexes_20260426',
--   '_archive_reservation_no_quote_backup_20260426',
--   '_archive_reservation_no_quote_airport_backup_20260426',
--   '_archive_reservation_no_quote_cruise_backup_20260426',
--   '_archive_reservation_no_quote_tour_backup_20260426'
-- )
-- ORDER BY tablename;

-- Count backup rows
-- SELECT 
--   'pg_policies' as backup_type,
--   COUNT(*) as row_count
-- FROM public._backup_pg_policies_20260426
-- UNION ALL
-- SELECT 
--   'pg_indexes',
--   COUNT(*)
-- FROM public._backup_pg_indexes_20260426
-- UNION ALL
-- SELECT 
--   'no_quote_backup',
--   COUNT(*)
-- FROM public._archive_reservation_no_quote_backup_20260426
-- UNION ALL
-- SELECT 
--   'no_quote_airport_backup',
--   COUNT(*)
-- FROM public._archive_reservation_no_quote_airport_backup_20260426
-- UNION ALL
-- SELECT 
--   'no_quote_cruise_backup',
--   COUNT(*)
-- FROM public._archive_reservation_no_quote_cruise_backup_20260426
-- UNION ALL
-- SELECT 
--   'no_quote_tour_backup',
--   COUNT(*)
-- FROM public._archive_reservation_no_quote_tour_backup_20260426;
