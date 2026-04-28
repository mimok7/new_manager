-- ============================================================================
-- 호텔 1: THE YACHT HOTEL BY DC - 데이터 INSERT (2026)
-- ============================================================================
-- 실행 순서: 001-hotel-system-v3-tables-2026.sql 이후 실행
-- 호텔별로 독립적으로 실행 가능 (다른 호텔 영향 없음)
-- 업데이트: 이 파일만 수정하여 재실행 가능

BEGIN;

-- ============================================================================
-- 1. 호텔 기본 정보 INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location, star_rating,
  check_in_time, check_out_time, special_features, active_year,
  currency, contact_info
) VALUES (
  'YACHT',
  'The Yacht Hotel by DC',
  'HOTEL'::hotel_product_type,
  '하롱 국제 크루즈 선착장 앞',
  4,
  '14:00:00',
  '11:00:00',
  '["크루즈 투어 연계", "하롱베이 뷰", "피시 스파", "온천탕"]'::jsonb,
  ARRAY[2026],
  'VND',
  '{"phone": "+84-033-3891-888", "website": "yachthotel.vn"}'::jsonb
);

-- 방금 삽입된 hotel_id를 변수에 저장 (다음 INSERT를 위해 필요)
-- NOTA: 실제로는 위에서 RETURNING으로 id를 가져와야 하지만, 
-- 배치 실행 시 간단하게 hotel_code로 조회

-- ============================================================================
-- 2. 객실 타입 INSERT (고정 구조 - 복합 쿼리)
-- ============================================================================

WITH yacht_hotel AS (
  SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'
)
INSERT INTO room_type (
  hotel_id, room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
)
SELECT
  yh.hotel_id,
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
FROM yacht_hotel yh
CROSS JOIN (
  VALUES
  (
    'DELUXE_KING',
    'Deluxe King - 하롱베이 뷰',
    'STANDARD_ROOM'::room_category_type,
    33,
    'King Bed',
    2,
    3,
    '["발코니", "하롱베이 뷰", "피시 스파", "욕조"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1,
    1
  ),
  (
    'DELUXE_TWIN',
    'Deluxe Twin - 하롱베이 뷰',
    'STANDARD_ROOM'::room_category_type,
    33,
    'Twin Beds',
    2,
    3,
    '["발코니", "하롱베이 뷰", "피시 스파", "욕조"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1,
    1
  ),
  (
    'SUPERIOR_KING',
    'Superior King - 도시 뷰',
    'STANDARD_ROOM'::room_category_type,
    39,
    'King Bed',
    2,
    3,
    '["발코니", "넓은 객실", "피시 스파"]'::jsonb,
    ARRAY['CITY_VIEW'],
    1,
    1
  ),
  (
    'SUITE_KING',
    'Suite Room - 스위트',
    'SUITE'::room_category_type,
    45,
    'King Bed',
    2,
    4,
    '["발코니", "거실", "욕조", "고급 스파"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    2,
    2
  )
) AS room_data(
  room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
);

-- ============================================================================
-- 3. 가격 데이터 INSERT (2026년, 모든 시즌)
-- ============================================================================

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)

SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY',
  'LOW SEASON - 평일',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKDAY'::day_of_week_type,
  1600000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND',
  'LOW SEASON - 주말',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKEND'::day_of_week_type,
  1900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY',
  'HIGH SEASON - 평일',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKDAY'::day_of_week_type,
  1900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND',
  'HIGH SEASON - 주말',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKEND'::day_of_week_type,
  2310000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG',
  'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKDAY'::day_of_week_type,
  1600000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG',
  'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKEND'::day_of_week_type,
  1900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
-- DELUXE_TWIN
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY',
  'LOW SEASON - 평일',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKDAY'::day_of_week_type,
  1600000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND',
  'LOW SEASON - 주말',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKEND'::day_of_week_type,
  1900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY',
  'HIGH SEASON - 평일',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKDAY'::day_of_week_type,
  1900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND',
  'HIGH SEASON - 주말',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKEND'::day_of_week_type,
  2310000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG',
  'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKDAY'::day_of_week_type,
  1600000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG',
  'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKEND'::day_of_week_type,
  1900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
-- SUPERIOR_KING
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY',
  'LOW SEASON - 평일',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKDAY'::day_of_week_type,
  2000000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND',
  'LOW SEASON - 주말',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKEND'::day_of_week_type,
  2400000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY',
  'HIGH SEASON - 평일',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKDAY'::day_of_week_type,
  2400000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND',
  'HIGH SEASON - 주말',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKEND'::day_of_week_type,
  2900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG',
  'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKDAY'::day_of_week_type,
  2000000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUPERIOR_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG',
  'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKEND'::day_of_week_type,
  2400000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
-- SUITE_KING
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUITE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY',
  'LOW SEASON - 평일',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKDAY'::day_of_week_type,
  3200000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUITE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND',
  'LOW SEASON - 주말',
  '2026-01-01'::date,
  '2026-05-30'::date,
  'WEEKEND'::day_of_week_type,
  3900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUITE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY',
  'HIGH SEASON - 평일',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKDAY'::day_of_week_type,
  3900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUITE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND',
  'HIGH SEASON - 주말',
  '2026-05-31'::date,
  '2026-08-16'::date,
  'WEEKEND'::day_of_week_type,
  4700000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUITE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG',
  'LOW SEASON - 평일 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKDAY'::day_of_week_type,
  3200000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026
UNION ALL
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT') AND room_code = 'SUITE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG',
  'LOW SEASON - 주말 (8월 이후)',
  '2026-08-17'::date,
  '2026-12-31'::date,
  'WEEKEND'::day_of_week_type,
  3900000,
  500000,
  '6세 이상 성인가, 6세 미만 무료',
  true,
  'AC, TV, WiFi',
  '1박 기준',
  2026;

-- ============================================================================
-- 4. 공휴일 추가요금 INSERT (2026)
-- ============================================================================

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  NULL::uuid,
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_LABOR',
  '노동절 추가요금',
  '2026-04-30'::date,
  '2026-05-03'::date,
  'ANY'::day_of_week_type,
  1600000,
  500000,
  '기본가 + 500K',
  true,
  'AC, TV, WiFi',
  '2박 최소',
  2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  NULL::uuid,
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_INDEPENDENCE',
  '독립기념일 추가요금',
  '2026-08-30'::date,
  '2026-09-02'::date,
  'ANY'::day_of_week_type,
  2400000,
  500000,
  '기본가 + 500K',
  true,
  'AC, TV, WiFi',
  '2박 최소',
  2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT'),
  NULL::uuid,
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_NEWYEAR',
  '연말/새해 추가요금',
  '2026-12-31'::date,
  '2027-01-01'::date,
  'ANY'::day_of_week_type,
  4700000,
  1100000,
  '기본가 + 1.1M',
  true,
  'AC, TV, WiFi',
  '1박 최소',
  2026;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================

-- 호텔 정보 확인
-- SELECT * FROM hotel_info WHERE hotel_code = 'YACHT';

-- 객실 정보 확인
-- SELECT * FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT');

-- 2026년 모든 요금 확인
-- SELECT season_name, date_range_start, date_range_end, day_of_week, base_price, surcharge_holiday
-- FROM pricing_model WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT')
-- ORDER BY date_range_start, day_of_week;

-- 삽입된 데이터 개수
-- SELECT COUNT(*) FROM pricing_model WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YACHT');
