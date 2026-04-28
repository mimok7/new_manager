-- ============================================
-- 파라다이스 레거시 크루즈 2026년 1박 2일 가격 UPDATE
-- 각 room×season = 1행 (모든 카테고리 가격을 컬럼에 저장)
-- ============================================

-- Step 0: 기존 모든 파라다이스 레거시 데이터 삭제
DELETE FROM cruise_rate_card 
WHERE cruise_name IN ('파라다이스 레거시', '파라다이스 레거시 크루즈')
  AND valid_year = 2026;

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name IN ('파라다이스 레거시', '파라다이스 레거시 크루즈')
  AND valid_year = 2026;

-- ============================================
-- 기간 1: 2026/01/01 - 04/30 (정가)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 디럭스 발코니
  ('파라다이스 레거시 크루즈', '1N2D', '디럭스 발코니', 'Deluxe Balcony',
   4550000, 3600000, 4550000, 4275000, 8100000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 이그제큐티브 발코니
  ('파라다이스 레거시 크루즈', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
   4800000, 3600000, 4800000, 4275000, 8600000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 레거시 스위트
  ('파라다이스 레거시 크루즈', '1N2D', '레거시 스위트', 'Legacy Suite',
   5850000, 3600000, 5850000, 4275000, 10300000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 갤러리 스위트
  ('파라다이스 레거시 크루즈', '1N2D', '갤러리 스위트', 'Gallery Suite',
   13100000, 3600000, 13100000, 4275000, 22900000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30');

-- ============================================
-- 기간 2: 2026/05/01 - 09/30 (프로모션, -3~5%)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 디럭스 발코니
  ('파라다이스 레거시 크루즈', '1N2D', '디럭스 발코니', 'Deluxe Balcony',
   4400000, 3350000, 4400000, 4025000, 7500000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 이그제큐티브 발코니
  ('파라다이스 레거시 크루즈', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
   4650000, 3350000, 4650000, 4025000, 8000000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 레거시 스위트
  ('파라다이스 레거시 크루즈', '1N2D', '레거시 스위트', 'Legacy Suite',
   5600000, 3350000, 5600000, 4025000, 9550000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 갤러리 스위트
  ('파라다이스 레거시 크루즈', '1N2D', '갤러리 스위트', 'Gallery Suite',
   13000000, 3350000, 13000000, 4025000, 22300000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30');

-- ============================================
-- 기간 3: 2026/10/01 - 12/31 (정가)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 디럭스 발코니
  ('파라다이스 레거시 크루즈', '1N2D', '디럭스 발코니', 'Deluxe Balcony',
   4550000, 3600000, 4550000, 4275000, 8100000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 이그제큐티브 발코니
  ('파라다이스 레거시 크루즈', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
   4800000, 3600000, 4800000, 4275000, 8600000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 레거시 스위트
  ('파라다이스 레거시 크루즈', '1N2D', '레거시 스위트', 'Legacy Suite',
   5850000, 3600000, 5850000, 4275000, 10300000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 갤러리 스위트
  ('파라다이스 레거시 크루즈', '1N2D', '갤러리 스위트', 'Gallery Suite',
   13100000, 3600000, 13100000, 4275000, 22900000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31');

-- ============================================
-- Step 1: 추가요금 (Holiday Surcharge) 입력
-- ============================================

INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, valid_year, currency)
VALUES
  ('파라다이스 레거시 크루즈', '1N2D', '2026-12-24', NULL, '크리스마스 이브 추가요금', 1350000, 2026, 'VND'),
  ('파라다이스 레거시 크루즈', '1N2D', '2026-12-31', NULL, '연말 추가요금', 1350000, 2026, 'VND');

-- ============================================
-- Step 2: 최종 검증
-- ============================================

SELECT '✅ 파라다이스 레거시 크루즈 레이트카드 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 총행수,
  schedule_type,
  COUNT(DISTINCT room_type) as 객실수,
  COUNT(DISTINCT valid_from) as 기간수
FROM cruise_rate_card
WHERE cruise_name = '파라다이스 레거시 크루즈'
  AND valid_year = 2026
GROUP BY schedule_type;

SELECT 
  room_type,
  valid_from,
  price_adult as 성인가격,
  price_child as 아동가격,
  price_extra_bed as 엑스트라베드,
  price_child_extra_bed as 아동엑스트라베드
FROM cruise_rate_card
WHERE cruise_name = '파라다이스 레거시 크루즈'
  AND valid_year = 2026
ORDER BY valid_from, room_type;

SELECT '✅ 파라다이스 레거시 크루즈 추가요금 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 추가요금행수,
  holiday_name,
  surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = '파라다이스 레거시 크루즈'
  AND valid_year = 2026
GROUP BY holiday_name, surcharge_per_person;
