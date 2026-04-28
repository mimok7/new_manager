-- ============================================================================
-- 호텔 5: YOKO ONSEN RESORT - 데이터 INSERT (2026)
-- ============================================================================
-- 실행 순서: 001-hotel-system-v3-tables-2026.sql 이후 실행
-- 호텔별 독립 실행 가능 (다른 호텔과 무관)
-- 특이사항: 복합 리조트 (Day Pass + WASHITSU 객실 + VILLAS 독채)
-- 운영사: SUN GROUP
-- 가격구조: LOW/HIGH 시즌 + 평일/금토 구분

BEGIN;

-- ============================================================================
-- 1. 호텔 기본 정보 INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location, star_rating,
  check_in_time, check_out_time, special_features, active_year,
  currency, contact_info
) VALUES (
  'YOKO',
  'Yoko Onsen Resort',
  'RESORT_ONSEN'::hotel_product_type,
  'Tổ 5, khu 9B, Cẩm Phả, Quảng Ninh',
  NULL,
  '14:00:00',
  '11:00:00',
  '["SUN GROUP 운영", "공용 온천", "Day Pass 프로그램", "WASHITSU 객실", "VILLAS 독채", "뷔페 선택 650K/인"]'::jsonb,
  ARRAY[2026],
  'VND',
  '{"operator": "SUN GROUP", "note": "3가지 운영모델: Day Pass / WASHITSU / VILLAS"}'::jsonb
) ON CONFLICT (hotel_code) DO NOTHING;

-- ============================================================================
-- 2. 객실/프로그램 타입 INSERT
-- ============================================================================
-- Day Pass 3종 + WASHITSU 4종 + VILLAS 4종 = 총 11종

WITH yoko_hotel AS (
  SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'
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
FROM yoko_hotel yh
CROSS JOIN (
  VALUES
  -- ===== Day Pass 프로그램 (3종) =====
  (
    'DAYPASS_MORNING',
    'Morning Onsen (09:00-13:00)',
    'STANDARD_ROOM'::room_category_type,
    0, -- area N/A for day pass
    'N/A',
    1, 1,
    '["공용 온천", "뷔페 포함", "09:00-13:00"]'::jsonb,
    ARRAY['ONSEN'],
    0, 0
  ),
  (
    'DAYPASS_AFTERNOON',
    'Afternoon Onsen (14:00-21:00)',
    'STANDARD_ROOM'::room_category_type,
    0,
    'N/A',
    1, 1,
    '["공용 온천", "뷔페 포함", "14:00-21:00"]'::jsonb,
    ARRAY['ONSEN'],
    0, 0
  ),
  (
    'DAYPASS_NIGHT',
    'Night Onsen (18:00-21:00)',
    'STANDARD_ROOM'::room_category_type,
    0,
    'N/A',
    1, 1,
    '["공용 온천", "식사 불포함", "18:00-21:00"]'::jsonb,
    ARRAY['ONSEN'],
    0, 0
  ),
  -- ===== WASHITSU 객실 (4종) =====
  (
    'WASHITSU_ICHI',
    'Washitsu Ichi',
    'STANDARD_ROOM'::room_category_type,
    40,
    'Japanese Style',
    2, 3,
    '["온천 포함", "일본식 객실", "40㎡"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0, 1
  ),
  (
    'WASHITSU_NI',
    'Washitsu Ni',
    'STANDARD_ROOM'::room_category_type,
    40,
    'Japanese Style',
    2, 3,
    '["온천 포함", "일본식 객실", "40㎡", "업그레이드"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0, 1
  ),
  (
    'WASHITSU_OMOTEASHI',
    'Washitsu Omoteashi',
    'FAMILY_ROOM'::room_category_type,
    75,
    'Japanese Style (Large)',
    2, 4,
    '["온천 포함", "일본식 객실", "75㎡", "가족형"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0, 2
  ),
  (
    'WASHITSU_KAZOKU',
    'Washitsu Kazoku (가족형)',
    'FAMILY_ROOM'::room_category_type,
    63,
    'Japanese Style (Family)',
    2, 4,
    '["온천 포함", "일본식 객실", "63㎡", "성인 4인 가능"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0, 2
  ),
  -- ===== VILLAS (4종) =====
  (
    'YAMA_ONSEN_2BED',
    'Yama Onsen Villa 2BED',
    'VILLA'::room_category_type,
    0,
    '2 Bedroom Villa',
    4, 6,
    '["프라이빗 온천", "독채", "2베드룸"]'::jsonb,
    ARRAY['MOUNTAIN_VIEW'],
    0, 2
  ),
  (
    'YAMA_ONSEN_3BED',
    'Yama Onsen Villa 3BED',
    'VILLA'::room_category_type,
    0,
    '3 Bedroom Villa',
    6, 9,
    '["프라이빗 온천", "독채", "3베드룸"]'::jsonb,
    ARRAY['MOUNTAIN_VIEW'],
    0, 3
  ),
  (
    'YAMA_PREMIUM_3BED',
    'Yama Premium Villa 3BED',
    'VILLA'::room_category_type,
    0,
    '3 Bedroom Premium Villa',
    6, 9,
    '["프라이빗 온천", "독채", "프리미엄", "3베드룸"]'::jsonb,
    ARRAY['MOUNTAIN_VIEW'],
    0, 3
  ),
  (
    'YAMA_GRAND_4BED',
    'Yama Grand Villa 4BED',
    'VILLA'::room_category_type,
    0,
    '4 Bedroom Grand Villa',
    8, 12,
    '["프라이빗 온천", "독채", "그랜드", "4베드룸"]'::jsonb,
    ARRAY['MOUNTAIN_VIEW'],
    0, 4
  )
) AS room_data(
  room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
);

-- ============================================================================
-- 3-A. Day Pass 가격 INSERT (인당 가격, DAY_PASS 모델)
-- ============================================================================
-- 시즌: HIGH (5/17~8/30), LOW (1/1~5/16, 9/4~12/31)

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- MORNING ONSEN - LOW
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'DAYPASS_MORNING' LIMIT 1),
  'DAY_PASS'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-16'::date, 'ANY'::day_of_week_type,
  1400000, 0, '4세 이하 무료, 4세 이상 성인 요금',
  true, '공용 온천, 뷔페 포함', '인당 가격', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'DAYPASS_MORNING' LIMIT 1),
  'DAY_PASS'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-17'::date, '2026-08-30'::date, 'ANY'::day_of_week_type,
  1850000, 0, '4세 이하 무료, 4세 이상 성인 요금',
  true, '공용 온천, 뷔페 포함', '인당 가격 (주말 포함)', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'DAYPASS_MORNING' LIMIT 1),
  'DAY_PASS'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1400000, 0, '4세 이하 무료, 4세 이상 성인 요금',
  true, '공용 온천, 뷔페 포함', '인당 가격', 2026
UNION ALL
-- AFTERNOON ONSEN - LOW
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'DAYPASS_AFTERNOON' LIMIT 1),
  'DAY_PASS'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-16'::date, 'ANY'::day_of_week_type,
  1300000, 0, '4세 이하 무료, 4세 이상 성인 요금',
  true, '공용 온천, 뷔페 포함', '인당 가격', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'DAYPASS_AFTERNOON' LIMIT 1),
  'DAY_PASS'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-17'::date, '2026-08-30'::date, 'ANY'::day_of_week_type,
  1700000, 0, '4세 이하 무료, 4세 이상 성인 요금',
  true, '공용 온천, 뷔페 포함', '인당 가격 (주말 포함)', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'DAYPASS_AFTERNOON' LIMIT 1),
  'DAY_PASS'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1300000, 0, '4세 이하 무료, 4세 이상 성인 요금',
  true, '공용 온천, 뷔페 포함', '인당 가격', 2026
UNION ALL
-- NIGHT ONSEN - 연중 동일가
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'DAYPASS_NIGHT' LIMIT 1),
  'DAY_PASS'::pricing_model_type,
  'YEAR_2026', '연중 단일가',
  '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  550000, 0, '4세 이하 무료, 4세 이상 성인 요금',
  false, '공용 온천 (식사 불포함)', '인당 가격, 식사 별도', 2026;

-- ============================================================================
-- 3-B. WASHITSU 대실 가격 INSERT (6시간 이용)
-- ============================================================================
-- LOW 평일 / LOW 주말(=MID) / HIGH 주말(=HIGH) 3단계
-- 뷔페 별도: 650,000 VND/인

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- WASHITSU_ICHI 대실
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_DAYTIME', 'LOW 평일 대실 (6시간)',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  3100000, 650000, '4세 이하 무료, 4세 이상 성인요금, 뷔페 650K/인 별도',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간, 기본 성인2+아동1', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_DAYTIME', 'LOW 주말 대실 (6시간)',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  4300000, 650000, '4세 이하 무료, 4세 이상 성인요금, 뷔페 650K/인 별도',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간 (MID 가격)', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_DAYTIME', 'HIGH 평일 대실 (6시간)',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  4300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간 (MID=HIGH평일)', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_DAYTIME', 'HIGH 주말 대실 (6시간)',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  4900000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
-- LOW_AUG 대실
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_DAYTIME', 'LOW 평일 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  3100000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_DAYTIME', 'LOW 주말 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  4300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간 (MID 가격)', 2026

-- WASHITSU_NI 대실
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_DAYTIME', 'LOW 평일 대실',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  3700000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_DAYTIME', 'LOW 주말 대실',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  5200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_DAYTIME', 'HIGH 평일 대실',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  5200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_DAYTIME', 'HIGH 주말 대실',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  5900000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_DAYTIME', 'LOW 평일 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  3700000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_DAYTIME', 'LOW 주말 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  5200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026

-- WASHITSU_OMOTEASHI 대실
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_DAYTIME', 'LOW 평일 대실',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  4300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간, 75㎡', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_DAYTIME', 'LOW 주말 대실',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  6000000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_DAYTIME', 'HIGH 평일 대실',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  6000000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_DAYTIME', 'HIGH 주말 대실',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  6850000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_DAYTIME', 'LOW 평일 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  4300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_DAYTIME', 'LOW 주말 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  6000000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026

-- WASHITSU_KAZOKU 대실
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_DAYTIME', 'LOW 평일 대실',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  5250000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간, 63㎡, 성인4인 가능', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_DAYTIME', 'LOW 주말 대실',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  7300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_DAYTIME', 'HIGH 평일 대실',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  7300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_DAYTIME', 'HIGH 주말 대실',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  8300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_DAYTIME', 'LOW 평일 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  5250000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_DAYTIME', 'LOW 주말 대실 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  7300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '대실 6시간', 2026;

-- ============================================================================
-- 3-C. WASHITSU 1박 가격 INSERT
-- ============================================================================

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- WASHITSU_ICHI 1박
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_OVERNIGHT', 'LOW 평일 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  3350000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박, 기본 성인2+아동1', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_OVERNIGHT', 'LOW 주말 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  6050000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박 (MID 가격)', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_OVERNIGHT', 'HIGH 평일 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  6050000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_OVERNIGHT', 'HIGH 주말 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  6850000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_OVERNIGHT', 'LOW 평일 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  3350000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_ICHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_OVERNIGHT', 'LOW 주말 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  6050000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026

-- WASHITSU_NI 1박
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_OVERNIGHT', 'LOW 평일 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  5200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_OVERNIGHT', 'LOW 주말 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  7200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_OVERNIGHT', 'HIGH 평일 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  7200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_OVERNIGHT', 'HIGH 주말 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  8200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_OVERNIGHT', 'LOW 평일 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  5200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_NI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_OVERNIGHT', 'LOW 주말 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  7200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026

-- WASHITSU_OMOTEASHI 1박
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_OVERNIGHT', 'LOW 평일 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  6050000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박, 75㎡', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_OVERNIGHT', 'LOW 주말 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  8400000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_OVERNIGHT', 'HIGH 평일 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  8400000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_OVERNIGHT', 'HIGH 주말 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  9600000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_OVERNIGHT', 'LOW 평일 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  6050000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_OMOTEASHI' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_OVERNIGHT', 'LOW 주말 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  8400000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026

-- WASHITSU_KAZOKU 1박
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_OVERNIGHT', 'LOW 평일 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  7300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박, 63㎡, 성인4인 가능', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_OVERNIGHT', 'LOW 주말 1박',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  10200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY_OVERNIGHT', 'HIGH 평일 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  10200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND_OVERNIGHT', 'HIGH 주말 1박',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  11650000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG_OVERNIGHT', 'LOW 평일 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  7300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'WASHITSU_KAZOKU' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG_OVERNIGHT', 'LOW 주말 1박 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  10200000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '온천 포함, 뷔페 별도 650K/인', '1박 숙박', 2026;

-- ============================================================================
-- 3-D. VILLAS 가격 INSERT
-- ============================================================================
-- 시즌: HIGH (5/17~8/30), LOW (1/1~5/16, 9/4~12/31)
-- 평일/금토 구분

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- YAMA_ONSEN_2BED
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW 평일',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  9100000, 650000, '4세 이하 무료(기본인원 포함), 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인4+아동2', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW 금토',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  10400000, 650000, '4세 이하 무료(기본인원 포함), 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인4+아동2', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH 평일',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  10400000, 650000, '4세 이하 무료(기본인원 포함), 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인4+아동2', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH 금토',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  11600000, 650000, '4세 이하 무료(기본인원 포함), 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인4+아동2', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW 평일 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  9100000, 650000, '4세 이하 무료(기본인원 포함), 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인4+아동2', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW 금토 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  10400000, 650000, '4세 이하 무료(기본인원 포함), 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인4+아동2', 2026

-- YAMA_ONSEN_3BED
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW 평일',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  11100000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW 금토',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  12600000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH 평일',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  12600000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH 금토',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  14100000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW 평일 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  11100000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_ONSEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW 금토 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  12600000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채', '기본 성인6+아동3', 2026

-- YAMA_PREMIUM_3BED
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_PREMIUM_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW 평일',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  13700000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 프리미엄', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_PREMIUM_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW 금토',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  15600000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 프리미엄', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_PREMIUM_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH 평일',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  15600000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 프리미엄', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_PREMIUM_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH 금토',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  17500000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 프리미엄', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_PREMIUM_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW 평일 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  13700000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 프리미엄', '기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_PREMIUM_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW 금토 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  15600000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 프리미엄', '기본 성인6+아동3', 2026

-- YAMA_GRAND_4BED
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_GRAND_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY', 'LOW 평일',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKDAY'::day_of_week_type,
  79800000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 그랜드', '기본 성인8+아동4', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_GRAND_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND', 'LOW 금토',
  '2026-01-01'::date, '2026-05-16'::date, 'WEEKEND'::day_of_week_type,
  91000000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 그랜드', '기본 성인8+아동4', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_GRAND_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKDAY', 'HIGH 평일',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKDAY'::day_of_week_type,
  91000000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 그랜드', '기본 성인8+아동4', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_GRAND_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026_WEEKEND', 'HIGH 금토',
  '2026-05-17'::date, '2026-08-30'::date, 'WEEKEND'::day_of_week_type,
  102300000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 그랜드', '기본 성인8+아동4', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_GRAND_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKDAY_AUG', 'LOW 평일 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKDAY'::day_of_week_type,
  79800000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 그랜드', '기본 성인8+아동4', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') AND room_code = 'YAMA_GRAND_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_WEEKEND_AUG', 'LOW 금토 (9월~)',
  '2026-09-04'::date, '2026-12-31'::date, 'WEEKEND'::day_of_week_type,
  91000000, 650000, '4세 이하 무료, 4세 이상 성인요금',
  false, '프라이빗 온천, 독채, 그랜드', '기본 성인8+아동4', 2026;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT * FROM hotel_info WHERE hotel_code = 'YOKO';
-- SELECT room_code, room_name, room_category FROM room_type 
--   WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO') ORDER BY room_code;
-- SELECT rt.room_code, pm.season_key, pm.base_price, pm.day_of_week, pm.notes
-- FROM pricing_model pm
-- JOIN room_type rt ON pm.room_id = rt.room_id
-- WHERE pm.hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO')
-- ORDER BY rt.room_code, pm.date_range_start, pm.day_of_week;
-- SELECT COUNT(*) FROM pricing_model WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'YOKO');
