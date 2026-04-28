-- ============================================================================
-- 호텔 4: HYATT PLACE HA LONG - 데이터 INSERT (2026)
-- ============================================================================
-- 실행 순서: 001-hotel-system-v3-tables-2026.sql 이후 실행
-- 호텔별 독립 실행 가능 (다른 호텔과 무관)
-- 특이사항: LOW/HIGH 동일가격, HOLIDAY만 +500K

BEGIN;

-- ============================================================================
-- 1. 호텔 기본 정보 INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location, star_rating,
  check_in_time, check_out_time, special_features, active_year,
  currency, contact_info
) VALUES (
  'HYATT',
  'Hyatt Place Ha Long',
  'HOTEL'::hotel_product_type,
  '하롱 바이짜이짜이 지역, 크루즈 선착장 차량 10분',
  4,
  '14:00:00',
  '12:00:00',
  '["글로벌 Hyatt 브랜드", "실제 5성급 시설", "스마트룸", "도보 이동 가능"]'::jsonb,
  ARRAY[2026],
  'VND',
  '{"brand": "Hyatt", "note": "공식 4성 (실제 5성급 코드)"}'::jsonb
) ON CONFLICT (hotel_code) DO NOTHING;

-- ============================================================================
-- 2. 객실 타입 INSERT (6종 - 가장 많은 객실 타입)
-- ============================================================================

WITH hyatt_hotel AS (
  SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'
)
INSERT INTO room_type (
  hotel_id, room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
)
SELECT
  hh.hotel_id,
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
FROM hyatt_hotel hh
CROSS JOIN (
  VALUES
  (
    'STANDARD',
    '스탠다드 (King/Twin)',
    'STANDARD_ROOM'::room_category_type,
    30,
    'King 또는 Twin 선택',
    2,
    3,
    '["에어컨", "WiFi", "미니바", "스마트TV"]'::jsonb,
    ARRAY['CITY_VIEW'],
    0,
    1
  ),
  (
    'BAY_VIEW',
    '베이뷰 (King/Twin)',
    'STANDARD_ROOM'::room_category_type,
    32,
    'King 또는 Twin 선택',
    2,
    3,
    '["에어컨", "WiFi", "미니바", "하롱베이 뷰"]'::jsonb,
    ARRAY['BAY_VIEW'],
    0,
    1
  ),
  (
    'DELUXE_BAY_TWIN',
    '디럭스 베이뷰 Twin',
    'STANDARD_ROOM'::room_category_type,
    35,
    'Twin Beds',
    2,
    3,
    '["에어컨", "WiFi", "미니바", "하롱베이 뷰", "넓은 객실"]'::jsonb,
    ARRAY['BAY_VIEW'],
    0,
    1
  ),
  (
    'DELUXE_KING',
    '디럭스 King',
    'STANDARD_ROOM'::room_category_type,
    35,
    'King Bed',
    2,
    3,
    '["에어컨", "WiFi", "미니바", "넓은 객실"]'::jsonb,
    ARRAY['CITY_VIEW', 'BAY_VIEW'],
    0,
    1
  ),
  (
    'DELUXE_TWIN',
    '디럭스 Twin',
    'STANDARD_ROOM'::room_category_type,
    35,
    'Twin Beds',
    2,
    3,
    '["에어컨", "WiFi", "미니바", "넓은 객실"]'::jsonb,
    ARRAY['CITY_VIEW'],
    0,
    1
  ),
  (
    'SUITE',
    '스위트 King',
    'SUITE'::room_category_type,
    50,
    'King Bed',
    2,
    4,
    '["에어컨", "WiFi", "미니바", "거실", "욕조"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    0,
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
-- 특이: LOW/HIGH 가격 동일 → 연중 단일가 + HOLIDAY 별도
-- 추가인원: 900,000 VND/박
-- 엑스트라베드: 없음 (뷔페버페드 사용)

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- STANDARD: 1,800,000 VND
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT') AND room_code = 'STANDARD' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가 (LOW=HIGH 동일)',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1800000, 900000, '엑스트라베드 없음, 뷔페버페드 사용',
  true, 'AC, WiFi, 미니바', 'King/Twin 선택 가능', 2026
UNION ALL
-- BAY_VIEW: 2,000,000 VND
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT') AND room_code = 'BAY_VIEW' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가 (LOW=HIGH 동일)',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  2000000, 900000, '엑스트라베드 없음',
  true, 'AC, WiFi, 미니바', 'King/Twin 선택 가능', 2026
UNION ALL
-- DELUXE_BAY_TWIN: 2,300,000 VND
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT') AND room_code = 'DELUXE_BAY_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가 (LOW=HIGH 동일)',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  2300000, 900000, '엑스트라베드 없음',
  true, 'AC, WiFi, 미니바', 'Twin 전용', 2026
UNION ALL
-- DELUXE_KING: 2,400,000 VND
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT') AND room_code = 'DELUXE_KING' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가 (LOW=HIGH 동일)',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  2400000, 900000, '엑스트라베드 없음',
  true, 'AC, WiFi, 미니바', 'King 전용', 2026
UNION ALL
-- DELUXE_TWIN: 2,100,000 VND
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT') AND room_code = 'DELUXE_TWIN' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가 (LOW=HIGH 동일)',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  2100000, 900000, '엑스트라베드 없음',
  true, 'AC, WiFi, 미니바', 'Twin 전용', 2026
UNION ALL
-- SUITE: 3,400,000 VND
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT') AND room_code = 'SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중 단일가 (LOW=HIGH 동일)',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  3400000, 900000, '엑스트라베드 없음',
  true, 'AC, WiFi, 미니바, 거실', 'King 전용, 최고급', 2026;

-- ============================================================================
-- 4. 공휴일 추가요금 INSERT (HOLIDAY +500K)
-- ============================================================================

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  surcharge_holiday, include_breakfast, include_facilities, notes, calendar_year
)
-- 노동절 (4/30~5/1)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  NULL::uuid,
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_LABOR', '노동절 추가요금',
  '2026-04-30'::date, '2026-05-01'::date, 'ANY'::day_of_week_type,
  500000, 900000, '전 객실 +500K 추가',
  500000, true, 'AC, WiFi', '기본가에 추가 적용', 2026
UNION ALL
-- 독립기념일 (9/1~9/2)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  NULL::uuid,
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_INDEPENDENCE', '독립기념일 추가요금',
  '2026-09-01'::date, '2026-09-02'::date, 'ANY'::day_of_week_type,
  500000, 900000, '전 객실 +500K 추가',
  500000, true, 'AC, WiFi', '기본가에 추가 적용', 2026
UNION ALL
-- 크리스마스 (12/24~12/25)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  NULL::uuid,
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_CHRISTMAS', '크리스마스 추가요금',
  '2026-12-24'::date, '2026-12-25'::date, 'ANY'::day_of_week_type,
  500000, 900000, '전 객실 +500K 추가',
  500000, true, 'AC, WiFi', '기본가에 추가 적용', 2026
UNION ALL
-- 연말 (12/31)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT'),
  NULL::uuid,
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_NEWYEAR', '연말/새해 추가요금',
  '2026-12-31'::date, '2027-01-01'::date, 'ANY'::day_of_week_type,
  500000, 900000, '전 객실 +500K 추가',
  500000, true, 'AC, WiFi', '기본가에 추가 적용', 2026;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT * FROM hotel_info WHERE hotel_code = 'HYATT';
-- SELECT * FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT');
-- SELECT season_key, season_name, base_price, surcharge_holiday 
-- FROM pricing_model WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'HYATT')
-- ORDER BY date_range_start;
