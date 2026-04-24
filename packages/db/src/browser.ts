'use client';

import { createBrowserClient } from '@supabase/ssr';
import type { Database } from './types';
import { SUPABASE_ANON_KEY, SUPABASE_URL } from './env';

let _client: ReturnType<typeof createBrowserClient<Database>> | null = null;

/**
 * 브라우저 전용 Supabase 클라이언트 (싱글톤).
 * autoRefreshToken: true (기본값) — 중복 갱신 금지 원칙 준수.
 */
export function createSupabaseBrowserClient() {
  if (_client) return _client;
  _client = createBrowserClient<Database>(SUPABASE_URL(), SUPABASE_ANON_KEY());
  return _client;
}
