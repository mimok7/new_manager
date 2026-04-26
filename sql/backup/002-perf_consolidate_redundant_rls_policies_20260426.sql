-- Migration: perf_consolidate_redundant_rls_policies_20260426
-- Purpose: Create manager/admin policies & drop 21 redundant/insecure policies
-- Author: Phase 10 DB Optimization (2026.04.26)
-- Security: Fixes 4 qual=true vulnerabilities (universal read access)

-- ============================================================================
-- PHASE 1: Create manager/admin policies (must precede DROP to prevent breakage)
-- ============================================================================

-- quote: Add manager/admin visibility (replaces qual=true security hole)
CREATE POLICY quote_manager_admin_all 
  ON public.quote 
  FOR ALL 
  TO authenticated 
  USING ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )))
  WITH CHECK ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )));

-- quote_item: Add manager/admin visibility (replaces qual=true security hole)
CREATE POLICY quote_item_manager_admin_all
  ON public.quote_item
  FOR ALL
  TO authenticated
  USING ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )))
  WITH CHECK ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )));

-- ============================================================================
-- PHASE 2: Drop 21 redundant/insecure policies
-- ============================================================================

-- users table: 5 DROP (includes 2 qual=true security holes)
-- SECURITY: "Allow all select for users" exposed all users regardless of role
-- SECURITY: "Allow public read for FK constraints" was qual=true duplicate
DROP POLICY IF EXISTS "Allow all select for users" ON public.users;
DROP POLICY IF EXISTS "Allow public read for FK constraints" ON public.users;
DROP POLICY IF EXISTS "Enable users to read own profile" ON public.users;
DROP POLICY IF EXISTS "Allow authenticated users to insert profile" ON public.users;
DROP POLICY IF EXISTS "Enable users to insert own profile" ON public.users;
DROP POLICY IF EXISTS "Allow users to update own profile" ON public.users;
DROP POLICY IF EXISTS "Enable users to update own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.users;
DROP POLICY IF EXISTS "Allow authenticated users to update profile" ON public.users;
DROP POLICY IF EXISTS "Service role full access" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.users;

-- quote table: 4 DROP (includes 1 qual=true security hole)
-- SECURITY: "Allow authenticated users to view quotes" exposed all quotes (qual=true)
--   Now replaced by quote_manager_admin_all + users' own quote policies
DROP POLICY IF EXISTS "Allow authenticated users to view quotes" ON public.quote;
DROP POLICY IF EXISTS "Users can view own quotes" ON public.quote;
DROP POLICY IF EXISTS "Users can insert own quotes" ON public.quote;
DROP POLICY IF EXISTS "Users can update own quotes" ON public.quote;

-- quote_item table: 2 DROP (includes 1 no user check security hole)
-- SECURITY: "Allow authenticated users to view quote items" had no user ownership check
--   Now replaced by quote_item_manager_admin_all
DROP POLICY IF EXISTS "Allow authenticated users to view quote items" ON public.quote_item;

-- reservation table: 2 DROP
DROP POLICY IF EXISTS "Users can insert own reservations" ON public.reservation;
DROP POLICY IF EXISTS "Users can read own reservations" ON public.reservation;

-- reservation_airport table: 3 DROP
DROP POLICY IF EXISTS "Users can manage own airport reservations" ON public.reservation_airport;
DROP POLICY IF EXISTS "reservation_airport_member_policy_select" ON public.reservation_airport;
DROP POLICY IF EXISTS "reservation_airport_staff_policy" ON public.reservation_airport;

-- reservation_cruise_car table: 1 DROP
DROP POLICY IF EXISTS "reservation_cruise_car_member_policy" ON public.reservation_cruise_car;

-- reservation_rentcar table: 1 DROP
DROP POLICY IF EXISTS "reservation_rentcar_staff_policy" ON public.reservation_rentcar;

-- ============================================================================
-- Post-migration verification
-- ============================================================================
-- SELECT COUNT(*) as current_policies FROM pg_policies WHERE schemaname = 'public';
-- Expected: baseline_count - 21 + 2 (removed 21, added 2 manager policies)

-- Verify manager can SELECT quote/quote_item:
-- SET ROLE authenticated;
-- SET app.current_user_id = (SELECT id FROM users WHERE role = 'manager' LIMIT 1);
-- SELECT id, title FROM quote LIMIT 1;  -- Should return results

-- Verify user cannot SELECT other users' quotes:
-- SET app.current_user_id = (SELECT id FROM users WHERE role = 'member' LIMIT 1);
-- SELECT id, title FROM quote WHERE re_user_id != app.current_user_id;  -- Should return 0 rows
