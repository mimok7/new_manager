-- ============================================================
-- 034-rentcar-return-trip-columns.sql
-- reservation_rentcar 테이블에 오는 편(샌딩) 컬럼 추가
-- 당일왕복 / 다른날왕복 이용 시 가는 편(픽업)과 오는 편(샌딩) 분리 저장
-- ============================================================

-- 오는 편(샌딩) 이동정보 컬럼 추가
ALTER TABLE reservation_rentcar ADD COLUMN IF NOT EXISTS return_datetime timestamp without time zone;
ALTER TABLE reservation_rentcar ADD COLUMN IF NOT EXISTS return_pickup_location text;
ALTER TABLE reservation_rentcar ADD COLUMN IF NOT EXISTS return_destination text;
ALTER TABLE reservation_rentcar ADD COLUMN IF NOT EXISTS return_via_location text;
ALTER TABLE reservation_rentcar ADD COLUMN IF NOT EXISTS return_via_waiting text;

-- 컬럼 코멘트
COMMENT ON COLUMN reservation_rentcar.return_datetime IS '오는 편(샌딩) 출발 일시';
COMMENT ON COLUMN reservation_rentcar.return_pickup_location IS '오는 편(샌딩) 출발지';
COMMENT ON COLUMN reservation_rentcar.return_destination IS '오는 편(샌딩) 목적지';
COMMENT ON COLUMN reservation_rentcar.return_via_location IS '오는 편(샌딩) 경유지';
COMMENT ON COLUMN reservation_rentcar.return_via_waiting IS '오는 편(샌딩) 경유지 대기시간';

-- ============================================================
-- 검증 쿼리
-- ============================================================
/*
-- 추가된 컬럼 확인
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'reservation_rentcar'
  AND column_name LIKE 'return_%'
ORDER BY ordinal_position;
*/
