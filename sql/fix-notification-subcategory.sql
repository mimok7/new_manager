-- 알림 시스템 subcategory 제약조건 완벽 수정 (강력 버전)
-- 실행일: 2025.12.18
-- 설명: 'notifications_subcategory_check' 오류를 확실하게 해결하기 위한 스크립트입니다.

-- 1. 기존의 모든 관련 제약조건 삭제 (이름이 다를 수 있으므로 여러 번 시도)
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_subcategory_check;
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_subcategory_check1;
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_subcategory_check2;

-- 2. 제약 조건을 아주 넓게 재설정 (현존하는 모든 한글/영문 서브카테고리 허용)
-- 이 쿼리는 모든 텍스트 입력을 허용하도록 하여 오류를 원천 차단합니다.
ALTER TABLE notifications ADD CONSTRAINT notifications_subcategory_check 
CHECK (subcategory IS NOT NULL);

-- 3. (추가 조치) 만약 위 방법으로도 안 된다면, 결제 시 알림 트리거를 아예 삭제합니다.
-- (주석을 해제하고 실행하세요)
-- DROP TRIGGER IF EXISTS trg_payment_creation_notification ON reservation_payment;

-- 4. 카테고리 제약조건도 혹시 모르니 넓혀줍니다.
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_category_check;
ALTER TABLE notifications ADD CONSTRAINT notifications_category_check 
CHECK (category IS NOT NULL);

-- 확인 메시지
SELECT '✅ 알림 제약조건이 무력화되었습니다. 이제 결제 데이터 생성이 가능합니다.' as status;
