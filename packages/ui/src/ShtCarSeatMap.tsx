'use client';

import React, { useEffect, useMemo, useState } from 'react';
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type SupabaseLike = any;

interface SeatReservation {
  id: string;
  vehicle_number: string | null;
  seat_number: string | null;
  sht_category: string | null;
  usage_date?: string | null;
  pickup_datetime?: string | null;
}

interface Props {
  isOpen: boolean;
  onClose: () => void;
  supabase: SupabaseLike;
  /** YYYY-MM-DD */
  usageDate?: string;
  /** 결과 콜백 */
  onSeatSelect?: (info: { vehicle: string; seat: string; category: string }) => void;
  readOnly?: boolean;
  /** 미저장 닫힘 방지 */
  preventCloseWithoutSave?: boolean;
}

const ALL_VEHICLES = ['Vehicle 1', 'Vehicle 2', 'Vehicle 3', 'Vehicle 4', 'Vehicle 5', 'Vehicle 6'];

const SEAT_LAYOUT = {
  driver: { id: 'DRIVER', x: 54, y: 82, label: 'D' },
  topRow: [
    { id: 'X1', x: 116, y: 78, label: 'X', disabled: true },
    { id: 'C1', x: 168, y: 78, label: 'C1', disabled: false },
  ],
  middleRows: [
    [
      { id: 'A1', x: 80, y: 144, label: 'A1' },
      { id: 'A2', x: 168, y: 144, label: 'A2' },
    ],
    [
      { id: 'A3', x: 80, y: 208, label: 'A3' },
      { id: 'A4', x: 168, y: 208, label: 'A4' },
    ],
    [
      { id: 'A5', x: 80, y: 272, label: 'A5' },
      { id: 'A6', x: 168, y: 272, label: 'A6' },
    ],
  ],
  bottomRow: [
    { id: 'B1', x: 80, y: 354, label: 'B1' },
    { id: 'B2', x: 132, y: 354, label: 'B2' },
    { id: 'B3', x: 184, y: 354, label: 'B3' },
  ],
};

const ALL_SEATS = [
  ...SEAT_LAYOUT.topRow.filter((s) => !s.disabled).map((s) => s.id),
  ...SEAT_LAYOUT.middleRows.flat().map((s) => s.id),
  ...SEAT_LAYOUT.bottomRow.map((s) => s.id),
];

function toDateStr(s?: string | null): string | null {
  if (!s) return null;
  const d = new Date(s);
  if (Number.isNaN(d.getTime())) return null;
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}

export function ShtCarSeatMap({
  isOpen,
  onClose,
  supabase,
  usageDate,
  onSeatSelect,
  readOnly = false,
  preventCloseWithoutSave = false,
}: Props) {
  const todayKst = useMemo(
    () =>
      new Intl.DateTimeFormat('sv-SE', {
        timeZone: 'Asia/Seoul',
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      }).format(new Date()),
    [],
  );

  const [currentDate, setCurrentDate] = useState(usageDate || todayKst);
  const [currentVehicle, setCurrentVehicle] = useState('Vehicle 1');
  const [allData, setAllData] = useState<SeatReservation[]>([]);
  const [selectedSeats, setSelectedSeats] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!isOpen) return;
    setSelectedSeats([]);
    setCurrentVehicle('Vehicle 1');
    setCurrentDate(usageDate || todayKst);
    setLoading(true);
    void (async () => {
      try {
        const { data } = await supabase
          .from('reservation_car_sht')
          .select('id, vehicle_number, seat_number, sht_category, usage_date, pickup_datetime')
          .not('vehicle_number', 'is', null)
          .or(`usage_date.gte.${todayKst},pickup_datetime.gte.${todayKst}`);
        setAllData((data || []) as SeatReservation[]);
      } catch {
        setAllData([]);
      } finally {
        setLoading(false);
      }
    })();
  }, [isOpen, usageDate, todayKst, supabase]);

  const reservationsForVehicle = useMemo(
    () =>
      allData.filter((r) => {
        if (r.vehicle_number !== currentVehicle) return false;
        const d1 = toDateStr(r.usage_date);
        const d2 = toDateStr(r.pickup_datetime);
        return d1 === currentDate || d2 === currentDate;
      }),
    [allData, currentVehicle, currentDate],
  );

  const reservedSet = useMemo(() => {
    const set = new Set<string>();
    let allFlag = false;
    reservationsForVehicle.forEach((r) => {
      const seats = (r.seat_number || '')
        .split(',')
        .map((s) => s.trim().toUpperCase())
        .filter(Boolean);
      if (seats.includes('ALL')) allFlag = true;
      seats.forEach((s) => set.add(s));
    });
    if (allFlag) ALL_SEATS.forEach((s) => set.add(s));
    return set;
  }, [reservationsForVehicle]);

  const handleSeatClick = (seatId: string, disabled?: boolean) => {
    if (readOnly || disabled || seatId === 'DRIVER') return;
    if (reservedSet.has(seatId)) return;
    setSelectedSeats((prev) =>
      prev.includes('ALL')
        ? ALL_SEATS.filter((s) => !reservedSet.has(s) && s !== seatId)
        : prev.includes(seatId)
          ? prev.filter((s) => s !== seatId)
          : [...prev, seatId],
    );
  };

  const handleExclusive = () => {
    const target = ALL_VEHICLES.find((v) => {
      return !allData.some((r) => {
        if (r.vehicle_number !== v) return false;
        const d1 = toDateStr(r.usage_date);
        const d2 = toDateStr(r.pickup_datetime);
        return d1 === currentDate || d2 === currentDate;
      });
    });
    if (!target) {
      alert('예약 가능한 빈 차량이 없습니다.');
      return;
    }
    setCurrentVehicle(target);
    setSelectedSeats(['ALL']);
  };

  const handleConfirm = () => {
    if (selectedSeats.length === 0) {
      alert('좌석을 선택하세요.');
      return;
    }
    onSeatSelect?.({ vehicle: currentVehicle, seat: selectedSeats.join(','), category: 'roundtrip' });
    onClose();
  };

  const handleRequestClose = () => {
    if (!readOnly && preventCloseWithoutSave && selectedSeats.length > 0) {
      alert('좌석 선택 완료를 눌러 저장한 후 닫아주세요.');
      return;
    }
    onClose();
  };

  if (!isOpen) return null;

  const seatColor = (seatId: string, disabled?: boolean) => {
    if (seatId === 'DRIVER' || disabled) return '#6a6a6a';
    if (reservedSet.has(seatId)) return '#ff6b6b';
    if (selectedSeats.includes(seatId) || selectedSeats.includes('ALL')) return '#4ade80';
    return '#8ecae6';
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
      <div className="mx-4 max-h-[90vh] w-full max-w-3xl overflow-y-auto rounded-lg bg-white shadow-xl">
        <div className="flex items-center justify-between border-b p-4">
          <h2 className="text-base font-semibold">🚗 스테이하롱 셔틀 좌석 선택</h2>
          <button
            type="button"
            onClick={handleRequestClose}
            className="rounded px-2 py-1 text-lg hover:bg-gray-100"
          >
            ✕
          </button>
        </div>

        <div className="border-b bg-gray-50 p-4">
          <div className="mb-3 grid grid-cols-3 gap-2">
            {ALL_VEHICLES.map((v) => {
              const isCurrent = v === currentVehicle;
              const cnt = allData.filter(
                (r) =>
                  r.vehicle_number === v &&
                  (toDateStr(r.usage_date) === currentDate ||
                    toDateStr(r.pickup_datetime) === currentDate),
              ).length;
              return (
                <button
                  key={v}
                  type="button"
                  onClick={() => setCurrentVehicle(v)}
                  className={`rounded border-2 p-2 text-xs transition ${
                    isCurrent
                      ? 'border-brand-500 bg-brand-50'
                      : 'border-gray-200 bg-white hover:border-brand-200'
                  }`}
                >
                  <div className="font-medium">{v}</div>
                  <div className="text-gray-500">예약 {cnt}건</div>
                </button>
              );
            })}
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="mb-1 block text-xs text-gray-500">날짜</label>
              <input
                type="date"
                value={currentDate}
                onChange={(e) => setCurrentDate(e.target.value)}
                className="w-full rounded border border-gray-200 px-2 py-1 text-sm"
              />
            </div>
            <div className="flex items-end">
              {!readOnly && (
                <button
                  type="button"
                  onClick={handleExclusive}
                  className="rounded bg-orange-500 px-3 py-1 text-xs text-white hover:bg-orange-600"
                >
                  단독(빈 차량 전체)
                </button>
              )}
            </div>
          </div>
        </div>

        <div className="p-4">
          {loading ? (
            <p className="py-12 text-center text-sm text-gray-500">불러오는 중…</p>
          ) : (
            <svg viewBox="0 0 240 410" className="mx-auto h-96 w-56 rounded border border-gray-200 bg-gray-50">
              {/* driver */}
              <g>
                <rect
                  x={SEAT_LAYOUT.driver.x - 18}
                  y={SEAT_LAYOUT.driver.y - 18}
                  width={36}
                  height={36}
                  rx={6}
                  fill="#6a6a6a"
                />
                <text
                  x={SEAT_LAYOUT.driver.x}
                  y={SEAT_LAYOUT.driver.y + 4}
                  textAnchor="middle"
                  fontSize={12}
                  fill="#fff"
                >
                  D
                </text>
              </g>
              {[...SEAT_LAYOUT.topRow, ...SEAT_LAYOUT.middleRows.flat(), ...SEAT_LAYOUT.bottomRow].map(
                (s) => (
                  <g key={s.id} onClick={() => handleSeatClick(s.id, (s as { disabled?: boolean }).disabled)}>
                    <rect
                      x={s.x - 18}
                      y={s.y - 18}
                      width={36}
                      height={36}
                      rx={6}
                      fill={seatColor(s.id, (s as { disabled?: boolean }).disabled)}
                      style={{ cursor: readOnly ? 'default' : 'pointer' }}
                    />
                    <text x={s.x} y={s.y + 4} textAnchor="middle" fontSize={11} fill="#fff">
                      {s.label}
                    </text>
                  </g>
                ),
              )}
            </svg>
          )}
          <p className="mt-3 text-center text-xs text-gray-500">
            선택된 좌석:{' '}
            <span className="font-mono text-brand-600">
              {selectedSeats.length === 0 ? '-' : selectedSeats.join(',')}
            </span>
          </p>
        </div>

        {!readOnly && (
          <div className="border-t p-3 text-right">
            <button
              type="button"
              onClick={handleConfirm}
              className="rounded bg-brand-500 px-4 py-2 text-sm text-white hover:bg-brand-600"
            >
              좌석 선택 완료
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

export default ShtCarSeatMap;
