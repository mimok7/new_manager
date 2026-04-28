-- 🔧 reservation 테이블의 re_type 제약 조건 및 총금액 계산 함수 수정
-- 에러 해결: new row for relation "reservation" violates check constraint "reservation_re_type_permissive_check"
-- 원인: re_type 컬럼에 'sht' 또는 'car' 등 새로운 서비스 타입이 포함되어 있지 않아 업데이트가 거부됨.
-- 추가 개선: 총금액 자동 계산 함수에 reservation_car_sht 테이블 포함.

DO $$
DECLARE
    constraint_name TEXT;
BEGIN
    -- 1. re_type 컬럼에 대한 기존 체크 제약 조건 조회
    SELECT conname INTO constraint_name
    FROM pg_constraint c
    JOIN pg_namespace n ON n.oid = c.connamespace
    WHERE n.nspname = 'public'
    AND conrelid = 'reservation'::regclass
    AND contype = 'c'
    AND (pg_get_constraintdef(c.oid) LIKE '%re_type%' OR conname = 'reservation_re_type_permissive_check');

    -- 2. 기존 제약 조건이 있으면 삭제
    IF constraint_name IS NOT NULL THEN
        EXECUTE 'ALTER TABLE reservation DROP CONSTRAINT ' || constraint_name;
        RAISE NOTICE '기존 제약 조건 %를 삭제했습니다.', constraint_name;
    END IF;

    -- 3. 새로운 통합 제약 조건 추가
    -- 기존 타입(cruise, airport, hotel, rentcar, tour) + 신규 타입(sht, car, sht_car, car_sht) 포함
    ALTER TABLE reservation
    ADD CONSTRAINT reservation_re_type_permissive_check
    CHECK (re_type IN ('cruise', 'airport', 'hotel', 'rentcar', 'tour', 'sht', 'car', 'sht_car', 'car_sht', 'etc'));

    RAISE NOTICE '새로운 제약 조건 reservation_re_type_permissive_check를 추가했습니다.';
END $$;

-- 4. 총금액 재계산 함수 업데이트 (reservation_car_sht 포함)
CREATE OR REPLACE FUNCTION recompute_reservation_total(p_reservation_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total NUMERIC(14,2) := 0;
BEGIN
  -- 각 서비스별 금액 합산 (모든 관련 테이블 통합)
  SELECT
      -- 크루즈 객실
      COALESCE( (SELECT SUM(CASE WHEN COALESCE(room_total_price, 0) > 0 THEN room_total_price ELSE COALESCE(unit_price, 0) * COALESCE(guest_count, 1) END) FROM reservation_cruise WHERE reservation_id = p_reservation_id), 0 )
    -- 크루즈 차량
    + COALESCE( (SELECT SUM(COALESCE(car_total_price, 0)) FROM reservation_cruise_car WHERE reservation_id = p_reservation_id), 0 )
    -- 공항 서비스
    + COALESCE( (SELECT SUM(CASE WHEN COALESCE(total_price, 0) > 0 THEN total_price ELSE COALESCE(unit_price, 0) * COALESCE(ra_car_count, 1) END) FROM reservation_airport WHERE reservation_id = p_reservation_id), 0 )
    -- 호텔 서비스
    + COALESCE( (SELECT SUM(COALESCE(total_price, 0)) FROM reservation_hotel WHERE reservation_id = p_reservation_id), 0 )
    -- 투어 서비스
    + COALESCE( (SELECT SUM(COALESCE(total_price, 0)) FROM reservation_tour WHERE reservation_id = p_reservation_id), 0 )
    -- 렌터카 서비스
    + COALESCE( (SELECT SUM(CASE WHEN COALESCE(total_price, 0) > 0 THEN total_price ELSE COALESCE(unit_price, 0) * COALESCE(car_count, 1) END) FROM reservation_rentcar WHERE reservation_id = p_reservation_id), 0 )
    -- SHT 차량 서비스 (reservation_car_sht)
    + COALESCE( (SELECT SUM(COALESCE(car_total_price, 0)) FROM reservation_car_sht WHERE reservation_id = p_reservation_id), 0 )
  INTO v_total;

  -- reservation 테이블의 total_amount 업데이트
  UPDATE reservation
  SET total_amount = COALESCE(v_total, 0)
  WHERE re_id = p_reservation_id;
END;
$$;

-- 5. 확인
SELECT conname, pg_get_constraintdef(c.oid)
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
WHERE n.nspname = 'public'
AND conrelid = 'reservation'::regclass
AND conname = 'reservation_re_type_permissive_check';
