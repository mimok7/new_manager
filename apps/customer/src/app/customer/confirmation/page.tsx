'use client';

import { Suspense, useEffect, useMemo, useState } from 'react';
import { useSearchParams } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner, UnifiedConfirmation } from '@sht/ui';
import type { UnifiedQuoteData } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { confirmation as confirmationDomain } from '@sht/domain';

export const dynamic = 'force-dynamic';

function ConfirmationInner() {
  const params = useSearchParams();
  const quoteId = params?.get('quote_id') || '';
  const supabase = useMemo(() => createSupabaseBrowserClient(), []);
  const [data, setData] = useState<UnifiedQuoteData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    if (!quoteId) {
      setLoading(false);
      return;
    }
    void confirmationDomain
      .buildConfirmationData(supabase, quoteId)
      .then((d) => {
        if (cancelled) return;
        setData(d);
        if (!d) setError('확정서 데이터를 찾을 수 없습니다.');
      })
      .catch((e: Error) => {
        if (!cancelled) setError(e.message);
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [quoteId, supabase]);

  return (
    <PageWrapper>
      <SectionBox
        title="📄 예약 확정서"
        right={
          data && (
            <button
              type="button"
              onClick={() => window.print()}
              className="rounded bg-brand-500 px-3 py-1 text-xs text-white hover:bg-brand-600"
            >
              인쇄
            </button>
          )
        }
      >
        {loading ? (
          <Spinner />
        ) : !quoteId ? (
          <p className="text-sm text-red-500">quote_id 파라미터가 없습니다.</p>
        ) : error ? (
          <p className="text-sm text-red-500">{error}</p>
        ) : data ? (
          <UnifiedConfirmation data={data} />
        ) : null}
      </SectionBox>
    </PageWrapper>
  );
}

export default function CustomerConfirmationPage() {
  return (
    <Suspense
      fallback={
        <PageWrapper>
          <Spinner />
        </PageWrapper>
      }
    >
      <ConfirmationInner />
    </Suspense>
  );
}

