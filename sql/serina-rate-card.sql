-- ============================================
-- 세리나 크루즈 2026년 1박 2일 사전예약 특별요금
-- 각 room×season = 1행 (모든 카테고리 가격을 컬럼에 저장)
-- ============================================

-- Step 0: 기존 모든 세리나 데이터 삭제
DELETE FROM cruise_rate_card 
WHERE cruise_name IN ('세리나', '세리나 크루즈')
  AND valid_year = 2026;

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name IN ('세리나', '세리나 크루즈')
  AND valid_year = 2026;

-- ============================================
-- 사전예약 프로모션: 2026/01/01 - 12/31
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES 
  -- 오션 발코니
  ('세리나 크루즈', '1N2D', '오션 발코니', 'Ocean Balcony',
   4350000, 3300000, NULL, 3900000, 3700000, 7500000,
   true, 2026, 'VND', true, '2026-01-01', '2026-12-31', '사전예약 프로모션'),
  -- 시니어 발코니
  ('세리나 크루즈', '1N2D', '시니어 발코니', 'Senior Balcony',
   4600000, 3500000, NULL, 4150000, 3950000, 8000000,
   true, 2026, 'VND', true, '2026-01-01', '2026-12-31', '사전예약 프로모션'),
  -- 이그제큐티브 발코니
  ('세리나 크루즈', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
   5000000, 3800000, NULL, 4525000, 4300000, 8700000,
   true, 2026, 'VND', true, '2026-01-01', '2026-12-31', '사전예약 프로모션'),
  -- 문스위트 (VIP)
  ('세리나 크루즈', '1N2D', '문스위트', 'Moon Suite (VIP)',
   7450000, 5650000, NULL, 6750000, 6350000, 12900000,
   true, 2026, 'VND', true, '2026-01-01', '2026-12-31', '사전예약 프로모션, VIP'),
  -- 프레지던트 (VVIP)
  ('세리나 크루즈', '1N2D', '프레지던트', 'President (VVIP)',
   15900000, 11900000, NULL, 14300000, 13500000, 27200000,
   true, 2026, 'VND', true, '2026-01-01', '2026-12-31', '사전예약 프로모션, VVIP');

-- ============================================
-- Step 1: 최종 검증
-- ============================================

SELECT '✅ 세리나 크루즈 레이트카드 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 총행수,
  schedule_type,
  COUNT(DISTINCT room_type) as 객실수,
  COUNT(DISTINCT valid_from) as 기간수
FROM cruise_rate_card
WHERE cruise_name = '세리나 크루즈'
  AND valid_year = 2026
GROUP BY schedule_type;

SELECT 
  room_type,
  valid_from,
  valid_to,
  price_adult as 성인가격,
  price_child as 아동가격,
  price_child_extra_bed as 아동엑스트라,
  price_extra_bed as 성인엑스트라베드,
  price_single as 싱글차지,
  notes
FROM cruise_rate_card
WHERE cruise_name = '세리나 크루즈'
  AND valid_year = 2026
ORDER BY valid_from, room_type;
