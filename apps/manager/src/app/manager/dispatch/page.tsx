'use client';

import { useEffect, useState } from 'react';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface DispatchRow {
  id: string;
  reservation_id: string | null;
  vehicle_number?: string | null;
  driver?: string | null;
  status?: string | null;
  scheduled_at?: string | null;
}

export default function ManagerDispatchPage() {
  const [items, setItems] = useState<DispatchRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const { data } = await supabase
          .from('dispatch')
          .select('*')
          .order('scheduled_at', { ascending: true })
          .limit(200);
        if (!cancelled) setItems((data || []) as DispatchRow[]);
      } catch {
        if (!cancelled) setItems([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <PageWrapper>
      <SectionBox title="🚐 차량 배차">
        {loading ? (
          <Spinner />
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">배차 없음</p>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-100 text-left text-xs text-gray-500">
                <th className="py-2">예약</th>
                <th className="py-2">차량</th>
                <th className="py-2">기사</th>
                <th className="py-2">예정</th>
                <th className="py-2">상태</th>
              </tr>
            </thead>
            <tbody>
              {items.map((d) => (
                <tr key={d.id} className="border-b border-gray-50">
                  <td className="py-2 font-mono text-xs">{d.reservation_id?.slice(0, 8) || '-'}…</td>
                  <td className="py-2 text-gray-700">{d.vehicle_number || '-'}</td>
                  <td className="py-2 text-gray-700">{d.driver || '-'}</td>
                  <td className="py-2 text-xs text-gray-500">
                    {d.scheduled_at ? new Date(d.scheduled_at).toLocaleString('ko-KR') : '-'}
                  </td>
                  <td className="py-2 text-gray-500">{d.status || '-'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
