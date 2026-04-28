-- Add 'approved' status to reservation re_status field
-- This allows 3-step reservation workflow: pending -> approved -> confirmed

-- 1. 기존 CHECK constraint 확인 및 제거 (Supabase에서 자동 생성된 경우)
-- Supabase에서 생성한 constraint는 보통 자동으로 관리되므로 수동 수정 불필요
-- 하지만 타입 제약이 있다면 아래와 같이 처리:

-- 2. re_status 타입이 enum이 아니라 text이므로 제약 없음
-- 따라서 'approved' 값을 직접 저장 가능

-- 3. 예시: 기존 pending 상태 데이터를 'approved'로 변경하고 싶다면:
-- UPDATE reservation SET re_status = 'approved' WHERE re_status = 'pending' AND created_at > '2026-03-24';

-- 4. RLS 정책 확인 (re_status 필터링이 없으면 추가 정책 불필요)

-- 5. 접근 권한 확인:
-- - 매니저/관리자: UPDATE 권한 필요
-- - 고객: SELECT 권한만 필요

-- Note: re_status는 이미 text 타입이므로 'approved' 값 저장 가능
-- Supabase 인스턴스에서 실제 제약이 있는지 확인:
-- SELECT constraint_name, constraint_type 
-- FROM information_schema.table_constraints 
-- WHERE table_name = 'reservation' AND constraint_type = 'CHECK';
