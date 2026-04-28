-- ============================================================
-- 예약 상태 변경 자동 로깅 트리거
-- reservation.re_status가 변경될 때마다 자동으로 reservation_status_log에 기록
-- 
-- 장점:
-- 1. 앱/크론/DB콘솔 어디서 변경하든 100% 캡처
-- 2. 앱 코드에서 수동 로깅 호출 불필요
-- 3. 누락 0% 보장
--
-- Supabase Dashboard → SQL Editor에서 실행
-- ============================================================

-- 1. 트리거 함수 생성
CREATE OR REPLACE FUNCTION fn_log_reservation_status_change()
RETURNS TRIGGER AS $$
DECLARE
    v_uid uuid;
    v_email text;
BEGIN
    -- re_status가 실제로 변경된 경우에만 로그 기록
    IF OLD.re_status IS NOT DISTINCT FROM NEW.re_status THEN
        RETURN NEW;
    END IF;

    -- 현재 사용자 정보 (Supabase auth context)
    BEGIN
        v_uid := auth.uid();
    EXCEPTION WHEN OTHERS THEN
        v_uid := NULL;
    END;

    -- 이메일 조회 (인증된 사용자인 경우)
    IF v_uid IS NOT NULL THEN
        SELECT email INTO v_email FROM auth.users WHERE id = v_uid;
    END IF;

    -- 로그 삽입
    INSERT INTO reservation_status_log (
        reservation_id,
        re_type,
        prev_status,
        new_status,
        changed_by,
        changed_by_email,
        note
    ) VALUES (
        NEW.re_id,
        NEW.re_type,
        OLD.re_status,
        NEW.re_status,
        v_uid,
        COALESCE(v_email, 'system'),
        CASE
            WHEN v_uid IS NULL THEN '시스템 자동처리'
            ELSE '자동 기록'
        END
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. 기존 트리거 삭제 후 재생성 (재실행 안전)
DROP TRIGGER IF EXISTS trg_reservation_status_change ON reservation;

CREATE TRIGGER trg_reservation_status_change
    AFTER UPDATE ON reservation
    FOR EACH ROW
    EXECUTE FUNCTION fn_log_reservation_status_change();

-- ============================================================
-- 검증 쿼리 (실행 후 확인용)
-- ============================================================
-- 트리거 존재 확인
-- SELECT tgname, tgrelid::regclass, tgtype FROM pg_trigger WHERE tgname = 'trg_reservation_status_change';

-- 함수 존재 확인
-- SELECT proname FROM pg_proc WHERE proname = 'fn_log_reservation_status_change';

-- 테스트: 예약 상태 변경 후 로그 확인
-- UPDATE reservation SET re_status = 'approved' WHERE re_id = '테스트ID';
-- SELECT * FROM reservation_status_log ORDER BY changed_at DESC LIMIT 5;
