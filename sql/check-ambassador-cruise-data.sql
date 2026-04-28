-- ============================================
-- 엠바사더 크루즈 데이터 입력 확인 쿼리
-- ============================================

-- 1️⃣ 공통 아동/유아 요금 확인
SELECT '【Step 1: 공통 아동/유아 요금】' AS check_point;
SELECT 
  room_code,
  room_category,
  cruise,
  room_type,
  price,
  schedule,
  payment
FROM room_price
WHERE room_code IN ('COMMON-CHILD', 'COMMON-INFANT')
  AND cruise = 'Ambassador Signature Cruise'
ORDER BY room_code;

-- 2️⃣ 성인 요금 확인
SELECT '【Step 2: 성인 요금 (객실별)】' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price,
  schedule
FROM room_price
WHERE room_code LIKE 'R-AMB-%'
  AND room_type = '성인'
  AND cruise = 'Ambassador Signature Cruise'
ORDER BY room_code;

-- 3️⃣ 엑스트라베드 확인
SELECT '【Step 3: 엑스트라베드 (객실별)】' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price,
  schedule
FROM room_price
WHERE room_code LIKE 'R-AMB-%'
  AND room_type = '엑스트라베드'
  AND cruise = 'Ambassador Signature Cruise'
ORDER BY room_code;

-- 4️⃣ 싱글차지 확인
SELECT '【Step 4: 싱글차지 (객실별)】' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price,
  schedule
FROM room_price
WHERE room_code LIKE 'R-AMB-%'
  AND room_type = '싱글차지'
  AND cruise = 'Ambassador Signature Cruise'
ORDER BY room_code;

-- 5️⃣ 시즌별 추가요금 확인
SELECT '【Step 5: 시즌별 추가요금】' AS check_point;
SELECT 
  cruise_name,
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person,
  valid_year,
  currency
FROM cruise_holiday_surcharge
WHERE cruise_name = 'Ambassador Signature Cruise'
  AND valid_year = 2026
ORDER BY holiday_date;

-- 6️⃣ 전체 입력 데이터 수 확인
SELECT '【전체 입력 데이터 수】' AS check_point;
SELECT 
  'room_price (Ambassador)' AS table_name,
  COUNT(*) AS count
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'

UNION ALL

SELECT 
  'cruise_holiday_surcharge (Ambassador)',
  COUNT(*)
FROM cruise_holiday_surcharge
WHERE cruise_name = 'Ambassador Signature Cruise'
  AND valid_year = 2026;

-- 7️⃣ 예약 시스템에서 아동 요금 조회 방식 확인
SELECT '【현재 room_price 테이블 구조】' AS check_point;
SELECT 
  room_code,
  room_category,
  cruise,
  room_type,
  price
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
LIMIT 20;
