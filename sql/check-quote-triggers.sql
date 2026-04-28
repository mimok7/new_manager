-- quote 테이블의 트리거 목록
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_schema = 'public'
  AND event_object_table = 'quote'
ORDER BY trigger_name;
