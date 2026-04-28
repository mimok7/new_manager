-- Supabase에서 사용자가 생성한 테이블의 모든 컬럼 정보를 조회하는 SQL
-- public 스키마의 사용자 생성 테이블만 조회 (시스템 테이블 제외)

-- 방법 1: public 스키마의 모든 사용자 테이블 (기본 정보)
SELECT 
    table_schema,
    table_name,
    column_name,
    data_type
FROM 
    information_schema.columns
WHERE 
    table_schema = 'public'
    AND table_name NOT LIKE 'pg_%'  -- PostgreSQL 시스템 테이블 제외
    AND table_name NOT LIKE 'sql_%' -- SQL 시스템 테이블 제외
ORDER BY 
    table_name,
    ordinal_position;

-- 방법 2: 상세 정보 포함 (nullable, default 값 등)
SELECT 
    c.table_schema,
    c.table_name,
    c.column_name,
    c.data_type,
    c.is_nullable,
    c.column_default,
    c.character_maximum_length,
    c.numeric_precision,
    c.numeric_scale,
    c.ordinal_position
FROM 
    information_schema.columns c
    INNER JOIN information_schema.tables t 
        ON c.table_schema = t.table_schema 
        AND c.table_name = t.table_name
WHERE 
    c.table_schema = 'public'
    AND t.table_type = 'BASE TABLE'  -- 뷰 제외, 실제 테이블만
    AND c.table_name NOT LIKE 'pg_%'
    AND c.table_name NOT LIKE 'sql_%'
ORDER BY 
    c.table_name,
    c.ordinal_position;

-- 방법 3: 사용자 테이블 목록만 먼저 확인
SELECT DISTINCT
    table_name,
    COUNT(*) as column_count
FROM 
    information_schema.columns
WHERE 
    table_schema = 'public'
    AND table_name NOT LIKE 'pg_%'
    AND table_name NOT LIKE 'sql_%'
GROUP BY 
    table_name
ORDER BY 
    table_name;

-- 방법 4: users 테이블의 모든 컬럼 상세 정보
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length,
    ordinal_position
FROM 
    information_schema.columns
WHERE 
    table_schema = 'public'
    AND table_name = 'users'
ORDER BY 
    ordinal_position;
