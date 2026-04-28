-- ⚠️ 중요: 이 스크립트를 Supabase SQL Editor에서 실행해주세요.

-- 1. reservation_airport 테이블의 reservation_id 관련 유니크 제약조건 및 인덱스 강제 삭제
DO $$ 
DECLARE 
    r RECORD;
BEGIN 
    -- 1-1. 유니크 제약조건(Constraint) 삭제
    FOR r IN (
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'reservation_airport'::regclass 
        AND contype = 'u'  -- Unique constraint
    ) LOOP
        -- reservation_id가 포함된 제약조건인지 확인
        IF EXISTS (
            SELECT 1
            FROM pg_attribute a
            WHERE a.attrelid = 'reservation_airport'::regclass
            AND a.attnum = ANY(r.conkey)
            AND a.attname = 'reservation_id'
        ) THEN
            EXECUTE 'ALTER TABLE reservation_airport DROP CONSTRAINT ' || quote_ident(r.conname);
            RAISE NOTICE 'Dropped unique constraint: %', r.conname;
        END IF;
    END LOOP;

    -- 1-2. 유니크 인덱스(Index) 삭제 (제약조건 없이 생성된 유니크 인덱스 대응)
    FOR r IN (
        SELECT indexname 
        FROM pg_indexes 
        WHERE tablename = 'reservation_airport' 
        AND indexdef LIKE '%UNIQUE%' 
        AND indexdef LIKE '%reservation_id%'
    ) LOOP
        EXECUTE 'DROP INDEX ' || quote_ident(r.indexname);
        RAISE NOTICE 'Dropped unique index: %', r.indexname;
    END LOOP;
END $$;

-- 2. way_type 컬럼 확인 및 추가
ALTER TABLE reservation_airport 
ADD COLUMN IF NOT EXISTS way_type text DEFAULT 'pickup';

-- 3. 성능을 위한 일반 인덱스 추가 (유니크 아님)
CREATE INDEX IF NOT EXISTS idx_reservation_airport_reservation_id ON reservation_airport(reservation_id);

-- 4. 변경사항 확인용 쿼리 (실행 결과에서 확인 가능)
SELECT 
    conname as constraint_name, 
    contype as constraint_type,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint 
WHERE conrelid = 'reservation_airport'::regclass;
