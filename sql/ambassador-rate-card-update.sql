-- ============================================
-- 엠바사더 시그니처 크루즈 2026년 1박 2일 가격 입력
-- (cruise_rate_card 테이블용 - NEW)
-- ============================================

-- Step 0: 기존 엠바사더 크루즈 레이트카드 삭제 (재입력 위해)
DELETE FROM cruise_rate_card 
WHERE cruise_name = '엠바사더 시그니처'
  AND valid_year = 2026;

-- Step 1: 발코니 객실 (1박 2일)
INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_child, price_infant, 
   price_extra_bed, price_single, price_child_extra_bed, extra_bed_available, valid_year, currency, is_active)
VALUES
  ('엠바사더 시그니처', '1N2D', '발코니', 'Balcony', 3750000, 2750000, 950000, 3750000, 6800000, 2750000, true, 2026, 'VND', true);

-- Step 2: 이그제큐티브 객실 (1박 2일)
INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_child, price_infant, 
   price_extra_bed, price_single, price_child_extra_bed, extra_bed_available, valid_year, currency, is_active)
VALUES
  ('엠바사더 시그니처', '1N2D', '이그제큐티브', 'Executive', 4000000, 2750000, 950000, 4000000, 7300000, 2750000, true, 2026, 'VND', true);

-- Step 3: 발코니 스위트 객실 (1박 2일)
INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_child, price_infant, 
   price_extra_bed, price_single, price_child_extra_bed, extra_bed_available, valid_year, currency, is_active)
VALUES
  ('엠바사더 시그니처', '1N2D', '발코니 스위트', 'Balcony Suite', 4700000, 2750000, 950000, 4700000, 8800000, 2750000, true, 2026, 'VND', true);

-- Step 4: 캡틴 뷰 엠바사더 스위트 객실 (1박 2일)
INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_child, price_infant, 
   price_extra_bed, price_single, price_child_extra_bed, extra_bed_available, valid_year, currency, is_active)
VALUES
  ('엠바사더 시그니처', '1N2D', '캡틴 뷰 스위트', 'Captain View Suite', 5050000, 2750000, 950000, 5050000, 9450000, 2750000, true, 2026, 'VND', true);

-- Step 5: 기존 시즌별 추가요금 삭제 (재입력 위해)
DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '엠바사더 시그니처'
  AND valid_year = 2026;

-- Step 6: 시즌별 추가요금 입력
INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, valid_year, currency)
VALUES
  -- 일별 추가요금: 12월 24일만
  ('엠바사더 시그니처', '1N2D', '2026-12-24', NULL, '크리스마스 이브 추가요금', 1350000, 2026, 'VND'),
  
  -- 일별 추가요금: 12월 31일만
  ('엠바사더 시그니처', '1N2D', '2026-12-31', NULL, '연말 특수요금', 1350000, 2026, 'VND'),
  
  -- 일별 추가요금: 9월 2일만 (베트남 국경일)
  ('엠바사더 시그니처', '1N2D', '2026-09-02', NULL, '베트남 국경일 추가요금', 800000, 2026, 'VND'),
  
  -- 기간 추가요금: 4월 30일 ~ 5월 1일 (미정)
  ('엠바사더 시그니처', '1N2D', '2026-04-30', '2026-05-01', '5월 연휴 추가요금', 0, 2026, 'VND');

-- ============================================
-- 최종 확인 쿼리 (Step 7)
-- ============================================
SELECT '✅ 레이트카드 데이터 입력 완료' AS result;
SELECT 
  cruise_name,
  room_type,
  price_adult,
  price_child,
  price_infant,
  price_extra_bed,
  price_single
FROM cruise_rate_card
WHERE cruise_name = '엠바사더 시그니처'
  AND valid_year = 2026
ORDER BY room_type;

-- 추가요금 확인
SELECT '✅ 추가요금 데이터 입력 완료' AS result;
SELECT 
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = '엠바사더 시그니처'
  AND valid_year = 2026
ORDER BY holiday_date;
