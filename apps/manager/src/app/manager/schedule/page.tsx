'use client';

import { useEffect, useState } from 'react';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface ScheduleRow {
  re_id: string;
  re_type: string;
  re_status: string | null;
  re_created_at: string;
  start_at?: string | null;
}

export default function ManagerSchedulePage() {
  const [items, setItems] = useState<ScheduleRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        // 향후 7일간 예약을 단순 노출
        const since = new Date();
        const until = new Date();
        until.setDate(until.getDate() + 14);
        const { data } = await supabase
          .from('reservation')
          .select('re_id, re_type, re_status, re_created_at')
          .gte('re_created_at', since.toISOString())
          .lte('re_created_at', until.toISOString())
          .order('re_created_at', { ascending: true })
          .limit(200);
        if (!cancelled) setItems((data || []) as ScheduleRow[]);
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
      <SectionBox title="📅 일정">
        {loading ? (
          <Spinner />
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">일정 없음</p>
        ) : (
          <ul className="divide-y divide-gray-100">
            {items.map((it) => (
              <li key={it.re_id} className="flex items-center justify-between py-2">
                <span className="text-sm text-gray-700">
                  [{it.re_type}] {it.re_status || '-'}
                </span>
                <span className="text-xs text-gray-500">
                  {new Date(it.re_created_at).toLocaleString('ko-KR')}
                </span>
              </li>
            ))}
          </ul>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
