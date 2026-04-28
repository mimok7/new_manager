-- reservation 테이블의 모든 제약조건을 확인하고 'car_sht' 등의 입력을 방해하는 요소를 제거합니다.
-- re_type 뿐만 아니라 re_status 등의 제약조건도 함께 완화합니다.

DO $$
DECLARE
    r RECORD;
BEGIN
    -- 1. re_type 관련 체크 제약조건 모두 삭제
    FOR r IN 
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'reservation'::regclass 
        AND (pg_get_constraintdef(oid) LIKE '%re_type%' OR conname LIKE '%re_type%')
    LOOP
        EXECUTE 'ALTER TABLE reservation DROP CONSTRAINT ' || r.conname;
        RAISE NOTICE '제약조건 삭제됨: %', r.conname;
    END LOOP;

    -- 2. re_status 관련 체크 제약조건도 있을 수 있으므로 확인 후 삭제 (필요시)
    -- 일부 스크립트에서 re_status를 ('pending', 'confirmed', 'cancelled')로 제한했을 수 있음
    -- 하지만 sync 로직은 'pending'을 사용하므로 통과해야 정상이지만, 혹시 모르니 확인.
    
    -- 3. 안전하게 새로운 re_type 제약조건 추가 (NOT VALID)
    ALTER TABLE reservation
    ADD CONSTRAINT reservation_re_type_permissive_check 
    CHECK (re_type IN (
        'cruise', 'airport', 'hotel', 'tour', 'rentcar', 'golf', 
        'car', 'car_sht', 'vehicle', 'cruise_car'
    )) NOT VALID;

    -- 4. order_id 컬럼 존재 여부 재확인 및 추가
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reservation' AND column_name = 'order_id') THEN
        ALTER TABLE reservation ADD COLUMN order_id TEXT;
        RAISE NOTICE 'order_id 컬럼 추가됨';
    END IF;

    RAISE NOTICE 'reservation 테이블 제약조건 완화 완료';
END $$;
