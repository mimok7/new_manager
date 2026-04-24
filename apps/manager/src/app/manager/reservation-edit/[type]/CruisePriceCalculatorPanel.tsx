'use client';

import { useEffect, useMemo, useState } from 'react';
import { pricing } from '@sht/domain';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface Props {
  /** reservation_cruise 행 (room_price_code, schedule, cruise_name, room_type, checkin, 인원 등) */
  detail: Record<string, unknown>;
  onApply?: (totals: {
    room_total_price: number;
    car_total_price: number;
    surcharge_total: number;
    total_price: number;
    price_breakdown: Record<string, unknown>;
  }) => void;
}

const SCHEDULES = ['1박2일', '2박3일', '3박4일', '당일'] as const;

export function CruisePriceCalculatorPanel({ detail, onApply }: Props) {
  const supabase = useMemo(() => createSupabaseBrowserClient(), []);
  const calc = useMemo(() => new pricing.CruisePriceCalculator(supabase), [supabase]);

  const [schedule, setSchedule] = useState<string>(
    (detail['schedule'] as string) || '2박3일',
  );
  const [cruiseName, setCruiseName] = useState<string>((detail['cruise_name'] as string) || '');
  const [roomType, setRoomType] = useState<string>((detail['room_type'] as string) || '');
  const [checkin, setCheckin] = useState<string>(
    (detail['checkin'] as string)?.slice(0, 10) || '',
  );
  const [adult, setAdult] = useState<number>(Number(detail['adult_count'] ?? 2));
  const [child, setChild] = useState<number>(Number(detail['child_count'] ?? 0));
  const [infant, setInfant] = useState<number>(Number(detail['infant_count'] ?? 0));
  const [extra, setExtra] = useState<number>(Number(detail['extra_count'] ?? 0));
  const [single, setSingle] = useState<number>(Number(detail['single_count'] ?? 0));

  const [cruiseNames, setCruiseNames] = useState<string[]>([]);
  const [roomTypes, setRoomTypes] = useState<string[]>([]);
  const [result, setResult] = useState<pricing.CruisePriceResult | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    void calc
      .getCruiseNames({ schedule })
      .then(setCruiseNames)
      .catch(() => setCruiseNames([]));
  }, [calc, schedule]);

  useEffect(() => {
    if (!cruiseName) {
      setRoomTypes([]);
      return;
    }
    void calc
      .getRoomTypes({ schedule, cruise_name: cruiseName })
      .then((rows) => {
        const types = Array.from(new Set(rows.map((r) => r.room_type).filter(Boolean)));
        setRoomTypes(types as string[]);
      })
      .catch(() => setRoomTypes([]));
  }, [calc, schedule, cruiseName]);

  const recompute = async () => {
    if (!cruiseName || !roomType || !checkin) {
      setError('일정/크루즈/객실/체크인을 모두 선택하세요.');
      return;
    }
    setError(null);
    setLoading(true);
    try {
      const r = await calc.calculate({
        schedule,
        cruise_name: cruiseName,
        room_type: roomType,
        checkin_date: checkin,
        adult_count: adult,
        child_count: child,
        infant_count: infant,
        extra_bed_count: extra,
        single_count: single,
        selected_options: [],
      });
      setResult(r);
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setLoading(false);
    }
  };

  const apply = () => {
    if (!result) return;
    onApply?.({
      room_total_price: result.subtotal,
      car_total_price: 0,
      surcharge_total: result.surcharge_total,
      total_price: result.grand_total,
      price_breakdown: result.price_breakdown,
    });
  };

  return (
    <div className="space-y-3 rounded border border-brand-200 bg-brand-50 p-3">
      <div className="text-sm font-semibold text-brand-600">🚢 크루즈 가격 재계산</div>

      <div className="grid gap-2 md:grid-cols-4">
        <div>
          <label className="block text-xs text-gray-500">일정</label>
          <select
            value={schedule}
            onChange={(e) => {
              setSchedule(e.target.value);
              setCruiseName('');
              setRoomType('');
            }}
            className="w-full rounded border border-gray-200 px-2 py-1 text-sm"
          >
            {SCHEDULES.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label className="block text-xs text-gray-500">크루즈명</label>
          <select
            value={cruiseName}
            onChange={(e) => {
              setCruiseName(e.target.value);
              setRoomType('');
            }}
            className="w-full rounded border border-gray-200 px-2 py-1 text-sm"
          >
            <option value="">선택</option>
            {cruiseNames.map((n) => (
              <option key={n} value={n}>
                {n}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label className="block text-xs text-gray-500">객실</label>
          <select
            value={roomType}
            onChange={(e) => setRoomType(e.target.value)}
            className="w-full rounded border border-gray-200 px-2 py-1 text-sm"
          >
            <option value="">선택</option>
            {roomTypes.map((r) => (
              <option key={r} value={r}>
                {r}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label className="block text-xs text-gray-500">체크인</label>
          <input
            type="date"
            value={checkin}
            onChange={(e) => setCheckin(e.target.value)}
            className="w-full rounded border border-gray-200 px-2 py-1 text-sm"
          />
        </div>
      </div>

      <div className="grid gap-2 md:grid-cols-5">
        {([
          ['성인', adult, setAdult],
          ['아동', child, setChild],
          ['유아', infant, setInfant],
          ['엑베', extra, setExtra],
          ['싱글', single, setSingle],
        ] as Array<[string, number, (n: number) => void]>).map(([label, val, set]) => (
          <div key={label}>
            <label className="block text-xs text-gray-500">{label}</label>
            <input
              type="number"
              min={0}
              value={val}
              onChange={(e) => set(Number(e.target.value) || 0)}
              className="w-full rounded border border-gray-200 px-2 py-1 text-sm"
            />
          </div>
        ))}
      </div>

      {error && <p className="text-xs text-red-500">{error}</p>}

      <div className="flex items-center gap-2">
        <button
          type="button"
          onClick={recompute}
          disabled={loading}
          className="rounded bg-brand-500 px-3 py-1 text-xs text-white hover:bg-brand-600 disabled:opacity-50"
        >
          {loading ? '계산 중…' : '가격 재계산'}
        </button>
        {result && (
          <button
            type="button"
            onClick={apply}
            className="rounded border border-brand-500 px-3 py-1 text-xs text-brand-600 hover:bg-white"
          >
            계산 결과 적용
          </button>
        )}
      </div>

      {result && (
        <div className="rounded border border-gray-200 bg-white p-3 text-xs text-gray-700">
          <div>객실 소계: {result.subtotal.toLocaleString()}동</div>
          <div>추가요금: {result.surcharge_total.toLocaleString()}동</div>
          {result.option_total > 0 && (
            <div>옵션: {result.option_total.toLocaleString()}동</div>
          )}
          <div className="mt-1 text-sm font-bold text-red-500">
            합계: {result.grand_total.toLocaleString()}동
          </div>
          {result.has_unconfirmed_surcharge && (
            <div className="mt-1 text-[11px] text-yellow-600">⚠ 공휴일 추가요금 미확정 항목 포함</div>
          )}
        </div>
      )}
    </div>
  );
}
