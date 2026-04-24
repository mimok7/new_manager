'use client';

import { useEffect, useMemo, useState, type FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import {
  quote as quoteDomain,
  reservation as reservationDomain,
  datetime,
  pricing,
} from '@sht/domain';

const SCHEDULES = ['1박2일', '2박3일', '3박4일', '당일'];

export default function CruiseDirectBookingPage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth('/login');
  const supabase = useMemo(() => createSupabaseBrowserClient(), []);
  const calc = useMemo(() => new pricing.CruisePriceCalculator(supabase), [supabase]);

  const [schedule, setSchedule] = useState('2박3일');
  const [checkin, setCheckin] = useState('');
  const [cruiseNames, setCruiseNames] = useState<string[]>([]);
  const [cruiseName, setCruiseName] = useState('');
  const [rateCards, setRateCards] = useState<pricing.CruiseRateCard[]>([]);
  const [selected, setSelected] = useState<pricing.CruiseRateCard | null>(null);

  const [adultCount, setAdultCount] = useState(2);
  const [childCount, setChildCount] = useState(0);
  const [infantCount, setInfantCount] = useState(0);
  const [extraBedCount, setExtraBedCount] = useState(0);
  const [singleCount, setSingleCount] = useState(0);
  const [requestNote, setRequestNote] = useState('');

  const [priceResult, setPriceResult] = useState<pricing.CruisePriceResult | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loadingNames, setLoadingNames] = useState(false);
  const [loadingRooms, setLoadingRooms] = useState(false);

  const checkinDate = useMemo(() => (checkin ? checkin.slice(0, 10) : ''), [checkin]);

  useEffect(() => {
    let cancelled = false;
    if (!schedule || !checkinDate) return;
    setLoadingNames(true);
    void calc
      .getCruiseNames({ schedule, checkin_date: checkinDate })
      .then((names) => {
        if (cancelled) return;
        setCruiseNames(names);
        if (!names.includes(cruiseName)) {
          setCruiseName(names[0] || '');
          setSelected(null);
          setRateCards([]);
        }
      })
      .finally(() => {
        if (!cancelled) setLoadingNames(false);
      });
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [schedule, checkinDate]);

  useEffect(() => {
    let cancelled = false;
    if (!schedule || !checkinDate || !cruiseName) {
      setRateCards([]);
      return;
    }
    setLoadingRooms(true);
    void calc
      .getRoomTypes({ schedule, checkin_date: checkinDate, cruise_name: cruiseName })
      .then((cards) => {
        if (!cancelled) setRateCards(cards);
      })
      .finally(() => {
        if (!cancelled) setLoadingRooms(false);
      });
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [schedule, checkinDate, cruiseName]);

  useEffect(() => {
    let cancelled = false;
    if (!selected || !checkinDate) {
      setPriceResult(null);
      return;
    }
    void calc
      .calculate({
        cruise_name: cruiseName,
        schedule,
        room_type: selected.room_type,
        checkin_date: checkinDate,
        adult_count: adultCount,
        child_count: childCount,
        infant_count: infantCount,
        extra_bed_count: extraBedCount,
        single_count: singleCount,
      })
      .then((res) => {
        if (!cancelled) setPriceResult(res);
      });
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    selected,
    checkinDate,
    cruiseName,
    schedule,
    adultCount,
    childCount,
    infantCount,
    extraBedCount,
    singleCount,
  ]);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!user || !selected || submitting) return;
    setSubmitting(true);
    setError(null);
    try {
      const draft = await quoteDomain.createOrReuseDraft(
        supabase,
        user.id,
        `크루즈 ${cruiseName} ${schedule}`,
      );
      const reservation = await reservationDomain.ensureReservation(
        supabase,
        user.id,
        draft.id,
        'cruise',
      );

      const checkinKst = datetime.toDbDateTimeKst(checkin) || checkin;
      const totalGuests = adultCount + childCount + infantCount;

      const { error: dErr } = await supabase.from('reservation_cruise').upsert(
        {
          reservation_id: reservation.re_id,
          room_price_code: selected.id,
          checkin: checkinKst,
          guest_count: totalGuests,
          adult_count: adultCount,
          child_count: childCount,
          infant_count: infantCount,
          extra_bed_count: extraBedCount,
          single_count: singleCount,
          room_total_price: priceResult?.subtotal ?? null,
          surcharge_total: priceResult?.surcharge_total ?? null,
          total_price: priceResult?.grand_total ?? null,
          price_breakdown: priceResult?.price_breakdown ?? null,
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

  if (authLoading)
    return (
      <PageWrapper>
        <Spinner />
      </PageWrapper>
    );

  return (
    <PageWrapper>
      <SectionBox title="🚢 크루즈 직접 예약">
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid gap-3 md:grid-cols-3">
            <div>
              <label className="mb-1 block text-sm text-gray-600">일정</label>
              <select
                value={schedule}
                onChange={(e) => setSchedule(e.target.value)}
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              >
                {SCHEDULES.map((s) => (
                  <option key={s} value={s}>
                    {s}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">체크인</label>
              <input
                type="datetime-local"
                value={checkin}
                onChange={(e) => setCheckin(e.target.value)}
                required
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">크루즈</label>
              <select
                value={cruiseName}
                onChange={(e) => setCruiseName(e.target.value)}
                disabled={loadingNames || cruiseNames.length === 0}
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm disabled:opacity-50"
              >
                {cruiseNames.length === 0 && <option value="">— 일정/날짜 선택 —</option>}
                {cruiseNames.map((n) => (
                  <option key={n} value={n}>
                    {n}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div>
            <label className="mb-2 block text-sm text-gray-600">객실 선택</label>
            {loadingRooms ? (
              <Spinner />
            ) : rateCards.length === 0 ? (
              <p className="text-xs text-gray-400">선택 조건에 맞는 객실이 없습니다.</p>
            ) : (
              <div className="grid gap-2 md:grid-cols-2">
                {rateCards.map((r) => (
                  <button
                    type="button"
                    key={r.id}
                    onClick={() => setSelected(r)}
                    className={`rounded border-2 p-3 text-left text-sm transition ${
                      selected?.id === r.id
                        ? 'border-brand-500 bg-brand-50'
                        : 'border-gray-200 bg-white hover:border-brand-200'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <span className="font-medium text-gray-700">{r.room_type}</span>
                      {r.is_promotion && (
                        <span className="rounded bg-red-50 px-2 py-0.5 text-xs text-red-500">
                          프로모션
                        </span>
                      )}
                    </div>
                    <div className="mt-1 text-xs text-gray-500">
                      성인 {r.price_adult.toLocaleString()}동
                      {r.price_child != null && ` · 아동 ${r.price_child.toLocaleString()}동`}
                    </div>
                    {r.season_name && (
                      <div className="mt-1 text-xs text-gray-400">{r.season_name}</div>
                    )}
                  </button>
                ))}
              </div>
            )}
          </div>

          <div className="grid gap-3 md:grid-cols-5">
            {(
              [
                ['성인', adultCount, setAdultCount, 1],
                ['아동', childCount, setChildCount, 0],
                ['유아', infantCount, setInfantCount, 0],
                ['엑베', extraBedCount, setExtraBedCount, 0],
                ['싱글', singleCount, setSingleCount, 0],
              ] as Array<[string, number, (n: number) => void, number]>
            ).map(([label, val, setter, min]) => (
              <div key={label}>
                <label className="mb-1 block text-sm text-gray-600">{label}</label>
                <input
                  type="number"
                  min={min}
                  value={val}
                  onChange={(e) => setter(parseInt(e.target.value, 10) || min)}
                  className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
                />
              </div>
            ))}
          </div>

          {priceResult && (
            <div className="rounded bg-yellow-50 p-3 text-sm">
              <div className="mb-2 font-medium text-yellow-800">💰 예상 총 금액</div>
              <ul className="space-y-0.5 text-xs text-gray-600">
                {priceResult.items.map((it, i) => (
                  <li key={i}>
                    {it.label} × {it.count} = {it.total.toLocaleString()}동
                  </li>
                ))}
                {priceResult.surcharges.map((s, i) => (
                  <li key={`sc-${i}`} className={s.is_confirmed ? '' : 'text-gray-400'}>
                    {s.holiday_name} ({s.holiday_date}) {s.is_confirmed ? '' : '— 미확정'}{' '}
                    +{s.total.toLocaleString()}동
                  </li>
                ))}
              </ul>
              <div className="mt-2 text-base font-bold text-red-500">
                합계 {priceResult.grand_total.toLocaleString()}동
              </div>
              {priceResult.has_unconfirmed_surcharge && (
                <p className="mt-1 text-xs text-gray-500">
                  * 미확정 추가요금은 합계에서 제외됨
                </p>
              )}
            </div>
          )}

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
