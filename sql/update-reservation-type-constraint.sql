-- reservation 테이블의 re_type 제약조건 업데이트 (기존 데이터 검증 회피)
-- NOT VALID 옵션을 사용하여 기존 데이터를 검증하지 않고 제약조건을 추가한 후, 나중에 VALIDATE 합니다.

DO $$
DECLARE
    con_name TEXT;
BEGIN
    -- 1. 기존 제약조건 찾기 및 삭제
    SELECT conname INTO con_name
    FROM pg_constraint
    WHERE conrelid = 'reservation'::regclass
    AND contype = 'c'
    AND pg_get_constraintdef(oid) LIKE '%re_type%';

    IF con_name IS NOT NULL THEN
        EXECUTE 'ALTER TABLE reservation DROP CONSTRAINT ' || con_name;
        RAISE NOTICE '기존 제약조건 % 삭제 완료', con_name;
    ELSE
        RAISE NOTICE '삭제할 기존 re_type 제약조건이 없습니다.';
    END IF;

    -- 2. 새 제약조건 추가 (NOT VALID)
    -- NOT VALID: 기존 행은 검사하지 않고, 새로운 INSERT/UPDATE만 검사함
    ALTER TABLE reservation
    ADD CONSTRAINT reservation_re_type_check 
    CHECK (re_type IN ('cruise', 'airport', 'hotel', 'tour', 'rentcar', 'golf', 'car', 'car_sht', 'vehicle', 'cruise_car'))
    NOT VALID;
    
    RAISE NOTICE '새 제약조건이 NOT VALID 상태로 추가되었습니다.';

    -- 3. (선택사항) 나중에 데이터를 수정한 후 아래 명령어로 제약조건을 활성화할 수 있습니다.
    -- ALTER TABLE reservation VALIDATE CONSTRAINT reservation_re_type_check;
END $$;
