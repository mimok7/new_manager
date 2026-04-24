import Link from 'next/link';
import { PageWrapper, SectionBox } from '@sht/ui';

const SERVICES: Array<{ key: string; label: string; desc: string }> = [
  { key: 'cruise', label: '🚢 크루즈', desc: '객실/차량 패키지 견적+예약' },
  { key: 'airport', label: '✈️ 공항', desc: '픽업/샌딩 차량 예약' },
  { key: 'hotel', label: '🏨 호텔', desc: '하롱베이 호텔 숙박 예약' },
  { key: 'tour', label: '🗺️ 투어', desc: '하롱베이 투어 예약' },
  { key: 'rentcar', label: '🚗 렌터카', desc: '렌터카 예약' },
];

export default function DirectBookingPage() {
  return (
    <PageWrapper>
      <SectionBox title="🛒 직접 예약">
        <p className="text-sm text-gray-600">
          서비스를 선택하고 바로 견적·예약을 진행하세요.
        </p>
      </SectionBox>
      <div className="grid gap-3 md:grid-cols-2 lg:grid-cols-3">
        {SERVICES.map((s) => (
          <Link
            key={s.key}
            href={`/mypage/direct-booking/${s.key}`}
            className="block rounded-lg border border-gray-200 bg-white p-4 transition hover:border-brand-500 hover:shadow-sm"
          >
            <div className="mb-1 text-base font-medium text-gray-700">{s.label}</div>
            <div className="text-xs text-gray-500">{s.desc}</div>
          </Link>
        ))}
      </div>
    </PageWrapper>
  );
}
