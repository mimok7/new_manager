import React from 'react';
import { X, Ship, Plane, Building, MapPin, Car, FileText, User } from 'lucide-react';

/* ── 유틸 ── */
const fmt = (dateStr: string | null | undefined): string => {
  if (!dateStr) return '미정';
  try {
    const raw = String(dateStr).replace(' ', 'T');
    const parsed = new Date(raw);
    if (isNaN(parsed.getTime())) return String(dateStr);
    const plus8 = new Date(parsed.getTime() + 8 * 60 * 60 * 1000);
    const yyyy = plus8.getFullYear();
    const mm = String(plus8.getMonth() + 1).padStart(2, '0');
    const dd = String(plus8.getDate()).padStart(2, '0');
    const hh = plus8.getHours();
    const min = String(plus8.getMinutes()).padStart(2, '0');
    return `${yyyy}. ${mm}. ${dd}. ${hh < 12 ? '오전' : '오후'} ${hh % 12 || 12}:${min}`;
  } catch { return String(dateStr); }
};

const normalizeWayType = (value: string | null | undefined) => {
  const way = (value || '').toLowerCase();
  if (way === 'pickup' || way === '픽업') return '픽업';
  if (way === 'sending' || way === 'dropoff' || way === '샌딩') return '샌딩';
  return value || '-';
};

const fmtDate = (dateStr: string | null | undefined): string => {
  if (!dateStr) return '미정';
  const m = String(dateStr).match(/^(\d{4})-(\d{2})-(\d{2})/);
  return m ? `${m[1]}. ${m[2]}. ${m[3]}.` : String(dateStr);
};

const getServiceType = (item: any) => {
  if (item.cruise && item.checkin) return 'cruise';
  if (item.boardingDate && item.vehicleNumber) return 'vehicle';
  const hasAirportHint = !!(item.tripType || item.route || item.airportName || item.flightNumber || item.placeName);
  if (hasAirportHint && (item.date || item.time || item.airportName)) return 'airport';
  if (item.hotelName && item.checkinDate) return 'hotel';
  if (item.tourName && item.startDate) return 'tour';
  if (item.pickupDate && item.usagePeriod) return 'rentcar';
  if (item.pickupDatetime && !item.boardingDate && !item.pickupDate) return 'car';
  return 'unknown';
};

/* ── 서비스별 색상 & 메타 ── */
type ServiceMeta = { icon: any; label: string; bg: string; border: string; title: string; iconColor: string };
const SERVICE_META: Record<string, ServiceMeta> = {
  cruise:  { icon: Ship,     label: '크루즈',    bg: 'bg-blue-50',   border: 'border-blue-200',   title: 'text-blue-800',   iconColor: 'text-blue-600'   },
  car:     { icon: Car,      label: '차량',      bg: 'bg-cyan-50',   border: 'border-cyan-200',   title: 'text-cyan-800',   iconColor: 'text-cyan-600'   },
  vehicle: { icon: Car,      label: '스하차량',  bg: 'bg-purple-50', border: 'border-purple-200', title: 'text-purple-800', iconColor: 'text-purple-600' },
  airport: { icon: Plane,    label: '공항차량',  bg: 'bg-green-50',  border: 'border-green-200',  title: 'text-green-800',  iconColor: 'text-green-600'  },
  hotel:   { icon: Building, label: '호텔',      bg: 'bg-orange-50', border: 'border-orange-200', title: 'text-orange-800', iconColor: 'text-orange-600' },
  tour:    { icon: MapPin,   label: '투어',      bg: 'bg-pink-50',   border: 'border-pink-200',   title: 'text-pink-800',   iconColor: 'text-pink-600'   },
  rentcar: { icon: Car,      label: '렌터카',    bg: 'bg-indigo-50', border: 'border-indigo-200', title: 'text-indigo-800', iconColor: 'text-indigo-600' },
};
const DEFAULT_META: ServiceMeta = { icon: FileText, label: '서비스', bg: 'bg-gray-50', border: 'border-gray-200', title: 'text-gray-800', iconColor: 'text-gray-600' };

/* ── 필드 행 ── */
function Field({ label, value, highlight }: { label: string; value: React.ReactNode; highlight?: boolean }) {
  if (value === undefined || value === null || value === '' || value === '-') return null;
  return (
    <div className="flex justify-between items-start gap-2 py-1">
      <span className="text-gray-500 font-medium text-xs whitespace-nowrap shrink-0">{label}</span>
      <span className={`text-sm font-semibold text-right break-words ${highlight ? 'text-green-600 text-base' : 'text-gray-900'}`}>{value}</span>
    </div>
  );
}

/* ── 서비스별 상세 섹션 ── */
function ServiceDetails({ item, type, meta }: { item: any; type: string; meta: ServiceMeta }) {
  return (
    <div className={`${meta.bg} border ${meta.border} rounded-lg p-4`}>
      <h4 className={`font-semibold ${meta.title} mb-3 flex items-center gap-2 text-sm`}>
        <meta.icon className={`w-4 h-4 ${meta.iconColor}`} />
        {meta.label} 상세
      </h4>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-0">
        {type === 'cruise' && <>
          <Field label="크루즈명"  value={item.cruise} />
          <Field label="객실타입"  value={item.roomType ? <span className="bg-blue-100 text-blue-800 px-2 py-0.5 rounded text-xs">{item.roomType}</span> : null} />
          <Field label="분류"      value={item.category} />
          <Field label="체크인"    value={fmtDate(item.checkin)} />
          <Field label="객실수"    value={item.roomCount ? `${item.roomCount}개` : null} />
          <Field label="인원"      value={(() => { const p=[]; if(item.adult>0)p.push(`성인 ${item.adult}명`); if(item.child>0)p.push(`아동 ${item.child}명`); if(item.toddler>0)p.push(`유아 ${item.toddler}명`); return p.join(' / ') || null; })()} />
          <Field label="할인"      value={item.discount} />
        </>}

        {type === 'car' && <>
          <Field label="차종"      value={item.carType ? <span className="bg-cyan-100 text-cyan-800 px-2 py-0.5 rounded text-xs">{item.carType}</span> : null} />
          <Field label="차량수"    value={item.carCount ? `${item.carCount}대` : null} />
          <Field label="승객수"    value={item.passengerCount ? `${item.passengerCount}명` : null} />
          <Field label="픽업 일시" value={fmt(item.pickupDatetime)} />
          <Field label="픽업 장소" value={item.pickupLocation} />
          <Field label="도착 장소" value={item.dropoffLocation} />
        </>}

        {type === 'vehicle' && <>
          <Field label="탑승일"    value={fmtDate(item.boardingDate)} />
          <Field label="차량번호"  value={item.vehicleNumber} />
          <Field label="좌석번호"  value={item.seatNumber} />
          <Field label="구분"      value={item.serviceType} />
          <Field label="분류"      value={item.category} />
          <Field label="탑승자명"  value={item.name} />
        </>}

        {type === 'airport' && <>
          <Field label="구분"      value={normalizeWayType(item.tripType || item.wayType)} />
          <Field label="카테고리"  value={item.category} />
          <Field label="경로"      value={item.route} />
          <Field label="날짜"      value={fmtDate(item.date)} />
          <Field label="시간"      value={item.time} />
          <Field label="공항"      value={item.airportName} />
          <Field label="항공편"    value={item.flightNumber} />
          <Field label="차종"      value={item.vehicleType || item.carType} />
          <Field label="승객수"    value={item.passengerCount ? `${item.passengerCount}명` : null} />
          <Field label="차량수"    value={item.carCount ? `${item.carCount}대` : null} />
          <Field label="장소"      value={item.placeName} />
        </>}

        {type === 'hotel' && <>
          <Field label="호텔명"    value={item.hotelName ? <span className="bg-orange-100 text-orange-800 px-2 py-0.5 rounded text-xs font-semibold">{item.hotelName}</span> : null} />
          <Field label="객실명"    value={item.roomName} />
          <Field label="객실타입"  value={item.roomType} />
          <Field label="객실수"    value={item.roomCount ? `${item.roomCount}개` : null} />
          <Field label="체크인"    value={fmtDate(item.checkinDate)} />
          <Field label="숙박일수"  value={item.days ? `${item.days}박` : null} />
          <Field label="인원"      value={(() => { const p=[]; if(item.adult>0)p.push(`성인 ${item.adult}명`); if(item.child>0)p.push(`아동 ${item.child}명`); if(item.toddler>0)p.push(`유아 ${item.toddler}명`); return p.join(' / ') || null; })()} />
        </>}

        {type === 'tour' && <>
          <Field label="투어명"    value={item.tourName ? <span className="bg-pink-100 text-pink-800 px-2 py-0.5 rounded text-xs font-semibold">{item.tourName}</span> : null} />
          <Field label="투어타입"  value={item.tourType} />
          <Field label="시작일"    value={fmtDate(item.startDate)} />
          <Field label="종료일"    value={fmtDate(item.endDate)} />
          <Field label="인원"      value={item.participants ? `${item.participants}명` : null} />
          <Field label="픽업장소"  value={item.pickupLocation} />
        </>}

        {type === 'rentcar' && <>
          <Field label="차종"      value={item.carType ? <span className="bg-indigo-100 text-indigo-800 px-2 py-0.5 rounded text-xs">{item.carType}</span> : null} />
          <Field label="차량수"    value={item.carCount ? `${item.carCount}대` : null} />
          <Field label="픽업일"    value={fmtDate(item.pickupDate)} />
          <Field label="픽업시간"  value={item.pickupTime} />
          <Field label="픽업장소"  value={item.pickupLocation} />
          <Field label="목적지"    value={item.destination} />
          <Field label="이용기간"  value={item.usagePeriod} />
          <Field label="승객수"    value={item.passengerCount ? `${item.passengerCount}명` : null} />
        </>}
      </div>
      {item.requestNote && (
        <div className="mt-3 pt-3 border-t border-yellow-300 bg-yellow-50 rounded p-3">
          <p className="text-xs font-semibold text-yellow-800 mb-1">📝 요청사항</p>
          <p className="text-sm text-gray-900 whitespace-pre-wrap">{item.requestNote}</p>
        </div>
      )}
    </div>
  );
}

/* ── 메인 모달 ── */
export default function ReservationDetailModal({
  isOpen,
  onClose,
  item,
  items,
}: {
  isOpen: boolean;
  onClose: () => void;
  item: any;
  items?: any[];
}) {
  if (!isOpen || !item) return null;

  const type = getServiceType(item);
  const meta = SERVICE_META[type] || DEFAULT_META;
  const Icon = meta.icon;
  const groupedItems = (items && items.length > 0) ? items : [item];
  const groupKey = item?.source === 'sh'
    ? `주문번호 ${item?.orderId || '-'}`
    : `견적ID ${item?.quoteId || item?.re_quote_id || item?.quote_id || '-'}`;

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-start justify-center pt-0 sm:pt-2">
      <div className="absolute inset-0 bg-black/50" onClick={onClose} />
      <div className="relative bg-white w-full sm:w-[95%] sm:max-w-2xl rounded-t-2xl sm:rounded-xl shadow-2xl flex flex-col max-h-[95vh] sm:max-h-[90vh]">

        {/* 모달 헤더 */}
        <div className="flex items-center gap-3 px-4 py-3 border-b bg-white rounded-t-2xl sm:rounded-t-xl sticky top-0 z-10">
          <div className={`w-10 h-10 flex items-center justify-center rounded-xl ${meta.bg} border ${meta.border}`}>
            <Icon className={`w-5 h-5 ${meta.iconColor}`} />
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 flex-wrap">
              <span className={`font-bold text-base ${meta.title}`}>{meta.label} 상세 정보</span>
              {item.source === 'sh' && (
                <span className="text-xs px-2 py-0.5 rounded-full bg-gray-200 text-gray-600 font-medium">Old</span>
              )}
              {item.source === 'new' && (
                <span className="text-xs px-2 py-0.5 rounded-full bg-blue-100 text-blue-700 font-medium">New</span>
              )}
            </div>
            <p className="text-sm text-gray-500 truncate">
              {item.customerName || item.name || '고객 정보 없음'}
              {item.customerEnglishName ? ` (${item.customerEnglishName})` : ''}
            </p>
            <p className="text-xs text-gray-400 mt-0.5">{groupKey} · 연결 서비스 {groupedItems.length}건</p>
          </div>
          <button onClick={onClose} className="p-2 rounded-lg hover:bg-gray-100 shrink-0">
            <X className="w-5 h-5 text-gray-500" />
          </button>
        </div>

        {/* 모달 바디 */}
        <div className="overflow-y-auto p-4 space-y-4 flex-1">

          {/* 고객 기본 정보 */}
          <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
            <h4 className="font-semibold text-gray-700 mb-3 flex items-center gap-2 text-sm">
              <User className="w-4 h-4 text-gray-500" />
              고객 정보
            </h4>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-6">
              <Field label="이메일"     value={item.email} />
              <Field label="한글이름"   value={item.customerName} />
              <Field label="영문이름"   value={item.customerEnglishName} />
            </div>
          </div>

          {/* 연결된 서비스 상세 */}
          <div className="space-y-3">
            {groupedItems.map((serviceItem, idx) => {
              const serviceType = getServiceType(serviceItem);
              const serviceMeta = SERVICE_META[serviceType] || DEFAULT_META;
              return (
                <div key={`${serviceItem?.orderId || serviceItem?.re_id || 'item'}-${idx}`}>
                  {groupedItems.length > 1 && (
                    <div className="mb-2 text-xs text-gray-500 font-medium">
                      서비스 {idx + 1}
                    </div>
                  )}
                  <ServiceDetails item={serviceItem} type={serviceType} meta={serviceMeta} />
                </div>
              );
            })}
          </div>

        </div>
      </div>
    </div>
  );
}
