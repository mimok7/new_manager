import { createSupabaseBrowserClient } from '@sht/db/browser';
import { readSessionCache } from './cache';

/**
 * 로컬 세션만 조회 (네트워크 호출 없음).
 * Supabase getSession()은 토큰을 로컬에서 읽기만 함.
 */
export async function getSessionUser(): Promise<{ user: { id: string; email?: string | null } | null; error: unknown }> {
  const supabase = createSupabaseBrowserClient();
  try {
    const { data, error } = await supabase.auth.getSession();
    if (data.session?.user) return { user: data.session.user, error: null };
    const fallback = readSessionCache();
    if (fallback) return { user: fallback, error: null };
    return { user: null, error };
  } catch (err) {
    const fallback = readSessionCache();
    if (fallback) return { user: fallback, error: null };
    return { user: null, error: err };
  }
}

/**
 * 폼 제출 직전 세션 확인. autoRefreshToken에 위임 — 강제 refreshSession 금지.
 */
export const refreshAuthBeforeSubmit = getSessionUser;
