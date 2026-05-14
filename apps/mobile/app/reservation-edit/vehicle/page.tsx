// @ts-nocheck
'use client';

import React, { Suspense, useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ArrowLeft, Car, Save } from 'lucide-react';
import supabase from '@/lib/supabase';

interface CruiseCarItem {
  id: string;
  reservation_id: string;
  car_price_code?: string | null;
  car_count?: number | null;
  passenger_count?: number | null;
  pickup_location?: string | null;
  dropoff_location?: string | null;
  pickup_datetime?: string | null;
  car_total_price?: number | null;
  request_note?: string | null;
}

interface RentcarPriceMeta {
  rent_code: string;
  vehicle_type?: string | null;
  way_type?: string | null;
  route?: string | null;
  price?: number | null;
  category?: string | null;
  car_category_code?: string | null;
}

function MobileVehicleReservationEditContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const reservationId = searchParams.get('id');

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [items, setItems] = useState<CruiseCarItem[]>([]);
  const [rentcarMetaMap, setRentcarMetaMap] = useState<Record<string, RentcarPriceMeta>>({});

  useEffect(() => {
    if (!reservationId) {
      setError('예약 ID가 없습니다.');
      setLoading(false);
      return;
    }
    loadDetail();
  }, [reservationId]);

  const loadDetail = async () => {
    try {
      setLoading(true);
      setError(null);

      const { data, error: detailErr } = await supabase
        .from('reservation_cruise_car')
        .select(
          'id, reservation_id, car_price_code, car_count, passenger_count, pickup_location, dropoff_location, pickup_datetime, car_total_price, request_note'
        )
        .eq('reservation_id', reservationId)
        .order('id', { ascending: true });

      if (detailErr) throw detailErr;
      if (!data || data.length === 0) {
        setError('크루즈 차량 상세 데이터를 찾을 수 없습니다.');
        return;
      }

      setItems(data);

      const codes = Array.from(new Set((data || []).map((d: any) => d.car_price_code).filter(Boolean)));
      if (codes.length > 0) {
        const { data: rentRows, error: rentErr } = await supabase
          .from('rentcar_price')
          .select('rent_code, vehicle_type, way_type, route, price, category, car_category_code')
          .in('rent_code', codes);

        if (rentErr) {
          console.warn('rentcar_price 조회 실패:', rentErr.message);
        } else {
          const nextMap: Record<string, RentcarPriceMeta> = {};
          (rentRows || []).forEach((row: any) => {
            nextMap[row.rent_code] = row;
          });
          setRentcarMetaMap(nextMap);
        }
      } else {
        setRentcarMetaMap({});
      }
    } catch (err: any) {
      setError(err?.message || '크루즈 차량 상세 데이터를 불러오지 못했습니다.');
    } finally {
      setLoading(false);
    }
  };

  const updateItem = (id: string, patch: Partial<CruiseCarItem>) => {
    setItems((prev) => prev.map((item) => (item.id === id ? { ...item, ...patch } : item)));
  };

  const handleSave = async () => {
    if (!reservationId || items.length === 0) return;

    try {
      setSaving(true);

      for (const item of items) {
        const payload = {
          car_price_code: item.car_price_code || null,
          car_count: item.car_count || 0,
          passenger_count: item.passenger_count || 0,
          pickup_location: item.pickup_location || null,
          dropoff_location: item.dropoff_location || null,
          pickup_datetime: item.pickup_datetime || null,
          car_total_price: item.car_total_price || 0,
          request_note: item.request_note || null,
        };

        const { error: updateErr } = await supabase
          .from('reservation_cruise_car')
          .update(payload)
          .eq('id', item.id);

        if (updateErr) throw updateErr;
      }

      const carTotal = items.reduce((sum, item) => sum + Number(item.car_total_price || 0), 0);
      const paxCount = items.reduce((sum, item) => sum + Number(item.passenger_count || 0), 0);
      const latestPickup = items.find((item) => item.pickup_datetime)?.pickup_datetime || null;

      const { error: syncErr } = await supabase
        .from('reservation')
        .update({
          pax_count: paxCount,
          total_amount: carTotal > 0 ? carTotal : undefined,
          reservation_date: latestPickup,
          re_update_at: new Date().toISOString(),
        })
        .eq('re_id', reservationId);

      if (syncErr) {
        console.warn('reservation 동기화 경고:', syncErr.message);
      }

      alert('크루즈 차량 예약 상세가 수정되었습니다.');
      router.push('/reservation-edit');
    } catch (err: any) {
      alert(`저장 실패: ${err?.message || '알 수 없는 오류'}`);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="bg-white border-b shadow-sm px-4 py-3">
        <div className="flex items-center gap-3">
          <Link href="/reservation-edit" className="p-1.5 rounded-lg hover:bg-gray-100">
            <ArrowLeft className="w-5 h-5 text-gray-600" />
          </Link>
          <h1 className="text-lg font-bold text-gray-800 flex-1">🚗 크루즈 차량 수정</h1>
        </div>
        {reservationId && <p className="text-xs text-gray-500 mt-1">예약ID: {reservationId}</p>}
      </div>

      <div className="px-4 py-4">
        {loading ? (
          <div className="text-center py-20 text-sm text-gray-500">불러오는 중...</div>
        ) : error ? (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
            {error}
          </div>
        ) : (
          <div className="space-y-4">
            {items.map((item, index) => (
              <div key={item.id} className="bg-white rounded-xl border border-gray-100 p-4 space-y-3">
                <div className="flex items-center gap-2 text-sm font-semibold text-gray-800">
                  <Car className="w-4 h-4 text-cyan-600" />
                  차량 {index + 1}
                </div>

                <div className="rounded-lg border bg-cyan-50 border-cyan-200 p-3">
                  <div className="text-xs font-semibold text-cyan-800 mb-2">렌트카 가격 정보</div>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
                    <Info label="차종" value={rentcarMetaMap[item.car_price_code || '']?.vehicle_type} />
                    <Info label="구분" value={rentcarMetaMap[item.car_price_code || '']?.way_type} />
                    <Info label="경로" value={rentcarMetaMap[item.car_price_code || '']?.route} />
                    <Info
                      label="단가"
                      value={
                        rentcarMetaMap[item.car_price_code || '']?.price != null
                          ? `${Number(rentcarMetaMap[item.car_price_code || '']?.price).toLocaleString()}동`
                          : null
                      }
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-2">
                  <Field label="차량 수 (car_count)">
                    <input
                      type="number"
                      min="0"
                      value={item.car_count || 0}
                      onChange={(e) =>
                        updateItem(item.id, { car_count: Math.max(0, parseInt(e.target.value || '0', 10)) })
                      }
                      className="w-full px-3 py-2 text-sm border rounded-lg"
                    />
                  </Field>

                  <Field label="승객 수 (passenger_count)">
                    <input
                      type="number"
                      min="0"
                      value={item.passenger_count || 0}
                      onChange={(e) =>
                        updateItem(item.id, {
                          passenger_count: Math.max(0, parseInt(e.target.value || '0', 10)),
                        })
                      }
                      className="w-full px-3 py-2 text-sm border rounded-lg"
                    />
                  </Field>
                </div>

                <Field label="픽업 장소 (pickup_location)">
                  <input
                    type="text"
                    value={item.pickup_location || ''}
                    onChange={(e) => updateItem(item.id, { pickup_location: e.target.value })}
                    className="w-full px-3 py-2 text-sm border rounded-lg"
                  />
                </Field>

                <Field label="하차 장소 (dropoff_location)">
                  <input
                    type="text"
                    value={item.dropoff_location || ''}
                    onChange={(e) => updateItem(item.id, { dropoff_location: e.target.value })}
                    className="w-full px-3 py-2 text-sm border rounded-lg"
                  />
                </Field>

                <Field label="픽업 일시 (pickup_datetime)">
                  <input
                    type="datetime-local"
                    value={toDateTimeLocal(item.pickup_datetime)}
                    onChange={(e) => updateItem(item.id, { pickup_datetime: e.target.value })}
                    className="w-full px-3 py-2 text-sm border rounded-lg"
                  />
                </Field>

                <Field label="총 금액 (car_total_price)">
                  <input
                    type="number"
                    min="0"
                    value={item.car_total_price || 0}
                    onChange={(e) =>
                      updateItem(item.id, { car_total_price: Math.max(0, parseInt(e.target.value || '0', 10)) })
                    }
                    className="w-full px-3 py-2 text-sm border rounded-lg"
                  />
                </Field>

                <Field label="요청사항 (request_note)">
                  <textarea
                    rows={4}
                    value={item.request_note || ''}
                    onChange={(e) => updateItem(item.id, { request_note: e.target.value })}
                    className="w-full px-3 py-2 text-sm border rounded-lg"
                  />
                </Field>
              </div>
            ))}

            <button
              onClick={handleSave}
              disabled={saving}
              className={`w-full py-3 rounded-xl text-sm font-semibold inline-flex items-center justify-center gap-2 ${
                saving ? 'bg-gray-300 text-gray-600' : 'bg-blue-600 text-white'
              }`}
            >
              <Save className="w-4 h-4" />
              {saving ? '저장중...' : '저장'}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

export default function MobileVehicleReservationEditPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gray-50 flex items-center justify-center text-sm text-gray-500">불러오는 중...</div>}>
      <MobileVehicleReservationEditContent />
    </Suspense>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <label className="block text-xs text-gray-500 mb-1">{label}</label>
      {children}
    </div>
  );
}

function Info({ label, value }: { label: string; value: React.ReactNode }) {
  if (value === undefined || value === null || String(value).trim() === '') return null;
  return (
    <div className="flex items-start justify-between gap-2">
      <span className="text-gray-500">{label}</span>
      <span className="text-gray-800 text-right">{value}</span>
    </div>
  );
}

function toDateTimeLocal(value?: string | null) {
  if (!value) return '';
  const normalized = String(value).replace(' ', 'T');
  if (/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(normalized)) return normalized;
  const match = normalized.match(/^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2})/);
  if (match) return `${match[1]}T${match[2]}`;
  return '';
}
