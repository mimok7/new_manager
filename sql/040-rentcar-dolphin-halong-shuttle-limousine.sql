-- ============================================================
-- 040-rentcar-dolphin-halong-shuttle-limousine.sql
-- 돌핀 하롱 크루즈 크루즈 셔틀 리무진 렌트카 가격 추가
-- ============================================================

-- ────────────────────────────────────────────
-- 돌핀 하롱 크루즈 크루즈 셔틀 리무진 추가
-- ────────────────────────────────────────────

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
  cruise,
  memo,
  description,
  is_active
) VALUES
(
  'CRUISE_SHUTTLE_DOLPHIN_HALONG',     -- rent_code: 크루즈 셔틀 리무진 돌핀 하롱 식별자
  '돌핀 하롱 크루즈',                    -- category: 카테고리명
  '크루즈',                              -- car_category_code: 차량 카테고리 코드
  '크루즈 셔틀 리무진',                   -- vehicle_type: 차량명
  '돌핀 하롱 크루즈 이동',               -- route: 구간명
  '하노이',                              -- route_from: 출발지
  '하롱베이',                            -- route_to: 목적지
  '당일왕복',                            -- way_type: 편도/당일왕복 등
  750000,                               -- price: 가격 (VND)
  11,                                   -- capacity: 최대 탑승인원 (11인승)
  NULL,                                 -- duration_hours: 이용 시간
  '단독대여',                            -- rental_type: 렌탈 타입
  2026,                                 -- year: 연도
  '돌핀 하롱 크루즈',                    -- cruise: 크루즈명
  '크루즈 셔틀 리무진',                  -- memo: 메모
  '11인승 리무진 | 돌핀 하롱 크루즈 운영 차량',  -- description: 설명
  true                                  -- is_active: 활성화 여부
);

-- ────────────────────────────────────────────
-- 검증 쿼리
-- ────────────────────────────────────────────

SELECT '✅ 돌핀 하롱 크루즈 크루즈 셔틀 리무진 렌트카 추가 완료' AS 결과;

SELECT 
  rent_code,
  category,
  vehicle_type,
  price,
  capacity,
  description
FROM rentcar_price
WHERE category = '돌핀 하롱 크루즈'
  AND vehicle_type = '크루즈 셔틀 리무진'
  AND year = 2026
ORDER BY rent_code;

SELECT
  COUNT(*) as 돌핀하롱크루즈_데이터수,
  MIN(price) as 최저가격,
  MAX(price) as 최고가격,
  AVG(price) as 평균가격
FROM rentcar_price
WHERE category = '돌핀 하롱 크루즈'
  AND year = 2026;
