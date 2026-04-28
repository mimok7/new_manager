-- 1. reservation_airport 테이블의 reservation_id 유니크 제약조건 제거
-- (한 예약에 픽업/샌딩 2개의 행을 저장하기 위함)
DO $$ 
DECLARE 
    r RECORD;
BEGIN 
    FOR r IN (
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'reservation_airport'::regclass 
        AND contype = 'u'  -- unique constraint
        AND conkey = ARRAY[(SELECT attnum FROM pg_attribute WHERE attrelid = 'reservation_airport'::regclass AND attname = 'reservation_id')]
    ) LOOP
        EXECUTE 'ALTER TABLE reservation_airport DROP CONSTRAINT ' || quote_ident(r.conname);
        RAISE NOTICE 'Dropped unique constraint: %', r.conname;
    END LOOP;
END $$;

-- 2. 구분 컬럼 추가 (pickup / sending)
ALTER TABLE reservation_airport 
ADD COLUMN IF NOT EXISTS way_type text DEFAULT 'pickup';

-- 3. 코멘트 추가
COMMENT ON COLUMN reservation_airport.way_type IS '경로 타입 (pickup: 픽업, sending: 샌딩)';
