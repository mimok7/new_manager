import supabase from './supabase';

interface AuthUserSafeResult {
  user: any | null;
  error: Error | null;
  timedOut: boolean;
}

function extractUserFromStoredValue(raw: string): any | null {
  try {
    const parsed = JSON.parse(raw);
    const candidates = [
      parsed,
      parsed?.currentSession,
      parsed?.session,
      parsed?.data?.session,
      parsed?.value?.session,
      parsed?.value,
    ];

    for (const candidate of candidates) {
      const user = candidate?.user;
      if (user?.id) return user;
    }
  } catch {
    // ignore malformed storage
  }

  return null;
}

function getStoredSessionUser(): any | null {
  if (typeof window === 'undefined') return null;

  try {
    const authCache = sessionStorage.getItem('app:auth:cache');
    if (authCache) {
      const parsed = JSON.parse(authCache);
      if (parsed?.user?.id) return parsed.user;
    }
  } catch {
    // ignore
  }

  try {
    const sessionCache = sessionStorage.getItem('app:session:cache');
    if (sessionCache) {
      const parsed = JSON.parse(sessionCache);
      if (parsed?.user?.id) return parsed.user;
    }
  } catch {
    // ignore
  }

  try {
    for (const key of Object.keys(localStorage)) {
      if (!key.startsWith('sb-') || !key.endsWith('-auth-token')) continue;
      const raw = localStorage.getItem(key);
      if (!raw) continue;
      const user = extractUserFromStoredValue(raw);
      if (user?.id) return user;
    }
  } catch {
    // ignore
  }

  return null;
}

/**
 * 안전한 사용자 조회 (서버 검증 원칙).
 *
 *  - supabase.auth.getUser()로 서버에서 JWT 유효성 검증 + 만료 시 자동 갱신
 *  - timeoutMs/retries 인자는 하위 호환을 위해 유지하지만 실제로 사용하지 않음
 *  - timedOut 플래그는 항상 false
 */
export async function getAuthUserSafe(_options?: {
  timeoutMs?: number;
  retries?: number;
}): Promise<AuthUserSafeResult> {
  try {
    const { data: { user }, error: userError } = await supabase.auth.getUser();

    if (user) {
      return { user, error: null, timedOut: false };
    }

    return { user: null, error: (userError as Error) ?? null, timedOut: false };
  } catch (err) {
    return { user: null, error: err as Error, timedOut: false };
  }
}
