-- ============================================================================
-- 호텔 8: SOLEIL HALONG (Trademark Collection by Wyndham) - 5성급
-- ============================================================================
-- 소스: 스테이하롱 카페매니저 1:1 채팅 (2024.04.24)
-- 하롱베이 관광객 지역 중심지, SUN WORLD 케이블카 선착장 앞
-- 한국인 친화 호텔 (조식에 김밥, 김치 등 제공)
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. 호텔 기본 정보
-- ============================================================================
INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location, star_rating,
  check_in_time, check_out_time, special_features, active_year, currency, contact_info
) VALUES (
  'SOLEIL',
  'Hotel Soleil Halong (Trademark Collection by Wyndham)',
  'HOTEL'::hotel_product_type,
  '하롱베이 관광객 지역 중심지, SUN WORLD 케이블카 선착장 앞 (도보 이동 가능)',
  5,
  '14:00:00',
  '12:00:00',
  '[
    "Wyndham 계열 5성급",
    "SUN WORLD 케이블카 도보 접근",
    "한국인 친화 조식 (김밥, 김치)",
    "실내 수영장 (4층, 06:00~21:00)",
    "발코니 레스토랑 (2층)",
    "모던 객실 컨디션",
    "하롱베이 뷰 / 도심뷰"
  ]'::jsonb,
  ARRAY[2026],
  'VND',
  '{
    "brand": "Trademark Collection by Wyndham",
    "early_checkin": "08시 전 100%, 08~10시 50%",
    "late_checkout": "18시 후 100%, 18시 전 50%",
    "pool": "4층 실내수영장 06:00~21:00",
    "restaurant": "2층 발코니 레스토랑"
  }'::jsonb
) ON CONFLICT (hotel_code) DO NOTHING;

-- ============================================================================
-- 2. 객실 타입 (7종)
-- ============================================================================
WITH h AS (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL')
INSERT INTO room_type (
  hotel_id, room_code, room_name, room_category,
  area_sqm, bed_config, occupancy_base, occupancy_max,
  amenities, view_options, extra_bed_allowed, max_children
)
SELECT h.hotel_id, v.* FROM h CROSS JOIN (VALUES
  (
    'DELUXE_TWIN',
    'Deluxe Twin',
    'STANDARD_ROOM'::room_category_type,
    31, 'Twin Beds', 2, 3,
    '["단독 발코니", "에어컨", "WiFi", "TV", "미니바"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1, 1
  ),
  (
    'DELUXE_KING',
    'Deluxe King',
    'STANDARD_ROOM'::room_category_type,
    31, 'King Bed', 2, 3,
    '["단독 발코니", "에어컨", "WiFi", "TV", "미니바"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1, 1
  ),
  (
    'PREMIER',
    'Premier Room',
    'STANDARD_ROOM'::room_category_type,
    46, 'King Bed', 2, 3,
    '["단독 발코니", "에어컨", "WiFi", "TV", "미니바", "넓은 객실"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1, 1
  ),
  (
    'JUNIOR_SUITE',
    'Junior Suite',
    'SUITE'::room_category_type,
    46, 'King Bed', 2, 3,
    '["단독 발코니", "에어컨", "WiFi", "TV", "미니바", "스위트"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1, 1
  ),
  (
    'EXECUTIVE_SUITE',
    'Executive Suite',
    'SUITE'::room_category_type,
    68, 'King Bed', 2, 3,
    '["단독 발코니", "에어컨", "WiFi", "TV", "미니바", "거실", "고급 스위트"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1, 1
  ),
  (
    'FAMILY_SUITE',
    'Family Suite (2개 객실)',
    'FAMILY_ROOM'::room_category_type,
    60, 'King 1 + Twin Beds', 4, 6,
    '["단독 발코니", "에어컨", "WiFi", "TV", "2개 객실", "욕실 1개", "킹+트윈 구성"]'::jsonb,
    ARRAY['CITY_VIEW'],
    0, 2
  ),
  (
    'PRESIDENTIAL_SUITE',
    'Presidential Suite (2개 객실)',
    'SUITE'::room_category_type,
    98, 'King Bed', 2, 4,
    '["단독 발코니", "에어컨", "WiFi", "TV", "2개 객실", "최고급 스위트", "VIP"]'::jsonb,
    ARRAY['BAY_VIEW', 'CITY_VIEW'],
    1, 2
  )
) AS v(room_code, room_name, room_category, area_sqm, bed_config, occupancy_base, occupancy_max, amenities, view_options, extra_bed_allowed, max_children);

-- ============================================================================
-- 3. 가격 정보 (5월 기준 단일가 → 연중 적용)
-- ============================================================================
-- ⚠️ 소스 데이터가 5월 기준 1개 시즌만 제공
-- 시즌 구분 없이 연중 단일가로 적용
-- DELUXE는 CITY VIEW / BAY VIEW 별도 가격
-- ============================================================================

INSERT INTO pricing_model (
  hotel_id, room_id, model_type,
  season_key, season_name, date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- DELUXE_TWIN (City View: 1,650,000 / Bay View: 1,700,000 → 평균 1,675,000, City View 기준)
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'DELUXE_TWIN'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026_CITY', 'City View 연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1650000, 650000,
  '아동(6~12세) 300,000 / 엑스트라베드 650,000 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'City View 기준 / Bay View +50,000',
  2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'DELUXE_TWIN'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026_BAY', 'Bay View 연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1700000, 650000,
  '아동(6~12세) 300,000 / 엑스트라베드 650,000 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'Bay View 기준',
  2026

-- DELUXE_KING (동일 가격 구조)
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'DELUXE_KING'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026_CITY', 'City View 연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1650000, 650000,
  '아동(6~12세) 300,000 / 엑스트라베드 650,000 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'City View 기준 / Bay View +50,000',
  2026
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'DELUXE_KING'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026_BAY', 'Bay View 연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  1700000, 650000,
  '아동(6~12세) 300,000 / 엑스트라베드 650,000 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'Bay View 기준',
  2026

-- PREMIER (2,200,000)
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'PREMIER'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  2200000, 650000,
  '아동(6~12세) 300,000 / 엑스트라베드 650,000 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'Bay/City View 선택 가능',
  2026

-- JUNIOR_SUITE (2,500,000)
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'JUNIOR_SUITE'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  2500000, 650000,
  '아동(6~12세) 300,000 / 엑스트라베드 650,000 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'Bay/City View 선택 가능',
  2026

-- EXECUTIVE_SUITE (4,500,000)
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'EXECUTIVE_SUITE'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  4500000, 650000,
  '아동(6~12세) 300,000 / 엑스트라베드 650,000 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'Bay/City View 선택 가능',
  2026

-- FAMILY_SUITE (3,200,000 / 성인4+아동1 기준)
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'FAMILY_SUITE'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  3200000, 650000,
  '성인4+아동1 포함가 / 5번째 인원부터 추가요금 / 욕실 1개 주의',
  true, '실내수영장, WiFi',
  'City View 전용 / 2타입: 거실+방2 또는 거실없음+방2 / 성인4인 시 디럭스/프리미어 커넥팅 추천',
  2026

-- PRESIDENTIAL_SUITE (6,300,000)
UNION ALL
SELECT
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'SOLEIL') AND room_code = 'PRESIDENTIAL_SUITE'),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'YEAR_2026', '연중', '2026-01-01'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  6300000, 650000,
  '아동 추가 시 비용 발생 / 6세 미만 무료',
  true, '실내수영장, WiFi',
  'Bay/City View 선택 가능 / 2개 객실 / 최고급',
  2026;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT h.hotel_code, h.hotel_name, h.star_rating,
--        COUNT(rt.room_id) AS rooms,
--        COUNT(pm.pricing_id) AS prices
-- FROM hotel_info h
-- LEFT JOIN room_type rt ON h.hotel_id = rt.hotel_id
-- LEFT JOIN pricing_model pm ON h.hotel_id = pm.hotel_id
-- WHERE h.hotel_code = 'SOLEIL'
-- GROUP BY h.hotel_code, h.hotel_name, h.star_rating;
