'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface QuoteRow {
  id: string;
  user_id: string;
  title: string;
  status: string | null;
  created_at: string;
}

const STATUSES = ['all', 'draft', 'requested', 'approved', 'rejected'] as const;

export default function ManagerQuotesPage() {
  const [items, setItems] = useState<QuoteRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<(typeof STATUSES)[number]>('all');

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      setLoading(true);
      try {
        const supabase = createSupabaseBrowserClient();
        let q = supabase
          .from('quote')
          .select('id, user_id, title, status, created_at')
          .order('created_at', { ascending: false })
          .limit(200);
        if (filter !== 'all') q = q.eq('status', filter);
        const { data } = await q;
        if (!cancelled) setItems((data || []) as QuoteRow[]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, [filter]);

  return (
    <PageWrapper>
      <SectionBox
        title="📝 견적 관리"
        right={
          <select
            value={filter}
            onChange={(e) => setFilter(e.target.value as typeof filter)}
            className="rounded border border-gray-200 px-2 py-1 text-xs"
          >
            {STATUSES.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        }
      >
        {loading ? (
          <Spinner />
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">견적이 없습니다.</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-gray-100 text-left text-xs text-gray-500">
                  <th className="py-2">제목</th>
                  <th className="py-2">상태</th>
                  <th className="py-2">생성</th>
                  <th className="py-2"></th>
                </tr>
              </thead>
              <tbody>
                {items.map((q) => (
                  <tr key={q.id} className="border-b border-gray-50">
                    <td className="py-2 text-gray-700">{q.title}</td>
                    <td className="py-2 text-gray-500">{q.status || 'draft'}</td>
                    <td className="py-2 text-xs text-gray-500">
                      {new Date(q.created_at).toLocaleString('ko-KR')}
                    </td>
                    <td className="py-2 text-right">
                      <Link
                        href={`/manager/quotes/${q.id}` as never}
                        className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
                      >
                        상세
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
