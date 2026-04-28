-- =====================================================
-- 014-grand-pioneers-rate-card.sql
-- Grand Pioneers Cruise 요금 정보 (cruise_rate_card 테이블)
-- cruise_info 테이블의 8개 객실 타입 연동
-- 크루즈명: '그랜드 파이어니스 크루즈' (012와 동기화)
-- =====================================================
-- 필수: 011-cruise-info-columns.sql, 012-grand-pioneers-cruise-data.sql 실행 후 진행

-- 기존 Grand Pioneers 요금 데이터 삭제 (재실행 가능하도록)
DELETE FROM cruise_rate_card 
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D';

-- =====================================================
-- 2026년 1박2일 (1N2D) 기준 요금
-- 기간 1: 2026/01/01 - 04/30 (정가 시즌)
-- =====================================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_single,
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, display_order)
VALUES 
  -- 1. Ocean Suite (오션 스위트)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Suite', 'Ocean Suite',
   3200000, 2400000, 2800000, 5600000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', 1),
   
  -- 2. Ocean Suite TLP (3인실)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Suite TLP', 'Ocean Suite TLP',
   3100000, 2300000, NULL, 5400000,
   false, 2026, 'VND', true, '2026-01-01', '2026-04-30', 2),
   
  -- 3. Ocean Balcony Suite (발코니)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Balcony Suite', 'Ocean Balcony Suite',
   3900000, 2900000, 3400000, 6800000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', 3),
   
  -- 4. Veranda Suite (베란다 - 추천)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Veranda Suite', 'Veranda Suite',
   4200000, 3100000, 3700000, 7300000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', 4),
   
  -- 5. Executive Suite (레스토랑 근접)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Executive Suite', 'Executive Suite',
   4400000, 3200000, 3800000, 7600000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', 5),
   
  -- 6. The Essence Suite (VIP)
  ('그랜드 파이어니스 크루즈', '1N2D', 'The Essence Suite', 'The Essence Suite',
   5300000, 3900000, 4600000, 9100000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', 6),
   
  -- 7. Oceania Suite (VIP큰방)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Oceania Suite', 'Oceania Suite',
   6500000, 4700000, 5700000, 11200000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', 7),
   
  -- 8. The Owners Suite (프리미엄 VIP)
  ('그랜드 파이어니스 크루즈', '1N2D', 'The Owners Suite', 'The Owners Suite',
   8200000, 5900000, 7100000, 14100000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', 8);

-- =====================================================
-- 기간 2: 2026/05/01 - 09/30 (프로모션 기간)
-- 평상시 대비 10% 할인
-- =====================================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_single,
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, display_order)
VALUES 
  -- 1. Ocean Suite
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Suite', 'Ocean Suite',
   2880000, 2160000, 2520000, 5040000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', 1),
   
  -- 2. Ocean Suite TLP
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Suite TLP', 'Ocean Suite TLP',
   2790000, 2070000, NULL, 4860000,
   false, 2026, 'VND', true, '2026-05-01', '2026-09-30', 2),
   
  -- 3. Ocean Balcony Suite
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Balcony Suite', 'Ocean Balcony Suite',
   3510000, 2610000, 3060000, 6120000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', 3),
   
  -- 4. Veranda Suite (추천)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Veranda Suite', 'Veranda Suite',
   3780000, 2790000, 3330000, 6570000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', 4),
   
  -- 5. Executive Suite
  ('그랜드 파이어니스 크루즈', '1N2D', 'Executive Suite', 'Executive Suite',
   3960000, 2880000, 3420000, 6840000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', 5),
   
  -- 6. The Essence Suite (VIP)
  ('그랜드 파이어니스 크루즈', '1N2D', 'The Essence Suite', 'The Essence Suite',
   4770000, 3510000, 4140000, 8190000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', 6),
   
  -- 7. Oceania Suite (VIP큰방)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Oceania Suite', 'Oceania Suite',
   5850000, 4230000, 5130000, 10080000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', 7),
   
  -- 8. The Owners Suite (프리미엄 VIP)
  ('그랜드 파이어니스 크루즈', '1N2D', 'The Owners Suite', 'The Owners Suite',
   7380000, 5310000, 6390000, 12690000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', 8);

-- =====================================================
-- 기간 3: 2026/10/01 - 12/31 (성수기)
-- 평상시 대비 15% 인상
-- =====================================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_extra_bed, price_single,
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, display_order)
VALUES 
  -- 1. Ocean Suite
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Suite', 'Ocean Suite',
   3680000, 2760000, 3220000, 6440000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31', 1),
   
  -- 2. Ocean Suite TLP
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Suite TLP', 'Ocean Suite TLP',
   3565000, 2645000, NULL, 6210000,
   false, 2026, 'VND', true, '2026-10-01', '2026-12-31', 2),
   
  -- 3. Ocean Balcony Suite
  ('그랜드 파이어니스 크루즈', '1N2D', 'Ocean Balcony Suite', 'Ocean Balcony Suite',
   4485000, 3335000, 3910000, 7820000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31', 3),
   
  -- 4. Veranda Suite (추천)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Veranda Suite', 'Veranda Suite',
   4830000, 3565000, 4255000, 8395000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31', 4),
   
  -- 5. Executive Suite
  ('그랜드 파이어니스 크루즈', '1N2D', 'Executive Suite', 'Executive Suite',
   5060000, 3680000, 4370000, 8740000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31', 5),
   
  -- 6. The Essence Suite (VIP)
  ('그랜드 파이어니스 크루즈', '1N2D', 'The Essence Suite', 'The Essence Suite',
   6095000, 4485000, 5290000, 10465000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31', 6),
   
  -- 7. Oceania Suite (VIP큰방)
  ('그랜드 파이어니스 크루즈', '1N2D', 'Oceania Suite', 'Oceania Suite',
   7475000, 5405000, 6555000, 12880000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31', 7),
   
  -- 8. The Owners Suite (프리미엄 VIP)
  ('그랜드 파이어니스 크루즈', '1N2D', 'The Owners Suite', 'The Owners Suite',
   9430000, 6785000, 8165000, 16215000,
   true, 2026, 'VND', true, '2026-10-01', '2026-12-31', 8);

-- =====================================================
-- 검증 쿼리
-- =====================================================
SELECT 
  cruise_name, schedule_type, room_type, COUNT(*) as count
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
GROUP BY cruise_name, schedule_type, room_type
ORDER BY schedule_type, room_type;
