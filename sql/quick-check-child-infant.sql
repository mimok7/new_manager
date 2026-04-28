-- ============================================
-- 아동/유아 요금 최종 확인
-- ============================================

-- 아동/유아 데이터만 조회
SELECT 
  room_code,
  room_category,
  room_type,
  price,
  payment
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
  AND room_type IN ('아동', '유아')
ORDER BY room_category, room_type;

-- 또는 CHILD/INFANT로 검색
SELECT 
  room_code,
  room_category,
  room_type,
  price,
  payment
FROM room_price
WHERE cruise = 'Ambassador Signature Cruise'
  AND (room_code LIKE '%CHILD%' OR room_code LIKE '%INFANT%')
ORDER BY room_code;
