---
name: db-perf-optimization-phase10
description: "Phase 10: Supabase DB 성능/보안 최적화 (2026.04.26) — RLS 정책 통합, 중복 정책 제거, PK 추가, 백업/롤백 절차"
applyTo: "**/*.sql"
---

# DB 성능/보안 최적화 지침 (Phase 10, 2026.04.26)

## 개요
Supabase 프로젝트 `jkhookaflhibrcafmlxn`에서 자동 advisor 분석 결과를 기반으로 데이터 손실 없이 성능/보안을 개선한 4단계 마이그레이션.

**목표 달성**:
- Advisor lints: **268 → 191** (28% 감소)
- `no_primary_key`: 4 → **0** ✅
- `auth_rls_initplan`: 21 → **0** ✅
- `duplicate_index`: 22 → **0** ✅
- `unindexed_foreign_keys`: 21 → **0** ✅
- `multiple_permissive_policies`: 129 → **108** (-21)

---

## 적용된 마이그레이션 (순서대로)

### 1️⃣ `backup_before_perf_cleanup_20260426`
**목적**: 모든 변경 전 현재 상태 스냅샷 저장 (롤백용)

**생성 백업 테이블**:
```
public._backup_pg_policies_20260426         — 132행 (전체 RLS 정책)
public._backup_pg_indexes_20260426          — 315행 (전체 인덱스 정의)
public._archive_reservation_no_quote_backup_20260426     — 1,647행
public._archive_reservation_no_quote_airport_backup_20260426  — 2행
public._archive_reservation_no_quote_cruise_backup_20260426   — 0행
public._archive_reservation_no_quote_tour_backup_20260426     — 2행
```

**백업 테이블 검증** (쿼리):
```sql
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE tablename LIKE '_%backup_%' OR tablename LIKE '_%archive_%'
ORDER BY tablename;
```

---

### 2️⃣ `perf_consolidate_redundant_rls_policies_20260426`
**목적**: 중복/보안결함 RLS 정책 제거 및 매니저 가시성 정책 신규 추가

**신규 정책 추가** (매니저/관리자 통합):
```sql
-- 기존: quote/quote_item에 매니저 전용 정책 없어서 manager SELECT 불가능
-- 해결: quote_manager_admin_all, quote_item_manager_admin_all 신규 생성

CREATE POLICY quote_manager_admin_all 
  ON public.quote FOR ALL 
  TO authenticated 
  USING ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )))
  WITH CHECK ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )));

CREATE POLICY quote_item_manager_admin_all
  ON public.quote_item FOR ALL
  TO authenticated
  USING ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )))
  WITH CHECK ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )));
```

**DROP 대상 정책 21건** (category별):
- **users (5건, qual=true 보안결함 포함)**
  - `Allow all select for users` (SECURITY HOLE)
  - `Allow public read for FK constraints` (qual=true)
  - `Enable users to read own profile` (covered by `users_self_policy`)
  - `Allow authenticated users to insert profile`
  - `Enable users to insert own profile`
  - (나머지 users 정책들 중복)

- **quote (4건, qual=true 보안결함 포함)**
  - `Allow authenticated users to view quotes` (SECURITY HOLE → 신규 `quote_manager_admin_all`로 대체)
  - `Users can view own quotes` (cast variant duplicate)
  - `Users can insert own quotes` (중복)
  - `Users can update own quotes` (with_check 없어 약함)

- **quote_item (2건)**
  - `Allow authenticated users to view quote items` (사용자 체크 없음 → 신규로 대체)
  - (나머지)

- **reservation**, **reservation_airport**, **reservation_cruise_car**, **reservation_rentcar** (10건)
  - IN/EXISTS 중복 정책 정리
  - 역할별 구분(member/dispatcher)과 중복

**보안 결함 수정**:
| 정책명 | 문제 | 해결 |
|------|------|-----|
| Allow all select for users | qual=true = 모든 사용자 정보 노출 | DROP |
| Allow public read for FK constraints | qual=true 중복 | DROP |
| Allow authenticated users to view quotes | qual=true = 타인 견적 노출 | DROP + 신규 `quote_manager_admin_all` |
| Allow authenticated users to view quote items | 사용자 체크 없음 | DROP + 신규 `quote_item_manager_admin_all` |

---

### 3️⃣ `perf_add_pk_to_no_quote_backup_tables_20260426`
**목적**: 4개 `reservation_no_quote_*_backup` 테이블에 PK 추가

**수정 테이블**:
```sql
ALTER TABLE public.reservation_no_quote_backup 
  ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;

ALTER TABLE public.reservation_no_quote_airport_backup
  ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;

ALTER TABLE public.reservation_no_quote_cruise_backup
  ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;

ALTER TABLE public.reservation_no_quote_tour_backup
  ADD COLUMN _backup_pk BIGSERIAL PRIMARY KEY;
```

**advisor 결과**: `no_primary_key` 4건 → 0

---

### 4️⃣ `perf_add_pk_to_backup_archive_tables_20260426`
**목적**: 마이그레이션 #1에서 생성한 6개 백업/아카이브 테이블에 PK 추가

**수정 테이블** (각각 `_row_id BIGSERIAL PRIMARY KEY` 추가):
```
_backup_pg_policies_20260426
_backup_pg_indexes_20260426
_archive_reservation_no_quote_backup_20260426
_archive_reservation_no_quote_airport_backup_20260426
_archive_reservation_no_quote_cruise_backup_20260426
_archive_reservation_no_quote_tour_backup_20260426
```

**advisor 결과**: `no_primary_key` 6건 → 0

---

## unused_index 보류 이유

현재 **83건 미해결** (심사 필요):

```
idx_quote_user_id               — 핫패스 (quote 조회)
idx_quote_item_quote_id         — 핫패스 (quote_item 조회)
idx_quote_status                — 핫패스 (quote status 필터)
idx_reservation_user_id         — 핫패스 (reservation 조회)
idx_reservation_quote_id        — 핫패스 (reservation 조회)
idx_reservation_hotel_price_code — 핫패스 (호텔 예약 조회)
idx_*_created_at                — 정렬/필터 인덱스
idx_*_user_id_*                 — FK 인덱스 (마이그레이션 #2에서 추가)
```

**보류 이유**:
1. **통계 누적 부족**: `idx_scan=0`은 인덱스가 새로 생성되었거나 자동분석 미실행된 상태
2. **회귀 위험**: 쿼리 플래너는 인덱스 통계 부재 시 sequential scan 우선 선택 → DROP 후 성능 악화 가능
3. **권장 대기**: 운영 환경에서 2~4주 통계 누적 후 재검토 (Supabase autovacuum default: 3일)

**향후 검토 (2주 후)**:
```sql
-- idx_scan 0인 인덱스 재확인
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetched
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY indexname;

-- 임계값 < 10 정도까지 DROP 고려
-- (idx_scan >= 10: 최소 사용 증거)
```

---

## multiple_permissive_policies 잔존 이유

현재 **108건 미해결**:

**미해결 정책들의 특징**:
- 모두 `(SELECT auth.uid() IN (...))` 또는 `(SELECT auth.role() IN (...))` 형태로 InitPlan 최적화됨 (성능 이미 최소화)
- 역할별(member/manager/dispatcher) 정책으로 분리 필수 (통합 시 의미 변경)
- 예:
  ```
  reservation_member_policy_select  — member만 자신 예약 조회
  reservation_manager_policy_select — manager가 모든 예약 조회
  reservation_dispatcher_policy_select — dispatcher만 airport/rentcar 예약 조회
  ```

**통합 금지 이유**:
- `role = 'member' OR role = 'manager'` 불가 (권한 상승 위험)
- 각 역할의 data visibility가 다르므로 정책 분리 필수
- Advisor의 "redundant" 판단은 oversimplify — 현재 구조가 최선

---

## 롤백 절차 (응급 상황)

### A. 정책 복구
22개 DROP된 정책 자동 복구:
```sql
-- 1. _backup_pg_policies_20260426에서 복구 SQL 생성
SELECT 'CREATE POLICY "' || policyname || '" ON ' || schemaname || '.' || tablename ||
       CASE WHEN qual IS NOT NULL THEN ' AS PERMISSIVE FOR ' || cmd || ' TO ' || 
            (SELECT array_agg(DISTINCT r.rolname) FROM unnest(roles) r(rolname)) ||
            ' USING (' || qual || ')' ELSE '' END ||
       CASE WHEN with_check IS NOT NULL THEN ' WITH CHECK (' || with_check || ');' ELSE ';' END
FROM public._backup_pg_policies_20260426
WHERE policyname NOT IN (SELECT policyname FROM pg_policies)
ORDER BY policyname;

-- 2. 위 결과를 SQL Editor에서 실행 (22건 CREATE POLICY)
```

### B. 인덱스 복구
DROP된 인덱스 자동 복구:
```sql
-- _backup_pg_indexes_20260426.indexdef 실행
SELECT indexdef || ';' FROM public._backup_pg_indexes_20260426
WHERE indexname NOT IN (SELECT indexname FROM pg_indexes)
ORDER BY indexname;
```

### C. no_quote 테이블 데이터 복구
```sql
-- 필요 시 _archive_* 테이블에서 복원
INSERT INTO public.reservation_no_quote_backup 
  SELECT * FROM public._archive_reservation_no_quote_backup_20260426;

INSERT INTO public.reservation_no_quote_airport_backup
  SELECT * FROM public._archive_reservation_no_quote_airport_backup_20260426;

-- (기타 no_quote 테이블도 동일)
```

---

## 적용 체크리스트

### 사전 확인
- [ ] 백업 테이블 생성 성공 (6개 테이블, 1,651+ 행)
- [ ] Supabase 프로젝트 상태: ACTIVE_HEALTHY
- [ ] Production 트래픽 로우 타임대 (야간/주말) 확인

### 마이그레이션 순서
- [ ] #1: `backup_before_perf_cleanup_20260426`
- [ ] #2: `perf_consolidate_redundant_rls_policies_20260426`
- [ ] #3: `perf_add_pk_to_no_quote_backup_tables_20260426`
- [ ] #4: `perf_add_pk_to_backup_archive_tables_20260426`

### 사후 검증
- [ ] Advisor 다시 실행 → 191 lints 확인 (`multiple_permissive=108`, `unused_index=83`)
- [ ] Manager UI 접근 확인 (quote 조회 동작 확인)
- [ ] Query 성능 모니터링 (특히 `idx_quote_user_id`, `idx_reservation_user_id` 스캔율)

---

## 주의사항

⚠️ **무조건 피할 것**:
1. ❌ unused_index DROP 즉시 실행 금지 (통계 미흡)
2. ❌ multiple_permissive 정책 무리하게 통합 금지 (권한 상승 위험)
3. ❌ _backup_* / _archive_* 테이블 삭제 금지 (롤백용 필수)

✅ **권장 사항**:
1. 2주 후 `idx_scan` 재확인 후 unused_index 재심사
2. Manager/Member/Dispatcher 역할별 정책 분리 유지
3. 매월 Advisor 실행 (성능 추세 모니터링)

---

## 참고 자료

- **Supabase RLS 최적화**: https://supabase.com/docs/guides/auth/row-level-security
- **pg_stat_user_indexes**: PostgreSQL 공식 문서
- **Advisor 전체 결과**: `_backup_pg_policies_20260426` 및 `_backup_pg_indexes_20260426` 참조
