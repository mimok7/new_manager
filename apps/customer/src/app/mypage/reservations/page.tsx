'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { reservation as reservationDomain } from '@sht/domain';

const TYPE_LABEL: Record<string, string> = {
  cruise: '🚢 크루즈',
  airport: '✈️ 공항',
  hotel: '🏨 호텔',
  tour: '🗺️ 투어',
  rentcar: '🚗 렌터카',
  sht: '🚌 SHT',
};

export default function ReservationsPage() {
  const { user, loading: authLoading } = useAuth('/login');
  const [items, setItems] = useState<reservationDomain.ReservationRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    if (authLoading || !user) return;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const data = await reservationDomain.listReservations(supabase, user.id);
        if (!cancelled) setItems(data);
      } catch (err) {
        if (!cancelled) setError((err as Error).message);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, [authLoading, user]);

  return (
    <PageWrapper>
      <SectionBox
        title="📋 내 예약"
        right={
          <Link
            href="/mypage/direct-booking"
            className="rounded bg-brand-500 px-3 py-1 text-xs text-white hover:bg-brand-600"
          >
            새 예약
          </Link>
        }
      >
        {loading ? (
          <Spinner />
        ) : error ? (
          <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">예약 내역이 없습니다.</p>
        ) : (
          <ul className="divide-y divide-gray-100">
            {items.map((it) => (
              <li key={it.re_id} className="flex items-center justify-between py-3">
                <div>
                  <div className="text-sm font-medium text-gray-700">
                    {TYPE_LABEL[it.re_type] || it.re_type}
                  </div>
                  <div className="text-xs text-gray-500">
                    {new Date(it.re_created_at).toLocaleString('ko-KR')} · {it.re_status || '-'}
                  </div>
                </div>
                <Link
                  href={`/mypage/reservations/${it.re_id}`}
                  className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
                >
                  상세
                </Link>
              </li>
            ))}
          </ul>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
