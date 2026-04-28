-- 1. reservation_rentcar 테이블에 way_type 컬럼 추가
ALTER TABLE reservation_rentcar 
ADD COLUMN IF NOT EXISTS way_type text DEFAULT 'oneway';

-- 2. 코멘트 추가
COMMENT ON COLUMN reservation_rentcar.way_type IS '경로 타입 (pickup: 픽업, sending: 샌딩, oneway: 편도)';
