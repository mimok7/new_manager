-- reservation 테이블에 가격 상세 내역 컬럼 추가

-- 1. 가격 상세 내역 JSONB 컬럼 추가
ALTER TABLE reservation 
ADD COLUMN IF NOT EXISTS price_breakdown JSONB;

-- 2. 컬럼 주석 추가
COMMENT ON COLUMN reservation.price_breakdown IS '가격 상세 내역 (성인/아동/유아 단가 및 인원수, 총액 등)';

-- 3. 예시 데이터 구조:
-- {
--   "adult": {"count": 2, "unit_price": 8900000, "total": 17800000},
--   "child_extra_bed": {"count": 1, "unit_price": 6900000, "total": 6900000},
--   "child_no_extra_bed": {"count": 0, "unit_price": 5850000, "total": 0},
--   "infant_free": {"count": 0, "unit_price": 0, "total": 0},
--   "infant_tour": {"count": 1, "unit_price": 900000, "total": 900000},
--   "infant_extra_bed": {"count": 0, "unit_price": 4200000, "total": 0},
--   "infant_seat": {"count": 0, "unit_price": 800000, "total": 0},
--   "grand_total": 25600000
-- }

-- 4. 인덱스 추가 (JSONB 검색 성능 향상)
CREATE INDEX IF NOT EXISTS idx_reservation_price_breakdown 
ON reservation USING gin(price_breakdown);
