-- ========================================
-- Quote 테이블 종합 진단 스크립트
-- ========================================

-- 1. quote 테이블의 실제 컬럼 목록
SELECT 
    column_name, 
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'quote'
ORDER BY ordinal_position;
