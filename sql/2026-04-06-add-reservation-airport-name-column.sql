-- 2026-04-06-add-reservation-airport-name-column.sql
-- reservation_airport에 공항명 저장 컬럼 추가

ALTER TABLE reservation_airport
  ADD COLUMN IF NOT EXISTS ra_airport_name TEXT;

-- 필요 시 기존 데이터 기본값 설정 예시
-- UPDATE reservation_airport SET ra_airport_name = '노이바이 공항 국제선' WHERE ra_airport_name IS NULL;
