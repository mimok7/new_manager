-- reservation_tour 테이블에 dispatch_code 컬럼 추가
-- 차량 배차 코드를 투어 예약에서도 관리할 수 있도록 추가

ALTER TABLE reservation_tour 
ADD COLUMN IF NOT EXISTS dispatch_code text;

-- 컬럼 설명 추가
COMMENT ON COLUMN reservation_tour.dispatch_code IS '투어 차량 배차 코드';
