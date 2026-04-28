-- 잘못 설정된 외래 키 제약 조건들 제거
-- quote_item이 여러 테이블을 동시에 참조할 수 없으므로 CASCADE DELETE 설정 취소

-- ===== 룸(Room) 테이블 관련 외래 키 제거 =====
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_room_fkey;

-- ===== 카(Car) 테이블 관련 외래 키 제거 =====
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_car_fkey;

-- ===== 공항(Airport) 테이블 관련 외래 키 제거 =====
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_airport_fkey;

-- ===== 렌트카(Rentcar) 테이블 관련 외래 키 제거 =====
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_rentcar_fkey;

-- ===== 호텔(Hotel) 테이블 관련 외래 키 제거 =====
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_hotel_fkey;

-- ===== 투어(Tour) 테이블 관련 외래 키 제거 =====
ALTER TABLE quote_item
DROP CONSTRAINT IF EXISTS quote_item_tour_fkey;

-- 실행 완료 메시지
DO $$
BEGIN
    RAISE NOTICE '✅ 잘못된 외래 키 제약 조건들이 제거되었습니다.';
    RAISE NOTICE 'CASCADE DELETE는 애플리케이션 레벨이나 트리거를 통해 별도로 구현해야 합니다.';
END $$;