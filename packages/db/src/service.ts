import { createClient } from '@supabase/supabase-js';
import type { Database } from './types';
import { SUPABASE_SERVICE_ROLE_KEY, SUPABASE_URL } from './env';

/**
 * 서비스 롤 클라이언트 (RLS 우회).
 * 절대 클라이언트 코드에서 import 금지. API 라우트/서버 액션 전용.
 */
export function createSupabaseServiceRoleClient() {
  return createClient<Database>(SUPABASE_URL(), SUPABASE_SERVICE_ROLE_KEY(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}
