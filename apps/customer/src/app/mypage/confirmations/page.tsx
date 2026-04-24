'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface ConfirmRow {
  id: string;
  quote_id: string;
  status: string | null;
  created_at: string;
}

export default function ConfirmationsPage() {
  const { user, loading: authLoading } = useAuth('/login');
  const [items, setItems] = useState<ConfirmRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    if (authLoading || !user) return;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        // 사용자 견적의 확정서 조회
        const { data: quotes } = await supabase
          .from('quote')
          .select('id')
          .eq('user_id', user.id);
        const quoteIds = (quotes || []).map((q: { id: string }) => q.id);
        if (quoteIds.length === 0) {
          if (!cancelled) setItems([]);
          return;
        }
        const { data } = await supabase
          .from('reservation_confirmation')
          .select('id, quote_id, status, created_at')
          .in('quote_id', quoteIds)
          .order('created_at', { ascending: false });
        if (!cancelled) setItems((data || []) as ConfirmRow[]);
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
  }, [authLoading, user]);

  return (
    <PageWrapper>
      <SectionBox title="📄 확정서">
        {loading ? (
          <Spinner />
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">발행된 확정서가 없습니다.</p>
        ) : (
          <ul className="divide-y divide-gray-100">
            {items.map((c) => (
              <li key={c.id} className="flex items-center justify-between py-3">
                <div className="text-sm">
                  <div className="text-gray-700">견적 {c.quote_id.slice(0, 8)}…</div>
                  <div className="text-xs text-gray-500">
                    {new Date(c.created_at).toLocaleString('ko-KR')} · {c.status || '-'}
                  </div>
                </div>
                <Link
                  href={`/customer/confirmation?quote_id=${c.quote_id}`}
                  className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
                >
                  보기
                </Link>
              </li>
            ))}
          </ul>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
