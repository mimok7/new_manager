-- 패키지 예약에 아동/유아 옵션 및 차량 정보를 저장할 수 있는 컬럼 추가
-- 실행: Supabase Dashboard > SQL Editor에서 실행

-- 1. package_master 테이블에 기본 가격 및 차량 설정 컬럼 추가
ALTER TABLE package_master 
ADD COLUMN IF NOT EXISTS price_child_extra_bed INTEGER DEFAULT 6900000,
ADD COLUMN IF NOT EXISTS price_child_no_extra_bed INTEGER DEFAULT 5850000,
ADD COLUMN IF NOT EXISTS price_infant_tour INTEGER DEFAULT 900000,
ADD COLUMN IF NOT EXISTS price_infant_extra_bed INTEGER DEFAULT 4200000,
ADD COLUMN IF NOT EXISTS price_infant_seat INTEGER DEFAULT 800000,
ADD COLUMN IF NOT EXISTS vehicle_config JSONB DEFAULT '{
  "2": {"airport": "승용차", "ninhBinh": "승용차", "hanoi": "승용차"},
  "3": {"airport": "SUV (Xpander급)", "ninhBinh": "SUV (Xpander급)", "hanoi": "SUV (Xpander급)"},
  "4": {"airport": "SUV (Xpander급)", "ninhBinh": "카니발,VF9,이노바", "hanoi": "카니발,VF9,이노바"},
  "5": {"airport": "카니발,이노바", "ninhBinh": "9인승 리무진", "hanoi": "9인승 리무진"},
  "6": {"airport": "9인승 리무진", "ninhBinh": "9인승 리무진", "hanoi": "9인승 리무진"},
  "7": {"airport": "9인승 리무진", "ninhBinh": "9인승 리무진", "hanoi": "9인승 리무진"},
  "8": {"airport": "11인승 리무진", "ninhBinh": "11인승 리무진", "hanoi": "11인승 리무진"},
  "9": {"airport": "11인승 리무진", "ninhBinh": "11인승 리무진", "hanoi": "11인승 리무진"},
  "10": {"airport": "11인승 리무진", "ninhBinh": "11인승 리무진", "hanoi": "11인승 리무진"}
}'::jsonb;

-- 컬럼 설명 추가
COMMENT ON COLUMN package_master.price_child_extra_bed IS '아동(5-11세) 엑스트라베드 사용 가격 (동)';
COMMENT ON COLUMN package_master.price_child_no_extra_bed IS '아동(5-11세) 엑스트라베드 미사용 가격 (동)';
COMMENT ON COLUMN package_master.price_infant_tour IS '유아(5세미만) 1.1m 이상 투어 입장료 (동)';
COMMENT ON COLUMN package_master.price_infant_extra_bed IS '유아(5세미만) 엑스트라베드 사용 가격 (동)';
COMMENT ON COLUMN package_master.price_infant_seat IS '유아(5세미만) 리무진 별도 좌석 가격 (동)';
COMMENT ON COLUMN package_master.vehicle_config IS '인원수별 차량 배정 설정 (JSON)';

-- 2. 패키지 예약 테이블(reservation_package)이 없으면 생성
CREATE TABLE IF NOT EXISTS reservation_package (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reservation(re_id) ON DELETE CASCADE,
    package_id UUID NOT NULL REFERENCES package_master(id),
    
    -- 인원 구성
    adult_count INTEGER NOT NULL DEFAULT 1,
    child_extra_bed INTEGER DEFAULT 0,
    child_no_extra_bed INTEGER DEFAULT 0,
    infant_free INTEGER DEFAULT 0,
    infant_tour INTEGER DEFAULT 0,
    infant_extra_bed INTEGER DEFAULT 0,
    infant_seat INTEGER DEFAULT 0,
    
    -- 차량 정보
    airport_vehicle VARCHAR(100),
    ninh_binh_vehicle VARCHAR(100),
    hanoi_vehicle VARCHAR(100),
    cruise_vehicle VARCHAR(100) DEFAULT '스하 셔틀 리무진',
    
    -- 스하 셔틀 좌석 정보
    sht_pickup_vehicle VARCHAR(50),
    sht_pickup_seat VARCHAR(50),
    sht_dropoff_vehicle VARCHAR(50),
    sht_dropoff_seat VARCHAR(50),
    
    -- 가격 정보
    adult_price INTEGER,
    child_extra_bed_price INTEGER,
    child_no_extra_bed_price INTEGER,
    infant_tour_price INTEGER,
    infant_extra_bed_price INTEGER,
    infant_seat_price INTEGER,
    total_price INTEGER,
    
    -- 추가 요청사항
    additional_requests TEXT,
    
    -- 타임스탬프
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_reservation_package_reservation_id ON reservation_package(reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_package_package_id ON reservation_package(package_id);

-- RLS 정책 설정
ALTER TABLE reservation_package ENABLE ROW LEVEL SECURITY;

-- 기존 정책 삭제 후 재생성
DROP POLICY IF EXISTS "Users can view own reservation packages" ON reservation_package;
DROP POLICY IF EXISTS "Authenticated users can insert reservation packages" ON reservation_package;
DROP POLICY IF EXISTS "Users can update own reservation packages" ON reservation_package;

-- 모든 사용자가 자신의 예약 패키지 정보 조회 가능
CREATE POLICY "Users can view own reservation packages"
ON reservation_package FOR SELECT
USING (
    reservation_id IN (
        SELECT re_id FROM reservation WHERE re_user_id = auth.uid()
    )
);

-- 인증된 사용자만 패키지 예약 생성 가능
CREATE POLICY "Authenticated users can insert reservation packages"
ON reservation_package FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- 자신의 예약 패키지만 수정 가능
CREATE POLICY "Users can update own reservation packages"
ON reservation_package FOR UPDATE
USING (
    reservation_id IN (
        SELECT re_id FROM reservation WHERE re_user_id = auth.uid()
    )
);

-- 3. 기존 package_master 테이블 업데이트 (기본값 설정)
UPDATE package_master 
SET 
    price_child_extra_bed = COALESCE(price_child_extra_bed, 6900000),
    price_child_no_extra_bed = COALESCE(price_child_no_extra_bed, 5850000),
    price_infant_tour = COALESCE(price_infant_tour, 900000),
    price_infant_extra_bed = COALESCE(price_infant_extra_bed, 4200000),
    price_infant_seat = COALESCE(price_infant_seat, 800000)
WHERE price_child_extra_bed IS NULL 
   OR price_child_no_extra_bed IS NULL 
   OR price_infant_tour IS NULL 
   OR price_infant_extra_bed IS NULL 
   OR price_infant_seat IS NULL;

-- 확인 쿼리
SELECT 
    'package_master 컬럼 확인' as check_type,
    column_name, 
    data_type, 
    column_default
FROM information_schema.columns 
WHERE table_name = 'package_master' 
  AND column_name IN ('price_child_extra_bed', 'price_child_no_extra_bed', 'price_infant_tour', 'price_infant_extra_bed', 'price_infant_seat', 'vehicle_config');

SELECT 
    'reservation_package 테이블 확인' as check_type,
    column_name, 
    data_type
FROM information_schema.columns 
WHERE table_name = 'reservation_package'
ORDER BY ordinal_position;
