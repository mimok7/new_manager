-- ============================================
-- 칼리스타 크루즈 2026년 1박 2일 가격 UPDATE (컬럼 구조 올바로 수정)
-- 각 room×season = 1행 (모든 카테고리 가격을 컬럼에 저장)
-- ============================================

-- Step 0: 기존 모든 칼리스타 데이터 삭제 (구형 '칼리스타' 포함)
DELETE FROM cruise_rate_card 
WHERE cruise_name IN ('칼리스타 크루즈', '칼리스타')
  AND valid_year = 2026;

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name IN ('칼리스타 크루즈', '칼리스타')
  AND valid_year = 2026;

-- ============================================
-- 기간 1: 2026/01/01 - 04/30 (정가)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 칼리스타 오션
  ('칼리스타 크루즈', '1N2D', '칼리스타 오션', 'Calista Ocean',
   4650000, 2775000, 2950000, 4650000, 3825000, 7900000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 칼리스타 베이
  ('칼리스타 크루즈', '1N2D', '칼리스타 베이', 'Calista Bay',
   5000000, 2775000, 2950000, 5000000, 3825000, 9300000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- 칼리스타 레거시
  ('칼리스타 크루즈', '1N2D', '칼리스타 레거시', 'Calista Legacy',
   6000000, 2775000, 2950000, 6000000, 3825000, 10200000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- Horizon Suite
  ('칼리스타 크루즈', '1N2D', 'Horizon Suite', 'Horizon Suite',
   9100000, 2775000, 2950000, 9100000, 3825000, 15500000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- Majesty Suite
  ('칼리스타 크루즈', '1N2D', 'Majesty Suite', 'Majesty Suite',
   10200000, 2775000, 2950000, 10200000, 3825000, 17450000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30'),
  -- President Suite (엑스트라베드 불가)
  ('칼리스타 크루즈', '1N2D', 'President Suite', 'President Suite',
   22300000, 2775000, 2950000, NULL, NULL, 37900000,
   false, 2026, 'VND', true, '2026-01-01', '2026-04-30');

-- ============================================
-- 기간 2: 2026/05/01 - 09/30 (프로모션, -14% ~ -23%)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 칼리스타 오션
  ('칼리스타 크루즈', '1N2D', '칼리스타 오션', 'Calista Ocean',
   3975000, 2775000, 2950000, 3975000, 3825000, 6800000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 칼리스타 베이
  ('칼리스타 크루즈', '1N2D', '칼리스타 베이', 'Calista Bay',
   4250000, 2775000, 2950000, 4250000, 3825000, 7250000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- 칼리스타 레거시
  ('칼리스타 크루즈', '1N2D', '칼리스타 레거시', 'Calista Legacy',
   4650000, 2775000, 2950000, 4650000, 3825000, 7950000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- Horizon Suite
  ('칼리스타 크루즈', '1N2D', 'Horizon Suite', 'Horizon Suite',
   8300000, 2775000, 2950000, 8300000, 3825000, 14100000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- Majesty Suite
  ('칼리스타 크루즈', '1N2D', 'Majesty Suite', 'Majesty Suite',
   9400000, 2775000, 2950000, 9400000, 3825000, 16000000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30'),
  -- President Suite (엑스트라베드 불가)
  ('칼리스타 크루즈', '1N2D', 'President Suite', 'President Suite',
   20150000, 2775000, 2950000, NULL, NULL, 34300000,
   false, 2026, 'VND', true, '2026-05-01', '2026-09-30');

-- ============================================
-- 기간 3: 2026/10/01 - 12/31 (정가, 일부 상승)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to)
VALUES 
  -- 칼리스타 오션
  ('칼리스타 크루즈', '1N2D', '칼리스타 오션', 'Calista Ocean',
   4650000, 2775000, 2950000, 4650000, 3825000, 7900000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 칼리스타 베이 (+9.5% 상승)
  ('칼리스타 크루즈', '1N2D', '칼리스타 베이', 'Calista Bay',
   5475000, 2775000, 2950000, 5475000, 3825000, 9300000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- 칼리스타 레거시
  ('칼리스타 크루즈', '1N2D', '칼리스타 레거시', 'Calista Legacy',
   6000000, 2775000, 2950000, 6000000, 3825000, 10200000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- Horizon Suite
  ('칼리스타 크루즈', '1N2D', 'Horizon Suite', 'Horizon Suite',
   9100000, 2775000, 2950000, 9100000, 3825000, 15500000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- Majesty Suite
  ('칼리스타 크루즈', '1N2D', 'Majesty Suite', 'Majesty Suite',
   10200000, 2775000, 2950000, 10200000, 3825000, 17450000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31'),
  -- President Suite (엑스트라베드 불가)
  ('칼리스타 크루즈', '1N2D', 'President Suite', 'President Suite',
   22300000, 2775000, 2950000, NULL, NULL, 37900000,
   false, 2026, 'VND', true, '2026-10-01', '2026-12-31');

-- ============================================
-- Step 1: 추가요금 (Holiday Surcharge) 입력
-- ============================================

INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, valid_year, currency)
VALUES
  ('칼리스타 크루즈', '1N2D', '2026-04-30', '2026-05-01', '5월 연휴 추가요금', 1200000, 2026, 'VND'),
  ('칼리스타 크루즈', '1N2D', '2026-12-24', NULL, '크리스마스 이브 추가요금', 1200000, 2026, 'VND'),
  ('칼리스타 크루즈', '1N2D', '2026-12-31', NULL, '연말 추가요금', 1200000, 2026, 'VND');

-- ============================================
-- Step 2: 최종 검증
-- ============================================

SELECT '✅ 칼리스타 크루즈 레이트카드 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 총행수,
  schedule_type,
  COUNT(DISTINCT room_type) as 객실수,
  COUNT(DISTINCT valid_from) as 기간수
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND valid_year = 2026
GROUP BY schedule_type;

SELECT 
  room_type,
  valid_from,
  price_adult as 성인가격,
  price_child as 아동가격,
  price_infant as 유아가격,
  price_extra_bed as 엑스트라베드,
  price_child_extra_bed as 아동엑스트라베드
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND valid_year = 2026
ORDER BY valid_from, room_type;

SELECT '✅ 칼리스타 크루즈 추가요금 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 추가요금행수,
  holiday_name,
  surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = '칼리스타 크루즈'
  AND valid_year = 2026
GROUP BY holiday_name, surcharge_per_person;
