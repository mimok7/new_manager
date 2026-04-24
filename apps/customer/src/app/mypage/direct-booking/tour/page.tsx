'use client';

import { useEffect, useState, type FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { quote as quoteDomain, reservation as reservationDomain } from '@sht/domain';

interface TourRow {
  pricing_id: string;
  tour_name?: string | null;
  description?: string | null;
  price_per_person?: number | null;
}

export default function TourDirectBookingPage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth('/login');
  const [options, setOptions] = useState<TourRow[]>([]);
  const [selected, setSelected] = useState<TourRow | null>(null);
  const [tourDate, setTourDate] = useState('');
  const [pax, setPax] = useState(2);
  const [pickupLocation, setPickupLocation] = useState('');
  const [requestNote, setRequestNote] = useState('');
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        // tour + tour_pricing 조인 (단순 select + 후처리)
        const { data: pricings } = await supabase
          .from('tour_pricing')
          .select('pricing_id, tour_id, price_per_person')
          .limit(80);
        const tourIds = Array.from(new Set((pricings || []).map((p: { tour_id: string }) => p.tour_id).filter(Boolean)));
        const { data: tours } = await supabase
          .from('tour')
          .select('tour_id, tour_name, description')
          .in('tour_id', tourIds);
        const tourById = new Map((tours || []).map((t: { tour_id: string; tour_name?: string; description?: string }) => [t.tour_id, t]));
        const merged: TourRow[] = (pricings || []).map((p: { pricing_id: string; tour_id: string; price_per_person?: number }) => {
          const t = tourById.get(p.tour_id);
          return {
            pricing_id: p.pricing_id,
            tour_name: t?.tour_name || p.pricing_id,
            description: t?.description,
            price_per_person: p.price_per_person,
          };
        });
        if (!cancelled) setOptions(merged);
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
      const draft = await quoteDomain.createOrReuseDraft(supabase, user.id, '투어 직접 예약');
      const reservation = await reservationDomain.ensureReservation(
        supabase,
        user.id,
        draft.id,
        'tour',
      );
      const { error: dErr } = await supabase.from('reservation_tour').upsert(
        {
          reservation_id: reservation.re_id,
          tour_price_code: selected.pricing_id,
          usage_date: tourDate || null,
          tour_capacity: pax,
          pickup_location: pickupLocation,
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
      <SectionBox title="🗺️ 투어 직접 예약">
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid gap-2 md:grid-cols-2">
            {options.map((o) => (
              <button
                type="button"
                key={o.pricing_id}
                onClick={() => setSelected(o)}
                className={`rounded border-2 p-3 text-left text-sm transition ${
                  selected?.pricing_id === o.pricing_id
                    ? 'border-brand-500 bg-brand-50'
                    : 'border-gray-200 bg-white hover:border-brand-200'
                }`}
              >
                <div className="font-medium text-gray-700">{o.tour_name}</div>
                <div className="text-xs text-gray-500">
                  {o.description} · {o.price_per_person?.toLocaleString() || 0}동/인
                </div>
              </button>
            ))}
          </div>
          <div className="grid gap-3 md:grid-cols-3">
            <div>
              <label className="mb-1 block text-sm text-gray-600">투어 날짜</label>
              <input
                type="date"
                value={tourDate}
                onChange={(e) => setTourDate(e.target.value)}
                required
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
            <div>
              <label className="mb-1 block text-sm text-gray-600">픽업 장소</label>
              <input
                value={pickupLocation}
                onChange={(e) => setPickupLocation(e.target.value)}
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
