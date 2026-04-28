-- ============================================================================
-- 호텔 3: WINDOM GARDEN LEGEND HALONG - 데이터 INSERT (2026)
-- ============================================================================
-- 실행 순서: 001-hotel-system-v3-tables-2026.sql 이후 실행
-- 호텔별 독립 실행 가능 (다른 호텔과 무관)
-- 특이사항: 시즌/요일 가격 구분 없음 (단일가), 매우 가성비 호텔

BEGIN;

-- ============================================================================
-- 1. 호텔 기본 정보 INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location, star_rating,
  check_in_time, check_out_time, special_features, active_year,
  currency, contact_info
) VALUES (
  'WINDOM',
  'Windom Garden Legend Halong',
  'HOTEL'::hotel_product_type,
  '하롱 국제 크루즈 선착장 앞 (도보 5분)',
  4,
  '14:00:00',
  '11:00:00',
  '["2024년 8월 개관", "가성비 호텔", "수영장", "피트니스센터", "The Greenery Restaurant"]'::jsonb,
  ARRAY[2026],
  'VND',
  '{"note": "원화/달러만 가능, 카드결제 3.1% 수수료"}'::jsonb
) ON CONFLICT (hotel_code) DO NOTHING;

-- ============================================================================
-- 2. 객실 타입 INSERT
-- ============================================================================

WITH windom_hotel AS (
  SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM'
)
INSERT INTO room_type (
  hotel_id, room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
)
SELECT
  wh.hotel_id,
  room_data.room_code,
  room_data.room_name,
  room_data.room_category,
  room_data.area_sqm,
  room_data.bed_config,
  room_data.occupancy_base,
  room_data.occupancy_max,
  room_data.amenities,
  room_data.view_options,
  room_data.extra_bed_allowed,
  room_data.max_children
FROM windom_hotel wh
CROSS JOIN (
  VALUES
  (
    'SUPERIOR_GARDEN',
    '슈페리어 가든 (Double/Twin)',
    'STANDARD_ROOM'::room_category_type,
    33,
    'Double 또는 Twin',
    2,
    2,
    '["에어컨", "WiFi", "조식 포함"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0,
    0
  ),
  (
    'SUPERIOR_GARDEN_TRIPLE',
    '슈페리어 가든 트리플',
    'STANDARD_ROOM'::room_category_type,
    33,
    'Triple Beds',
    3,
    3,
    '["에어컨", "WiFi", "조식 포함"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0,
    0
  ),
  (
    'DELUXE_OCEAN',
    '디럭스 오션 (Double/Twin)',
    'STANDARD_ROOM'::room_category_type,
    34,
    'Double 또는 Twin',
    2,
    3,
    '["에어컨", "WiFi", "오션뷰", "조식 포함"]'::jsonb,
    ARRAY['OCEAN_VIEW'],
    1,
    1
  ),
  (
    'PREMIER_SUITE',
    '프리미어 스위트 (Double/Twin)',
    'SUITE'::room_category_type,
    71,
    'Double 또는 Twin',
    2,
    4,
    '["에어컨", "WiFi", "거실", "넓은 객실", "조식 포함"]'::jsonb,
    ARRAY['OCEAN_VIEW', 'CITY_VIEW'],
    2,
    2
  )
) AS room_data(
  room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
);

-- ============================================================================
-- 3. 가격 데이터 INSERT (2026년, 단일가 - 시즌/요일 구분 없음)
-- ============================================================================
-- 특이: 이 호텔은 시즌별/요일별 가격 차이가 없음 (단일가)
-- day_of_week = 'ANY', 전체 연도 한 구간으로 처리

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- SUPERIOR_GARDEN: 1,400,000 VND (엑스트라베드 불가)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM') AND room_code = 'SUPERIOR_GARDEN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1400000, 0, '6세 이상 엑스트라베드 준비중, 엑스트라베드 불가',
  true, '조식 포함 (The Greenery Restaurant, 06:00-10:00)', '47실 보유 (D12/T35), 취소: 체크인 15일전까지', 2026
UNION ALL
-- SUPERIOR_GARDEN_TRIPLE: 2,000,000 VND (엑스트라베드 불가)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM') AND room_code = 'SUPERIOR_GARDEN_TRIPLE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  2000000, 0, '6세 이상 엑스트라베드 준비중, 엑스트라베드 불가',
  true, '조식 포함 (The Greenery Restaurant, 06:00-10:00)', '13실 보유, 취소: 체크인 15일전까지', 2026
UNION ALL
-- DELUXE_OCEAN: 1,700,000 VND (엑스트라베드 800,000)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM') AND room_code = 'DELUXE_OCEAN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1700000, 800000, '6세 이상 엑스트라베드 가능 800,000 VND',
  true, '조식 포함 (The Greenery Restaurant, 06:00-10:00)', '99실 보유 (D23/T76), 취소: 체크인 15일전까지', 2026
UNION ALL
-- PREMIER_SUITE: 4,500,000 VND (엑스트라베드 800,000)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM') AND room_code = 'PREMIER_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  4500000, 800000, '6세 이상 엑스트라베드 가능 800,000 VND',
  true, '조식 포함 (The Greenery Restaurant, 06:00-10:00)', '3실 보유 (매우 제한), 취소: 체크인 15일전까지', 2026;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT * FROM hotel_info WHERE hotel_code = 'WINDOM';
-- SELECT * FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM');
-- SELECT * FROM pricing_model WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'WINDOM');
