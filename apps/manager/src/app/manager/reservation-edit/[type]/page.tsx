'use client';

import { useEffect, useState } from 'react';
import { useParams, useSearchParams } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { ReservationDetailForm } from './ReservationDetailForm';

const TABLE_MAP: Record<string, string> = {
  cruise: 'reservation_cruise',
  airport: 'reservation_airport',
  hotel: 'reservation_hotel',
  rentcar: 'reservation_rentcar',
  tour: 'reservation_tour',
  sht: 'reservation_car_sht',
  vehicle: 'reservation_car_sht',
};

export default function ReservationEditPage() {
  const params = useParams<{ type: string }>();
  const search = useSearchParams();
  const reservationId = search?.get('id');
  const type = params?.type || '';
  const tbl = TABLE_MAP[type];

  const [reservation, setReservation] = useState<Record<string, unknown> | null>(null);
  const [detail, setDetail] = useState<Record<string, unknown> | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  useEffect(() => {
    if (!reservationId || !tbl) return;
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const [{ data: r }, { data: d }] = await Promise.all([
          supabase.from('reservation').select('*').eq('re_id', reservationId).maybeSingle(),
          supabase.from(tbl).select('*').eq('reservation_id', reservationId).maybeSingle(),
        ]);
        if (cancelled) return;
        setReservation((r as Record<string, unknown> | null) ?? null);
        setDetail((d as Record<string, unknown> | null) ?? {});
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, [reservationId, tbl]);

  const handleStatus = async (newStatus: string) => {
    if (!reservationId) return;
    setSaving(true);
    try {
      const supabase = createSupabaseBrowserClient();
      const { error } = await supabase
        .from('reservation')
        .update({ re_status: newStatus } as never)
        .eq('re_id', reservationId);
      if (error) setMessage('상태 변경 실패: ' + error.message);
      else {
        setMessage('상태가 ' + newStatus + ' 로 변경되었습니다.');
        setReservation({ ...(reservation || {}), re_status: newStatus });
      }
    } finally {
      setSaving(false);
    }
  };

  if (!reservationId)
    return <PageWrapper><p className="text-sm text-red-500">id 파라미터가 필요합니다.</p></PageWrapper>;
  if (!tbl) return <PageWrapper><p className="text-sm text-red-500">알 수 없는 유형: {type}</p></PageWrapper>;
  if (loading) return <PageWrapper><Spinner /></PageWrapper>;

  return (
    <PageWrapper>
      <SectionBox
        title={`${type} 예약 편집`}
        right={
          <div className="flex gap-2">
            <button
              type="button"
              onClick={() => handleStatus('confirmed')}
              disabled={saving}
              className="rounded bg-green-500 px-3 py-1 text-xs text-white hover:bg-green-600 disabled:opacity-50"
            >
              확정
            </button>
            <button
              type="button"
              onClick={() => handleStatus('cancelled')}
              disabled={saving}
              className="rounded bg-red-500 px-3 py-1 text-xs text-white hover:bg-red-600 disabled:opacity-50"
            >
              취소
            </button>
          </div>
        }
      >
        {message && (
          <p className="mb-3 rounded bg-blue-50 px-3 py-2 text-sm text-blue-600">{message}</p>
        )}
        <pre className="max-h-64 overflow-auto rounded bg-gray-50 p-3 text-xs text-gray-600">
          {JSON.stringify(reservation, null, 2)}
        </pre>
      </SectionBox>
      <SectionBox title="서비스 상세">
        <ReservationDetailForm
          type={type}
          detail={(detail || {}) as Record<string, unknown>}
          saving={saving}
          onSave={async (next) => {
            setSaving(true);
            try {
              const supabase = createSupabaseBrowserClient();
              const { error } = await supabase
                .from(tbl)
                .update(next as never)
                .eq('reservation_id', reservationId);
              if (error) setMessage('저장 실패: ' + error.message);
              else {
                setMessage('서비스 상세가 저장되었습니다.');
                setDetail(next);
              }
            } finally {
              setSaving(false);
            }
          }}
        />
        <details className="mt-4">
          <summary className="cursor-pointer text-xs text-gray-400">RAW 보기</summary>
          <pre className="mt-2 max-h-96 overflow-auto rounded bg-gray-50 p-3 text-xs text-gray-600">
            {JSON.stringify(detail, null, 2)}
          </pre>
        </details>
      </SectionBox>
    </PageWrapper>
  );
}
