-- 🔧 reservation 테이블의 re_type 제약 조건에 'package' 추가 및 총금액 계산 함수 수정
-- 패키지 서비스를 위한 지원 추가

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
    -- 'package' 타입 추가
    ALTER TABLE reservation
    ADD CONSTRAINT reservation_re_type_permissive_check
    CHECK (re_type IN ('cruise', 'airport', 'hotel', 'rentcar', 'tour', 'sht', 'car', 'sht_car', 'car_sht', 'etc', 'package'));

    RAISE NOTICE '새로운 제약 조건 reservation_re_type_permissive_check(''package'' 포함)를 추가했습니다.';
END $$;

-- 4. 총금액 재계산 함수 업데이트 (package_id 기반 합산 또는 개별 항목 합산)
-- 패키지의 경우 reservation 테이블의 package_id가 있는 경우 package_master의 base_price를 참고할 수도 있지만,
-- 일반적으로는 하위 항목들의 합산으로 처리하거나 패키지 전용 가격을 적용합니다.
-- 우선 하위 항목 합산 로직을 유지하고, 패키지 자체의 금액 필드가 있다면 추가합니다.

CREATE OR REPLACE FUNCTION recompute_reservation_total(p_reservation_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total NUMERIC(14,2) := 0;
  v_package_id UUID;
  v_package_price NUMERIC(14,2) := 0;
BEGIN
  -- 패키지 ID 확인
  SELECT package_id INTO v_package_id FROM reservation WHERE re_id = p_reservation_id;

  -- 1. 각 서비스별 금액 합산
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

  -- 2. 만약 개별 항목 금액이 0이고 패키지 상품이라면 패키지 기본가 적용 고려 (비즈니스 로직에 따라 다름)
  -- 여기서는 개별 항목 금액의 합을 우선시함.

  -- reservation 테이블의 total_amount 업데이트
  UPDATE reservation
  SET total_amount = COALESCE(v_total, 0)
  WHERE re_id = p_reservation_id;
END;
$$;
