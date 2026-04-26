---
name: db-perf-optimization-rollback
description: "Phase 10 DB 롤백 절차 — 응급 복구 및 상태 원복 가이드"
---

# DB 성능/보안 최적화 롤백 절차 (Phase 10, 2026.04.26)

**상황**: Phase 10 마이그레이션(4개) 적용 후 문제 발생 시 복구 절차

---

## 🚨 긴급 상황별 대응

### 상황 1: 매니저가 quote/quote_item 조회 불가

**증상**: 매니저 로그인 후 "/mypage/quotes" 페이지 오류

**원인**: `quote_manager_admin_all`, `quote_item_manager_admin_all` 정책이 생성되지 않거나 작동 안 함

**복구 단계**:

```sql
-- 1단계: 정책 존재 확인
SELECT policyname FROM pg_policies 
WHERE tablename IN ('quote', 'quote_item') 
AND policyname LIKE '%manager%';

-- 2단계: 없으면 수동 재생성
CREATE POLICY quote_manager_admin_all 
  ON public.quote 
  FOR ALL 
  TO authenticated 
  USING ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )))
  WITH CHECK ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )));

CREATE POLICY quote_item_manager_admin_all
  ON public.quote_item
  FOR ALL
  TO authenticated
  USING ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )))
  WITH CHECK ((SELECT auth.uid() IN (
    SELECT u.id FROM public.users u WHERE u.role IN ('manager', 'admin')
  )));

-- 3단계: 검증 (매니저 계정으로 테스트)
SELECT COUNT(*) FROM quote LIMIT 1;  -- 0이 아닌 값이어야 함
```

---

### 상황 2: 쿼리 성능 악화 (특히 quote/reservation 조회)

**증상**: 
- quote 조회: 1초 이상 소요 (평소 100ms 이하)
- reservation 조회: 타임아웃

**원인**: 인덱스 미적용 또는 부실한 인덱스 통계

**복구 단계**:

```sql
-- 1단계: 핵심 인덱스 존재 확인
SELECT indexname, idx_scan FROM pg_stat_user_indexes
WHERE tablename IN ('quote', 'reservation', 'quote_item')
AND indexname LIKE '%_user_id%';

-- 2단계: 필수 인덱스 누락 시 _backup_pg_indexes_20260426에서 복구
SELECT indexdef || ';' FROM public._backup_pg_indexes_20260426
WHERE indexname IN (
  'idx_quote_user_id',
  'idx_reservation_user_id',
  'idx_quote_item_quote_id'
);
-- 위 쿼리 결과를 SQL Editor에서 실행

-- 3단계: 인덱스 통계 재계산
ANALYZE public.quote;
ANALYZE public.reservation;
ANALYZE public.quote_item;
ANALYZE public.quote_item;

-- 4단계: 쿼리 플랜 확인
EXPLAIN ANALYZE SELECT * FROM quote WHERE re_user_id = 'user-id-here' LIMIT 10;
-- "Index Scan" 또는 "Index Only Scan" 포함되어야 함
```

---

### 상황 3: 사용자 정보 접근 오류

**증상**: 
- 로그인 후 프로필 페이지 접근 불가
- "권한 없음" 오류

**원인**: users 테이블 정책 DROP 후 예상 밖 행동

**복구 단계**:

```sql
-- 1단계: users 테이블 현재 정책 확인
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'users';

-- 2단계: 필수 정책 없으면 _backup_pg_policies_20260426에서 복구
-- users_self_policy (ALL)가 있으면 충분
-- 없으면 아래 정책들 _backup_pg_policies_20260426에서 찾아 복구
SELECT 'CREATE POLICY "' || policyname || '" ON public.' || tablename || 
       ' AS PERMISSIVE FOR ' || cmd || ' TO ' || 
       array_to_string(roles, ', ') || 
       ' USING (' || qual || ')' ||
       CASE WHEN with_check IS NOT NULL THEN ' WITH CHECK (' || with_check || ');' ELSE ';' END
FROM public._backup_pg_policies_20260426
WHERE tablename = 'users' AND cmd IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'ALL');

-- 3단계: 위 결과를 SQL Editor에서 실행 (최대 10개 CREATE POLICY)
```

---

## 전체 롤백 (완전 복구)

**상황**: 모든 마이그레이션 취소하고 이전 상태로 돌리기

**⚠️ 주의**: 이 절차는 마이그레이션 이후의 데이터 변경을 모두 버립니다.

### 단계 1: 정책 복구 (21개 DROP된 정책 재생성)

```sql
-- _backup_pg_policies_20260426 조회하여 현재 없는 정책 복구
SELECT 
  'CREATE POLICY "' || policyname || '" ON public.' || tablename ||
  CASE 
    WHEN qual IS NULL THEN ''
    ELSE ' AS PERMISSIVE FOR ' || cmd || ' TO ' || 
         array_to_string(roles, ', ') || 
         ' USING (' || qual || ')'
  END ||
  CASE 
    WHEN with_check IS NOT NULL THEN ' WITH CHECK (' || with_check || ');'
    ELSE ';'
  END as restore_sql
FROM public._backup_pg_policies_20260426
WHERE policyname NOT IN (SELECT policyname FROM pg_policies)
ORDER BY tablename, policyname;

-- 위 결과 복사 → SQL Editor 실행 (22개 CREATE POLICY 예상)
```

### 단계 2: 신규 정책 제거 (manager 정책 2개 DROP)

```sql
DROP POLICY IF EXISTS quote_manager_admin_all ON public.quote;
DROP POLICY IF EXISTS quote_item_manager_admin_all ON public.quote_item;
```

### 단계 3: 인덱스 복구 (필요 시)

```sql
-- 현재 없는 인덱스만 재생성
SELECT indexdef || ';' 
FROM public._backup_pg_indexes_20260426 bi
WHERE NOT EXISTS (
  SELECT 1 FROM pg_indexes pi 
  WHERE pi.indexname = bi.indexname
)
ORDER BY bi.indexname;

-- 위 결과를 SQL Editor에서 실행
```

### 단계 4: no_quote 테이블 데이터 복구

```sql
-- 현재 no_quote 테이블 삭제 (주의!)
TRUNCATE TABLE public.reservation_no_quote_backup CASCADE;
TRUNCATE TABLE public.reservation_no_quote_airport_backup CASCADE;
TRUNCATE TABLE public.reservation_no_quote_cruise_backup CASCADE;
TRUNCATE TABLE public.reservation_no_quote_tour_backup CASCADE;

-- _archive_* 테이블에서 복구
INSERT INTO public.reservation_no_quote_backup 
  SELECT * EXCEPT(_row_id) FROM public._archive_reservation_no_quote_backup_20260426;

INSERT INTO public.reservation_no_quote_airport_backup
  SELECT * EXCEPT(_row_id) FROM public._archive_reservation_no_quote_airport_backup_20260426;

INSERT INTO public.reservation_no_quote_cruise_backup
  SELECT * EXCEPT(_row_id) FROM public._archive_reservation_no_quote_cruise_backup_20260426;

INSERT INTO public.reservation_no_quote_tour_backup
  SELECT * EXCEPT(_row_id) FROM public._archive_reservation_no_quote_tour_backup_20260426;
```

### 단계 5: 신규 PK 컬럼 제거 (선택 사항)

```sql
-- no_quote 테이블의 _backup_pk 제거
ALTER TABLE public.reservation_no_quote_backup DROP COLUMN IF EXISTS _backup_pk;
ALTER TABLE public.reservation_no_quote_airport_backup DROP COLUMN IF EXISTS _backup_pk;
ALTER TABLE public.reservation_no_quote_cruise_backup DROP COLUMN IF EXISTS _backup_pk;
ALTER TABLE public.reservation_no_quote_tour_backup DROP COLUMN IF EXISTS _backup_pk;

-- 백업 테이블의 _row_id 제거
ALTER TABLE public._backup_pg_policies_20260426 DROP COLUMN IF EXISTS _row_id;
ALTER TABLE public._backup_pg_indexes_20260426 DROP COLUMN IF EXISTS _row_id;
ALTER TABLE public._archive_reservation_no_quote_backup_20260426 DROP COLUMN IF EXISTS _row_id;
ALTER TABLE public._archive_reservation_no_quote_airport_backup_20260426 DROP COLUMN IF EXISTS _row_id;
ALTER TABLE public._archive_reservation_no_quote_cruise_backup_20260426 DROP COLUMN IF EXISTS _row_id;
ALTER TABLE public._archive_reservation_no_quote_tour_backup_20260426 DROP COLUMN IF EXISTS _row_id;
```

---

## 검증 체크리스트

### 롤백 후 확인
- [ ] 매니저가 quote 조회 가능 (유지 필요 시)
- [ ] quote 조회 성능 < 1초 (인덱스 작동 확인)
- [ ] 사용자 프로필 접근 가능
- [ ] Advisor "no_primary_key" 개수 증가 (롤백 전 10 → 롤백 후 14 등)

### 부분 복구 후 확인
- [ ] 해당 정책이 작동하는지 테스트 계정으로 검증
- [ ] 관련 쿼리 성능 모니터링 (EXPLAIN ANALYZE 실행)

---

## 백업 테이블 유지 관리

**보존 기간**: 최소 **3개월** (예: 2026.07.26까지)

```sql
-- 3개월 후 백업 테이블 삭제 (선택 사항)
DROP TABLE IF EXISTS public._backup_pg_policies_20260426;
DROP TABLE IF EXISTS public._backup_pg_indexes_20260426;
DROP TABLE IF EXISTS public._archive_reservation_no_quote_backup_20260426;
DROP TABLE IF EXISTS public._archive_reservation_no_quote_airport_backup_20260426;
DROP TABLE IF EXISTS public._archive_reservation_no_quote_cruise_backup_20260426;
DROP TABLE IF EXISTS public._archive_reservation_no_quote_tour_backup_20260426;
```

---

## 롤백 전 지원팀 확인사항

1. **현재 오류 로그 수집** (Supabase 대시보드 → Logs)
   - Query errors
   - RLS policy violations
   - Index performance issues

2. **영향 범위 파악**
   - 사용자 수 / 기능
   - 오류 시작 시간

3. **우선 순위 결정**
   - 긴급 부분 복구 vs 전체 롤백

---

## 지원 연락처

- Supabase 문제: https://supabase.com/docs/guides/database/troubleshooting
- RLS 정책 디버깅: `SET ROLE authenticated;` 후 쿼리 실행
- 성능 문제: EXPLAIN ANALYZE 결과 첨부 후 보고
