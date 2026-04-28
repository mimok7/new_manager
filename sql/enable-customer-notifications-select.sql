-- Allow customers (authenticated) to SELECT their own notifications
-- This fixes: customer portal cannot see notifications rows due to manager-only RLS.
-- Matching rules:
-- - assigned_to = auth.uid()
-- - target_id = auth.uid() (stored as text)
-- - customer_email = auth JWT email

BEGIN;

ALTER TABLE IF EXISTS public.notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS notifications_customer_select_own ON public.notifications;
CREATE POLICY notifications_customer_select_own
  ON public.notifications
  FOR SELECT
  TO authenticated
  USING (
    assigned_to = auth.uid()
    OR target_id = auth.uid()::text
    OR customer_email = COALESCE((auth.jwt() ->> 'email')::text, '')
  );

COMMIT;
