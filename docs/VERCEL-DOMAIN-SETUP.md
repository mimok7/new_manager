# Vercel 도메인 분리 설정 가이드 (sht-platform monorepo)

작성일: 2026-04-30  
저장소: `https://github.com/mimok7/shtplatform`

---

## 1. 전체 구조

```
GitHub: mimok7/shtplatform (단일 모노레포)
  ├─ apps/customer  ─→ Vercel Project: sht-customer  ─→ www.staycruise.kr
  ├─ apps/manager   ─→ Vercel Project: sht-manager   ─→ manager.staycruise.kr
  ├─ apps/admin     ─→ Vercel Project: sht-admin     ─→ admin.staycruise.kr
  └─ apps/partner   ─→ Vercel Project: sht-partner   ─→ partner.staycruise.kr
```

각 앱은 **별도 Vercel Project**로 등록하고 **Root Directory만 다르게** 지정합니다.

---

## 2. Vercel Project 생성 (4개 반복)

### 2.1 Vercel Dashboard
1. https://vercel.com 로그인 → **Add New… → Project**
2. **Import Git Repository**에서 `mimok7/shtplatform` 선택 (조직/계정 권한 필요)
3. **Configure Project** 단계 입력:

| 항목 | customer | manager | admin | partner |
|------|----------|---------|-------|---------|
| **Project Name** | `sht-customer` | `sht-manager` | `sht-admin` | `sht-partner` |
| **Framework Preset** | Next.js | Next.js | Next.js | Next.js |
| **Root Directory** | `apps/customer` | `apps/manager` | `apps/admin` | `apps/partner` |
| **Build Command** | (자동: vercel.json 사용) | 동일 | 동일 | 동일 |
| **Install Command** | (자동: vercel.json 사용) | 동일 | 동일 | 동일 |
| **Output Directory** | `.next` | `.next` | `.next` | `.next` |
| **Node Version** | 20.x | 20.x | 20.x | 20.x |

> ⚠️ **중요**: Root Directory를 잘못 설정하면 빌드 실패합니다. 반드시 `apps/<앱이름>`만 입력.

### 2.2 vercel.json (각 앱에 이미 적용됨)
각 앱의 `apps/<앱>/vercel.json`이 monorepo 빌드를 자동 처리합니다:
```json
{
  "installCommand": "cd ../.. && pnpm install --frozen-lockfile",
  "buildCommand": "cd ../.. && pnpm --filter @sht/<앱> build",
  "outputDirectory": ".next",
  "framework": "nextjs"
}
```

---

## 3. 환경 변수 설정 (4개 프로젝트 모두)

각 Vercel Project → **Settings → Environment Variables**:

```env
NEXT_PUBLIC_SUPABASE_URL=https://<your-project>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOi...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOi...
```

| 환경 | 적용 |
|------|------|
| Production | 운영용 키 (실제 사용자 데이터) |
| Preview | 운영용 또는 스테이징 키 |
| Development | 로컬 .env.local에서 사용 |

> 💡 **권장**: 4개 앱 모두 **동일한 Supabase 인스턴스** 사용 (RLS로 권한 분리). 별도 인스턴스 불필요.

---

## 4. 도메인 분리 설정 (서브도메인 권장)

### 4.1 도메인 구매/소유
이미 보유한 도메인(예: `staycruise.kr`)이 있다고 가정합니다.

### 4.2 각 Vercel Project에 도메인 추가
Vercel Project → **Settings → Domains → Add**:

| 앱 | 도메인 | DNS 레코드 |
|----|--------|------------|
| sht-customer | `staycruise.kr` + `www.staycruise.kr` | A `76.76.21.21` (apex), CNAME `cname.vercel-dns.com` (www) |
| sht-manager | `manager.staycruise.kr` | CNAME `cname.vercel-dns.com` |
| sht-admin | `admin.staycruise.kr` | CNAME `cname.vercel-dns.com` |
| sht-partner | `partner.staycruise.kr` | CNAME `cname.vercel-dns.com` |

### 4.3 DNS 설정 (도메인 등록업체에서)
도메인 관리 페이지(가비아/카페24/Cloudflare 등)에서:

```
# Apex 도메인 (staycruise.kr)
Type: A
Name: @
Value: 76.76.21.21
TTL: 3600

# www
Type: CNAME
Name: www
Value: cname.vercel-dns.com
TTL: 3600

# 서브도메인들
Type: CNAME
Name: manager
Value: cname.vercel-dns.com
TTL: 3600

Type: CNAME
Name: admin
Value: cname.vercel-dns.com
TTL: 3600

Type: CNAME
Name: partner
Value: cname.vercel-dns.com
TTL: 3600
```

### 4.4 SSL 인증서
Vercel이 **Let's Encrypt 자동 발급** (무료, 자동 갱신). DNS 전파 후 1~5분 내 적용.

### 4.5 도메인 분리 효과
- ✅ **쿠키/세션 격리**: customer 로그인이 manager 세션에 영향 없음
- ✅ **CORS 자연 분리**: 다른 origin이라 cross-app fetch는 명시적 허용 필요
- ✅ **보안 강화**: 한 앱 XSS가 다른 앱 토큰 탈취 불가
- ✅ **사용자 경험**: 매니저는 `manager.도메인`, 파트너는 `partner.도메인`으로 직관적

---

## 5. Ignored Build Step (변경된 앱만 재배포)

**핵심 비용 절감 기능**. main 브랜치에 push할 때마다 4개 앱이 모두 빌드되는 낭비를 막습니다.

각 Vercel Project → **Settings → Git → Ignored Build Step**에 입력:

### customer
```bash
git diff HEAD^ HEAD --quiet -- apps/customer packages
```

### manager
```bash
git diff HEAD^ HEAD --quiet -- apps/manager packages
```

### admin
```bash
git diff HEAD^ HEAD --quiet -- apps/admin packages
```

### partner
```bash
git diff HEAD^ HEAD --quiet -- apps/partner packages
```

**동작**: 해당 앱과 `packages/*`(공유 코드)에 변경이 없으면 빌드 skip → "Build skipped" 표시.

> 📊 효과 예시: manager만 수정한 PR → manager 1개만 빌드, customer/admin/partner 3개 skip → CI 시간 75% 절감

---

## 6. 자동 배포 흐름

```
[개발자: git push origin main]
   ↓
[GitHub mimok7/shtplatform 업데이트]
   ↓
[Vercel: 4개 프로젝트 동시 트리거]
   ↓
[각 프로젝트: Ignored Build Step 평가]
   ├─ apps/customer 변경? → ✅ 빌드 + 배포 → www.staycruise.kr
   ├─ apps/manager 변경?  → ✅ 빌드 + 배포 → manager.staycruise.kr
   ├─ apps/admin 변경?    → ⏭️ skip
   ├─ apps/partner 변경?  → ⏭️ skip
   └─ packages/* 변경?    → 4개 모두 빌드
```

---

## 7. Preview 배포 활용

- PR 생성/업데이트 시 자동으로 `<프로젝트>-<해시>-<계정>.vercel.app` 미리보기 URL 생성
- QA 후 main으로 머지 → Production 자동 배포
- Branch별 도메인: Vercel Project → Settings → Domains → 특정 브랜치 매핑 가능
  - 예: `staging.manager.staycruise.kr` → manager 프로젝트의 `develop` 브랜치

---

## 8. 모니터링 & 로그

| 메뉴 | 용도 |
|------|------|
| Deployments | 배포 이력, 빌드 로그 |
| Analytics | 트래픽, Core Web Vitals |
| Logs (Functions) | API Routes 런타임 로그 |
| Speed Insights | 페이지 성능 측정 |
| Usage | 빌드 시간/대역폭 사용량 |

---

## 9. 정리 권장사항

### 9.1 단독 저장소 처리
이제 모든 작업을 `mimok7/shtplatform`에서만 진행하므로:

| 저장소 | 처리 |
|--------|------|
| `mimok7/new_manager` | **Archive** (3개월 후 삭제) |
| `mimok7/new_customer` | **Archive** (3개월 후 삭제) |
| `sht-manager` (단독) | 로컬만 유지 → 추후 삭제 |
| `sht-manager1` (단독) | 로컬만 유지 → 추후 삭제 |
| `sht-customer` (단독) | 로컬만 유지 → 추후 삭제 |
| `sht-admin` (단독) | 로컬만 유지 → 추후 삭제 |

### 9.2 GitHub Archive 방법
1. https://github.com/mimok7/new_manager → Settings → 맨 아래 **Archive this repository**
2. 동일 절차로 `new_customer` archive
3. Archive된 저장소는 read-only이지만 보존됨 → 안전

### 9.3 로컬 정리
3개월 안정 운영 후:
```powershell
# Remove-Item -Recurse -Force c:\Users\saint\SH_DATA\sht-manager
# Remove-Item -Recurse -Force c:\Users\saint\SH_DATA\sht-customer
# (백업 권장)
```

---

## 10. 체크리스트

### 즉시 실행
- [x] `apps/admin` 추가, monorepo 통합 완료
- [x] `mimok7/shtplatform` 신규 origin 등록 + 푸시 완료
- [ ] Vercel에 `sht-admin` Project 신규 생성 (Root: `apps/admin`)
- [ ] Vercel `sht-customer`, `sht-manager`, `sht-partner` Project를 새 origin으로 재연결
- [ ] 각 Project에 환경변수(SUPABASE_*) 입력
- [ ] 각 Project에 Ignored Build Step 4종 등록
- [ ] DNS에 4종 CNAME 등록 + Vercel Domain 추가

### 운영 단계
- [ ] CODEOWNERS 파일 추가 (`.github/CODEOWNERS`)
- [ ] Branch Protection: main에 PR 필수, 1명 이상 리뷰
- [ ] 단독 저장소 5종 → 3개월 안정 후 Archive

---

## 11. 트러블슈팅

| 증상 | 원인 / 해결 |
|------|------------|
| Vercel 빌드 시 `pnpm: command not found` | Vercel은 pnpm 자동 감지. `corepack enable` 또는 root `package.json`의 `packageManager: "pnpm@..."` 명시 |
| `Cannot find module '@sht/...'` | pnpm-workspace.yaml 인식 안됨. Root Directory가 `apps/<앱>`인지 재확인 |
| 도메인 추가 후 SSL 안됨 | DNS 전파 대기 (최대 24시간). https://www.whatsmydns.net 에서 확인 |
| Ignored Build Step이 항상 빌드 | shallow clone 문제. Vercel Project → Settings → Git → "Ignored Build Step"이 정확한지 + Production Branch 설정 확인 |
| 환경변수 변경 후 미반영 | Re-deploy 필요. Deployments → 최신 → ⋯ → Redeploy |
