'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth, useUserRole, writeSessionCache } from '@sht/auth';
import { AppShell, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';

const NAV = [
  { href: '/manager', label: '대시보드' },
  { href: '/manager/quotes', label: '견적' },
  { href: '/manager/reservations', label: '예약' },
  { href: '/manager/reservation-edit', label: '예약 수정' },
  { href: '/manager/confirmation', label: '확정서' },
  { href: '/manager/payments', label: '결제' },
  { href: '/manager/dispatch', label: '차량 배차' },
  { href: '/manager/schedule', label: '일정' },
  { href: '/manager/analytics', label: '분석' },
];

export default function ManagerLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth('/login');
  const { role, loading: roleLoading } = useUserRole();

  useEffect(() => {
    if (authLoading || roleLoading) return;
    if (!user) {
      router.replace('/login' as never);
      return;
    }
    if (!['manager', 'admin'].includes(role)) {
      router.replace('/login' as never);
    }
  }, [authLoading, roleLoading, user, role, router]);

  if (authLoading || roleLoading || !user) {
    return (
      <div className="flex h-screen items-center justify-center">
        <Spinner />
      </div>
    );
  }

  if (!['manager', 'admin'].includes(role)) {
    return (
      <div className="flex h-screen items-center justify-center text-sm text-gray-500">
        권한이 없습니다…
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
      brand="Stay Halong · Manager"
      nav={NAV}
      rightSlot={
        <>
          <span>
            {user.email} ({role})
          </span>
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
