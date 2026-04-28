-- 사용자 생성 테이블 스키마 CSV 내보내기 가이드
-- Supabase SQL Editor에서 실행 후 "Download" 버튼 클릭 > CSV 선택

-- ============================================================
-- 1️⃣ 모든 테이블과 컬럼 정보 (가장 중요)
-- ============================================================
SELECT 
  t.table_name as "테이블명",
  c.column_name as "컬럼명",
  c.data_type as "데이터타입",
  CASE WHEN c.is_nullable = 'YES' THEN 'NULL 가능' ELSE 'NOT NULL' END as "NULL허용",
  c.column_default as "기본값",
  c.ordinal_position as "위치"
FROM 
  information_schema.tables t
  JOIN information_schema.columns c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE 
  t.table_schema = 'public'
ORDER BY 
  t.table_name, c.ordinal_position;


-- ============================================================
-- 2️⃣️ 테이블별 컬럼 개수 요약
-- ============================================================
-- SELECT 
--   t.table_name as "테이블명",
--   COUNT(c.column_name) as "컬럼개수"
-- FROM 
--   information_schema.tables t
--   LEFT JOIN information_schema.columns c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
-- WHERE 
--   t.table_schema = 'public'
-- GROUP BY 
--   t.table_name
-- ORDER BY 
--   t.table_name;


-- ============================================================
-- 3️⃣ 외래키 관계 (테이블 간 연결 정보)
-- ============================================================
-- SELECT
--   tc.table_name as "테이블명",
--   kcu.column_name as "컬럼명",
--   ccu.table_name as "참조테이블",
--   ccu.column_name as "참조컬럼"
-- FROM 
--   information_schema.table_constraints AS tc
--   JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
--   JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
-- WHERE 
--   tc.constraint_type = 'FOREIGN KEY' AND tc.table_schema = 'public'
-- ORDER BY 
--   tc.table_name;


-- ============================================================
-- 📝 사용 방법:
-- ============================================================
-- 1. Supabase 대시보드 접속 > SQL Editor
-- 2. 위의 "1️⃣ 모든 테이블과 컬럼 정보" 쿼리 전체 실행
-- 3. 결과 하단의 "Download" 버튼 클릭
-- 4. "CSV" 형식 선택
-- 5. 파일 저장
