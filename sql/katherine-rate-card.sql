-- ============================================
-- 캐서린 크루즈 2026년 1박 2일 객실요금
-- 각 room = 1행 (모든 카테고리 가격을 컬럼에 저장)
-- ============================================

-- Step 0: 기존 모든 캐서린 데이터 삭제
DELETE FROM cruise_rate_card 
WHERE cruise_name IN ('캐서린', '캐서린 크루즈')
  AND valid_year = 2026;

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name IN ('캐서린', '캐서린 크루즈')
  AND valid_year = 2026;

-- ============================================
-- Step 1: 객실요금 삽입 (7개 객실)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES 
  -- 프리미어 스위트 (1층)
  ('캐서린 크루즈', '1N2D', '프리미어 스위트 (1층)', 'Premier Suite (1st Floor)',
   5300000, 3300000, NULL, 4700000, NULL, 8450000,
   true, 2026, 'VND', true, '2026-01-01', '2026-12-31', '엑스트라베드 가능, 싱글차지 가능'),
  
  -- 프리미어 스위트 트리플 (1층)
  ('캐서린 크루즈', '1N2D', '프리미어 스위트 트리플 (1층)', 'Premier Suite Triple (1st Floor)',
   5300000, NULL, NULL, NULL, NULL, NULL,
   false, 2026, 'VND', true, '2026-01-01', '2026-12-31', '성인만 가능, 아동 불가, 엑스트라베드 불가, 싱글차지 불가'),
  
  -- 프리미어 스위트 (2층)
  ('캐서린 크루즈', '1N2D', '프리미어 스위트 (2층)', 'Premier Suite (2nd Floor)',
   5600000, 5000000, NULL, NULL, NULL, 8900000,
   false, 2026, 'VND', true, '2026-01-01', '2026-12-31', '엑스트라베드 없음, 싱글차지 가능'),
  
  -- 프리미어 스위트 (3층)
  ('캐서린 크루즈', '1N2D', '프리미어 스위트 (3층)', 'Premier Suite (3rd Floor)',
   5800000, 5250000, NULL, NULL, NULL, 9350000,
   false, 2026, 'VND', true, '2026-01-01', '2026-12-31', '엑스트라베드 없음, 싱글차지 가능'),
  
  -- 로얄 스위트
  ('캐서린 크루즈', '1N2D', '로얄 스위트', 'Royal Suite',
   7500000, 6700000, NULL, NULL, NULL, 12500000,
   false, 2026, 'VND', true, '2026-01-01', '2026-12-31', '엑스트라베드 없음, 싱글차지 가능'),
  
  -- 그랜드 스위트
  ('캐서린 크루즈', '1N2D', '그랜드 스위트', 'Grand Suite',
   8350000, 7500000, NULL, NULL, NULL, 14100000,
   false, 2026, 'VND', true, '2026-01-01', '2026-12-31', '엑스트라베드 없음, 싱글차지 가능'),
  
  -- 빌라 프레지던트
  ('캐서린 크루즈', '1N2D', '빌라 프레지던트', 'Villa President',
   15800000, 3500000, NULL, 14200000, NULL, 29150000,
   true, 2026, 'VND', true, '2026-01-01', '2026-12-31', '최고급, 아동 저가, 엑스트라베드 가능, 싱글차지 가능');

-- ============================================
-- Step 2: 휴일 추가요금 삽입 (4개 기간)
-- ============================================

INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, surcharge_type, valid_year, currency, is_confirmed)
VALUES 
  -- 노동절 연휴: 2026/04/30 - 2026/05/01 (기간)
  ('캐서린 크루즈', '1N2D', '2026-04-30', '2026-05-01', '노동절 연휴', 1200000, 'per_person', 2026, 'VND', true),
  
  -- 크리스마스 이브
  ('캐서린 크루즈', '1N2D', '2026-12-24', NULL, '크리스마스 이브', 1200000, 'per_person', 2026, 'VND', true),
  
  -- 연말연시
  ('캐서린 크루즈', '1N2D', '2026-12-31', NULL, '연말연시', 1200000, 'per_person', 2026, 'VND', true);

-- ============================================
-- Step 3: 최종 검증
-- ============================================

SELECT '✅ 캐서린 크루즈 레이트카드 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 총행수,
  schedule_type,
  COUNT(DISTINCT room_type) as 객실수
FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈'
  AND valid_year = 2026
GROUP BY schedule_type;

SELECT 
  room_type,
  price_adult as 성인,
  price_child as 아동,
  price_extra_bed as 엑스트라,
  price_single as 싱글차지,
  extra_bed_available as 엑스트라가능,
  notes
FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈'
  AND valid_year = 2026
ORDER BY room_type;

SELECT '--- 휴일 추가요금 확인 ---' AS 검증;

SELECT 
  holiday_date as 시작일,
  holiday_date_end as 종료일,
  holiday_name as 휴일명,
  surcharge_per_person as 인당추가요금,
  surcharge_type as 타입
FROM cruise_holiday_surcharge
WHERE cruise_name = '캐서린 크루즈'
  AND valid_year = 2026
ORDER BY holiday_date;
