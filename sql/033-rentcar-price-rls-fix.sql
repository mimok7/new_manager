-- ============================================================
-- 033-rentcar-price-rls-fix.sql
-- rentcar_price 테이블 RLS 정책 추가
-- 경로 데이터가 표시되지 않는 문제 해결
-- ============================================================

-- RLS 활성화
ALTER TABLE rentcar_price ENABLE ROW LEVEL SECURITY;

-- 기존 정책 삭제 (중복 방지)
DROP POLICY IF EXISTS "rentcar_price_select_authenticated" ON rentcar_price;
DROP POLICY IF EXISTS "rentcar_price_select_anon" ON rentcar_price;

-- 인증된 사용자 전체 조회 허용
CREATE POLICY "rentcar_price_select_authenticated"
  ON rentcar_price FOR SELECT
  TO authenticated
  USING (true);

-- 비인증 사용자 (anon) 활성 데이터 조회 허용
CREATE POLICY "rentcar_price_select_anon"
  ON rentcar_price FOR SELECT
  TO anon
  USING (is_active = true);

-- ============================================================
-- 검증 쿼리
-- ============================================================
/*
-- 데이터 확인 (031 SQL이 실행되었다면 way_type 컬럼이 존재해야 함)
SELECT way_type, COUNT(*) AS cnt
FROM rentcar_price
GROUP BY way_type
ORDER BY way_type;

-- 편도 경로 목록 확인
SELECT DISTINCT route
FROM rentcar_price
WHERE way_type = '편도'
ORDER BY route;
*/
