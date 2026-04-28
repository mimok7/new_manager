-- ============================================
-- 할로라 크루즈 2026년 1박 2일 가격 UPDATE
-- 각 room×season = 1행 (모든 카테고리 가격을 컬럼에 저장)
-- ============================================

-- Step 0: 기존 모든 할로라 데이터 삭제
DELETE FROM cruise_rate_card 
WHERE cruise_name IN ('할로라', '할로라 크루즈')
  AND valid_year = 2026;

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name IN ('할로라', '할로라 크루즈')
  AND valid_year = 2026;

-- ============================================
-- 기간 1: 2026/01/01 - 05/31 (오프닝 특별요금)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES 
  -- 디럭스룸
  ('할로라 크루즈', '1N2D', '디럭스룸', 'Deluxe Room',
   3650000, 2750000, 1900000, 2950000, NULL, 6150000,
   true, 2026, 'VND', true, '2026-01-01', '2026-05-31', '아동(8-11세)=2.75M, 아동(5-7세)=1.9M'),
  -- 프리미엄룸
  ('할로라 크루즈', '1N2D', '프리미엄룸', 'Premium Room',
   3850000, 2950000, 2000000, 3100000, NULL, 6450000,
   true, 2026, 'VND', true, '2026-01-01', '2026-05-31', '아동(8-11세)=2.95M, 아동(5-7세)=2M'),
  -- 프리미엄 트리플룸
  ('할로라 크루즈', '1N2D', '프리미엄 트리플룸', 'Premium Triple Room',
   3850000, 2950000, 2000000, NULL, NULL, NULL,
   false, 2026, 'VND', true, '2026-01-01', '2026-05-31', '엑스트라베드 불가, 싱글차지 불가'),
  -- 스위트룸
  ('할로라 크루즈', '1N2D', '스위트룸', 'Suite Room',
   4575000, 3450000, 2350000, 3700000, NULL, 7600000,
   true, 2026, 'VND', true, '2026-01-01', '2026-05-31', '아동(8-11세)=3.45M, 아동(5-7세)=2.35M'),
  -- 그랜드 스위트 룸
  ('할로라 크루즈', '1N2D', '그랜드 스위트 룸', 'Grand Suite Room',
   6775000, 5100000, 3450000, 5450000, NULL, 11150000,
   true, 2026, 'VND', true, '2026-01-01', '2026-05-31', '아동(8-11세)=5.1M, 아동(5-7세)=3.45M');

-- ============================================
-- 기간 2: 2026/06/01 - 12/31 (정상요금)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES 
  -- 디럭스룸
  ('할로라 크루즈', '1N2D', '디럭스룸', 'Deluxe Room',
   4275000, 3250000, 2225000, 3450000, NULL, 7150000,
   true, 2026, 'VND', true, '2026-06-01', '2026-12-31', '아동(8-11세)=3.25M, 아동(5-7세)=2.225M'),
  -- 프리미엄룸
  ('할로라 크루즈', '1N2D', '프리미엄룸', 'Premium Room',
   4500000, 3400000, 2350000, 3625000, NULL, 7500000,
   true, 2026, 'VND', true, '2026-06-01', '2026-12-31', '아동(8-11세)=3.4M, 아동(5-7세)=2.35M'),
  -- 프리미엄 트리플룸
  ('할로라 크루즈', '1N2D', '프리미엄 트리플룸', 'Premium Triple Room',
   4500000, 3400000, 2350000, NULL, NULL, NULL,
   false, 2026, 'VND', true, '2026-06-01', '2026-12-31', '엑스트라베드 불가, 싱글차지 불가'),
  -- 스위트룸
  ('할로라 크루즈', '1N2D', '스위트룸', 'Suite Room',
   5200000, 3950000, 2700000, 4200000, NULL, 8600000,
   true, 2026, 'VND', true, '2026-06-01', '2026-12-31', '아동(8-11세)=3.95M, 아동(5-7세)=2.7M'),
  -- 그랜드 스위트 룸
  ('할로라 크루즈', '1N2D', '그랜드 스위트 룸', 'Grand Suite Room',
   7700000, 5800000, 3950000, 6200000, NULL, 12600000,
   true, 2026, 'VND', true, '2026-06-01', '2026-12-31', '아동(8-11세)=5.8M, 아동(5-7세)=3.95M');

-- ============================================
-- Step 1: 최종 검증
-- ============================================

SELECT '✅ 할로라 크루즈 레이트카드 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 총행수,
  schedule_type,
  COUNT(DISTINCT room_type) as 객실수,
  COUNT(DISTINCT valid_from) as 기간수
FROM cruise_rate_card
WHERE cruise_name = '할로라 크루즈'
  AND valid_year = 2026
GROUP BY schedule_type;

SELECT 
  room_type,
  valid_from,
  price_adult as 성인가격,
  price_child as 아동811,
  price_infant as 아동57,
  price_extra_bed as 엑스트라베드,
  price_single as 싱글차지,
  notes
FROM cruise_rate_card
WHERE cruise_name = '할로라 크루즈'
  AND valid_year = 2026
ORDER BY valid_from, room_type;
