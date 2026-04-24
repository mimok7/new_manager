import Link from 'next/link';
import { PageWrapper, SectionBox } from '@sht/ui';

const TILES: Array<{ href: string; title: string; desc: string }> = [
  { href: '/mypage/quotes', title: '견적 관리', desc: '내 견적 목록 보기 / 새 견적 만들기' },
  { href: '/mypage/reservations', title: '예약 관리', desc: '예약 내역과 상세 확인' },
  { href: '/mypage/direct-booking', title: '직접 예약', desc: '크루즈/공항/호텔/투어/렌터카 바로 예약' },
  { href: '/mypage/confirmations', title: '확정서', desc: '예약 확정서 다운로드' },
  { href: '/mypage/profile', title: '프로필', desc: '연락처/여권 정보 관리' },
];

export default function MyPageHome() {
  return (
    <PageWrapper>
      <SectionBox title="환영합니다 👋">
        <p className="text-sm text-gray-600">스테이하롱 크루즈 예약 시스템입니다.</p>
      </SectionBox>
      <div className="grid gap-3 md:grid-cols-2 lg:grid-cols-3">
        {TILES.map((t) => (
          <Link
            key={t.href}
            href={t.href as never}
            className="block rounded-lg border border-gray-200 bg-white p-4 transition hover:border-brand-500 hover:shadow-sm"
          >
            <div className="mb-1 text-base font-medium text-gray-700">{t.title}</div>
            <div className="text-xs text-gray-500">{t.desc}</div>
          </Link>
        ))}
      </div>
    </PageWrapper>
  );
}
