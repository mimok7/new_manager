'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { PageWrapper, SectionBox, Spinner, UnifiedConfirmation } from '@sht/ui';
import type { UnifiedQuoteData } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { quote as quoteDomain, confirmation as confirmationDomain } from '@sht/domain';

export default function ManagerQuoteDetailPage() {
  const params = useParams<{ id: string }>();
  const id = params?.id;
  const [data, setData] = useState<{ quote: quoteDomain.QuoteRow; items: quoteDomain.QuoteItemRow[] } | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [confirmData, setConfirmData] = useState<UnifiedQuoteData | null>(null);
  const [issuing, setIssuing] = useState(false);
  const [issueMsg, setIssueMsg] = useState<string | null>(null);

  const refresh = async () => {
    if (!id) return;
    const supabase = createSupabaseBrowserClient();
    const r = await quoteDomain.getQuoteWithItems(supabase, id);
    setData(r);
  };

  useEffect(() => {
    if (!id) return;
    let cancelled = false;
    const run = async () => {
      try {
        await refresh();
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
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  const updateStatus = async (status: string) => {
    if (!data) return;
    const supabase = createSupabaseBrowserClient();
    await supabase.from('quote').update({ status } as never).eq('id', data.quote.id);
    await refresh();
  };

  const issueConfirmation = async () => {
    if (!data) return;
    setIssuing(true);
    setIssueMsg(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const built = await confirmationDomain.buildConfirmationData(supabase, data.quote.id);
      setConfirmData(built);
      // confirmation row upsert
      const { error: upErr } = await supabase
        .from('reservation_confirmation')
        .upsert(
          {
            quote_id: data.quote.id,
            status: 'issued',
            created_at: new Date().toISOString(),
          } as never,
          { onConflict: 'quote_id' },
        );
      if (upErr) throw upErr;
      await supabase.from('quote').update({ status: 'confirmed' } as never).eq('id', data.quote.id);
      setIssueMsg('확정서 발급 완료');
      await refresh();
    } catch (e) {
      setIssueMsg('발급 실패: ' + (e as Error).message);
    } finally {
      setIssuing(false);
    }
  };

  if (loading) return <PageWrapper><Spinner /></PageWrapper>;
  if (error) return <PageWrapper><p className="text-sm text-red-500">{error}</p></PageWrapper>;
  if (!data) return <PageWrapper><p className="text-sm text-gray-500">견적 없음</p></PageWrapper>;

  return (
    <PageWrapper>
      <SectionBox
        title={`견적: ${data.quote.title}`}
        right={
          <div className="flex gap-2">
            <button
              type="button"
              onClick={() => updateStatus('approved')}
              className="rounded bg-green-500 px-3 py-1 text-xs text-white hover:bg-green-600"
            >
              승인
            </button>
            <button
              type="button"
              onClick={() => updateStatus('rejected')}
              className="rounded bg-red-500 px-3 py-1 text-xs text-white hover:bg-red-600"
            >
              거절
            </button>
            <button
              type="button"
              onClick={issueConfirmation}
              disabled={issuing}
              className="rounded bg-brand-500 px-3 py-1 text-xs text-white hover:bg-brand-600 disabled:opacity-50"
            >
              {issuing ? '발급 중…' : '확정서 발급'}
            </button>
            <Link
              href={`/manager/confirmation?quote_id=${data?.quote.id ?? ''}` as never}
              className="rounded border border-gray-200 px-3 py-1 text-xs text-gray-600 hover:bg-gray-50"
            >
              확정서 목록
            </Link>
          </div>
        }
      >
        <dl className="grid grid-cols-2 gap-2 text-sm">
          <dt className="text-gray-500">상태</dt>
          <dd className="text-gray-700">{data.quote.status || 'draft'}</dd>
          <dt className="text-gray-500">사용자</dt>
          <dd className="font-mono text-xs text-gray-500">{data.quote.user_id}</dd>
          <dt className="text-gray-500">생성</dt>
          <dd>{new Date(data.quote.created_at).toLocaleString('ko-KR')}</dd>
        </dl>
      </SectionBox>

      <SectionBox title="포함 서비스">
        {data.items.length === 0 ? (
          <p className="text-sm text-gray-500">없음</p>
        ) : (
          <ul className="divide-y divide-gray-100">
            {data.items.map((it) => (
              <li key={it.id} className="flex justify-between py-2 text-sm">
                <span className="text-gray-700">{it.service_type}</span>
                <span className="text-gray-500">
                  {it.quantity} × {it.unit_price.toLocaleString()} = {it.total_price.toLocaleString()}동
                </span>
              </li>
            ))}
          </ul>
        )}
      </SectionBox>
      {issueMsg && (
        <SectionBox title="확정서 발급 결과">
          <p className="text-sm text-brand-600">{issueMsg}</p>
        </SectionBox>
      )}
      {confirmData && (
        <SectionBox
          title="확정서 미리보기"
          right={
            <button
              type="button"
              onClick={() => window.print()}
              className="rounded bg-brand-500 px-3 py-1 text-xs text-white hover:bg-brand-600"
            >
              인쇄
            </button>
          }
        >
          <UnifiedConfirmation data={confirmData} />
        </SectionBox>
      )}
    </PageWrapper>
  );
}
