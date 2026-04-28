-- reservation 테이블에 reservation_date 컬럼 추가
-- 예약의 실제 여행 시작일을 저장하는 컬럼

ALTER TABLE reservation 
ADD COLUMN IF NOT EXISTS reservation_date date;

-- 컬럼에 설명 추가
COMMENT ON COLUMN reservation.reservation_date IS '예약 여행 시작일 (실제 출발일)';

-- 기존 레코드의 경우 manager_note에서 여행시작일을 파싱하거나 null로 유지
-- 새로운 예약부터 이 컬럼이 채워집니다

-- 인덱스 추가 (날짜별 예약 조회 성능 향상)
CREATE INDEX IF NOT EXISTS idx_reservation_date ON reservation(reservation_date);
