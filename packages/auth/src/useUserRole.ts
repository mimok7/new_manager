'use client';

import { useEffect, useState } from 'react';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { useAuth } from './useAuth';

export type UserRole = 'guest' | 'member' | 'manager' | 'admin';

/**
 * 현재 사용자의 역할 조회 (users.role).
 * users 테이블에 행이 없으면 'guest'.
 * 안정성: try/finally + cancelled 플래그.
 */
export function useUserRole(): { role: UserRole; loading: boolean } {
  const { user, loading: authLoading } = useAuth();
  const [role, setRole] = useState<UserRole>('guest');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    if (authLoading) return;
    if (!user) {
      setRole('guest');
      setLoading(false);
      return;
    }
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const { data, error } = await supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();
        if (cancelled) return;
        if (error || !data) {
          setRole('guest');
          return;
        }
        const r = (data as { role?: string }).role;
        if (r === 'admin' || r === 'manager' || r === 'member') setRole(r);
        else setRole('guest');
      } catch {
        if (!cancelled) setRole('guest');
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, [user, authLoading]);

  return { role, loading: authLoading || loading };
}
