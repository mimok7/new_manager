-- 예약 테이블 삭제 시 연결된 상세 예약 테이블 데이터 자동 삭제를 위한 외래 키 제약 조건 추가
-- db.csv 파일 기준으로 작성됨

-- 1. reservation_airport 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_airport
DROP CONSTRAINT IF EXISTS reservation_airport_reservation_id_fkey,
ADD CONSTRAINT reservation_airport_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 2. reservation_car_sht 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_car_sht
DROP CONSTRAINT IF EXISTS reservation_car_sht_reservation_id_fkey,
ADD CONSTRAINT reservation_car_sht_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 3. reservation_cruise 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_cruise
DROP CONSTRAINT IF EXISTS reservation_cruise_reservation_id_fkey,
ADD CONSTRAINT reservation_cruise_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 4. reservation_cruise_car 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_cruise_car
DROP CONSTRAINT IF EXISTS reservation_cruise_car_reservation_id_fkey,
ADD CONSTRAINT reservation_cruise_car_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 5. reservation_hotel 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_hotel
DROP CONSTRAINT IF EXISTS reservation_hotel_reservation_id_fkey,
ADD CONSTRAINT reservation_hotel_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 6. reservation_rentcar 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_rentcar
DROP CONSTRAINT IF EXISTS reservation_rentcar_reservation_id_fkey,
ADD CONSTRAINT reservation_rentcar_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 7. reservation_tour 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_tour
DROP CONSTRAINT IF EXISTS reservation_tour_reservation_id_fkey,
ADD CONSTRAINT reservation_tour_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 8. reservation_payment 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_payment
DROP CONSTRAINT IF EXISTS reservation_payment_reservation_id_fkey,
ADD CONSTRAINT reservation_payment_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 9. reservation_payments 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_payments
DROP CONSTRAINT IF EXISTS reservation_payments_reservation_id_fkey,
ADD CONSTRAINT reservation_payments_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 10. reservation_confirmation 테이블의 외래 키 제약 조건 수정
ALTER TABLE reservation_confirmation
DROP CONSTRAINT IF EXISTS reservation_confirmation_reservation_id_fkey,
ADD CONSTRAINT reservation_confirmation_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 11. payment_notifications 테이블의 외래 키 제약 조건 수정
ALTER TABLE payment_notifications
DROP CONSTRAINT IF EXISTS payment_notifications_reservation_id_fkey,
ADD CONSTRAINT payment_notifications_reservation_id_fkey
FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 실행 완료 메시지
DO $$
BEGIN
    RAISE NOTICE '✅ 예약 테이블 CASCADE DELETE 설정이 완료되었습니다.';
    RAISE NOTICE '이제 reservation 테이블에서 데이터를 삭제하면 연결된 모든 상세 테이블의 데이터가 자동으로 삭제됩니다.';
END $$;