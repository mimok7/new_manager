# SHT Platform (v2)

스테이하롱 크루즈 예약 시스템 — 모노레포 v2.

## 구조

```
sht-platform/
├── apps/
│   ├── customer/        # 고객용 (포트 3000)
│   └── manager/         # 매니저/관리자 (포트 3001)
├── packages/
│   ├── config/          # 공유 ESLint/TS/Tailwind preset
│   ├── types/           # Zod 스키마 + 도메인 타입
│   ├── db/              # Supabase 클라이언트 팩토리
│   ├── auth/            # 인증 훅/헬퍼
│   ├── domain/          # 가격·시간·견적·예약 순수 함수
│   └── ui/              # 공통 React 컴포넌트
└── tooling/scripts/
```

## 빠른 시작

```bash
# 1) 의존성 설치
pnpm install

# 2) 환경변수 설정
cp .env.example .env.local
# 그리고 .env.local 의 Supabase 키 채우기

# 3) 개발 서버 (둘 다)
pnpm dev

# 또는 개별
pnpm dev:customer   # http://localhost:3000
pnpm dev:manager    # http://localhost:3001
```

## 주요 명령

| 명령 | 설명 |
|------|------|
| `pnpm dev` | 모든 앱 동시 실행 |
| `pnpm build` | 전체 빌드 |
| `pnpm typecheck` | 타입 체크 |
| `pnpm lint` | 린트 |
| `pnpm lint:fix` | 린트 자동 수정 |
| `pnpm test` | 테스트 |

## 기술 스택

- **Next.js 15 App Router** + TypeScript strict
- **Supabase** (PostgreSQL + Auth + RLS) — 기존 프로젝트 그대로 사용
- **TanStack Query v5** + react-hook-form + Zod
- **Tailwind CSS v4** + shadcn/ui
- **Vitest** + Playwright + Sentry
- **pnpm 9** + Turborepo

## 안정성 원칙

1. `useAuth`는 캐시 우선 + `onAuthStateChange`만 (watchdog 없음)
2. 모든 init `useEffect`는 try/finally + cancelled 플래그 + `[]` 의존성
3. 시간은 `@sht/domain/datetime` 만 사용 (수동 ±9 금지)
4. 가격 조회는 단순 select + 별도 조회 (중첩 FK 조인 금지)
5. 예약 중복 방지: `(re_user_id, re_quote_id, re_type)` 유니크
