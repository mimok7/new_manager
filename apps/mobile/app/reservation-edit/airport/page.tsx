// @ts-nocheck
'use client';

import React, { Suspense, useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ArrowLeft, Save, Plane } from 'lucide-react';
import supabase from '@/lib/supabase';

function MobileAirportReservationEditContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const reservationId = searchParams.get('id');

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [formData, setFormData] = useState({
    ra_airport_location: '',
    ra_flight_number: '',
    ra_datetime: '',
    ra_passenger_count: 0,
    ra_car_count: 0,
    ra_luggage_count: 0,
    ra_way_type: '',
    accommodation_info: '',
    request_note: '',
  });

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
        .from('reservation_airport')
        .select(
          'reservation_id, ra_airport_location, ra_flight_number, ra_datetime, ra_passenger_count, ra_car_count, ra_luggage_count, ra_way_type, accommodation_info, request_note'
        )
        .eq('reservation_id', reservationId)
        .limit(1)
        .maybeSingle();

      if (detailErr) throw detailErr;
      if (!data) {
        setError('공항 상세 데이터를 찾을 수 없습니다.');
        return;
      }

      setFormData({
        ra_airport_location: data.ra_airport_location || '',
        ra_flight_number: data.ra_flight_number || '',
        ra_datetime: data.ra_datetime || '',
        ra_passenger_count: data.ra_passenger_count || 0,
        ra_car_count: data.ra_car_count || 0,
        ra_luggage_count: data.ra_luggage_count || 0,
        ra_way_type: data.ra_way_type || '',
        accommodation_info: data.accommodation_info || '',
        request_note: data.request_note || '',
      });
    } catch (err: any) {
      setError(err?.message || '공항 상세 데이터를 불러오지 못했습니다.');
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    if (!reservationId) return;

    try {
      setSaving(true);

      const payload = {
        ra_airport_location: formData.ra_airport_location || null,
        ra_flight_number: formData.ra_flight_number || null,
        ra_datetime: formData.ra_datetime || null,
        ra_passenger_count: formData.ra_passenger_count || 0,
        ra_car_count: formData.ra_car_count || 0,
        ra_luggage_count: formData.ra_luggage_count || 0,
        ra_way_type: formData.ra_way_type || null,
        accommodation_info: formData.accommodation_info || null,
        request_note: formData.request_note || null,
      };

      const { data: updatedRows, error: updateErr } = await supabase
        .from('reservation_airport')
        .update(payload)
        .eq('reservation_id', reservationId)
        .select('reservation_id');

      if (updateErr) throw updateErr;
      if (!updatedRows || updatedRows.length === 0) {
        throw new Error('업데이트 대상이 없습니다.');
      }

      const { error: syncErr } = await supabase
        .from('reservation')
        .update({
          pax_count: formData.ra_passenger_count || 0,
          reservation_date: formData.ra_datetime || null,
          re_update_at: new Date().toISOString(),
        })
        .eq('re_id', reservationId);

      if (syncErr) {
        console.warn('reservation 동기화 경고:', syncErr.message);
      }

      alert('공항 예약 상세가 수정되었습니다.');
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
          <h1 className="text-lg font-bold text-gray-800 flex-1">✈️ 공항 상세수정</h1>
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
            <div className="bg-white rounded-xl border border-gray-100 p-4 space-y-3">
              <div className="flex items-center gap-2 text-sm font-semibold text-gray-800">
                <Plane className="w-4 h-4 text-green-600" />
                공항 ra_* 필드
              </div>

              <Field label="공항 위치 (ra_airport_location)">
                <input
                  type="text"
                  value={formData.ra_airport_location}
                  onChange={(e) => setFormData((prev) => ({ ...prev, ra_airport_location: e.target.value }))}
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </Field>

              <Field label="항공편 (ra_flight_number)">
                <input
                  type="text"
                  value={formData.ra_flight_number}
                  onChange={(e) => setFormData((prev) => ({ ...prev, ra_flight_number: e.target.value }))}
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </Field>

              <Field label="일시 (ra_datetime)">
                <input
                  type="datetime-local"
                  value={toDateTimeLocal(formData.ra_datetime)}
                  onChange={(e) =>
                    setFormData((prev) => ({ ...prev, ra_datetime: toIsoLike(e.target.value) }))
                  }
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </Field>

              <div className="grid grid-cols-3 gap-2">
                <Field label="인원 (ra_passenger_count)">
                  <input
                    type="number"
                    min="0"
                    value={formData.ra_passenger_count}
                    onChange={(e) =>
                      setFormData((prev) => ({
                        ...prev,
                        ra_passenger_count: Math.max(0, parseInt(e.target.value || '0', 10)),
                      }))
                    }
                    className="w-full px-2 py-2 text-sm border rounded-lg"
                  />
                </Field>

                <Field label="차량수 (ra_car_count)">
                  <input
                    type="number"
                    min="0"
                    value={formData.ra_car_count}
                    onChange={(e) =>
                      setFormData((prev) => ({
                        ...prev,
                        ra_car_count: Math.max(0, parseInt(e.target.value || '0', 10)),
                      }))
                    }
                    className="w-full px-2 py-2 text-sm border rounded-lg"
                  />
                </Field>

                <Field label="수하물 (ra_luggage_count)">
                  <input
                    type="number"
                    min="0"
                    value={formData.ra_luggage_count}
                    onChange={(e) =>
                      setFormData((prev) => ({
                        ...prev,
                        ra_luggage_count: Math.max(0, parseInt(e.target.value || '0', 10)),
                      }))
                    }
                    className="w-full px-2 py-2 text-sm border rounded-lg"
                  />
                </Field>
              </div>

              <Field label="구분 (ra_way_type)">
                <select
                  value={formData.ra_way_type}
                  onChange={(e) => setFormData((prev) => ({ ...prev, ra_way_type: e.target.value }))}
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                >
                  <option value="">선택</option>
                  <option value="pickup">pickup</option>
                  <option value="sending">sending</option>
                  <option value="픽업">픽업</option>
                  <option value="샌딩">샌딩</option>
                </select>
              </Field>

              <Field label="숙소 정보 (accommodation_info)">
                <input
                  type="text"
                  value={formData.accommodation_info}
                  onChange={(e) => setFormData((prev) => ({ ...prev, accommodation_info: e.target.value }))}
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </Field>

              <Field label="요청사항 (request_note)">
                <textarea
                  rows={4}
                  value={formData.request_note}
                  onChange={(e) => setFormData((prev) => ({ ...prev, request_note: e.target.value }))}
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </Field>
            </div>

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

export default function MobileAirportReservationEditPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gray-50 flex items-center justify-center text-sm text-gray-500">불러오는 중...</div>}>
      <MobileAirportReservationEditContent />
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

function toDateTimeLocal(value: string) {
  if (!value) return '';
  const normalized = String(value).replace(' ', 'T');
  if (/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(normalized)) return normalized;
  const match = normalized.match(/^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2})/);
  if (match) return `${match[1]}T${match[2]}`;
  return '';
}

function toIsoLike(value: string) {
  if (!value) return '';
  return value;
}
