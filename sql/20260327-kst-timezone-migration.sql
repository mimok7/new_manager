-- Auto-generated at 2026-03-27T02:33:39.064Z
-- Source: sql/db.csv
-- Goal: Convert all "timestamp without time zone" columns to timestamptz (KST-assumed legacy data)

BEGIN;

SET lock_timeout = '10s';
SET statement_timeout = '0';

DO $$
DECLARE
  item RECORD;
BEGIN
  FOR item IN
    SELECT table_name, column_name
    FROM (
      VALUES
    ('business_notifications', 'created_at'),
    ('business_notifications', 'updated_at'),
    ('cruise_tour_options', 'created_at'),
    ('cruise_tour_options', 'updated_at'),
    ('customer_notifications', 'response_deadline'),
    ('customer_notifications', 'created_at'),
    ('customer_notifications', 'updated_at'),
    ('hotel_info', 'created_at'),
    ('hotel_info', 'updated_at'),
    ('hotel_price', 'created_at'),
    ('hotel_price', 'updated_at'),
    ('notification_reads', 'read_at'),
    ('notification_templates', 'created_at'),
    ('notification_templates', 'updated_at'),
    ('notifications', 'due_date'),
    ('notifications', 'created_at'),
    ('notifications', 'updated_at'),
    ('notifications', 'processed_at'),
    ('reservation_airport', 'ra_datetime'),
    ('reservation_no_quote_reservation_airport_backup', 'ra_datetime'),
    ('reservation_rentcar', 'pickup_datetime'),
    ('reservation_rentcar', 'return_datetime'),
    ('tour', 'created_at'),
    ('tour', 'updated_at'),
    ('tour_addon_options', 'created_at'),
    ('tour_addon_options', 'updated_at'),
    ('tour_booking', 'deposit_paid_at'),
    ('tour_booking', 'payment_due_date'),
    ('tour_booking', 'created_at'),
    ('tour_booking', 'updated_at'),
    ('tour_booking', 'cancelled_at'),
    ('tour_cancellation_policy', 'created_at'),
    ('tour_cruise_integration', 'created_at'),
    ('tour_cruise_integration', 'updated_at'),
    ('tour_exclusions', 'created_at'),
    ('tour_important_info', 'created_at'),
    ('tour_inclusions', 'created_at'),
    ('tour_payment_pricing', 'created_at'),
    ('tour_payment_pricing', 'updated_at'),
    ('tour_pricing', 'created_at'),
    ('tour_pricing', 'updated_at'),
    ('tour_review', 'created_at'),
    ('tour_review', 'updated_at'),
    ('tour_schedule', 'created_at'),
    ('users', 'updated_at')
    ) AS t(table_name, column_name)
  LOOP
    IF EXISTS (
      SELECT 1
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname = 'public'
        AND c.relname = item.table_name
        AND c.relkind IN ('r', 'p')
    )
    AND EXISTS (
      SELECT 1
      FROM information_schema.columns ic
      WHERE ic.table_schema = 'public'
        AND ic.table_name = item.table_name
        AND ic.column_name = item.column_name
        AND ic.data_type = 'timestamp without time zone'
    ) THEN
      EXECUTE format(
        'ALTER TABLE public.%I ALTER COLUMN %I TYPE timestamptz USING %I AT TIME ZONE ''Asia/Seoul''',
        item.table_name, item.column_name, item.column_name
      );

      RAISE NOTICE 'Converted %.% to timestamptz (Asia/Seoul interpreted)', item.table_name, item.column_name;
    ELSE
      RAISE NOTICE 'Skipped %.% (missing table/column or already converted)', item.table_name, item.column_name;
    END IF;
  END LOOP;
END $$;

-- Session timezone defaults for Supabase roles
ALTER ROLE anon SET timezone = 'Asia/Seoul';
ALTER ROLE authenticated SET timezone = 'Asia/Seoul';
ALTER ROLE service_role SET timezone = 'Asia/Seoul';

-- Helper functions for consistent app-side conversion
CREATE OR REPLACE FUNCTION public.to_utc_from_kst(local_ts timestamp)
RETURNS timestamptz
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT local_ts AT TIME ZONE 'Asia/Seoul'
$$;

CREATE OR REPLACE FUNCTION public.to_kst(ts timestamptz)
RETURNS timestamp
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT timezone('Asia/Seoul', ts)
$$;

COMMIT;
