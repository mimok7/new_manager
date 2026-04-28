-- 패키지 아이템 고도화를 위한 SQL 스크립트
-- 아이템별 설명 컬럼 추가

ALTER TABLE public.package_items ADD COLUMN IF NOT EXISTS description TEXT;

COMMENT ON COLUMN public.package_items.description IS '서비스 상세 구성 정보 (예: 크루즈 명, 호텔 명 등)';
