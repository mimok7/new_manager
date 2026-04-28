-- ============================================================
-- 035-upgrade-rent-price-to-rentcar-price.sql
-- 목적:
-- 1) rentcar_price를 기준 테이블로 유지
-- 2) rent_price 데이터를 rentcar_price로 이관
-- 3) rentcar_price에 cruise 컬럼 추가 및 기본값 반영
-- 4) 이관 완료 후 rent_price 테이블 삭제
-- ============================================================

BEGIN;

-- 1) 기준 테이블 보강 (크루즈 컬럼)
ALTER TABLE IF EXISTS rentcar_price
  ADD COLUMN IF NOT EXISTS cruise TEXT;

UPDATE rentcar_price
SET cruise = COALESCE(NULLIF(cruise, ''), '공통')
WHERE cruise IS NULL OR cruise = '';

-- 2) 기존 rent_price 데이터 이관
-- 매핑 규칙:
-- - rent_code            -> rent_code
-- - rent_category        -> category, car_category_code
-- - rent_type            -> vehicle_type
-- - rent_route           -> route
-- - route_from/to        -> 고정값 (하노이/하롱베이)
-- - way_type             -> 기본값 '편도'
-- - cruise               -> '공통'
INSERT INTO rentcar_price (
  rent_code,
  category,
  car_category_code,
  vehicle_type,
  route,
  route_from,
  route_to,
  way_type,
  price,
  rental_type,
  year,
  description,
  is_active,
  cruise
)
SELECT
  rp.rent_code,
  COALESCE(NULLIF(rp.rent_category, ''), '공통') AS category,
  COALESCE(NULLIF(rp.rent_category, ''), '공통') AS car_category_code,
  COALESCE(NULLIF(rp.rent_type, ''), '기본차량') AS vehicle_type,
  COALESCE(NULLIF(rp.rent_route, ''), '하노이 - 하롱베이') AS route,
  '하노이' AS route_from,
  '하롱베이' AS route_to,
  '편도' AS way_type,
  COALESCE(rp.price::INTEGER, 0) AS price,
  '단독대여' AS rental_type,
  2026 AS year,
  'migrated from rent_price' AS description,
  TRUE AS is_active,
  '공통' AS cruise
FROM rent_price rp
ON CONFLICT (rent_code) DO UPDATE
SET
  category = COALESCE(EXCLUDED.category, rentcar_price.category),
  car_category_code = COALESCE(EXCLUDED.car_category_code, rentcar_price.car_category_code),
  vehicle_type = COALESCE(EXCLUDED.vehicle_type, rentcar_price.vehicle_type),
  route = COALESCE(EXCLUDED.route, rentcar_price.route),
  route_from = COALESCE(rentcar_price.route_from, EXCLUDED.route_from),
  route_to = COALESCE(rentcar_price.route_to, EXCLUDED.route_to),
  way_type = COALESCE(rentcar_price.way_type, EXCLUDED.way_type),
  price = COALESCE(EXCLUDED.price, rentcar_price.price),
  cruise = COALESCE(rentcar_price.cruise, EXCLUDED.cruise),
  updated_at = NOW();

-- 3) 구 테이블 제거
DROP TABLE IF EXISTS rent_price;

COMMIT;

-- 4) 검증 쿼리
SELECT 'rentcar_price_count' AS check_name, COUNT(*)::TEXT AS value FROM rentcar_price
UNION ALL
SELECT 'rentcar_price_with_cruise', COUNT(*)::TEXT FROM rentcar_price WHERE cruise IS NOT NULL
UNION ALL
SELECT 'rent_price_exists',
       CASE WHEN EXISTS (
         SELECT 1 FROM information_schema.tables
         WHERE table_schema = 'public' AND table_name = 'rent_price'
       ) THEN 'YES' ELSE 'NO' END;
