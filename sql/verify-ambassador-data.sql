-- ============================================
-- 엠바사더 크루즈 실제 데이터 확인 (수정 금지)
-- ============================================

-- 1️⃣ 모든 엠바사더 크루즈 데이터 조회
SELECT 'ALL AMBASSADOR CRUISE DATA' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price,
  schedule
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
ORDER BY room_code, room_type;

-- 2️⃣ 객실별 요금 현황 (pivot 형태)
SELECT 'ROOM PRICE SUMMARY BY CATEGORY' AS check_point;
SELECT 
  room_category,
  COUNT(*) as total_records
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
GROUP BY room_category
ORDER BY room_category;

-- 3️⃣ room_type별 개수 확인
SELECT 'SUMMARY BY ROOM_TYPE' AS check_point;
SELECT 
  room_type,
  COUNT(*) as count,
  STRING_AGG(DISTINCT room_category, ', ') as room_categories
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
GROUP BY room_type
ORDER BY room_type;

-- 4️⃣ 발코니 객실의 모든 요금 조회
SELECT 'BALCONY ROOM DETAILS' AS check_point;
SELECT 
  room_code,
  room_type,
  price,
  payment
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
  AND room_category = '발코니'
ORDER BY room_code;

-- 5️⃣ 추가요금 확인
SELECT 'HOLIDAY SURCHARGE' AS check_point;
SELECT 
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = 'Ambassador Signature Cruise'
ORDER BY holiday_date;
