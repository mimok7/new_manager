'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { quote as quoteDomain } from '@sht/domain';

export default function QuotesPage() {
  const { user, loading: authLoading } = useAuth('/login');
  const [items, setItems] = useState<quoteDomain.QuoteRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    if (authLoading || !user) return;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const data = await quoteDomain.listQuotes(supabase, user.id);
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
        title="📝 내 견적"
        right={
          <Link
            href="/mypage/quotes/new"
            className="rounded bg-brand-500 px-3 py-1 text-xs text-white hover:bg-brand-600"
          >
            새 견적 만들기
          </Link>
        }
      >
        {loading ? (
          <Spinner />
        ) : error ? (
          <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">견적이 없습니다.</p>
        ) : (
          <ul className="divide-y divide-gray-100">
            {items.map((q) => (
              <li key={q.id} className="flex items-center justify-between py-3">
                <div>
                  <div className="text-sm font-medium text-gray-700">{q.title}</div>
                  <div className="text-xs text-gray-500">
                    {new Date(q.created_at).toLocaleString('ko-KR')} · {q.status || 'draft'}
                  </div>
                </div>
                <Link
                  href={`/mypage/quotes/${q.id}`}
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
