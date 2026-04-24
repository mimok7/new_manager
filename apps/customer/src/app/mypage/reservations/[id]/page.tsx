'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { datetime } from '@sht/domain';

export default function ReservationDetailPage() {
  const params = useParams<{ id: string }>();
  const id = params?.id;
  const [reservation, setReservation] = useState<Record<string, unknown> | null>(null);
  const [detail, setDetail] = useState<Record<string, unknown> | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const { data: r, error: rErr } = await supabase
          .from('reservation')
          .select('*')
          .eq('re_id', id)
          .maybeSingle();
        if (rErr) throw rErr;
        if (!r) throw new Error('예약을 찾을 수 없습니다.');
        if (cancelled) return;
        setReservation(r as Record<string, unknown>);
        const type = (r as { re_type: string }).re_type;
        const map: Record<string, string> = {
          cruise: 'reservation_cruise',
          airport: 'reservation_airport',
          hotel: 'reservation_hotel',
          rentcar: 'reservation_rentcar',
          tour: 'reservation_tour',
          sht: 'reservation_car_sht',
        };
        const tbl = map[type];
        if (tbl) {
          const { data: d } = await supabase
            .from(tbl)
            .select('*')
            .eq('reservation_id', id)
            .maybeSingle();
          if (!cancelled) setDetail((d as Record<string, unknown>) || null);
        }
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
  if (!reservation) return <PageWrapper><p className="text-sm text-gray-500">예약 없음</p></PageWrapper>;

  const r = reservation as { re_id: string; re_type: string; re_status: string | null; re_created_at: string; re_quote_id: string | null };

  return (
    <PageWrapper>
      <SectionBox
        title={`예약 #${r.re_id.slice(0, 8)}`}
        right={
          <Link
            href={`/mypage/reservations/${r.re_id}/change-request`}
            className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-gray-50"
          >
            변경 요청
          </Link>
        }
      >
        <dl className="grid grid-cols-2 gap-2 text-sm">
          <dt className="text-gray-500">유형</dt>
          <dd className="text-gray-700">{r.re_type}</dd>
          <dt className="text-gray-500">상태</dt>
          <dd className="text-gray-700">{r.re_status || '-'}</dd>
          <dt className="text-gray-500">생성</dt>
          <dd className="text-gray-700">{datetime.formatKst(r.re_created_at)}</dd>
          {r.re_quote_id && (
            <>
              <dt className="text-gray-500">견적</dt>
              <dd>
                <Link href={`/mypage/quotes/${r.re_quote_id}`} className="text-brand-500 underline">
                  보기
                </Link>
              </dd>
            </>
          )}
        </dl>
      </SectionBox>

      {detail && (
        <SectionBox title="상세 정보">
          <pre className="max-h-96 overflow-auto rounded bg-gray-50 p-3 text-xs text-gray-600">
            {JSON.stringify(detail, null, 2)}
          </pre>
        </SectionBox>
      )}
    </PageWrapper>
  );
}
