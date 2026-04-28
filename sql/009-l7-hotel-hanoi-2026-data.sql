-- ============================================================================
-- 호텔: L7 WEST LAKE HANOI BY LOTTE - 데이터 INSERT (2026)
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
  'L7LH',
  'L7 WEST LAKE HANOI By LOTTE',
  'HOTEL'::hotel_product_type,
  '하노이 서호(West Lake) 인근',
  5,
  '15:00:00',
  '12:00:00',
  '["LOTTE MALL 직연결", "무한 수영장", "고급 스파", "24시간 GYM", "피트니스 센터"]'::jsonb,
  ARRAY[2026],
  'VND',
  '{"phone": "+84-024-3946-7777", "website": "l7westlakehanoi.lottentl.com"}'::jsonb
);

-- ============================================================================
-- 2. 객실 타입 INSERT (고정 구조 - 복합 쿼리)
-- ============================================================================

WITH l7_hotel AS (
  SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'
)
INSERT INTO room_type (
  hotel_id, room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
)
SELECT
  lh.hotel_id,
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
FROM l7_hotel lh
CROSS JOIN (
  VALUES
  (
    'SUPERIOR_CITY',
    'Superior Room - 시티뷰',
    'STANDARD_ROOM'::room_category_type,
    39,
    'Double or Twin Beds',
    2,
    2,
    '["발코니", "무료 WIFI", "에어컨", "욕조", "고급 비누/샴푸"]'::jsonb,
    ARRAY['CITY_VIEW'],
    1,
    0
  ),
  (
    'SUPERIOR_LAKE',
    'Superior Lake View Room',
    'STANDARD_ROOM'::room_category_type,
    39,
    'Double or Twin Beds',
    2,
    2,
    '["발코니", "무료 WIFI", "에어컨", "욕조", "서호 뷰"]'::jsonb,
    ARRAY['LAKE_VIEW'],
    1,
    0
  ),
  (
    'SUPERIOR_FAMILY',
    'Superior Family Room - 패밀리',
    'STANDARD_ROOM'::room_category_type,
    39,
    'Family Twin (Double + Single)',
    3,
    3,
    '["발코니", "무료 WIFI", "에어컨", "욕조", "서호 뷰"]'::jsonb,
    ARRAY['LAKE_VIEW', 'CITY_VIEW'],
    0,
    2
  ),
  (
    'SUPERIOR_CLUB_CITY',
    'Superior Double Club Floor Room - 시티뷰',
    'STANDARD_ROOM'::room_category_type,
    39,
    'Double Bed',
    2,
    2,
    '["발코니", "클럽라운지 접근권", "무료 WIFI", "고급 어메니티"]'::jsonb,
    ARRAY['CITY_VIEW'],
    0,
    0
  ),
  (
    'SUPERIOR_CLUB_LAKE',
    'Superior Double Club Floor Room - 레이크뷰',
    'STANDARD_ROOM'::room_category_type,
    39,
    'Double Bed',
    2,
    2,
    '["발코니", "클럽라운지 접근권", "무료 WIFI", "서호 뷰"]'::jsonb,
    ARRAY['LAKE_VIEW'],
    0,
    0
  ),
  (
    'STUDIO_SUITE',
    'Studio Suite Room - 스튜디오 스위트',
    'SUITE'::room_category_type,
    82,
    'Double or Twin Beds',
    2,
    2,
    '["대형 발코니", "거실", "욕조", "샤워부스", "서호 뷰", "클럽라운지 접근권"]'::jsonb,
    ARRAY['LAKE_VIEW'],
    0,
    0
  ),
  (
    'UPPER_HOUSE',
    'Upper House Room - 어퍼하우스',
    'SUITE'::room_category_type,
    130,
    'Double Bed',
    2,
    2,
    '["대형 발코니", "침실", "거실/라운지", "욕실", "개인 스파", "서호 뷰", "클럽라운지 접근권"]'::jsonb,
    ARRAY['LAKE_VIEW'],
    0,
    0
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

-- SUPERIOR CITY VIEW
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH') AND room_code = 'SUPERIOR_CITY' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'STANDARD_2026',
  'Standard Season 2026',
  '2026-01-01'::date,
  '2026-12-31'::date,
  'ANY'::day_of_week_type,
  3450000,
  500000,
  '상이 내용 문의',
  true,
  '서비스료 5%, VAT 포함. 조식뷔페, 무료 WIFI, GYM/사우나/수영장 무료 이용, 생수 2병, 차/커피 세트 제공',
  '성인 2인 기준',
  2026
UNION ALL
-- SUPERIOR LAKE VIEW
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH') AND room_code = 'SUPERIOR_LAKE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'STANDARD_2026',
  'Standard Season 2026',
  '2026-01-01'::date,
  '2026-12-31'::date,
  'ANY'::day_of_week_type,
  4000000,
  500000,
  '상이 내용 문의',
  true,
  '서비스료 5%, VAT 포함. 조식뷔페, 무료 WIFI, GYM/사우나/수영장 무료 이용, 생수 2병, 차/커피 세트 제공',
  '성인 2인 기준, 서호 뷰',
  2026
UNION ALL
-- SUPERIOR FAMILY TRIPLE
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH') AND room_code = 'SUPERIOR_FAMILY' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'STANDARD_2026',
  'Standard Season 2026',
  '2026-01-01'::date,
  '2026-12-31'::date,
  'ANY'::day_of_week_type,
  4850000,
  600000,
  '상이 내용 문의',
  true,
  '서비스료 5%, VAT 포함. 조식뷔페, 무료 WIFI, GYM/사우나/수영장 무료 이용, 생수 2병, 차/커피 세트 제공',
  '성인 3인 기준, 패밀리 루형',
  2026
UNION ALL
-- SUPERIOR CLUB FLOOR CITY
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH') AND room_code = 'SUPERIOR_CLUB_CITY' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'STANDARD_2026',
  'Standard Season 2026',
  '2026-01-01'::date,
  '2026-12-31'::date,
  'ANY'::day_of_week_type,
  5350000,
  500000,
  '상이 내용 문의',
  true,
  '서비스료 5%, VAT 포함. 조식뷔페, 무료 WIFI, GYM/사우나/수영장 무료 이용, 생수 2병, 차/커피 세트 제공, 클럽라운지 접근권',
  '성인 2인 기준, 클럽플로어 시티뷰',
  2026
UNION ALL
-- SUPERIOR CLUB FLOOR LAKE VIEW
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH') AND room_code = 'SUPERIOR_CLUB_LAKE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'STANDARD_2026',
  'Standard Season 2026',
  '2026-01-01'::date,
  '2026-12-31'::date,
  'ANY'::day_of_week_type,
  5900000,
  500000,
  '상이 내용 문의',
  true,
  '서비스료 5%, VAT 포함. 조식뷔페, 무료 WIFI, GYM/사우나/수영장 무료 이용, 생수 2병, 차/커피 세트 제공, 클럽라운지 접근권',
  '성인 2인 기준, 클럽플로어 레이크뷰',
  2026
UNION ALL
-- STUDIO SUITE (Club benefits included)
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH') AND room_code = 'STUDIO_SUITE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'STANDARD_2026',
  'Standard Season 2026',
  '2026-01-01'::date,
  '2026-12-31'::date,
  'ANY'::day_of_week_type,
  0,
  0,
  '개별 문의',
  true,
  '서비스료 5%, VAT 포함. 조식뷔페, 무료 WIFI, GYM/사우나/수영장 무료 이용, 생수 2병, 차/커피 세트 제공, 클럽라운지 접근권',
  '82㎡ 스튜디오 스위트, 레이크뷰, 개별 문의 필요',
  2026
UNION ALL
-- UPPER HOUSE (Club benefits included)
SELECT 
  (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH') AND room_code = 'UPPER_HOUSE' LIMIT 1),
  'FIXED_OCCUPANCY'::pricing_model_type,
  'STANDARD_2026',
  'Standard Season 2026',
  '2026-01-01'::date,
  '2026-12-31'::date,
  'ANY'::day_of_week_type,
  0,
  0,
  '개별 문의',
  true,
  '서비스료 5%, VAT 포함. 조식뷔페, 무료 WIFI, GYM/사우나/수영장 무료 이용, 생수 2병, 차/커피 세트 제공, 클럽라운지 접근권',
  '130㎡ 어퍼하우스, 레이크뷰, 개별 문의 필요',
  2026;

-- ============================================================================
-- 4. 예약 정책 및 특이사항
-- ============================================================================
-- 호텔 예약 정책:
-- · 예약금: 50% / 체크인 5일 전 잔금
-- · 할인 프로모션 진행 시: 100% 전액송금
-- · 체크인 시 여권정보 필수 제출 (스테이하롱트래블에서 호텔에 전달)
-- · 모든 가격에는 5%의 봉사료 및 VAT가 포함됨
-- · 모든 객실에 조식뷔페(21층 Layered Restaurant) 포함
-- · 무료 WIFI, GYM, 사우나, 무한 수영장 무료 이용
-- · 객실 내 생수 2병, TEA/커피 세트 제공

-- ============================================================================
-- 5. 검증 쿼리
-- ============================================================================
SELECT 
  hi.hotel_name,
  COUNT(rt.room_id) as room_types,
  hi.star_rating,
  hi.check_in_time,
  hi.check_out_time
FROM hotel_info hi
LEFT JOIN room_type rt ON hi.hotel_id = rt.hotel_id
WHERE hi.hotel_code = 'L7LH'
GROUP BY hi.hotel_id, hi.hotel_name, hi.star_rating, hi.check_in_time, hi.check_out_time;

-- 객실별 가격 확인
SELECT 
  rt.room_name,
  pm.base_price,
  pm.include_breakfast,
  pm.include_facilities
FROM room_type rt
JOIN pricing_model pm ON rt.room_id = pm.room_id
WHERE rt.hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'L7LH')
ORDER BY rt.room_id;

COMMIT;
