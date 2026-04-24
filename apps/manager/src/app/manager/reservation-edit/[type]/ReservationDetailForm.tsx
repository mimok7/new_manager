'use client';

import { useEffect, useMemo, useState, type FormEvent } from 'react';
import { pricing } from '@sht/domain';
import { ShtCarSeatMap } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { CruisePriceCalculatorPanel } from './CruisePriceCalculatorPanel';

type Detail = Record<string, unknown>;

interface Props {
  type: string;
  detail: Detail;
  onSave: (next: Detail) => Promise<void>;
  saving: boolean;
}

const FIELDS: Record<string, Array<{ key: string; label: string; type?: string }>> = {
  cruise: [
    { key: 'checkin', label: '체크인', type: 'datetime-local' },
    { key: 'guest_count', label: '인원', type: 'number' },
    { key: 'adult_count', label: '성인', type: 'number' },
    { key: 'child_count', label: '아동', type: 'number' },
    { key: 'infant_count', label: '유아', type: 'number' },
    { key: 'total_price', label: '총액', type: 'number' },
    { key: 'request_note', label: '요청사항', type: 'textarea' },
  ],
  airport: [
    { key: 'ra_datetime', label: '일시', type: 'datetime-local' },
    { key: 'ra_flight_number', label: '항공편' },
    { key: 'ra_passenger_count', label: '인원', type: 'number' },
    { key: 'ra_car_count', label: '차량수', type: 'number' },
    { key: 'ra_luggage_count', label: '수하물', type: 'number' },
    { key: 'ra_airport_location', label: '공항위치' },
    { key: 'accommodation_info', label: '숙소정보' },
    { key: 'request_note', label: '요청사항', type: 'textarea' },
  ],
  hotel: [
    { key: 'checkin_date', label: '체크인', type: 'date' },
    { key: 'nights', label: '숙박일수', type: 'number' },
    { key: 'guest_count', label: '인원', type: 'number' },
    { key: 'request_note', label: '요청사항', type: 'textarea' },
  ],
  rentcar: [
    { key: 'pickup_datetime', label: '픽업일시', type: 'datetime-local' },
    { key: 'rental_days', label: '대여일수', type: 'number' },
    { key: 'driver_count', label: '기사수', type: 'number' },
    { key: 'destination', label: '목적지' },
    { key: 'request_note', label: '요청사항', type: 'textarea' },
  ],
  tour: [
    { key: 'usage_date', label: '이용일', type: 'date' },
    { key: 'tour_capacity', label: '인원', type: 'number' },
    { key: 'pickup_location', label: '픽업장소' },
    { key: 'request_note', label: '요청사항', type: 'textarea' },
  ],
  sht: [
    { key: 'vehicle_number', label: '차량번호' },
    { key: 'seat_number', label: '좌석번호 (예: A1,A2,B1)' },
    { key: 'color_label', label: '색상' },
    { key: 'total_price', label: '총액 (자동/수동)', type: 'number' },
    { key: 'request_note', label: '요청사항', type: 'textarea' },
  ],
};

export function ReservationDetailForm({ type, detail, onSave, saving }: Props) {
  const [form, setForm] = useState<Detail>(detail);
  const [seatMapOpen, setSeatMapOpen] = useState(false);
  const supabase = useMemo(() => createSupabaseBrowserClient(), []);

  useEffect(() => {
    setForm(detail);
  }, [detail]);

  const fields = FIELDS[type] || [];

  const seatPrice = useMemo(() => {
    if (type !== 'sht') return null;
    const seat = String(form['seat_number'] ?? '');
    if (!seat) return null;
    return pricing.calculateShtSeatPrice(seat);
  }, [type, form]);

  const handleChange = (key: string, value: unknown) => {
    setForm((prev) => ({ ...prev, [key]: value }));
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    await onSave(form);
  };

  if (fields.length === 0) {
    return (
      <p className="text-xs text-gray-500">이 유형({type})에 대한 편집 폼이 정의되지 않았습니다.</p>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-3">
      <div className="grid gap-3 md:grid-cols-2">
        {fields.map((f) => {
          const v = form[f.key];
          if (f.type === 'textarea') {
            return (
              <div key={f.key} className="md:col-span-2">
                <label className="mb-1 block text-xs text-gray-500">{f.label}</label>
                <textarea
                  rows={3}
                  value={(v as string) ?? ''}
                  onChange={(e) => handleChange(f.key, e.target.value)}
                  className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
                />
              </div>
            );
          }
          return (
            <div key={f.key}>
              <label className="mb-1 block text-xs text-gray-500">{f.label}</label>
              <input
                type={f.type || 'text'}
                value={
                  v == null
                    ? ''
                    : f.type === 'datetime-local' && typeof v === 'string'
                      ? v.slice(0, 16).replace(' ', 'T')
                      : (v as string | number)
                }
                onChange={(e) =>
                  handleChange(
                    f.key,
                    f.type === 'number' ? Number(e.target.value) || 0 : e.target.value,
                  )
                }
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
          );
        })}
      </div>

      {seatPrice && seatPrice.groups.length > 0 && (
        <div className="rounded bg-yellow-50 p-3 text-xs">
          <div className="mb-1 font-medium text-yellow-800">🚌 좌석별 단가</div>
          <ul className="space-y-0.5 text-gray-600">
            {seatPrice.groups.map((g) => (
              <li key={g.type}>
                {g.type} | {g.seats.join(',')} | @{g.unit_price.toLocaleString()} ={' '}
                {g.subtotal.toLocaleString()}동
              </li>
            ))}
          </ul>
          <div className="mt-1 flex items-center justify-between">
            <span className="font-medium text-red-500">
              합계 {seatPrice.total.toLocaleString()}동
            </span>
            <button
              type="button"
              onClick={() => handleChange('total_price', seatPrice.total)}
              className="rounded border border-gray-200 px-2 py-1 text-xs text-gray-600 hover:bg-white"
            >
              계산된 가격으로 적용
            </button>
          </div>
        </div>
      )}

      {type === 'cruise' && (
        <CruisePriceCalculatorPanel
          detail={form}
          onApply={(t) => {
            setForm((prev) => ({
              ...prev,
              room_total_price: t.room_total_price,
              surcharge_total: t.surcharge_total,
              total_price: t.total_price,
              price_breakdown: t.price_breakdown,
            }));
          }}
        />
      )}

      {type === 'sht' && (
        <div>
          <button
            type="button"
            onClick={() => setSeatMapOpen(true)}
            className="rounded border border-brand-200 bg-brand-50 px-3 py-2 text-xs text-brand-600 hover:bg-brand-100"
          >
            🚗 좌석맵 열기
          </button>
          <ShtCarSeatMap
            isOpen={seatMapOpen}
            onClose={() => setSeatMapOpen(false)}
            supabase={supabase}
            usageDate={(form['usage_date'] as string) || (form['pickup_datetime'] as string)?.slice(0, 10)}
            onSeatSelect={(info) => {
              setForm((prev) => ({
                ...prev,
                vehicle_number: info.vehicle,
                seat_number: info.seat,
              }));
            }}
          />
        </div>
      )}

      <button
        type="submit"
        disabled={saving}
        className="rounded bg-brand-500 px-4 py-2 text-sm text-white hover:bg-brand-600 disabled:opacity-50"
      >
        {saving ? '저장 중…' : '서비스 상세 저장'}
      </button>
    </form>
  );
}
