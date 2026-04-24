'use client';

import React from 'react';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyMap = Record<string, any>;

export interface UnifiedReservationDetail {
  reservation_id: string;
  service_type: string;
  service_details: AnyMap | null;
  amount: number;
  status: string;
}

export interface UnifiedQuoteData {
  id?: string;
  quote_id?: string;
  title: string;
  user_name: string;
  user_phone: string;
  user_email?: string;
  total_price: number;
  created_at?: string;
  reservations: UnifiedReservationDetail[];
}

interface Props {
  data: UnifiedQuoteData;
}

const TYPE_LABEL: Record<string, string> = {
  cruise: '크루즈 객실',
  cruise_car: '크루즈 차량',
  airport: '공항 서비스',
  hotel: '호텔',
  rentcar: '렌터카',
  tour: '투어',
  car: '차량(SHT)',
  sht: '차량(SHT)',
};

function formatDateTime(dateString?: string): string {
  if (!dateString) return '';
  try {
    return new Date(dateString).toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  } catch {
    return String(dateString);
  }
}

function summarize(obj: AnyMap | null | undefined, opts?: { exclude?: string[] }): string {
  if (!obj) return '-';
  const exclude = new Set((opts?.exclude || []).map((k) => String(k)));
  const parts: string[] = [];
  for (const [k, v] of Object.entries(obj)) {
    if (v == null || v === '' || exclude.has(String(k))) continue;
    if (String(k).includes('_id') || String(k).includes('reservation_id')) continue;
    parts.push(`${String(k).replace(/_/g, ' ')}: ${String(v)}`);
  }
  return parts.length ? parts.join(' • ') : '-';
}

function StatusBadge({ s }: { s: string }) {
  const cls =
    s === 'confirmed'
      ? 'bg-green-100 text-green-700'
      : s === 'pending'
        ? 'bg-yellow-100 text-yellow-700'
        : 'bg-gray-100 text-gray-700';
  const label = s === 'confirmed' ? '확정' : s === 'pending' ? '대기' : s;
  return <span className={`rounded px-2 py-1 text-xs ${cls}`}>{label}</span>;
}

/** 예약 확인서 공용 렌더러. customer/manager 양측에서 동일 마크업으로 출력. */
export function UnifiedConfirmation({ data }: Props) {
  return (
    <div id="confirmation-letter" className="bg-white">
      <div className="mb-8 border-b-4 border-brand-500 pb-6 text-center">
        <h1 className="mb-2 text-2xl font-bold text-brand-600">
          🌊 베트남 하롱베이 여행 예약확인서 🌊
        </h1>
        <p className="text-gray-600">Vietnam Ha Long Bay Travel Reservation Confirmation</p>
      </div>

      <section className="mb-8">
        <h3 className="mb-4 flex items-center text-lg font-semibold text-gray-900">
          <span className="mr-3 h-6 w-1 bg-brand-500"></span>고객 정보
        </h3>
        <div className="rounded-lg bg-gray-50 p-6">
          <table className="w-full border-collapse border border-gray-300 text-sm">
            <tbody>
              <tr>
                <th className="w-40 border border-gray-300 bg-gray-100 px-3 py-2 text-left text-gray-700">
                  행복여행 이름
                </th>
                <td className="border border-gray-300 px-3 py-2 font-semibold text-gray-900">
                  {data.title}
                </td>
              </tr>
              <tr>
                <th className="border border-gray-300 bg-gray-100 px-3 py-2 text-left text-gray-700">
                  예약자명
                </th>
                <td className="border border-gray-300 px-3 py-2 text-gray-900">{data.user_name}</td>
              </tr>
              <tr>
                <th className="border border-gray-300 bg-gray-100 px-3 py-2 text-left text-gray-700">
                  연락처
                </th>
                <td className="border border-gray-300 px-3 py-2 text-gray-900">{data.user_phone}</td>
              </tr>
              <tr>
                <th className="border border-gray-300 bg-gray-100 px-3 py-2 text-left text-gray-700">
                  예약번호
                </th>
                <td className="border border-gray-300 px-3 py-2 font-mono text-brand-600">
                  {data.id || data.quote_id}
                </td>
              </tr>
              <tr>
                <th className="border border-gray-300 bg-gray-100 px-3 py-2 text-left text-gray-700">
                  발급일
                </th>
                <td className="border border-gray-300 px-3 py-2 text-gray-900">
                  {formatDateTime(new Date().toISOString())}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <section className="mb-8">
        <h3 className="mb-4 flex items-center text-lg font-semibold text-gray-900">
          <span className="mr-3 h-6 w-1 bg-green-500"></span>예약 서비스 상세 내역
        </h3>
        {data.reservations?.length ? (
          <div className="overflow-x-auto">
            <table className="w-full border-collapse border border-gray-300 text-sm">
              <thead>
                <tr className="bg-brand-500 text-white">
                  <th className="w-16 border border-gray-300 px-3 py-3 text-center font-semibold">
                    No
                  </th>
                  <th className="w-40 border border-gray-300 px-3 py-3 text-left font-semibold">
                    서비스 구분
                  </th>
                  <th className="border border-gray-300 px-3 py-3 text-left font-semibold">
                    주요 정보
                  </th>
                  <th className="w-[28%] border border-gray-300 px-3 py-3 text-left font-semibold">
                    세부 정보
                  </th>
                  <th className="w-32 border border-gray-300 px-3 py-3 text-center font-semibold">
                    금액
                  </th>
                  <th className="w-28 border border-gray-300 px-3 py-3 text-center font-semibold">
                    상태
                  </th>
                </tr>
              </thead>
              <tbody>
                {data.reservations.map((r, idx) => {
                  const d = (r.service_details || {}) as AnyMap;
                  const info = summarize(d, { exclude: ['price_info'] });
                  const priceInfo = d?.price_info ? summarize(d.price_info as AnyMap) : '-';
                  return (
                    <tr key={`${r.reservation_id}_${idx}`} className="hover:bg-gray-50">
                      <td className="border border-gray-300 px-3 py-3 text-center text-gray-700">
                        {idx + 1}
                      </td>
                      <td className="whitespace-nowrap border border-gray-300 px-3 py-3 font-medium text-gray-800">
                        {TYPE_LABEL[r.service_type] || r.service_type}
                      </td>
                      <td className="border border-gray-300 px-3 py-3 text-gray-700">
                        <div>{info || '-'}</div>
                        <div className="mt-1 text-xs text-gray-400">
                          예약ID: {String(r.reservation_id).slice(-8)}
                        </div>
                      </td>
                      <td className="border border-gray-300 px-3 py-3 text-gray-700">
                        <div className="whitespace-pre-wrap break-words">{priceInfo}</div>
                      </td>
                      <td className="border border-gray-300 px-3 py-3 text-center font-bold text-brand-600">
                        {r.amount > 0 ? `${r.amount.toLocaleString()}동` : '포함'}
                      </td>
                      <td className="border border-gray-300 px-3 py-3 text-center">
                        <StatusBadge s={r.status} />
                      </td>
                    </tr>
                  );
                })}
              </tbody>
              <tfoot>
                <tr className="bg-brand-50">
                  <td
                    colSpan={4}
                    className="border border-gray-300 px-3 py-4 text-right font-semibold text-gray-700"
                  >
                    총 결제 금액
                  </td>
                  <td className="border border-gray-300 px-3 py-4 text-center">
                    <div className="text-xl font-bold text-brand-600">
                      {(data.total_price || 0).toLocaleString()}동
                    </div>
                  </td>
                  <td className="border border-gray-300 px-3 py-4 text-center">
                    <span className="inline-block rounded bg-green-100 px-2 py-1 text-xs font-medium text-green-800">
                      결제완료
                    </span>
                  </td>
                </tr>
              </tfoot>
            </table>
          </div>
        ) : (
          <div className="rounded border border-gray-200 bg-gray-50 p-6 text-center text-gray-600">
            서비스 정보가 없습니다.
          </div>
        )}
      </section>

      <section className="mb-8">
        <div className="flex items-center justify-between rounded-lg border border-brand-200 bg-brand-50 p-4">
          <div className="font-medium text-gray-700">총 결제 금액</div>
          <div className="text-xl font-bold text-brand-600">
            {(data.total_price || 0).toLocaleString()}동
          </div>
        </div>
      </section>

      <footer className="border-t-2 border-brand-500 pt-6 text-center text-sm text-gray-500">
        <div className="mb-4">
          <div className="mb-2 text-lg font-bold text-brand-600">
            🌊 스테이하롱 트레블과 함께하는 특별한 여행 🌊
          </div>
          <p className="text-gray-600">베트남 하롱베이에서 잊지 못할 추억을 만들어보세요!</p>
        </div>
        <div className="rounded-lg bg-brand-50 p-4 text-center">
          <div className="mb-2 font-medium text-gray-700">
            <span className="text-brand-600">🏢 스테이하롱 트레블 </span>|
            <span className="text-gray-600"> 하롱베이 상주 한국인 베트남 전문 여행사</span>
          </div>
          <div className="space-y-1 text-xs text-gray-500">
            <div>📍 상호 : CONG TY TENPER COMMUNICATIONS</div>
            <div>📍 주소 : PHUONG YET KIEU, THANH PHO HA LONG</div>
            <div>📧 stayhalong@gmail.com | ☎️ 07045545185 🌐 https://cafe.naver.com/stayhalong</div>
            <div>🕒 운영시간: 평일 09:00-24:00 (토요일 09:00-15:00, 일요일/공휴일 비상업무)</div>
            <div className="mt-2 text-gray-400">© 2024 StayHalong Travel. All rights reserved.</div>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default UnifiedConfirmation;
