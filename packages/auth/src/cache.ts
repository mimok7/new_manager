/**
 * 세션 사용자 로컬 캐시 (localStorage).
 * 네트워크 일시 단절 시 화면 깜빡임/강제 로그아웃 방지용.
 */
const KEY = 'sht.session.user';

export interface CachedUser {
  id: string;
  email?: string | null;
}

export function readSessionCache(): CachedUser | null {
  if (typeof window === 'undefined') return null;
  try {
    const raw = window.localStorage.getItem(KEY);
    return raw ? (JSON.parse(raw) as CachedUser) : null;
  } catch {
    return null;
  }
}

export function writeSessionCache(user: CachedUser | null): void {
  if (typeof window === 'undefined') return;
  try {
    if (user) window.localStorage.setItem(KEY, JSON.stringify({ id: user.id, email: user.email }));
    else window.localStorage.removeItem(KEY);
  } catch {
    /* noop */
  }
}
