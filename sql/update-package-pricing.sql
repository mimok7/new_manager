-- 패키지 가격 체계 고도화를 위한 SQL 스크립트
-- 인원별 가격 설정을 위한 JSONB 컬럼 추가

ALTER TABLE public.package_master ADD COLUMN IF NOT EXISTS price_config JSONB DEFAULT '{}';

-- reservation 테이블에 인원수(pax_count) 컬럼 추가
ALTER TABLE public.reservation ADD COLUMN IF NOT EXISTS pax_count INTEGER DEFAULT 1;

-- 기존 데이터 마이그레이션 (필요한 경우)
-- UPDATE public.package_master SET price_config = jsonb_build_object('default', base_price) WHERE price_config IS NULL OR price_config = '{}';

COMMENT ON COLUMN public.package_master.price_config IS '인원수별 가격 설정 (예: {"2": 12850000, "3": 11750000, ...})';
