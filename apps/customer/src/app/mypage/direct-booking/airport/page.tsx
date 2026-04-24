'use client';

import { useEffect, useState, type FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { quote as quoteDomain, reservation as reservationDomain, datetime } from '@sht/domain';

interface AirportPriceRow {
  airport_code: string;
  service_type?: string | null;
  route?: string | null;
  vehicle_type?: string | null;
  price?: number | null;
}

export default function AirportDirectBookingPage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth('/login');
  const [options, setOptions] = useState<AirportPriceRow[]>([]);
  const [selected, setSelected] = useState<AirportPriceRow | null>(null);
  const [whenStr, setWhenStr] = useState('');
  const [flight, setFlight] = useState('');
  const [pax, setPax] = useState(2);
  const [requestNote, setRequestNote] = useState('');
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const { data } = await supabase
          .from('airport_price')
          .select('airport_code, service_type, route, vehicle_type, price')
          .order('price', { ascending: true })
          .limit(80);
        if (!cancelled) setOptions((data || []) as AirportPriceRow[]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, []);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!user || !selected || submitting) return;
    setSubmitting(true);
    setError(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const draft = await quoteDomain.createOrReuseDraft(supabase, user.id, '공항 직접 예약');
      const reservation = await reservationDomain.ensureReservation(
        supabase,
        user.id,
        draft.id,
        'airport',
      );
      const { error: dErr } = await supabase.from('reservation_airport').upsert(
        {
          reservation_id: reservation.re_id,
          airport_price_code: selected.airport_code,
          ra_datetime: datetime.toDbDateTimeKst(whenStr) || whenStr,
          ra_flight_number: flight || null,
          ra_passenger_count: pax,
          ra_airport_location: selected.route || null,
          way_type: selected.service_type || null,
          request_note: requestNote || null,
        },
        { onConflict: 'reservation_id' },
      );
      if (dErr) throw dErr;
      router.replace(`/mypage/reservations/${reservation.re_id}` as never);
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setSubmitting(false);
    }
  };

  if (authLoading || loading) return <PageWrapper><Spinner /></PageWrapper>;

  return (
    <PageWrapper>
      <SectionBox title="✈️ 공항 직접 예약">
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="mb-1 block text-sm text-gray-600">서비스 선택</label>
            <div className="grid gap-2 md:grid-cols-2">
              {options.map((o) => (
                <button
                  type="button"
                  key={o.airport_code + (o.service_type || '')}
                  onClick={() => setSelected(o)}
                  className={`rounded border-2 p-3 text-left text-sm transition ${
                    selected?.airport_code === o.airport_code &&
                    selected?.service_type === o.service_type
                      ? 'border-brand-500 bg-brand-50'
                      : 'border-gray-200 bg-white hover:border-brand-200'
                  }`}
                >
                  <div className="font-medium text-gray-700">
                    [{o.service_type}] {o.route}
                  </div>
                  <div className="text-xs text-gray-500">
                    {o.vehicle_type} · {o.price?.toLocaleString() || 0}동
                  </div>
                </button>
              ))}
            </div>
          </div>
          <div className="grid gap-3 md:grid-cols-3">
            <div>
              <label className="mb-1 block text-sm text-gray-600">일시</label>
              <input
                type="datetime-local"
                value={whenStr}
                onChange={(e) => setWhenStr(e.target.value)}
                required
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">항공편</label>
              <input
                value={flight}
                onChange={(e) => setFlight(e.target.value)}
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">인원</label>
              <input
                type="number"
                min={1}
                value={pax}
                onChange={(e) => setPax(parseInt(e.target.value, 10) || 1)}
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
          </div>
          <div>
            <label className="mb-1 block text-sm text-gray-600">요청사항</label>
            <textarea
              value={requestNote}
              onChange={(e) => setRequestNote(e.target.value)}
              rows={4}
              className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
            />
          </div>
          {error && <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>}
          <button
            type="submit"
            disabled={!selected || submitting}
            className="rounded bg-brand-500 px-4 py-2 text-sm text-white hover:bg-brand-600 disabled:opacity-50"
          >
            {submitting ? '예약 중…' : '예약하기'}
          </button>
        </form>
      </SectionBox>
    </PageWrapper>
  );
}
