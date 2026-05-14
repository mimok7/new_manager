// @ts-nocheck
'use client';

import React, { Suspense, useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { ArrowLeft, Save, Ship } from 'lucide-react';
import supabase from '@/lib/supabase';

interface CruiseMeta {
  cruise_name?: string | null;
  room_type?: string | null;
  schedule_type?: string | null;
}

function MobileCruiseReservationEditContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const reservationId = searchParams.get('id');

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [cruiseMeta, setCruiseMeta] = useState<CruiseMeta | null>(null);

  const [formData, setFormData] = useState({
    room_count: 1,
    guest_count: 0,
    checkin: '',
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
        .from('reservation_cruise')
        .select('reservation_id, room_price_code, room_count, guest_count, checkin, request_note')
        .eq('reservation_id', reservationId)
        .limit(1)
        .maybeSingle();

      if (detailErr) throw detailErr;
      if (!data) {
        setError('크루즈 상세 데이터를 찾을 수 없습니다.');
        return;
      }

      if (data.room_price_code) {
        const { data: metaRow, error: metaErr } = await supabase
          .from('cruise_rate_card')
          .select('cruise_name, room_type, schedule_type')
          .eq('id', data.room_price_code)
          .maybeSingle();

        if (!metaErr && metaRow) {
          setCruiseMeta(metaRow);
        } else {
          setCruiseMeta(null);
        }
      } else {
        setCruiseMeta(null);
      }

      setFormData({
        room_count: data.room_count ?? 1,
        guest_count: data.guest_count ?? 0,
        checkin: data.checkin || '',
        request_note: data.request_note || '',
      });
    } catch (err: any) {
      setError(err?.message || '크루즈 상세 데이터를 불러오지 못했습니다.');
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    if (!reservationId) return;

    try {
      setSaving(true);

      const payload = {
        room_count: formData.room_count,
        guest_count: formData.guest_count,
        checkin: formData.checkin || null,
        request_note: formData.request_note || null,
      };

      const { data: updatedRows, error: updateErr } = await supabase
        .from('reservation_cruise')
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
          pax_count: formData.guest_count || 0,
          reservation_date: formData.checkin || null,
          re_update_at: new Date().toISOString(),
        })
        .eq('re_id', reservationId);

      if (syncErr) {
        console.warn('reservation 동기화 경고:', syncErr.message);
      }

      alert('크루즈 예약 상세가 수정되었습니다.');
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
          <h1 className="text-lg font-bold text-gray-800 flex-1">🚢 크루즈 상세수정</h1>
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
                <Ship className="w-4 h-4 text-blue-600" />
                크루즈 핵심 항목
              </div>

              <div className="rounded-lg border border-blue-200 bg-blue-50 p-3">
                <div className="text-xs font-semibold text-blue-800 mb-2">크루즈 정보</div>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
                  <Info label="크루즈명" value={cruiseMeta?.cruise_name} />
                  <Info label="객실명" value={cruiseMeta?.room_type} />
                  <Info label="일정" value={cruiseMeta?.schedule_type} />
                </div>
              </div>

              <div>
                <label className="block text-xs text-gray-500 mb-1">객실 수 (room_count)</label>
                <input
                  type="number"
                  min="1"
                  value={formData.room_count}
                  onChange={(e) =>
                    setFormData((prev) => ({
                      ...prev,
                      room_count: Math.max(1, parseInt(e.target.value || '1', 10)),
                    }))
                  }
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </div>

              <div>
                <label className="block text-xs text-gray-500 mb-1">인원 수 (guest_count)</label>
                <input
                  type="number"
                  min="0"
                  value={formData.guest_count}
                  onChange={(e) =>
                    setFormData((prev) => ({
                      ...prev,
                      guest_count: Math.max(0, parseInt(e.target.value || '0', 10)),
                    }))
                  }
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </div>

              <div>
                <label className="block text-xs text-gray-500 mb-1">체크인 (checkin)</label>
                <input
                  type="date"
                  value={formData.checkin || ''}
                  onChange={(e) => setFormData((prev) => ({ ...prev, checkin: e.target.value }))}
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </div>

              <div>
                <label className="block text-xs text-gray-500 mb-1">요청사항 (request_note)</label>
                <textarea
                  rows={5}
                  value={formData.request_note}
                  onChange={(e) => setFormData((prev) => ({ ...prev, request_note: e.target.value }))}
                  className="w-full px-3 py-2 text-sm border rounded-lg"
                />
              </div>
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

export default function MobileCruiseReservationEditPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gray-50 flex items-center justify-center text-sm text-gray-500">불러오는 중...</div>}>
      <MobileCruiseReservationEditContent />
    </Suspense>
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
