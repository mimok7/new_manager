'use client';

import { useEffect, useState } from 'react';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface Stats {
  totalQuotes: number;
  totalReservations: number;
  byType: Record<string, number>;
  byStatus: Record<string, number>;
}

export default function ManagerAnalyticsPage() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const [qRes, rRes] = await Promise.all([
          supabase.from('quote').select('id', { count: 'exact', head: true }),
          supabase.from('reservation').select('re_type, re_status'),
        ]);
        const byType: Record<string, number> = {};
        const byStatus: Record<string, number> = {};
        ((rRes.data || []) as Array<{ re_type: string; re_status: string | null }>).forEach((r) => {
          byType[r.re_type] = (byType[r.re_type] || 0) + 1;
          const s = r.re_status || 'unknown';
          byStatus[s] = (byStatus[s] || 0) + 1;
        });
        if (cancelled) return;
        setStats({
          totalQuotes: qRes.count || 0,
          totalReservations: rRes.data?.length || 0,
          byType,
          byStatus,
        });
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, []);

  if (loading || !stats) return <PageWrapper><Spinner /></PageWrapper>;

  return (
    <PageWrapper>
      <div className="grid gap-3 md:grid-cols-2">
        <SectionBox title="📝 견적">
          <p className="text-3xl font-semibold text-brand-500">{stats.totalQuotes.toLocaleString()}</p>
        </SectionBox>
        <SectionBox title="📋 예약">
          <p className="text-3xl font-semibold text-brand-500">{stats.totalReservations.toLocaleString()}</p>
        </SectionBox>
      </div>
      <SectionBox title="유형별 예약">
        <ul className="space-y-1 text-sm">
          {Object.entries(stats.byType).map(([k, v]) => (
            <li key={k} className="flex justify-between">
              <span className="text-gray-600">{k}</span>
              <span className="text-gray-700">{v}</span>
            </li>
          ))}
        </ul>
      </SectionBox>
      <SectionBox title="상태별 예약">
        <ul className="space-y-1 text-sm">
          {Object.entries(stats.byStatus).map(([k, v]) => (
            <li key={k} className="flex justify-between">
              <span className="text-gray-600">{k}</span>
              <span className="text-gray-700">{v}</span>
            </li>
          ))}
        </ul>
      </SectionBox>
    </PageWrapper>
  );
}
