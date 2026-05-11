-- Phase 10: 투어 가격 테이블 성인/아동 가격 분리 (2026-05-11)
-- 목적: tour_pricing 테이블에 adult_price, child_price 컬럼 추가로 성인/아동 가격 구분

-- Step 1: adult_price, child_price 컬럼 추가
-- (기존 price_per_person은 유지, 새 컬럼은 NULL 기본값)
ALTER TABLE tour_pricing 
ADD COLUMN IF NOT EXISTS adult_price numeric NULL DEFAULT NULL,
ADD COLUMN IF NOT EXISTS child_price numeric NULL DEFAULT NULL;

-- Step 2: 코멘트 추가 (데이터 딕셔너리)
COMMENT ON COLUMN tour_pricing.adult_price IS '성인 1인당 가격 (NULL = price_per_person 사용)';
COMMENT ON COLUMN tour_pricing.child_price IS '아동 1인당 가격 (NULL = price_per_person 사용)';

-- Step 3: 기존 price_per_person 데이터로 초기화 (마이그레이션)
-- 현재 price_per_person 값이 있으면 adult_price/child_price에 동일하게 설정
UPDATE tour_pricing 
SET 
  adult_price = COALESCE(adult_price, price_per_person),
  child_price = COALESCE(child_price, CASE 
    WHEN price_per_person > 0 THEN price_per_person * 0.7  -- 아동: 성인 70% (기본값)
    ELSE 0 
  END)
WHERE (adult_price IS NULL OR child_price IS NULL) 
  AND price_per_person IS NOT NULL;

-- Step 4: 인덱스 추가 (조회 성능)
CREATE INDEX IF NOT EXISTS idx_tour_pricing_adult_price 
  ON tour_pricing(pricing_id, adult_price, child_price);

-- Step 5: 검증 쿼리 (실행 확인용, 프로덕션에서는 제거)
-- 성공하면 아래 결과 확인:
-- SELECT COUNT(*) as "투어 가격 레코드 수",
--        COUNT(adult_price) as "adult_price 채워진 수",
--        COUNT(child_price) as "child_price 채워진 수"
-- FROM tour_pricing;
