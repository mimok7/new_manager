-- 패키지 시스템 구축을 위한 SQL 스크립트
-- 1. 패키지 마스터 테이블 생성 (상품 정의)
CREATE TABLE IF NOT EXISTS public.package_master (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    package_code VARCHAR(50) UNIQUE NOT NULL, -- 예: 'PKG-HALONG-001'
    name TEXT NOT NULL,                        -- 패키지 명
    description TEXT,                          -- 패키지 상세 설명
    base_price NUMERIC(15, 2) DEFAULT 0,       -- 기본 판매가
    is_active BOOLEAN DEFAULT true,            -- 판매 여부
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 패키지 구성 요소 정의 테이블 (템플릿 정보)
CREATE TABLE IF NOT EXISTS public.package_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    package_id UUID REFERENCES public.package_master(id) ON DELETE CASCADE,
    service_type TEXT NOT NULL, -- 'cruise', 'hotel', 'airport', 'tour', 'rentcar', 'car_sht'
    item_order INTEGER DEFAULT 0, -- 생성 순서
    default_data JSONB,           -- 기본값 (예: 크루즈 코드, 투어 타입 등)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 기존 reservation 테이블에 패키지 연결 컬럼 추가
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='reservation' AND column_name='package_id') THEN
        ALTER TABLE public.reservation ADD COLUMN package_id UUID REFERENCES public.package_master(id);
    END IF;
END $$;

-- 4. 샘플 데이터 삽입
INSERT INTO public.package_master (package_code, name, description, base_price)
VALUES ('PKG-HL-PREMIUM', '하롱베이 프리미엄 2박3일 패키지', '크루즈+호텔+차량이 포함된 풀 패키지', 1200000)
ON CONFLICT (package_code) DO NOTHING;

-- 패키지 아이템 정의 (예시: 크루즈, 호텔, 공항 픽업 포함)
INSERT INTO public.package_items (package_id, service_type, item_order)
SELECT id, 'cruise', 1 FROM public.package_master WHERE package_code = 'PKG-HL-PREMIUM'
UNION ALL
SELECT id, 'hotel', 2 FROM public.package_master WHERE package_code = 'PKG-HL-PREMIUM'
UNION ALL
SELECT id, 'airport', 3 FROM public.package_master WHERE package_code = 'PKG-HL-PREMIUM'
ON CONFLICT DO NOTHING;

COMMENT ON TABLE public.package_master IS '패키지 상품 정의 마스터 테이블';
COMMENT ON TABLE public.package_items IS '패키지에 포함된 개별 서비스 템플릿 테이블';
