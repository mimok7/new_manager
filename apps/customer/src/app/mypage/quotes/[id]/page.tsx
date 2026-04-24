'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { quote as quoteDomain } from '@sht/domain';

export default function QuoteDetailPage() {
  const params = useParams<{ id: string }>();
  const id = params?.id;
  const [data, setData] = useState<{ quote: quoteDomain.QuoteRow; items: quoteDomain.QuoteItemRow[] } | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const result = await quoteDomain.getQuoteWithItems(supabase, id);
        if (!cancelled) setData(result);
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
  }, [id]);

  if (loading) return <PageWrapper><Spinner /></PageWrapper>;
  if (error) return <PageWrapper><p className="text-sm text-red-500">{error}</p></PageWrapper>;
  if (!data) return <PageWrapper><p className="text-sm text-gray-500">견적을 찾을 수 없습니다.</p></PageWrapper>;

  return (
    <PageWrapper>
      <SectionBox title={`견적: ${data.quote.title}`}>
        <dl className="grid grid-cols-2 gap-2 text-sm">
          <dt className="text-gray-500">상태</dt>
          <dd className="text-gray-700">{data.quote.status || 'draft'}</dd>
          <dt className="text-gray-500">생성일</dt>
          <dd className="text-gray-700">{new Date(data.quote.created_at).toLocaleString('ko-KR')}</dd>
        </dl>
      </SectionBox>
      <SectionBox title="포함 서비스">
        {data.items.length === 0 ? (
          <p className="text-sm text-gray-500">포함된 서비스가 없습니다.</p>
        ) : (
          <ul className="divide-y divide-gray-100">
            {data.items.map((item) => (
              <li key={item.id} className="flex justify-between py-2 text-sm">
                <span className="text-gray-700">{item.service_type}</span>
                <span className="text-gray-500">
                  {item.quantity} × {item.unit_price.toLocaleString()} = {item.total_price.toLocaleString()}동
                </span>
              </li>
            ))}
          </ul>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
