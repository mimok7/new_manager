-- 사용자 생성 테이블 스키마 및 컬럼 정보 조회

-- 1. 모든 사용자 생성 테이블 및 컬럼 정보
SELECT 
  t.table_name,
  c.column_name,
  c.data_type,
  c.is_nullable,
  c.column_default,
  c.ordinal_position
FROM 
  information_schema.tables t
  JOIN information_schema.columns c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE 
  t.table_schema = 'public'
ORDER BY 
  t.table_name, c.ordinal_position;

-- 2. 테이블별 컬럼 개수 및 행 수
SELECT 
  t.table_name,
  COUNT(c.column_name) as column_count,
  (SELECT COUNT(*) FROM information_schema.tables t2 WHERE t2.table_name = t.table_name) as table_exists
FROM 
  information_schema.tables t
  LEFT JOIN information_schema.columns c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE 
  t.table_schema = 'public'
GROUP BY 
  t.table_name
ORDER BY 
  t.table_name;

-- 3. 모든 사용자 생성 테이블 목록 (이름순)
SELECT 
  table_name,
  table_type,
  'public' as schema_name
FROM 
  information_schema.tables
WHERE 
  table_schema = 'public'
ORDER BY 
  table_name;

-- 4. 테이블 및 인덱스 정보
SELECT 
  t.table_name,
  i.indexname,
  i.indexdef
FROM 
  information_schema.tables t
  LEFT JOIN pg_indexes i ON t.table_name = i.tablename AND i.schemaname = 'public'
WHERE 
  t.table_schema = 'public'
ORDER BY 
  t.table_name, i.indexname;

-- 5. 외래키 제약 조건
SELECT 
  constraint_name,
  table_name,
  column_name,
  foreign_table_name,
  foreign_column_name
FROM (
  SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
  FROM 
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
  WHERE 
    tc.constraint_type = 'FOREIGN KEY' AND tc.table_schema = 'public'
) fk
ORDER BY 
  table_name, constraint_name;
