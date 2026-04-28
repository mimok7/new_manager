-- users 테이블에 child_birth_dates 컬럼 추가
-- 아동 생년월일을 배열로 저장 (최대 3명)

-- JSONB 배열 컬럼 추가
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS child_birth_dates JSONB DEFAULT '[]'::jsonb;

-- 컬럼 설명 추가
COMMENT ON COLUMN users.child_birth_dates IS '아동 생년월일 배열 (최대 3명, YYYY-MM-DD 형식)';

-- 예시 데이터 확인 쿼리
-- SELECT id, email, child_birth_dates FROM users WHERE child_birth_dates IS NOT NULL AND child_birth_dates != '[]'::jsonb;
