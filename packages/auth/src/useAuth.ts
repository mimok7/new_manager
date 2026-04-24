'use client';

import { useEffect, useState, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { readSessionCache, writeSessionCache, type CachedUser } from './cache';

export interface AuthState {
  user: CachedUser | null;
  loading: boolean;
  error: Error | null;
}

/**
 * 안정성 우선 인증 훅:
 * - 캐시 우선 즉시 표시 (깜빡임 방지)
 * - watchdog/타임아웃 없음
 * - tab/visibility 강제 재확인 없음
 * - onAuthStateChange만 구독
 * - 일시 오류 시 캐시 유지 (강제 로그아웃 금지)
 */
export function useAuth(redirectOnFail: string = '/login') {
  const router = useRouter();
  const cached = typeof window !== 'undefined' ? readSessionCache() : null;
  const [state, setState] = useState<AuthState>({
    user: cached,
    loading: !cached,
    error: null,
  });

  useEffect(() => {
    let cancelled = false;
    const supabase = createSupabaseBrowserClient();

    const checkOnce = async () => {
      try {
        const { data } = await supabase.auth.getSession();
        if (cancelled) return;
        if (data.session?.user) {
          writeSessionCache(data.session.user);
          setState({ user: data.session.user, loading: false, error: null });
        } else if (!cached) {
          setState({ user: null, loading: false, error: null });
          router.replace(redirectOnFail as never);
        } else {
          setState((prev) => ({ ...prev, loading: false }));
        }
      } catch (err) {
        if (cancelled) return;
        setState((prev) => ({ ...prev, loading: false, error: err as Error }));
      }
    };

    void checkOnce();

    const { data: sub } = supabase.auth.onAuthStateChange((event, session) => {
      if (cancelled) return;
      if (event === 'SIGNED_OUT') {
        writeSessionCache(null);
        setState({ user: null, loading: false, error: null });
        router.replace(redirectOnFail as never);
        return;
      }
      if (session?.user) {
        writeSessionCache(session.user);
        setState({ user: session.user, loading: false, error: null });
      }
    });

    return () => {
      cancelled = true;
      try {
        sub.subscription.unsubscribe();
      } catch {
        /* noop */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const refetch = useCallback(async () => {
    const supabase = createSupabaseBrowserClient();
    const { data } = await supabase.auth.getSession();
    if (data.session?.user) {
      writeSessionCache(data.session.user);
      setState({ user: data.session.user, loading: false, error: null });
    }
  }, []);

  return { ...state, isAuthenticated: !!state.user, refetch };
}
