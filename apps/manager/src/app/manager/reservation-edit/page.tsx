import Link from 'next/link';
import { PageWrapper, SectionBox } from '@sht/ui';

const TYPES = [
  { key: 'cruise', label: '🚢 크루즈' },
  { key: 'airport', label: '✈️ 공항' },
  { key: 'hotel', label: '🏨 호텔' },
  { key: 'rentcar', label: '🚗 렌터카' },
  { key: 'tour', label: '🗺️ 투어' },
  { key: 'sht', label: '🚌 SHT' },
];

export default function ReservationEditIndexPage() {
  return (
    <PageWrapper>
      <SectionBox title="✏️ 예약 편집">
        <p className="text-sm text-gray-600">
          유형을 선택하거나 예약 목록에서 편집 버튼을 누르세요.
        </p>
      </SectionBox>
      <div className="grid gap-3 md:grid-cols-3">
        {TYPES.map((t) => (
          <Link
            key={t.key}
            href={`/manager/reservation-edit/${t.key}` as never}
            className="block rounded-lg border border-gray-200 bg-white p-4 text-center transition hover:border-brand-500"
          >
            {t.label}
          </Link>
        ))}
      </div>
    </PageWrapper>
  );
}
