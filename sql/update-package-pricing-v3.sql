-- 패키지 상세 가격 정책 반영을 위한 SQL
-- 1. 패키지 마스터에 옵션별 가격 컬럼 추가
ALTER TABLE public.package_master 
ADD COLUMN IF NOT EXISTS price_child_extra_bed NUMERIC(15, 2) DEFAULT 6900000,
ADD COLUMN IF NOT EXISTS price_child_no_extra_bed NUMERIC(15, 2) DEFAULT 5850000,
ADD COLUMN IF NOT EXISTS price_infant_tour NUMERIC(15, 2) DEFAULT 900000,
ADD COLUMN IF NOT EXISTS price_infant_extra_bed NUMERIC(15, 2) DEFAULT 4200000,
ADD COLUMN IF NOT EXISTS price_infant_seat NUMERIC(15, 2) DEFAULT 800000;

-- 2. 예약 테이블에 옵션별 선택 수량 컬럼 추가
ALTER TABLE public.reservation 
ADD COLUMN IF NOT EXISTS re_count_child_extra_bed INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS re_count_child_no_extra_bed INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS re_count_infant_free INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS re_count_infant_tour INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS re_count_infant_extra_bed INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS re_count_infant_seat INTEGER DEFAULT 0;

-- 3. 기존 샘플 패키지 가격 업데이트
UPDATE public.package_master 
SET 
  base_price = 12850000,
  price_child_extra_bed = 6900000,
  price_child_no_extra_bed = 5850000,
  price_infant_tour = 900000,
  price_infant_extra_bed = 4200000,
  price_infant_seat = 800000
WHERE package_code = 'PKG-HL-PREMIUM';
