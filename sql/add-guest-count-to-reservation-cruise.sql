-- ============================================================
-- reservation_cruise 테이블 인원수 세부 정보 컬럼 추가
-- ============================================================

-- 1. 기존 컬럼 확인 조회
SELECT column_name, data_type, column_default
FROM information_schema.columns 
WHERE table_name = 'reservation_cruise'
ORDER BY ordinal_position;

-- 2. 추가 인원수 정보 컬럼 추가
ALTER TABLE public.reservation_cruise
ADD COLUMN child_extra_bed_count INTEGER DEFAULT 0,
ADD COLUMN extra_bed_count INTEGER DEFAULT 0,
ADD COLUMN single_count INTEGER DEFAULT 0;

-- 3. 추가된 컬럼 확인
SELECT column_name, data_type, column_default
FROM information_schema.columns 
WHERE table_name = 'reservation_cruise'
  AND column_name IN ('adult_count', 'child_count', 'child_extra_bed_count', 'infant_count', 'extra_bed_count', 'single_count')
ORDER BY ordinal_position;
