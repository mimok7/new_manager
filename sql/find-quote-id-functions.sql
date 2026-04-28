-- quote_id를 참조하는 함수 이름만 찾기
SELECT 
    p.proname as function_name
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.prokind = 'f'
  AND pg_get_functiondef(p.oid) LIKE '%quote_id%'
ORDER BY p.proname;
