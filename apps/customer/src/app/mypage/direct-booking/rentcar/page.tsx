'use client';

import { useEffect, useState, type FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { quote as quoteDomain, reservation as reservationDomain, datetime } from '@sht/domain';

interface RentcarPriceRow {
  rentcar_price_code: string;
  vehicle_type?: string | null;
  description?: string | null;
  price?: number | null;
}

export default function RentcarDirectBookingPage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth('/login');
  const [options, setOptions] = useState<RentcarPriceRow[]>([]);
  const [selected, setSelected] = useState<RentcarPriceRow | null>(null);
  const [pickup, setPickup] = useState('');
  const [days, setDays] = useState(1);
  const [pax, setPax] = useState(2);
  const [destination, setDestination] = useState('');
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
          .from('rentcar_price')
          .select('rentcar_price_code, vehicle_type, description, price')
          .order('price', { ascending: true })
          .limit(60);
        if (!cancelled) setOptions((data || []) as RentcarPriceRow[]);
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
      const draft = await quoteDomain.createOrReuseDraft(supabase, user.id, '렌터카 직접 예약');
      const reservation = await reservationDomain.ensureReservation(
        supabase,
        user.id,
        draft.id,
        'rentcar',
      );
      const { error: dErr } = await supabase.from('reservation_rentcar').upsert(
        {
          reservation_id: reservation.re_id,
          rentcar_price_code: selected.rentcar_price_code,
          pickup_datetime: datetime.toDbDateTimeKst(pickup) || pickup,
          rental_days: days,
          driver_count: pax,
          destination,
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
      <SectionBox title="🚗 렌터카 직접 예약">
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid gap-2 md:grid-cols-2">
            {options.map((o) => (
              <button
                type="button"
                key={o.rentcar_price_code}
                onClick={() => setSelected(o)}
                className={`rounded border-2 p-3 text-left text-sm transition ${
                  selected?.rentcar_price_code === o.rentcar_price_code
                    ? 'border-brand-500 bg-brand-50'
                    : 'border-gray-200 bg-white hover:border-brand-200'
                }`}
              >
                <div className="font-medium text-gray-700">{o.vehicle_type || o.rentcar_price_code}</div>
                <div className="text-xs text-gray-500">
                  {o.description} · {o.price?.toLocaleString() || 0}동
                </div>
              </button>
            ))}
          </div>
          <div className="grid gap-3 md:grid-cols-3">
            <div>
              <label className="mb-1 block text-sm text-gray-600">픽업 일시</label>
              <input
                type="datetime-local"
                value={pickup}
                onChange={(e) => setPickup(e.target.value)}
                required
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">대여일</label>
              <input
                type="number"
                min={1}
                value={days}
                onChange={(e) => setDays(parseInt(e.target.value, 10) || 1)}
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">탑승자</label>
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
            <label className="mb-1 block text-sm text-gray-600">목적지</label>
            <input
              value={destination}
              onChange={(e) => setDestination(e.target.value)}
              className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
            />
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
