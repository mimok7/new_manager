import { createServerClient, type CookieOptions } from '@supabase/ssr';
import type { Database } from './types';
import { SUPABASE_ANON_KEY, SUPABASE_URL } from './env';

type CookieStore = {
  get: (name: string) => { value: string } | undefined;
  set?: (name: string, value: string, options: CookieOptions) => void;
};

/**
 * 서버 컴포넌트/라우트 핸들러에서 사용.
 * Next.js의 cookies()를 인자로 받아 세션을 RSC에 노출.
 */
export function createSupabaseServerClient(cookieStore: CookieStore) {
  return createServerClient<Database>(SUPABASE_URL(), SUPABASE_ANON_KEY(), {
    cookies: {
      get(name: string) {
        return cookieStore.get(name)?.value;
      },
      set(name: string, value: string, options: CookieOptions) {
        try {
          cookieStore.set?.(name, value, options);
        } catch {
          /* RSC에서 호출되면 무시 */
        }
      },
      remove(name: string, options: CookieOptions) {
        try {
          cookieStore.set?.(name, '', { ...options, maxAge: 0 });
        } catch {
          /* noop */
        }
      },
    },
  });
}
