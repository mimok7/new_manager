-- ============================================================================
-- 호텔 2: ALACARTE HALONG HOTEL - 데이터 INSERT (2026)
-- ============================================================================
-- 실행 순서: 001-hotel-system-v3-tables-2026.sql 이후 실행
-- 호텔별 독립 실행 가능 (다른 호텔과 무관)

BEGIN;

-- ============================================================================
-- 1. 호텔 기본 정보 INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location, star_rating,
  check_in_time, check_out_time, special_features, active_year,
  currency, contact_info
) VALUES (
  'ALACARTE',
  'Alacarte Halong Hotel',
  'HOTEL'::hotel_product_type,
  '하롱베이 시내',
  4,
  '14:00:00',
  '11:00:00',
  '["모던 디자인", "로컬 음식점 근처", "도보 접근"]'::jsonb,
  ARRAY[2026],
  'VND',
  '{"phone": "+84-033-3891-XXX"}'::jsonb
);

-- ============================================================================
-- 2. 객실 타입 INSERT (고정 구조 - 복합 쿼리)
-- ============================================================================

WITH alacarte_hotel AS (
  SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'
)
INSERT INTO room_type (
  hotel_id, room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
)
SELECT
  ah.hotel_id,
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
FROM alacarte_hotel ah
CROSS JOIN (
  VALUES
  (
    'DELUXE_KING',
    'Deluxe King Room',
    'STANDARD_ROOM'::room_category_type,
    32,
    'King Bed',
    2,
    3,
    '["발코니", "에어컨"]'::jsonb,
    ARRAY['CITY_VIEW'],
    1,
    1
  ),
  (
    'DELUXE_TWIN',
    'Deluxe Twin Room',
    'STANDARD_ROOM'::room_category_type,
    32,
    'Twin Beds',
    2,
    3,
    '["발코니", "에어컨"]'::jsonb,
    ARRAY['CITY_VIEW'],
    1,
    1
  ),
  (
    'SUPERIOR_KING',
    'Superior King Room',
    'STANDARD_ROOM'::room_category_type,
    40,
    'King Bed',
    2,
    4,
    '["넓은 발코니", "업그레이드"]'::jsonb,
    ARRAY['CITY_VIEW'],
    1,
    1
  ),
  (
    'JUNIOR_SUITE',
    'Junior Suite',
    'SUITE'::room_category_type,
    48,
    'King Bed',
    2,
    4,
    '["거실", "발코니", "고급 편의시설"]'::jsonb,
    ARRAY['CITY_VIEW'],
    2,
    2
  )
) AS room_data(
  room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
);


-- ============================================================================
-- 3. 가격 데이터 INSERT (2026년)
-- ============================================================================

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW SEASON - 평일',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKDAY'::day_of_week_type,
  1800000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW SEASON - 주말',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKEND'::day_of_week_type,
  2100000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH SEASON - 평일',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKDAY'::day_of_week_type,
  2100000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH SEASON - 주말',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKEND'::day_of_week_type,
  2600000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  1800000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  2100000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW SEASON - 평일',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKDAY'::day_of_week_type,
  1800000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW SEASON - 주말',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKEND'::day_of_week_type,
  2100000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH SEASON - 평일',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKDAY'::day_of_week_type,
  2100000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH SEASON - 주말',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKEND'::day_of_week_type,
  2600000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  1800000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  2100000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW SEASON - 평일',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKDAY'::day_of_week_type,
  2200000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW SEASON - 주말',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKEND'::day_of_week_type,
  2700000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH SEASON - 평일',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKDAY'::day_of_week_type,
  2700000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH SEASON - 주말',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKEND'::day_of_week_type,
  3200000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  2200000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  2700000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'JUNIOR_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW SEASON - 평일',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKDAY'::day_of_week_type,
  2600000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'JUNIOR_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW SEASON - 주말',
  '2026-01-01'::date, '2026-05-30'::date, 'WEEKEND'::day_of_week_type,
  3200000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'JUNIOR_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH SEASON - 평일',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKDAY'::day_of_week_type,
  3200000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'JUNIOR_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH SEASON - 주말',
  '2026-05-31'::date, '2026-08-16'::date, 'WEEKEND'::day_of_week_type,
  4000000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'JUNIOR_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  2600000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE') AND room_code = 'JUNIOR_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  3200000, 500000, '6세 이상 성인가, 6세 미만 무료',
  true, 'AC, TV, WiFi', '1박 기준', 2026;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================

-- SELECT * FROM hotel_info WHERE hotel_code = 'ALACARTE';
-- SELECT * FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE');
-- SELECT COUNT(*) FROM pricing_model WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'ALACARTE');
