-- 견적 아이템이 참조하는 서비스 데이터 자동 삭제를 위한 외래 키 제약 조건 추가
-- 가격 테이블은 절대 삭제되지 않도록 설정 (CASCADE DELETE 제거)
-- db.csv 파일 기준으로 작성됨

-- ===== 룸(Room) 테이블 관련 =====
-- quote_item → room (service_ref_id) - 견적 삭제 시 연결된 서비스 데이터 삭제
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_room_fkey,
ADD CONSTRAINT quote_item_room_fkey
FOREIGN KEY (service_ref_id) REFERENCES room(id) ON DELETE CASCADE;

-- ===== 카(Car) 테이블 관련 =====
-- quote_item → car (service_ref_id) - 견적 삭제 시 연결된 서비스 데이터 삭제
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_car_fkey,
ADD CONSTRAINT quote_item_car_fkey
FOREIGN KEY (service_ref_id) REFERENCES car(id) ON DELETE CASCADE;

-- ===== 공항(Airport) 테이블 관련 =====
-- quote_item → airport (service_ref_id) - 견적 삭제 시 연결된 서비스 데이터 삭제
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_airport_fkey,
ADD CONSTRAINT quote_item_airport_fkey
FOREIGN KEY (service_ref_id) REFERENCES airport(id) ON DELETE CASCADE;

-- ===== 렌트카(Rentcar) 테이블 관련 =====
-- quote_item → rentcar (service_ref_id) - 견적 삭제 시 연결된 서비스 데이터 삭제
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_rentcar_fkey,
ADD CONSTRAINT quote_item_rentcar_fkey
FOREIGN KEY (service_ref_id) REFERENCES rentcar(id) ON DELETE CASCADE;

-- ===== 호텔(Hotel) 테이블 관련 =====
-- quote_item → hotel (service_ref_id) - 견적 삭제 시 연결된 서비스 데이터 삭제
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_hotel_fkey,
ADD CONSTRAINT quote_item_hotel_fkey
FOREIGN KEY (service_ref_id) REFERENCES hotel(id) ON DELETE CASCADE;

-- ===== 투어(Tour) 테이블 관련 =====
-- quote_item → tour (service_ref_id) - 견적 삭제 시 연결된 서비스 데이터 삭제
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_tour_fkey,
ADD CONSTRAINT quote_item_tour_fkey
FOREIGN KEY (service_ref_id) REFERENCES tour(id) ON DELETE CASCADE;

-- 실행 완료 메시지
DO $$
BEGIN
    RAISE NOTICE '✅ 견적 아이템 CASCADE DELETE 설정이 완료되었습니다.';
    RAISE NOTICE '이제 견적 삭제 시 연결된 서비스 데이터가 자동으로 삭제되며, 가격 테이블은 안전하게 유지됩니다.';
    RAISE NOTICE '대상: quote_item → room, car, airport, rentcar, hotel, tour';
END $$;