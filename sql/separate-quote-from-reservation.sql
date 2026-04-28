-- 견적과 예약 완전 분리 SQL
-- 2025.01.19 - reservation.re_quote_id를 NULL 허용으로 변경

-- 1. re_quote_id 컬럼을 NULL 허용으로 변경
ALTER TABLE reservation 
ALTER COLUMN re_quote_id DROP NOT NULL;

-- 2. 기존 외래키 제약조건 확인 및 수정 (CASCADE 유지)
DO $$
BEGIN
    -- 기존 외래키 제약조건이 있는지 확인
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name LIKE '%reservation%quote%' 
        AND table_name = 'reservation'
        AND constraint_type = 'FOREIGN KEY'
    ) THEN
        -- 기존 제약조건 삭제
        EXECUTE (
            SELECT 'ALTER TABLE reservation DROP CONSTRAINT ' || constraint_name
            FROM information_schema.table_constraints 
            WHERE constraint_name LIKE '%reservation%quote%' 
            AND table_name = 'reservation'
            AND constraint_type = 'FOREIGN KEY'
            LIMIT 1
        );
        
        RAISE NOTICE '기존 외래키 제약조건이 삭제되었습니다.';
    END IF;
    
    -- NULL 허용 외래키 제약조건 재생성
    ALTER TABLE reservation
    ADD CONSTRAINT fk_reservation_quote_id
    FOREIGN KEY (re_quote_id)
    REFERENCES quote(id)
    ON DELETE SET NULL;
    
    RAISE NOTICE '✅ re_quote_id NULL 허용 외래키가 설정되었습니다.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '⚠️ 외래키 설정 중 오류: %', SQLERRM;
END$$;

-- 3. 인덱스 확인 (성능 유지)
CREATE INDEX IF NOT EXISTS idx_reservation_re_quote_id 
ON reservation(re_quote_id) 
WHERE re_quote_id IS NOT NULL;

-- 4. 변경사항 확인
SELECT
    column_name,
    is_nullable,
    data_type
FROM information_schema.columns
WHERE table_name = 'reservation'
  AND column_name = 're_quote_id';

-- 5. 외래키 제약조건 확인
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
    ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'reservation'
  AND kcu.column_name = 're_quote_id';

-- Supabase 스키마 캐시 새로고침
NOTIFY pgrst, 'reload schema';

COMMIT;
