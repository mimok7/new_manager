-- 견적 테이블 삭제 시 연결된 모든 데이터 자동 삭제를 위한 외래 키 제약 조건 추가
-- db.csv 파일 기준으로 작성됨

-- 1. quote_item 테이블의 외래 키 제약 조건 수정
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_quote_id_fkey,
ADD CONSTRAINT quote_item_quote_id_fkey
FOREIGN KEY (quote_id) REFERENCES quote(id) ON DELETE CASCADE;

-- 2. reservation 테이블의 외래 키 제약 조건 수정 (quote_id 참조)
ALTER TABLE reservation
DROP CONSTRAINT IF EXISTS reservation_re_quote_id_fkey,
ADD CONSTRAINT reservation_re_quote_id_fkey
FOREIGN KEY (re_quote_id) REFERENCES quote(id) ON DELETE CASCADE;

-- 3. confirmation_status 테이블의 외래 키 제약 조건 수정 (quote_id 참조)
ALTER TABLE confirmation_status
DROP CONSTRAINT IF EXISTS confirmation_status_quote_id_fkey,
ADD CONSTRAINT confirmation_status_quote_id_fkey
FOREIGN KEY (quote_id) REFERENCES quote(id) ON DELETE CASCADE;

-- 4. reservation_confirmation 테이블의 외래 키 제약 조건 수정 (quote_id 참조)
ALTER TABLE reservation_confirmation
DROP CONSTRAINT IF EXISTS reservation_confirmation_quote_id_fkey,
ADD CONSTRAINT reservation_confirmation_quote_id_fkey
FOREIGN KEY (quote_id) REFERENCES quote(id) ON DELETE CASCADE;

-- 실행 완료 메시지
DO $$
BEGIN
    RAISE NOTICE '✅ 견적 테이블 CASCADE DELETE 설정이 완료되었습니다.';
    RAISE NOTICE '이제 quote 테이블에서 데이터를 삭제하면 연결된 모든 데이터가 자동으로 삭제됩니다:';
    RAISE NOTICE '  - quote_item (견적 아이템)';
    RAISE NOTICE '  - reservation (예약) 및 그 하위 모든 상세 테이블들';
    RAISE NOTICE '  - confirmation_status (확인 상태)';
    RAISE NOTICE '  - reservation_confirmation (예약 확인서)';
END $$;