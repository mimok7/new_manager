'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@sht/auth';
import { AppShell, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { writeSessionCache } from '@sht/auth';

const NAV = [
  { href: '/mypage', label: '홈' },
  { href: '/mypage/quotes', label: '견적' },
  { href: '/mypage/reservations', label: '예약' },
  { href: '/mypage/direct-booking', label: '직접예약' },
  { href: '/mypage/confirmations', label: '확정서' },
  { href: '/mypage/profile', label: '프로필' },
];

export default function MyPageLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const { user, loading } = useAuth('/login');

  useEffect(() => {
    if (!loading && !user) router.replace('/login' as never);
  }, [loading, user, router]);

  if (loading || !user) {
    return (
      <div className="flex h-screen items-center justify-center">
        <Spinner />
      </div>
    );
  }

  const handleLogout = async () => {
    const supabase = createSupabaseBrowserClient();
    await supabase.auth.signOut();
    writeSessionCache(null);
    router.replace('/login' as never);
  };

  return (
    <AppShell
      brand="Stay Halong"
      nav={NAV}
      rightSlot={
        <>
          <span>{user.email}</span>
          <button
            onClick={handleLogout}
            className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
          >
            로그아웃
          </button>
        </>
      }
    >
      {children}
    </AppShell>
  );
}
