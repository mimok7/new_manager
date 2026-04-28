-- ============================================================================
-- 🔴 호텔 가격 싱크: v3 → hotel_price (필수 실행!)
-- ============================================================================
-- ⚠️ 중요: 호텔을 추가한 후 이 파일을 반드시 실행해야 UI에 표시됩니다!
--
-- 사전 필수:
--   1. 001-hotel-system-v3-tables-2026.sql 실행 완료
--   2. 개별 호텔 데이터(002~008) 또는 호텔 SQL 파일 실행 완료
--
-- 이 스크립트는 v3 테이블(hotel_info + room_type + pricing_model)의 데이터를
-- 기존 hotel_price 테이블로 자동 변환하여 INSERT합니다.
--
-- 결과: 
--   ✅ 견적 페이지 (/mypage/quotes/hotel) → 호텔 표시 시작
--   ✅ 직접예약 페이지 (/mypage/direct-booking/hotel) → 호텔 표시 시작
--   ✅ 예약 페이지 (/mypage/reservations/hotel) → 호텔 표시 시작
--
-- weekday_type 매핑:
--   ANY     → '일,월,화,수,목,금,토' (전체)
--   WEEKDAY → '일,월,화,수,목' (일~목 체크인)
--   WEEKEND → '금,토' (금~토 체크인)
-- ============================================================================

BEGIN;

-- 기존 v3 호텔 데이터 정리 (hotel_code prefix로 식별)
DELETE FROM hotel_price
WHERE hotel_code LIKE 'YACHT_%'
   OR hotel_code LIKE 'ALACARTE_%'
   OR hotel_code LIKE 'WINDOM_%'
   OR hotel_code LIKE 'HYATT_%'
   OR hotel_code LIKE 'YOKO_%'
   OR hotel_code LIKE 'OAKWOOD_%'
   OR hotel_code LIKE 'SOLEIL_%';

-- ============================================================================
-- hotel_price 자동 동기화 (v3 → hotel_price)
-- ============================================================================
-- hotel_code 형식: {HOTEL_CODE}_{ROOM_CODE}_{SEASON_KEY}
-- 예: SOLEIL_DELUXE_TWIN_YEAR_2026_CITY
-- ============================================================================

INSERT INTO hotel_price (
  hotel_code, hotel_name, room_name, room_type, price,
  start_date, end_date, weekday_type
)
SELECT
  hi.hotel_code || '_' || rt.room_code || '_' || pm.season_key AS hotel_code,
  hi.hotel_name AS hotel_name,
  rt.room_name AS room_name,
  rt.room_category::TEXT AS room_type,
  pm.base_price AS price,
  pm.date_range_start AS start_date,
  pm.date_range_end AS end_date,
  CASE pm.day_of_week
    WHEN 'ANY'     THEN '일,월,화,수,목,금,토'
    WHEN 'WEEKDAY' THEN '일,월,화,수,목'
    WHEN 'WEEKEND' THEN '금,토'
    ELSE '일,월,화,수,목,금,토'
  END AS weekday_type
FROM hotel_info hi
JOIN room_type rt ON hi.hotel_id = rt.hotel_id
JOIN pricing_model pm ON pm.hotel_id = hi.hotel_id AND pm.room_id = rt.room_id
WHERE pm.calendar_year = 2026
ORDER BY hi.hotel_code, rt.room_code, pm.date_range_start;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================

-- 호텔별 hotel_price 레코드 수 확인
-- SELECT
--   SPLIT_PART(hotel_code, '_', 1) AS hotel,
--   COUNT(*) AS rows,
--   MIN(price) AS min_price,
--   MAX(price) AS max_price
-- FROM hotel_price
-- WHERE hotel_code LIKE 'YACHT_%'
--    OR hotel_code LIKE 'ALACARTE_%'
--    OR hotel_code LIKE 'WINDOM_%'
--    OR hotel_code LIKE 'HYATT_%'
--    OR hotel_code LIKE 'YOKO_%'
--    OR hotel_code LIKE 'OAKWOOD_%'
--    OR hotel_code LIKE 'SOLEIL_%'
-- GROUP BY SPLIT_PART(hotel_code, '_', 1)
-- ORDER BY hotel;

-- 특정 날짜에 예약 가능한 호텔 확인 (견적 페이지 시뮬레이션)
-- SELECT hotel_name, room_name, price, weekday_type
-- FROM hotel_price
-- WHERE start_date <= '2026-03-15'
--   AND end_date >= '2026-03-16'
--   AND weekday_type LIKE '%일%'
-- ORDER BY hotel_name, room_name;

-- SOLEIL 호텔 데이터 확인
-- SELECT hotel_code, hotel_name, room_name, price, weekday_type
-- FROM hotel_price
-- WHERE hotel_code LIKE 'SOLEIL_%'
-- ORDER BY price;
