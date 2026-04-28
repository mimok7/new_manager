-- 패키지 예약 추가 필드 지원을 위한 SQL
-- 1. 기본 예약 테이블에 인원 정보 추가
ALTER TABLE public.reservation 
ADD COLUMN IF NOT EXISTS re_adult_count INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS re_child_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS re_infant_count INTEGER DEFAULT 0;

-- 2. 크루즈 예약 테이블에 상세 인원 정보 추가
ALTER TABLE public.reservation_cruise 
ADD COLUMN IF NOT EXISTS adult_count INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS child_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS infant_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS accommodation_info TEXT;

-- 3. 호텔 예약 테이블에 상세 인원 정보 및 숙소 정보 추가
ALTER TABLE public.reservation_hotel 
ADD COLUMN IF NOT EXISTS adult_count INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS child_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS infant_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS accommodation_info TEXT;

-- 4. 투어 예약 테이블에 상세 인원 정보 및 숙소 정보 추가
ALTER TABLE public.reservation_tour 
ADD COLUMN IF NOT EXISTS adult_count INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS child_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS infant_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS accommodation_info TEXT;

-- 5. 공항/차량 서비스 테이블에 숙소 정보 추가
ALTER TABLE public.reservation_airport ADD COLUMN IF NOT EXISTS accommodation_info TEXT;
ALTER TABLE public.reservation_car_sht ADD COLUMN IF NOT EXISTS accommodation_info TEXT;

-- 6. 패키지 아이템에 설명 컬럼 추가 (카드에 표시용)
ALTER TABLE public.package_items ADD COLUMN IF NOT EXISTS description TEXT;

COMMENT ON COLUMN public.reservation.re_adult_count IS '성인 인원수';
COMMENT ON COLUMN public.reservation.re_child_count IS '아동 인원수 (5-11세)';
COMMENT ON COLUMN public.reservation.re_infant_count IS '유아 인원수 (5세 미만)';
