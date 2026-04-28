-- RLS 정책에서 quote_id 참조를 찾기
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd,
    qual::text as using_expression,
    with_check::text as with_check_expression
FROM pg_policies 
WHERE 
    (qual::text LIKE '%quote_id%' OR with_check::text LIKE '%quote_id%')
    AND tablename IN ('quote', 'quote_item')
ORDER BY tablename, policyname;

-- 트리거 함수에서 quote_id 참조 찾기
SELECT 
    n.nspname as schema_name,
    p.proname as function_name,
    pg_get_functiondef(p.oid) as function_definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE 
    pg_get_functiondef(p.oid) LIKE '%quote_id%'
    AND n.nspname = 'public'
ORDER BY p.proname;
