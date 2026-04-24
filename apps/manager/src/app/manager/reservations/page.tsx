'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface ReservationRow {
  re_id: string;
  re_user_id: string;
  re_quote_id: string | null;
  re_type: string;
  re_status: string | null;
  re_created_at: string;
}

const TYPES = ['all', 'cruise', 'airport', 'hotel', 'rentcar', 'tour', 'sht'] as const;
const STATUSES = ['all', 'pending', 'confirmed', 'cancelled'] as const;

export default function ManagerReservationsPage() {
  const [items, setItems] = useState<ReservationRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [type, setType] = useState<(typeof TYPES)[number]>('all');
  const [status, setStatus] = useState<(typeof STATUSES)[number]>('all');

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      setLoading(true);
      try {
        const supabase = createSupabaseBrowserClient();
        let q = supabase
          .from('reservation')
          .select('*')
          .order('re_created_at', { ascending: false })
          .limit(200);
        if (type !== 'all') q = q.eq('re_type', type);
        if (status !== 'all') q = q.eq('re_status', status);
        const { data } = await q;
        if (!cancelled) setItems((data || []) as ReservationRow[]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, [type, status]);

  return (
    <PageWrapper>
      <SectionBox
        title="📋 예약 관리"
        right={
          <div className="flex gap-2">
            <select
              value={type}
              onChange={(e) => setType(e.target.value as typeof type)}
              className="rounded border border-gray-200 px-2 py-1 text-xs"
            >
              {TYPES.map((t) => (
                <option key={t} value={t}>
                  {t}
                </option>
              ))}
            </select>
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value as typeof status)}
              className="rounded border border-gray-200 px-2 py-1 text-xs"
            >
              {STATUSES.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
          </div>
        }
      >
        {loading ? (
          <Spinner />
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">예약 없음</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-gray-100 text-left text-xs text-gray-500">
                  <th className="py-2">유형</th>
                  <th className="py-2">상태</th>
                  <th className="py-2">생성</th>
                  <th className="py-2"></th>
                </tr>
              </thead>
              <tbody>
                {items.map((r) => (
                  <tr key={r.re_id} className="border-b border-gray-50">
                    <td className="py-2 text-gray-700">{r.re_type}</td>
                    <td className="py-2 text-gray-500">{r.re_status || '-'}</td>
                    <td className="py-2 text-xs text-gray-500">
                      {new Date(r.re_created_at).toLocaleString('ko-KR')}
                    </td>
                    <td className="py-2 text-right">
                      <Link
                        href={`/manager/reservation-edit/${r.re_type}?id=${r.re_id}` as never}
                        className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
                      >
                        편집
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
