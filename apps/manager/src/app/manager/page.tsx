import Link from 'next/link';
import { PageWrapper, SectionBox } from '@sht/ui';

const TILES: Array<{ href: string; title: string; desc: string }> = [
  { href: '/manager/dashboard', title: '대시보드', desc: '오늘의 요약' },
  { href: '/manager/quotes', title: '견적 관리', desc: '신규/대기/승인 견적' },
  { href: '/manager/reservations', title: '예약 관리', desc: '서비스별 예약 목록' },
  { href: '/manager/reservation-edit', title: '예약 수정', desc: '서비스별 상세 수정' },
  { href: '/manager/reservation-details', title: '예약 상세', desc: '상세 조회' },
  { href: '/manager/confirmation', title: '확정서', desc: '예약 확정서 발행' },
  { href: '/manager/payments', title: '결제 관리', desc: '입금/원페이' },
  { href: '/manager/payment-processing', title: '결제 처리', desc: '결제 승인/취소' },
  { href: '/manager/dispatch', title: '차량 배차', desc: '공항/크루즈/렌터카/SHT' },
  { href: '/manager/dispatch-codes', title: '배차 코드', desc: '코드 관리' },
  { href: '/manager/assignment-codes', title: '배정 코드', desc: '코드 관리' },
  { href: '/manager/boarding-code', title: '탑승 코드', desc: '코드 관리' },
  { href: '/manager/sht-car', title: 'SHT 차량', desc: '차량 시트' },
  { href: '/manager/cruise-car-dates', title: '크루즈 차량 일정', desc: '운영일정' },
  { href: '/manager/schedule', title: '일정', desc: 'Google Sheets 연동' },
  { href: '/manager/sheet-reservations', title: '시트 예약', desc: '시트 동기' },
  { href: '/manager/customers', title: '고객 관리', desc: '회원/예약자' },
  { href: '/manager/passport-management', title: '여권 관리', desc: '여권 정보' },
  { href: '/manager/services', title: '서비스', desc: '서비스 카탈로그' },
  { href: '/manager/service-tables', title: '서비스 테이블', desc: '서비스 메타' },
  { href: '/manager/packages', title: '패키지', desc: '여행 패키지' },
  { href: '/manager/pricing', title: '요금 관리', desc: '단가 관리' },
  { href: '/manager/exchange-rate', title: '환율', desc: 'KRW/VND 환율' },
  { href: '/manager/additional-fee-management', title: '추가요금', desc: '추가 요금 템플릿' },
  { href: '/manager/cafe-guide', title: '카페 가이드', desc: '안내문' },
  { href: '/manager/notifications', title: '알림', desc: '발송 이력' },
  { href: '/manager/reports', title: '리포트', desc: '집계 리포트' },
  { href: '/manager/analytics', title: '분석', desc: '매출/통계' },
  { href: '/manager/sync', title: '동기화', desc: '외부 동기화' },
];

export default function ManagerHome() {
  return (
    <PageWrapper>
      <SectionBox title="매니저 대시보드">
        <p className="text-sm text-gray-600">담당 업무 모듈을 선택하세요.</p>
      </SectionBox>
      <div className="grid gap-3 md:grid-cols-2 lg:grid-cols-4">
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
