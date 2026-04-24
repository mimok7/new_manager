'use client';

import { useEffect, useMemo, useState } from 'react';
import { PageWrapper, SectionBox, Spinner, UnifiedConfirmation } from '@sht/ui';
import type { UnifiedQuoteData } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { confirmation as confirmationDomain } from '@sht/domain';

interface ConfirmRow {
  id: string;
  quote_id: string;
  status: string | null;
  created_at: string;
}

export default function ManagerConfirmationPage() {
  const [items, setItems] = useState<ConfirmRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [previewQuoteId, setPreviewQuoteId] = useState<string | null>(null);
  const [previewData, setPreviewData] = useState<UnifiedQuoteData | null>(null);
  const [previewLoading, setPreviewLoading] = useState(false);
  const supabase = useMemo(() => createSupabaseBrowserClient(), []);

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      try {
        const { data } = await supabase
          .from('reservation_confirmation')
          .select('id, quote_id, status, created_at')
          .order('created_at', { ascending: false })
          .limit(100);
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
  }, [supabase]);

  useEffect(() => {
    let cancelled = false;
    if (!previewQuoteId) {
      setPreviewData(null);
      return;
    }
    setPreviewLoading(true);
    void confirmationDomain
      .buildConfirmationData(supabase, previewQuoteId)
      .then((d) => {
        if (!cancelled) setPreviewData(d);
      })
      .finally(() => {
        if (!cancelled) setPreviewLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [previewQuoteId, supabase]);

  return (
    <PageWrapper>
      <SectionBox title="📄 확정서 관리">
        {loading ? (
          <Spinner />
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">확정서 없음</p>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-100 text-left text-xs text-gray-500">
                <th className="py-2">견적</th>
                <th className="py-2">상태</th>
                <th className="py-2">생성</th>
                <th className="py-2 text-right">미리보기</th>
              </tr>
            </thead>
            <tbody>
              {items.map((c) => (
                <tr key={c.id} className="border-b border-gray-50">
                  <td className="py-2 font-mono text-xs text-gray-700">
                    {c.quote_id.slice(0, 8)}…
                  </td>
                  <td className="py-2 text-gray-500">{c.status || '-'}</td>
                  <td className="py-2 text-xs text-gray-500">
                    {new Date(c.created_at).toLocaleString('ko-KR')}
                  </td>
                  <td className="py-2 text-right">
                    <button
                      type="button"
                      onClick={() => setPreviewQuoteId(c.quote_id)}
                      className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
                    >
                      열기
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </SectionBox>

      {previewQuoteId && (
        <SectionBox
          title={`확정서 미리보기 — ${previewQuoteId.slice(0, 8)}…`}
          right={
            <div className="flex gap-2">
              <button
                type="button"
                onClick={() => window.print()}
                className="rounded bg-brand-500 px-3 py-1 text-xs text-white hover:bg-brand-600"
              >
                인쇄
              </button>
              <button
                type="button"
                onClick={() => setPreviewQuoteId(null)}
                className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
              >
                닫기
              </button>
            </div>
          }
        >
          {previewLoading ? (
            <Spinner />
          ) : previewData ? (
            <UnifiedConfirmation data={previewData} />
          ) : (
            <p className="text-sm text-red-500">데이터를 불러오지 못했습니다.</p>
          )}
        </SectionBox>
      )}
    </PageWrapper>
  );
}
