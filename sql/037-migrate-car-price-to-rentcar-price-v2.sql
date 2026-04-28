-- ============================================================
-- 037-migrate-car-price-to-rentcar-price-v2.sql
-- 목적:
-- 1) rentcar_price를 기준 테이블로 유지
-- 2) rentcar_price에 cruise, memo 컬럼 추가
-- 3) 기존 rentcar_price 데이터는 memo='렌트카', cruise='공통'으로 정규화
-- 4) car_price 데이터를 rentcar_price 형식으로 이관
--    - 경로: 하노이 - 하롱베이 고정
--    - 왕복: 당일왕복 + 다른날왕복 2건으로 분기 저장
--    - rental_type: 기본 단독대여, 차량명/카테고리에 '셔틀' 포함 시 공유차량
--    - memo: '크루즈'
-- 5) 중복 데이터 제거(차량타입/구간/방식/크루즈/렌탈타입 기준)
-- ============================================================

BEGIN;

-- 0) 사전 점검
-- car_price가 없으면 중단
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'car_price'
  ) THEN
    RAISE EXCEPTION 'car_price 테이블이 존재하지 않습니다.';
  END IF;
END $$;

-- 1) rentcar_price 기준 스키마 보강
ALTER TABLE IF EXISTS rentcar_price
  ADD COLUMN IF NOT EXISTS cruise TEXT;

ALTER TABLE IF EXISTS rentcar_price
  ADD COLUMN IF NOT EXISTS memo TEXT;

-- category / car_category_code를 계속 써야 하는 코드가 있을 수 있어 삭제/rename은 하지 않음
-- 대신 요구사항에 맞춰 의미를 정규화한다.

-- 2) 기존 rentcar_price 데이터 정규화
UPDATE rentcar_price
SET
  cruise = COALESCE(NULLIF(cruise, ''), '공통'),
  memo = COALESCE(NULLIF(memo, ''), '렌트카'),
  rental_type = COALESCE(NULLIF(rental_type, ''), '단독대여'),
  route = COALESCE(NULLIF(route, ''), '하노이 - 하롱베이'),
  route_from = COALESCE(NULLIF(route_from, ''), '하노이'),
  route_to = COALESCE(NULLIF(route_to, ''), '하롱베이'),
  category = COALESCE(NULLIF(cruise, ''), '공통'),
  car_category_code = COALESCE(NULLIF(memo, ''), '렌트카')
WHERE TRUE;

-- 3) car_price -> rentcar_price 이관용 데이터 정규화/분기
WITH src AS (
  SELECT
    cp.car_code,
    COALESCE(NULLIF(BTRIM(cp.cruise), ''), '공통') AS cruise_norm,
    COALESCE(NULLIF(BTRIM(cp.car_type), ''), '기본차량') AS vehicle_type_norm,
    COALESCE(NULLIF(BTRIM(cp.schedule), ''), '편도') AS schedule_norm,
    COALESCE(cp.price, 0)::INTEGER AS price_norm,
    CASE
      WHEN COALESCE(cp.car_type, '') ILIKE '%셔틀%'
        OR COALESCE(cp.car_category, '') ILIKE '%셔틀%'
      THEN '공유차량'
      ELSE '단독대여'
    END AS rental_type_norm
  FROM car_price cp
),
expanded AS (
  -- 편도
  SELECT *, '편도'::TEXT AS way_type_norm
  FROM src
  WHERE schedule_norm IN ('편도', 'oneway', 'ONEWAY')

  UNION ALL

  -- 왕복이면 반드시 2건(당일왕복, 다른날왕복) 생성
  SELECT *, '당일왕복'::TEXT AS way_type_norm
  FROM src
  WHERE schedule_norm IN ('왕복', 'roundtrip', 'ROUNDTRIP', '왕복(당일/다른날)')

  UNION ALL

  SELECT *, '다른날왕복'::TEXT AS way_type_norm
  FROM src
  WHERE schedule_norm IN ('왕복', 'roundtrip', 'ROUNDTRIP', '왕복(당일/다른날)')

  UNION ALL

  -- 이미 상세 방식이 들어온 경우 그대로 이관
  SELECT *, '당일왕복'::TEXT AS way_type_norm
  FROM src
  WHERE schedule_norm = '당일왕복'

  UNION ALL

  SELECT *, '다른날왕복'::TEXT AS way_type_norm
  FROM src
  WHERE schedule_norm = '다른날왕복'
),
prepared AS (
  SELECT
    -- rent_code 유일성 확보
    ('CRUISE_' || SUBSTRING(MD5(CONCAT_WS('|',
      COALESCE(car_code, ''),
      cruise_norm,
      vehicle_type_norm,
      way_type_norm,
      rental_type_norm,
      '하노이',
      '하롱베이'
    )) FROM 1 FOR 20)) AS rent_code,
    cruise_norm AS cruise,
    '크루즈'::TEXT AS memo,
    cruise_norm AS category,
    '크루즈'::TEXT AS car_category_code,
    vehicle_type_norm AS vehicle_type,
    '하노이 - 하롱베이'::TEXT AS route,
    '하노이'::TEXT AS route_from,
    '하롱베이'::TEXT AS route_to,
    way_type_norm AS way_type,
    price_norm AS price,
    NULL::INTEGER AS capacity,
    NULL::INTEGER AS duration_hours,
    rental_type_norm AS rental_type,
    2026 AS year,
    CONCAT('migrated from car_price:', COALESCE(car_code, ''), ', schedule:', schedule_norm) AS description,
    TRUE AS is_active
  FROM expanded
),
-- 완전중복 제거(동일 조건에서는 높은 price 우선)
dedup AS (
  SELECT DISTINCT ON (
    vehicle_type,
    route_from,
    route_to,
    way_type,
    cruise,
    rental_type
  )
    *
  FROM prepared
  ORDER BY
    vehicle_type,
    route_from,
    route_to,
    way_type,
    cruise,
    rental_type,
    price DESC,
    rent_code
)
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
  capacity,
  duration_hours,
  rental_type,
  year,
  description,
  is_active,
  cruise,
  memo
)
SELECT
  d.rent_code,
  d.category,
  d.car_category_code,
  d.vehicle_type,
  d.route,
  d.route_from,
  d.route_to,
  d.way_type,
  d.price,
  d.capacity,
  d.duration_hours,
  d.rental_type,
  d.year,
  d.description,
  d.is_active,
  d.cruise,
  d.memo
FROM dedup d
WHERE NOT EXISTS (
  SELECT 1
  FROM rentcar_price r
  WHERE COALESCE(r.vehicle_type, '') = COALESCE(d.vehicle_type, '')
    AND COALESCE(r.route_from, '') = COALESCE(d.route_from, '')
    AND COALESCE(r.route_to, '') = COALESCE(d.route_to, '')
    AND COALESCE(r.way_type, '') = COALESCE(d.way_type, '')
    AND COALESCE(r.cruise, '공통') = COALESCE(d.cruise, '공통')
    AND COALESCE(r.rental_type, '단독대여') = COALESCE(d.rental_type, '단독대여')
);

-- 4) 기존 데이터 포함 전체 중복 정리
WITH ranked AS (
  SELECT
    id,
    ROW_NUMBER() OVER (
      PARTITION BY
        COALESCE(vehicle_type, ''),
        COALESCE(route_from, ''),
        COALESCE(route_to, ''),
        COALESCE(way_type, ''),
        COALESCE(cruise, '공통'),
        COALESCE(rental_type, '단독대여')
      ORDER BY updated_at DESC NULLS LAST, created_at DESC NULLS LAST, id DESC
    ) AS rn
  FROM rentcar_price
)
DELETE FROM rentcar_price t
USING ranked r
WHERE t.id = r.id
  AND r.rn > 1;

COMMIT;

-- ============================================================
-- 검증 쿼리
-- ============================================================

-- A. memo 구분 확인 (렌트카/크루즈)
SELECT memo, COUNT(*) AS cnt
FROM rentcar_price
GROUP BY memo
ORDER BY memo;

-- B. cruise 값 확인
SELECT cruise, COUNT(*) AS cnt
FROM rentcar_price
GROUP BY cruise
ORDER BY cnt DESC, cruise;

-- C. 차량 타입 중복 여부 확인 (중복이면 1보다 큼)
SELECT
  vehicle_type,
  route_from,
  route_to,
  way_type,
  cruise,
  rental_type,
  COUNT(*) AS dup_cnt
FROM rentcar_price
GROUP BY
  vehicle_type,
  route_from,
  route_to,
  way_type,
  cruise,
  rental_type
HAVING COUNT(*) > 1
ORDER BY dup_cnt DESC, vehicle_type;

-- D. 왕복 분기 확인
SELECT way_type, COUNT(*) AS cnt
FROM rentcar_price
WHERE memo = '크루즈'
GROUP BY way_type
ORDER BY way_type;
