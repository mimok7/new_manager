-- ⚠️ 주의: 이 스크립트는 quote 테이블에 quote_id 컬럼이 실제로 없을 때만 실행하세요
-- 먼저 check-quote-schema.sql로 테이블 구조를 확인한 후 결정하세요

-- 방법 1: quote_id 컬럼을 id의 별칭으로 추가 (권장)
-- quote_id가 없다면 id를 복사하여 추가
DO $$
BEGIN
    -- quote_id 컬럼이 없는지 확인
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
          AND table_name = 'quote' 
          AND column_name = 'quote_id'
    ) THEN
        -- quote_id 컬럼 추가 (id 값으로 초기화)
        ALTER TABLE quote ADD COLUMN quote_id uuid;
        UPDATE quote SET quote_id = id WHERE quote_id IS NULL;
        
        -- NOT NULL 제약 조건 추가
        ALTER TABLE quote ALTER COLUMN quote_id SET NOT NULL;
        
        -- UNIQUE 제약 조건 추가 (선택사항)
        ALTER TABLE quote ADD CONSTRAINT quote_quote_id_key UNIQUE (quote_id);
        
        RAISE NOTICE 'quote_id 컬럼이 성공적으로 추가되었습니다.';
    ELSE
        RAISE NOTICE 'quote_id 컬럼이 이미 존재합니다.';
    END IF;
END $$;

-- 방법 2: id를 quote_id로 이름 변경 (비권장 - 기존 코드에 영향)
-- ALTER TABLE quote RENAME COLUMN id TO quote_id;
