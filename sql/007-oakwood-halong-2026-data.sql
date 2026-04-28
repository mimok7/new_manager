-- ============================================================================
-- 호텔 6: OAKWOOD HALONG POOL VILLAS - 데이터 INSERT (2026)
-- ============================================================================
-- 실행 순서: 001-hotel-system-v3-tables-2026.sql 이후 실행
-- 호텔별 독립 실행 가능 (다른 호텔과 무관)
-- 특이사항: 5성급 독채 빌라단지 86개, LOW/HIGH 시즌, 복잡한 추가인원 정책

BEGIN;

-- ============================================================================
-- 1. 호텔 기본 정보 INSERT
-- ============================================================================

INSERT INTO hotel_info (
  hotel_code, hotel_name, product_type, location, star_rating,
  check_in_time, check_out_time, special_features, active_year,
  currency, contact_info
) VALUES (
  'OAKWOOD',
  'Oakwood Halong Pool Villas',
  'VILLA_POOL'::hotel_product_type,
  '바이짜이짜이 대교 인근 (선반도해변 근처)',
  5,
  '14:00:00',
  '12:00:00',
  '["86개 독채 빌라", "프라이빗 수영장", "레스토랑", "스파", "컨시어지", "커뮤니티 수영장"]'::jsonb,
  ARRAY[2026],
  'VND',
  '{"note": "공휴일 2박 필수, 식사비 900K/인/일 의무"}'::jsonb
) ON CONFLICT (hotel_code) DO NOTHING;

-- ============================================================================
-- 2. 빌라 타입 INSERT (9종: 3 타입 × 1~5BED 조합)
-- ============================================================================

WITH oakwood_hotel AS (
  SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'
)
INSERT INTO room_type (
  hotel_id, room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
)
SELECT
  oh.hotel_id,
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
FROM oakwood_hotel oh
CROSS JOIN (
  VALUES
  -- 주니어 가든빌라 (1BED만)
  (
    'JUNIOR_GARDEN_1BED',
    '주니어 가든빌라 1BED',
    'VILLA'::room_category_type,
    0,
    '1 Bedroom Villa',
    2, 3,
    '["정원 뷰", "프라이빗풀 없음", "커뮤니티풀"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0, 1
  ),
  -- 디럭스 가든빌라 (2~4BED)
  (
    'DELUXE_GARDEN_2BED',
    '디럭스 가든빌라 2BED',
    'VILLA'::room_category_type,
    0,
    '2 Bedroom Villa',
    4, 6,
    '["정원 뷰", "프라이빗풀 없음", "커뮤니티풀"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    2, 2
  ),
  (
    'DELUXE_GARDEN_3BED',
    '디럭스 가든빌라 3BED',
    'VILLA'::room_category_type,
    0,
    '3 Bedroom Villa',
    6, 9,
    '["정원 뷰", "프라이빗풀 없음", "커뮤니티풀"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0, 3
  ),
  (
    'DELUXE_GARDEN_4BED',
    '디럭스 가든빌라 4BED',
    'VILLA'::room_category_type,
    0,
    '4 Bedroom Villa',
    8, 12,
    '["정원 뷰", "프라이빗풀 없음", "커뮤니티풀"]'::jsonb,
    ARRAY['GARDEN_VIEW'],
    0, 4
  ),
  -- 디럭스 레이크빌라 (2~4BED)
  (
    'DELUXE_LAKE_2BED',
    '디럭스 레이크빌라 2BED',
    'VILLA'::room_category_type,
    0,
    '2 Bedroom Villa',
    4, 6,
    '["레이크사이드", "프리미엄 뷰"]'::jsonb,
    ARRAY['LAKE_VIEW'],
    2, 2
  ),
  (
    'DELUXE_LAKE_3BED',
    '디럭스 레이크빌라 3BED',
    'VILLA'::room_category_type,
    0,
    '3 Bedroom Villa',
    6, 9,
    '["레이크사이드", "프리미엄 뷰"]'::jsonb,
    ARRAY['LAKE_VIEW'],
    0, 3
  ),
  (
    'DELUXE_LAKE_4BED',
    '디럭스 레이크빌라 4BED',
    'VILLA'::room_category_type,
    0,
    '4 Bedroom Villa',
    8, 12,
    '["레이크사이드", "프리미엄 뷰"]'::jsonb,
    ARRAY['LAKE_VIEW'],
    0, 4
  ),
  -- 프리미어 코너빌라 (2~4BED, 프라이빗 수영장)
  (
    'PREMIER_CORNER_2BED',
    '프리미어 코너빌라 2BED',
    'VILLA'::room_category_type,
    0,
    '2 Bedroom Villa',
    4, 6,
    '["프라이빗 수영장", "코너 위치", "최고급"]'::jsonb,
    ARRAY['POOL_VIEW', 'CORNER'],
    2, 2
  ),
  (
    'PREMIER_CORNER_3BED',
    '프리미어 코너빌라 3BED',
    'VILLA'::room_category_type,
    0,
    '3 Bedroom Villa',
    6, 9,
    '["프라이빗 수영장", "코너 위치", "최고급"]'::jsonb,
    ARRAY['POOL_VIEW', 'CORNER'],
    0, 3
  )
) AS room_data(
  room_code, room_name, room_category, area_sqm,
  bed_config, occupancy_base, occupancy_max, amenities,
  view_options, extra_bed_allowed, max_children
);

-- ============================================================================
-- 3. 가격 데이터 INSERT (2026년)
-- ============================================================================
-- 시즌: LOW (1/1~5/30, 8/17~12/31) / HIGH (5/31~8/16)
-- LOW → HIGH: +500,000 VND
-- 추가인원: 유아(1~5세) 무료, 아동(6~11세 엑스트라) 1,250K, 아동(미사용) 700K, 성인 엑스트라 1,400K

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  include_breakfast, include_facilities, notes, calendar_year
)
-- ===== 주니어 가든빌라 1BED =====
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'JUNIOR_GARDEN_1BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  4450000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '1BED 기본 성인2+아동1', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'JUNIOR_GARDEN_1BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  4950000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '1BED, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'JUNIOR_GARDEN_1BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  4450000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '1BED', 2026

-- ===== 디럭스 가든빌라 2BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  4450000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '2BED 기본 성인4+아동2', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  4950000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '2BED, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  4450000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '2BED', 2026

-- ===== 디럭스 가든빌라 3BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  6150000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '3BED 기본 성인6+아동3', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  6650000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '3BED, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  6150000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '3BED', 2026

-- ===== 디럭스 가든빌라 4BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  7750000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '4BED 기본 성인8+아동4', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  8250000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '4BED, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_GARDEN_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  7750000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '커뮤니티풀, 피트니스, 조식 포함', '4BED', 2026

-- ===== 디럭스 레이크빌라 2BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  7150000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '2BED 레이크사이드', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  7650000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '2BED 레이크, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  7150000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '2BED 레이크', 2026

-- ===== 디럭스 레이크빌라 3BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  8850000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '3BED 레이크사이드', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  9350000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '3BED 레이크, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  8850000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '3BED 레이크', 2026

-- ===== 디럭스 레이크빌라 4BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  10450000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '4BED 레이크사이드', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  10950000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '4BED 레이크, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'DELUXE_LAKE_4BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  10450000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '레이크뷰, 프리미엄, 조식 포함', '4BED 레이크', 2026

-- ===== 프리미어 코너빌라 2BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'PREMIER_CORNER_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  11550000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '프라이빗 수영장, 코너 위치, 최고급, 조식 포함', '2BED 프리미어', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'PREMIER_CORNER_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  12150000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '프라이빗 수영장, 코너 위치, 최고급, 조식 포함', '2BED 프리미어, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'PREMIER_CORNER_2BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  11550000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '프라이빗 수영장, 코너 위치, 최고급, 조식 포함', '2BED 프리미어', 2026

-- ===== 프리미어 코너빌라 3BED =====
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'PREMIER_CORNER_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026', 'LOW SEASON',
  '2026-01-01'::date, '2026-05-30'::date, 'ANY'::day_of_week_type,
  13250000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '프라이빗 수영장, 코너 위치, 최고급, 조식 포함', '3BED 프리미어', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'PREMIER_CORNER_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HIGH_2026', 'HIGH SEASON',
  '2026-05-31'::date, '2026-08-16'::date, 'ANY'::day_of_week_type,
  13850000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '프라이빗 수영장, 코너 위치, 최고급, 조식 포함', '3BED 프리미어, LOW+500K', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  (SELECT room_id FROM room_type WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') AND room_code = 'PREMIER_CORNER_3BED' LIMIT 1),
  'SCALED_OCCUPANCY'::pricing_model_type,
  'LOW_2026_AUG', 'LOW SEASON (8월~)',
  '2026-08-17'::date, '2026-12-31'::date, 'ANY'::day_of_week_type,
  13250000, 1400000, '유아(1~5세) 무료, 아동(6~11세) 엑스트라 1,250K/미사용 700K, 성인 엑스트라 1,400K',
  true, '프라이빗 수영장, 코너 위치, 최고급, 조식 포함', '3BED 프리미어', 2026;

-- ============================================================================
-- 4. 공휴일 규정 (노동절/독립기념일: 2박 필수 + 식사비 900K/인/일 의무)
-- ============================================================================

INSERT INTO pricing_model (
  hotel_id, room_id, model_type, season_key, season_name,
  date_range_start, date_range_end, day_of_week,
  base_price, extra_person_price, child_policy,
  surcharge_holiday, include_breakfast, include_facilities, notes, calendar_year
)
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  NULL::uuid,
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_LABOR', '노동절 (2박 필수)',
  '2026-04-30'::date, '2026-05-03'::date, 'ANY'::day_of_week_type,
  0, 0, '2박 의무, 식사비 900K/인/일 필수',
  900000, true, '식사비 900K/인/일 의무', '2박 최소 숙박 의무, base_price=0은 추가요금만 의미', 2026
UNION ALL
SELECT (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD'),
  NULL::uuid,
  'SCALED_OCCUPANCY'::pricing_model_type,
  'HOLIDAY_2026_INDEPENDENCE', '독립기념일 (2박 필수)',
  '2026-08-30'::date, '2026-09-02'::date, 'ANY'::day_of_week_type,
  0, 0, '2박 의무, 식사비 900K/인/일 필수',
  900000, true, '식사비 900K/인/일 의무', '2박 최소 숙박 의무', 2026;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================
-- SELECT * FROM hotel_info WHERE hotel_code = 'OAKWOOD';
-- SELECT room_code, room_name, room_category FROM room_type 
--   WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD') ORDER BY room_code;
-- SELECT rt.room_code, pm.season_key, pm.base_price, pm.day_of_week
-- FROM pricing_model pm
-- LEFT JOIN room_type rt ON pm.room_id = rt.room_id
-- WHERE pm.hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD')
-- ORDER BY rt.room_code, pm.date_range_start;
-- SELECT COUNT(*) FROM pricing_model WHERE hotel_id = (SELECT hotel_id FROM hotel_info WHERE hotel_code = 'OAKWOOD');
