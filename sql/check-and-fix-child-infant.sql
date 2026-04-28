-- ============================================
-- 엠바사더 크루즈 아동/유아 요금 확인 및 재입력
-- ============================================

-- 1️⃣ 현재 입력된 데이터 확인
SELECT 'Step 1: 현재 room_price 데이터 확인' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price,
  cruise
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
ORDER BY room_code;

-- 2️⃣ 아동/유아 데이터만 확인
SELECT 'Step 2: 아동/유아 데이터만 조회' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
  AND room_type IN ('아동', '유아');

-- 3️⃣ CHILD, INFANT 키워드로도 확인
SELECT 'Step 3: CHILD/INFANT 키워드 검색' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
  AND (room_code LIKE '%CHILD%' OR room_code LIKE '%INFANT%');

-- 4️⃣ 성인만 입력된 데이터 확인
SELECT 'Step 4: 성인 데이터 확인' AS check_point;
SELECT 
  room_code,
  room_category,
  room_type,
  price
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
  AND room_type = '성인'
ORDER BY room_code;

-- 5️⃣ 아동/유아가 누락되었다면 여기서 추가 입력
-- 아동 요금만 따로 재입력
INSERT INTO room_price (room_code, room_category, cruise, room_type, price, schedule, payment)
VALUES
  ('R-AMB-BALCONY-CHILD', '발코니', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-BALCONY-INFANT', '발코니', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)'),
  ('R-AMB-EXECUTIVE-CHILD', '이그제큐티브', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-EXECUTIVE-INFANT', '이그제큐티브', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)'),
  ('R-AMB-SUITE-CHILD', '발코니 스위트', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-SUITE-INFANT', '발코니 스위트', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)'),
  ('R-AMB-CAPTAIN-CHILD', '캡틴 뷰 스위트', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-CAPTAIN-INFANT', '캡틴 뷰 스위트', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)');

-- 6️⃣ 재입력 후 최종 확인
SELECT 'Step 6: 재입력 후 최종 확인' AS check_point;
SELECT 
  COUNT(*) as total_rows,
  COUNT(DISTINCT room_code) as unique_room_codes
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise';

-- 7️⃣ 객실별 요금 현황
SELECT 'Step 7: 객실별 요금 현황 (모든 room_type)' AS check_point;
SELECT 
  room_category,
  COUNT(*) as count,
  STRING_AGG(DISTINCT room_type, ', ' ORDER BY room_type) as room_types
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
GROUP BY room_category
ORDER BY room_category;
