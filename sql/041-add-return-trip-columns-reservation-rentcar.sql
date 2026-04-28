-- ============================================================
-- 041-add-return-trip-columns-reservation-rentcar.sql
-- reservation_rentcar 테이블에 왕복(오는 편) 컬럼 추가
-- 대상: 당일왕복, 다른날왕복 예약 시 오는 편 정보 저장
-- ============================================================

-- 오는 편 출발 일시
ALTER TABLE reservation_rentcar
  ADD COLUMN IF NOT EXISTS return_datetime timestamp without time zone NULL;

-- 오는 편 출발 위치 (샌딩 기준: 숙소/항구 → 공항)
ALTER TABLE reservation_rentcar
  ADD COLUMN IF NOT EXISTS return_pickup_location text NULL;

-- 오는 편 목적지
ALTER TABLE reservation_rentcar
  ADD COLUMN IF NOT EXISTS return_destination text NULL;

-- 오는 편 경유지
ALTER TABLE reservation_rentcar
  ADD COLUMN IF NOT EXISTS return_via_location text NULL;

-- 오는 편 경유 대기 시간
ALTER TABLE reservation_rentcar
  ADD COLUMN IF NOT EXISTS return_via_waiting text NULL;

-- ────────────────────────────────────────────
-- 검증 쿼리
-- ────────────────────────────────────────────

SELECT '✅ reservation_rentcar 왕복 컬럼 추가 완료' AS 결과;

SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'reservation_rentcar'
  AND column_name LIKE 'return%'
ORDER BY ordinal_position;
