---
applyTo: "apps/partner/**"
description: "파트너 시스템 v2 — 역할별 도메인(예약자/제휴업체/매니저) 라우트 구조 + Vercel 도메인 생성·배포 절차 (2026-04-30)"
---

# 파트너 시스템: 역할 도메인 + 배포 지침

작성일: 2026-04-30  
대상 앱: `apps/partner` (`@sht/partner`, port 3003)  
운영 도메인: `partner.staycruise.kr`

---

## 1. 핵심 원칙

### 1.1 단일 앱, 역할 기반 라우트 분리 (도메인은 1개)
**`apps/partner` 한 앱에 3개 역할 도메인이 라우트 prefix로 공존**합니다. 별도 Vercel 프로젝트나 서브도메인을 추가로 만들지 않습니다.

| 역할 도메인 | URL prefix | 대상 사용자 | 권한 (RLS) |
|-------------|-----------|-------------|------------|
| 🛒 **예약자** | `/partner/browse`, `/partner/booking/[partnerId]`, `/partner/my-reservations` | `member` | 자기 예약만 |
| 🏢 **제휴업체** | `/partner/dashboard`, `/partner/calendar` | `partner` | `partner_user` 매핑된 자기 업체만 |
| 🛠️ **매니저** | `/partner/admin/partners`, `/services`, `/prices`, `/promotions`, `/reservations` | `manager`, `admin` | 전체 |

### 1.2 사이드바 분리 (필수)
[apps/partner/src/components/PartnerSidebar.tsx](apps/partner/src/components/PartnerSidebar.tsx) 의 메뉴 상수를 **역할별로 명시 분리** 유지:
- `MEMBER_MENU` — 예약자 메뉴
- `PARTNER_MENU` — 제휴업체 메뉴
- `ADMIN_MENU` — 매니저/관리자 메뉴

`useAuth()`에서 받은 `profile.role`로 분기 노출. **단일 `MENU_BY_ROLE` 맵으로 합치지 말 것** — 향후 메뉴 차이가 커질 때 수정 부담이 급증합니다.

### 1.3 페이지 작성 표준 (필수)
모든 신규 페이지는 다음 패턴을 사용합니다:

```tsx
'use client';
import PartnerLayout from '@/components/PartnerLayout';
import SectionBox from '@/components/SectionBox';

export default function MyPage() {
    return (
        <PartnerLayout title="페이지 제목" requiredRoles={['member']}>
            <SectionBox title="섹션">{/* ... */}</SectionBox>
        </PartnerLayout>
    );
}
```

- **인증 훅 자체 구현 금지** → `PartnerLayout`이 내부에서 `useAuth(requiredRoles, '/login')` 호출
- **Supabase 클라이언트 자체 생성 금지** → `import { supabase } from '@/lib/supabase'` 단일 인스턴스
- **try-catch-finally + cancelled 플래그 + `[]` 의존성** 패턴 (무한 로딩 방지, copilot-instructions.md 참조)

---

## 2. 데이터 모델 v2 (multi-category + promotion)

### 2.1 카테고리별 예약 모드 (`modeOf`)
[booking/[partnerId]/page.tsx](apps/partner/src/app/partner/booking/%5BpartnerId%5D/page.tsx) 에서 카테고리에 따라 폼 모드가 자동 분기됩니다:

| `partner.category` | 모드 | 사용 컬럼 |
|--------------------|------|-----------|
| `hotel` | `stay` | `checkin_date`, `checkout_date`, 박수, 객실수 |
| `spa`, `costume`, `tour`, `rentcar` | `schedule` | `scheduled_at` (date+time), `duration_minutes`, `quantity` |
| `restaurant` | `order` | `scheduled_at` (date+옵션 time), `quantity` |

신규 카테고리 추가 시 `modeOf(category)` 함수에 매핑 추가 필수.

### 2.2 v2 주요 컬럼 (반드시 표출)
- `partner`: `subcategory`, `branch_name`, `thumbnail_url`, `sort_order`, `sht_discount_rate`
- `partner_service`: `unit`, `duration_minutes`, `capacity`, `min/max_quantity`, `sht_discount_rate`
- `partner_price`: `tier_label`, `sht_price`, `duration_minutes`, `valid_from/to`
- `partner_reservation`: `scheduled_at`, `quantity`, `service_label`, `price_label`, `payment_status`, `confirmation_code`
- `partner_promotion`: `promo_type`(free_item|percent_discount|amount_discount), 인원/쿠폰/크루즈/등급 조건

### 2.3 예약 상태 전이 (제휴업체 도메인)
[dashboard/page.tsx](apps/partner/src/app/partner/dashboard/page.tsx) 의 `updateStatus()`:

```
pending → confirmed (자동 confirmation_code = `C${Date.now()}` 발급)
pending → cancelled
confirmed → completed
confirmed → cancelled
```

상태 변경 시 항상 `confirm()` 다이얼로그 → DB update → `loadRows()` 재조회.

---

## 3. 신규 페이지 추가 절차

새 기능을 추가할 때 따라야 할 표준 순서:

1. **역할 도메인 결정** → URL prefix 선택
   - 예약자 화면? → `apps/partner/src/app/partner/<기능>/page.tsx`
   - 매니저 CRUD? → `apps/partner/src/app/partner/admin/<기능>/page.tsx`
2. **사이드바 등록** → 해당 역할 메뉴 상수에 1줄 추가
3. **페이지 작성** → §1.3 표준 패턴 사용
4. **권한 명시** → `<PartnerLayout requiredRoles={[...]}>`
5. **타입 검증** → `get_errors`로 컴파일 에러 0 확인
6. **로컬 확인** → `pnpm --filter @sht/partner dev` (port 3003)
7. **커밋·푸시** → 사용자 명시 요청 시에만 (자동 push 금지)

---

## 4. Vercel 도메인 생성·배포 절차

### 4.1 신규 앱(별도 도메인) 추가 시 — 전체 흐름

새 앱을 만들고 새 서브도메인(`<sub>.staycruise.kr`)에 배포해야 할 때:

```
[1] 모노레포에 앱 생성
   apps/<newapp>/ (Next.js 15 + vercel.json)
   pnpm-workspace.yaml에 자동 포함됨
   ↓
[2] vercel.json 작성
   {
     "installCommand": "cd ../.. && pnpm install --frozen-lockfile",
     "buildCommand": "cd ../.. && pnpm --filter @sht/<newapp> build",
     "outputDirectory": ".next",
     "framework": "nextjs"
   }
   ↓
[3] Git push (단일 모노레포 origin)
   git push origin main
   ↓
[4] Vercel Dashboard
   Add New → Project → Import mimok7/shtplatform
   Project Name: sht-<newapp>
   Root Directory: apps/<newapp>     ← ⚠️ 반드시 정확히 입력
   Framework: Next.js
   Node: 20.x
   ↓
[5] 환경 변수 등록 (Settings → Environment Variables)
   NEXT_PUBLIC_SUPABASE_URL
   NEXT_PUBLIC_SUPABASE_ANON_KEY
   SUPABASE_SERVICE_ROLE_KEY
   ↓
[6] Ignored Build Step (Settings → Git)
   git diff HEAD^ HEAD --quiet -- apps/<newapp> packages
   ↓
[7] 도메인 추가 (Settings → Domains → Add)
   <sub>.staycruise.kr
   ↓
[8] DNS 등록 (도메인 등록업체)
   Type: CNAME
   Name: <sub>
   Value: cname.vercel-dns.com
   TTL: 3600
   ↓
[9] SSL 자동 발급 대기 (1~5분)
   Vercel이 Let's Encrypt 자동 처리
   ↓
[10] 배포 확인
    https://<sub>.staycruise.kr 접속 테스트
```

### 4.2 기존 앱(예: partner)의 새 라우트만 배포할 때
**별도 작업 없음.** `git push origin main` → Vercel이 자동 감지 → `apps/partner` 변경분이 있으면 `partner.staycruise.kr`로 자동 재배포됩니다 (Ignored Build Step이 변경 감지).

### 4.3 운영 중인 6개 프로젝트 매핑
| 앱 | Vercel 프로젝트 | 도메인 | Root Directory |
|----|-----------------|--------|----------------|
| customer | `sht-customer` | `staycruise.kr`, `www.staycruise.kr` | `apps/customer` |
| customer1 | `sht-customer1` | `legacy.staycruise.kr` | `apps/customer1` |
| manager | `sht-manager` | `manager.staycruise.kr` | `apps/manager` |
| manager1 | `sht-manager1` | `quick.manager.staycruise.kr` | `apps/manager1` |
| admin | `sht-admin` | `admin.staycruise.kr` | `apps/admin` |
| partner | `sht-partner` | `partner.staycruise.kr` | `apps/partner` |

### 4.4 DNS 표준 레코드
```
# Apex (staycruise.kr)
Type: A      Name: @         Value: 76.76.21.21       TTL: 3600
# 모든 서브도메인 (www, manager, admin, partner, legacy, quick.manager 등)
Type: CNAME  Name: <서브명>  Value: cname.vercel-dns.com  TTL: 3600
```

### 4.5 배포 검증 체크리스트
- [ ] `git push origin main` 완료
- [ ] Vercel Dashboard → Deployments에 최신 커밋 표시
- [ ] 빌드 로그 "Ready" 또는 "Build skipped"
- [ ] 도메인(`https://<sub>.staycruise.kr`) HTTPS 200 응답
- [ ] 로그인/세션/Supabase 쿼리 동작 확인
- [ ] (DB 변경 시) `sql/` 마이그레이션 Supabase Dashboard에서 선반영

---

## 5. 절대 금지 사항

- ❌ **별도 저장소 생성 금지** — 모든 코드는 `mimok7/shtplatform` 단일 모노레포
- ❌ **partner 앱을 3개로 분할 금지** — `/partner/admin/*`, `/partner/dashboard`, `/partner/browse`로 라우트 분리만
- ❌ **manager1 사이드바 구조 미러링 금지** — 2섹션(`⭐즐겨찾기` + `📂관리 기타`) 고정
- ❌ **자동 `git push` 금지** — 사용자 명시 요청 시에만
- ❌ **자동 `pnpm build`/`typecheck` 금지** — "전체 점검" 요청 시에만
- ❌ **자체 인증/세션/Supabase 인스턴스 생성 금지** — `useAuth`, `@/lib/supabase` 표준 사용
- ❌ **Vercel Root Directory 오타 금지** — `apps/<앱이름>` 정확히 (오타 시 빌드 실패)

---

## 6. 참고 문서

- 배포 상세: [docs/VERCEL-DOMAIN-SETUP.md](docs/VERCEL-DOMAIN-SETUP.md)
- 저장소 전략: [docs/GITHUB-VERCEL-STRATEGY.md](docs/GITHUB-VERCEL-STRATEGY.md)
- 공통 코딩 규칙: [.github/copilot-instructions.md](.github/copilot-instructions.md)
- DB 스키마 마이그레이션: [sql/2026-04-30-partner-system-v2-multi-category.sql](sql/2026-04-30-partner-system-v2-multi-category.sql)
