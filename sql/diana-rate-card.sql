-- ============================================
-- 다이아나 크루즈 2026년 1박 2일 객실요금
-- 시즌별 가격 분리: 시즌1(정가) + 시즌2(8% 할인)
-- 각 room × season = 1행 (모든 카테고리 가격을 컬럼에 저장)
-- ============================================

-- Step 0: 기존 모든 다이아나 데이터 삭제
DELETE FROM cruise_rate_card 
WHERE cruise_name IN ('다이아나', '다이아나 크루즈')
  AND valid_year = 2026;

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name IN ('다이아나', '다이아나 크루즈')
  AND valid_year = 2026;

-- ============================================
-- Step 1: 객실요금 삽입 (6개 객실 × 2시즌 = 12행)
-- ============================================

INSERT INTO cruise_rate_card 
  (cruise_name, schedule_type, room_type, room_type_en, 
   price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single, 
   extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES 
  -- ========== 시즌 1: 2026/01/01 - 04/30, 2026/10/01 - 12/31 (정가) ==========
  
  -- 주니어 발코니 (1층)
  ('다이아나 크루즈', '1N2D-S1', '주니어 발코니 (1층)', 'Junior Balcony (1st Floor)',
   4700000, 3600000, 0, 4700000, NULL, 7650000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '시즌1 정가, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 시니어 발코니 (1층)
  ('다이아나 크루즈', '1N2D-S1', '시니어 발코니 (1층)', 'Senior Balcony (1st Floor)',
   5000000, 3800000, 0, 5000000, NULL, 8000000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '시즌1 정가, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 이그제큐티브 발코니 (2층)
  ('다이아나 크루즈', '1N2D-S1', '이그제큐티브 발코니 (2층)', 'Executive Balcony (2nd Floor)',
   5250000, 4000000, 0, 5250000, NULL, 8400000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '시즌1 정가, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 프리미어 발코니 (3층)
  ('다이아나 크루즈', '1N2D-S1', '프리미어 발코니 (3층)', 'Premier Balcony (3rd Floor)',
   5750000, 4400000, 0, 5750000, NULL, 9200000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '시즌1 정가, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 하롱 스위트 (2층 / VIP)
  ('다이아나 크루즈', '1N2D-S1', '하롱 스위트 (2층 / VIP)', 'Halong Suite (2nd Floor / VIP)',
   8600000, 6550000, 0, 8600000, NULL, 13800000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '시즌1 정가 VIP, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 란하 스위트 (3층 / VIP)
  ('다이아나 크루즈', '1N2D-S1', '란하 스위트 (3층 / VIP)', 'Lanha Suite (3rd Floor / VIP)',
   9750000, 7350000, 0, 9750000, NULL, 15500000,
   true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '시즌1 정가 VIP, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- ========== 시즌 2: 2026/05/01 - 09/30 (8% 할인 적용) ==========
  
  -- 주니어 발코니 (1층)
  ('다이아나 크루즈', '1N2D-S2', '주니어 발코니 (1층)', 'Junior Balcony (1st Floor)',
   4324000, 3312000, 0, 4324000, NULL, 7038000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '시즌2 8% 할인 적용, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 시니어 발코니 (1층)
  ('다이아나 크루즈', '1N2D-S2', '시니어 발코니 (1층)', 'Senior Balcony (1st Floor)',
   4600000, 3496000, 0, 4600000, NULL, 7360000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '시즌2 8% 할인 적용, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 이그제큐티브 발코니 (2층)
  ('다이아나 크루즈', '1N2D-S2', '이그제큐티브 발코니 (2층)', 'Executive Balcony (2nd Floor)',
   4830000, 3680000, 0, 4830000, NULL, 7728000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '시즌2 8% 할인 적용, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 프리미어 발코니 (3층)
  ('다이아나 크루즈', '1N2D-S2', '프리미어 발코니 (3층)', 'Premier Balcony (3rd Floor)',
   5290000, 4048000, 0, 5290000, NULL, 8464000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '시즌2 8% 할인 적용, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 하롱 스위트 (2층 / VIP)
  ('다이아나 크루즈', '1N2D-S2', '하롱 스위트 (2층 / VIP)', 'Halong Suite (2nd Floor / VIP)',
   7912000, 6026000, 0, 7912000, NULL, 12696000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '시즌2 8% 할인 적용 VIP, 엑스트라베드 가능, 싱글차지 가능'),
  
  -- 란하 스위트 (3층 / VIP)
  ('다이아나 크루즈', '1N2D-S2', '란하 스위트 (3층 / VIP)', 'Lanha Suite (3rd Floor / VIP)',
   8970000, 6762000, 0, 8970000, NULL, 14260000,
   true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '시즌2 8% 할인 적용 VIP, 엑스트라베드 가능, 싱글차지 가능');

-- ============================================
-- Step 2: 휴일 추가요금 삽입 (3개 기간/날짜)
-- ============================================

INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, surcharge_type, valid_year, currency, is_confirmed)
VALUES 
  -- 크리스마스 이브 (단일)
  ('다이아나 크루즈', '1N2D', '2026-12-24', NULL, '크리스마스 이브', 1300000, 'per_person', 2026, 'VND', true),
  
  -- 연말연시 (단일)
  ('다이아나 크루즈', '1N2D', '2026-12-31', NULL, '연말연시', 1300000, 'per_person', 2026, 'VND', true),
  
  -- 토요일 추가요금 (6월 이후 - 별도 처리 필요)
  ('다이아나 크루즈', '1N2D', '2026-06-01', NULL, '주말추가 (6-8월 토요일)', 350000, 'per_person', 2026, 'VND', false);

-- 참고: 6월~8월 매주 토요일 추가 (350,000동/인)
-- 2026년 6-8월 토요일: 06-06, 06-13, 06-20, 06-27, 07-04, 07-11, 07-18, 07-25, 08-01, 08-08, 08-15, 08-22, 08-29
-- 필요시 별도로 입력 시스템을 통해 각 토요일마다 1행씩 추가하거나
-- 예약 단계에서 토요일 여부를 자동 판단하여 추가요금 적용

-- ============================================
-- Step 3: 최종 검증
-- ============================================

SELECT '✅ 다이아나 크루즈 레이트카드 데이터 업데이트 완료' AS 결과;

SELECT 
  COUNT(*) as 총행수,
  schedule_type as 시즌,
  COUNT(DISTINCT room_type) as 객실수
FROM cruise_rate_card
WHERE cruise_name = '다이아나 크루즈'
  AND valid_year = 2026
GROUP BY schedule_type
ORDER BY schedule_type;

-- 시즌 1 데이터 확인
SELECT '=== 시즌 1 (정가) 2026/01/01 - 04/30, 10/01 - 12/31 ===' AS 검증;

SELECT 
  room_type as 객실명,
  price_adult as 성인,
  price_child as 아동,
  price_extra_bed as 엑스트라,
  price_single as 싱글차지
FROM cruise_rate_card
WHERE cruise_name = '다이아나 크루즈'
  AND valid_year = 2026
  AND schedule_type = '1N2D-S1'
ORDER BY room_type;

-- 시즌 2 데이터 확인
SELECT '=== 시즌 2 (8% 할인) 2026/05/01 - 09/30 ===' AS 검증;

SELECT 
  room_type as 객실명,
  price_adult as 성인,
  price_child as 아동,
  price_extra_bed as 엑스트라,
  price_single as 싱글차지
FROM cruise_rate_card
WHERE cruise_name = '다이아나 크루즈'
  AND valid_year = 2026
  AND schedule_type = '1N2D-S2'
ORDER BY room_type;

-- 휴일 추가요금 확인
SELECT '--- 휴일 추가요금 확인 ---' AS 검증;

SELECT 
  holiday_date as 시작일,
  holiday_name as 휴일명,
  surcharge_per_person as 인당추가요금,
  CASE 
    WHEN is_confirmed THEN '확정' 
    ELSE '미정' 
  END as 상태
FROM cruise_holiday_surcharge
WHERE cruise_name = '다이아나 크루즈'
  AND valid_year = 2026
ORDER BY holiday_date;
