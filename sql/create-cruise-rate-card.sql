-- ============================================================
-- 크루즈 객실 요금표 시스템 (cruise_rate_card)
-- ============================================================
-- 목적: 각 크루즈별 객실 요금을 체계적으로 관리
-- 기존 room_price 테이블과 병행 사용
-- ============================================================

-- ============================================================
-- STEP 1: cruise_rate_card 테이블 생성
-- ============================================================
CREATE TABLE IF NOT EXISTS public.cruise_rate_card (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- 크루즈 기본 정보
    cruise_name TEXT NOT NULL,                    -- 크루즈명 (예: '엠바사더 시그니처')
    schedule_type TEXT NOT NULL DEFAULT '1N2D',   -- 일정 유형 ('1N2D', '2N3D', '3N4D')
    room_type TEXT NOT NULL,                      -- 객실 유형 (예: '발코니', '이그제큐티브')
    room_type_en TEXT,                            -- 객실 유형 영문 (예: 'Balcony', 'Executive')
    
    -- 가격 정보 (VND 기준)
    price_adult NUMERIC(15, 0) NOT NULL DEFAULT 0,       -- 성인 1인당
    price_child NUMERIC(15, 0),                          -- 아동 1인당 (5세~11세)
    price_child_extra_bed NUMERIC(15, 0),                -- 아동 엑스트라베드 사용 시 1인당
    price_infant NUMERIC(15, 0),                         -- 유아 (0세~4세)
    price_extra_bed NUMERIC(15, 0),                      -- 엑스트라베드 1인당
    price_single NUMERIC(15, 0),                         -- 싱글차지 (1인 사용 시 룸 요금)
    extra_bed_available BOOLEAN DEFAULT true,             -- 엑스트라베드 가능 여부
    
    -- 적용 기간
    valid_year INTEGER NOT NULL,                 -- 적용 년도 (예: 2026)
    valid_from DATE,                             -- 유효 시작일 (NULL이면 연중)
    valid_to DATE,                               -- 유효 종료일 (NULL이면 연중)
    
    -- 객실 부가 정보
    includes_vehicle BOOLEAN DEFAULT false,       -- 차량 포함 여부
    vehicle_type TEXT,                            -- 차량 유형 ('셔틀차량', '단독차량')
    infant_policy TEXT,                           -- 유아 정책 설명
    
    -- 시즌/프로모션
    season_name TEXT,                             -- 시즌명 (예: '프로모션', '성수기')
    is_promotion BOOLEAN DEFAULT false,           -- 프로모션 가격 여부
    
    -- 정렬 및 메타
    display_order INTEGER DEFAULT 0,             -- 표시 순서
    currency TEXT NOT NULL DEFAULT 'VND',         -- 통화
    is_active BOOLEAN DEFAULT true,              -- 활성 여부
    notes TEXT,                                  -- 비고
    
    -- 타임스탬프
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 유니크 제약: 같은 크루즈+일정+객실+년도 조합은 유일
    CONSTRAINT cruise_rate_card_unique UNIQUE (cruise_name, schedule_type, room_type, valid_year, valid_from)
);

-- 기존 테이블에 새 컬럼 추가 (이미 존재하면 무시)
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS price_child_extra_bed NUMERIC(15, 0);
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS extra_bed_available BOOLEAN DEFAULT true;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS includes_vehicle BOOLEAN DEFAULT false;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS vehicle_type TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS infant_policy TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS season_name TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS is_promotion BOOLEAN DEFAULT false;
-- 할로라/파라다이스 대응 컬럼
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS price_child_older NUMERIC(15, 0);
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS child_age_range TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS single_available BOOLEAN DEFAULT true;

-- 테이블 코멘트
COMMENT ON TABLE public.cruise_rate_card IS '크루즈별 객실 요금표 (연도별, 일정 유형별 관리)';
COMMENT ON COLUMN public.cruise_rate_card.cruise_name IS '크루즈명 (한글)';
COMMENT ON COLUMN public.cruise_rate_card.schedule_type IS '일정 유형: 1N2D(1박2일), 2N3D(2박3일), 3N4D(3박4일)';
COMMENT ON COLUMN public.cruise_rate_card.room_type IS '객실 유형 (한글)';
COMMENT ON COLUMN public.cruise_rate_card.price_adult IS '성인 1인당 가격 (VND)';
COMMENT ON COLUMN public.cruise_rate_card.price_child IS '아동 1인당 가격 (5세~11세, VND)';
COMMENT ON COLUMN public.cruise_rate_card.price_child_extra_bed IS '아동 엑스트라베드 사용 시 1인당 가격 (VND)';
COMMENT ON COLUMN public.cruise_rate_card.price_infant IS '유아 가격 (0세~4세, VND)';
COMMENT ON COLUMN public.cruise_rate_card.price_extra_bed IS '엑스트라베드 1인당 가격 (VND)';
COMMENT ON COLUMN public.cruise_rate_card.price_single IS '싱글차지 - 1인 사용 시 전체 룸 요금 (VND)';
COMMENT ON COLUMN public.cruise_rate_card.extra_bed_available IS '엑스트라베드 가능 여부 (false면 불가)';
COMMENT ON COLUMN public.cruise_rate_card.includes_vehicle IS '차량 포함 여부';
COMMENT ON COLUMN public.cruise_rate_card.vehicle_type IS '포함 차량 유형 (셔틀차량, 단독차량)';
COMMENT ON COLUMN public.cruise_rate_card.infant_policy IS '유아 정책 설명';
COMMENT ON COLUMN public.cruise_rate_card.season_name IS '시즌명 (프로모션, 성수기 등)';
COMMENT ON COLUMN public.cruise_rate_card.is_promotion IS '프로모션 가격 여부';


-- ============================================================
-- STEP 2: cruise_holiday_surcharge 테이블 생성
-- ============================================================
CREATE TABLE IF NOT EXISTS public.cruise_holiday_surcharge (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- 크루즈 정보
    cruise_name TEXT NOT NULL,                    -- 크루즈명 (NULL이면 전체 크루즈 적용)
    schedule_type TEXT DEFAULT '1N2D',            -- 일정 유형
    
    -- 공휴일/특별 기간 정보
    holiday_date DATE NOT NULL,                   -- 공휴일 시작 날짜
    holiday_date_end DATE,                        -- 공휴일 종료 날짜 (단일 날짜면 NULL)
    holiday_name TEXT,                            -- 공휴일 이름 (예: '크리스마스', '설날')
    
    -- 추가요금
    surcharge_per_person NUMERIC(15, 0) NOT NULL DEFAULT 0,  -- 1인당 추가요금 (VND)
    surcharge_type TEXT DEFAULT 'per_person',     -- 추가요금 유형 ('per_person', 'per_room', 'percentage')
    
    -- 적용 정보
    valid_year INTEGER NOT NULL,                 -- 적용 년도
    is_confirmed BOOLEAN DEFAULT true,           -- 확정 여부 (미정인 경우 false)
    currency TEXT NOT NULL DEFAULT 'VND',
    notes TEXT,
    
    -- 타임스탬프
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- 유니크 제약
    CONSTRAINT cruise_holiday_surcharge_unique UNIQUE (cruise_name, schedule_type, holiday_date, valid_year)
);

COMMENT ON TABLE public.cruise_holiday_surcharge IS '크루즈 공휴일/특별일 추가요금 테이블';
COMMENT ON COLUMN public.cruise_holiday_surcharge.surcharge_per_person IS '1인당 추가요금 (VND)';
COMMENT ON COLUMN public.cruise_holiday_surcharge.is_confirmed IS '요금 확정 여부 (false면 미정)';

-- 기존 테이블에 아동 별도 추가요금 컬럼 추가
ALTER TABLE public.cruise_holiday_surcharge ADD COLUMN IF NOT EXISTS surcharge_child NUMERIC(15, 0);
COMMENT ON COLUMN public.cruise_holiday_surcharge.surcharge_child IS '아동 1인당 추가요금 (성인과 다를 경우, VND)';


-- ============================================================
-- STEP 3: 인덱스 생성
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_cruise_rate_card_cruise_name 
    ON public.cruise_rate_card(cruise_name);

CREATE INDEX IF NOT EXISTS idx_cruise_rate_card_year 
    ON public.cruise_rate_card(valid_year);

CREATE INDEX IF NOT EXISTS idx_cruise_rate_card_schedule 
    ON public.cruise_rate_card(cruise_name, schedule_type, valid_year);

CREATE INDEX IF NOT EXISTS idx_cruise_holiday_surcharge_cruise 
    ON public.cruise_holiday_surcharge(cruise_name, valid_year);

CREATE INDEX IF NOT EXISTS idx_cruise_holiday_surcharge_date 
    ON public.cruise_holiday_surcharge(holiday_date);


-- ============================================================
-- STEP 4: updated_at 자동 갱신 트리거
-- ============================================================
CREATE OR REPLACE FUNCTION update_cruise_rate_card_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_cruise_rate_card_updated_at ON public.cruise_rate_card;
CREATE TRIGGER trigger_cruise_rate_card_updated_at
    BEFORE UPDATE ON public.cruise_rate_card
    FOR EACH ROW
    EXECUTE FUNCTION update_cruise_rate_card_updated_at();

DROP TRIGGER IF EXISTS trigger_cruise_holiday_surcharge_updated_at ON public.cruise_holiday_surcharge;
CREATE TRIGGER trigger_cruise_holiday_surcharge_updated_at
    BEFORE UPDATE ON public.cruise_holiday_surcharge
    FOR EACH ROW
    EXECUTE FUNCTION update_cruise_rate_card_updated_at();


-- ============================================================
-- STEP 5: RLS (Row Level Security) 정책
-- ============================================================
ALTER TABLE public.cruise_rate_card ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cruise_holiday_surcharge ENABLE ROW LEVEL SECURITY;

-- 모든 인증된 사용자가 읽기 가능
CREATE POLICY "cruise_rate_card_read_all" ON public.cruise_rate_card
    FOR SELECT USING (true);

CREATE POLICY "cruise_holiday_surcharge_read_all" ON public.cruise_holiday_surcharge
    FOR SELECT USING (true);

-- service_role만 쓰기 가능 (관리자 API를 통해서만 수정)
CREATE POLICY "cruise_rate_card_write_service" ON public.cruise_rate_card
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "cruise_holiday_surcharge_write_service" ON public.cruise_holiday_surcharge
    FOR ALL USING (auth.role() = 'service_role');


-- ============================================================
-- STEP 6: 엠바사더 시그니처 크루즈 2026년 1박2일 요금 데이터 입력
-- ============================================================

-- 기존 데이터 정리 (재실행 안전)
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '엠바사더 시그니처' 
  AND schedule_type = '1N2D' 
  AND valid_year = 2026;

-- 객실 요금 입력
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en, 
     price_adult, price_child, price_infant, price_extra_bed, price_single,
     valid_year, display_order, notes)
VALUES
    -- 1. 발코니
    ('엠바사더 시그니처', '1N2D', '발코니', 'Balcony',
     3750000, 2750000, 950000, 3750000, 6800000,
     2026, 1, '아동: 5세~11세, 유아: 0세~4세'),
    
    -- 2. 이그제큐티브
    ('엠바사더 시그니처', '1N2D', '이그제큐티브', 'Executive',
     4000000, NULL, NULL, 4000000, 7300000,
     2026, 2, '아동/유아 가격은 발코니 기준 적용 문의'),
    
    -- 3. 발코니 스위트
    ('엠바사더 시그니처', '1N2D', '발코니 스위트', 'Balcony Suite',
     4700000, NULL, NULL, 4700000, 8800000,
     2026, 3, '아동/유아 가격은 발코니 기준 적용 문의'),
    
    -- 4. 캡틴 뷰 엠바사더 스위트
    ('엠바사더 시그니처', '1N2D', '캡틴 뷰 엠바사더 스위트', 'Captain View Ambassador Suite',
     5050000, NULL, NULL, 5050000, 9450000,
     2026, 4, '아동/유아 가격은 발코니 기준 적용 문의');


-- ============================================================
-- STEP 7: 엠바사더 시그니처 2026년 공휴일/특별일 추가요금 입력
-- ============================================================

-- 기존 데이터 정리 (재실행 안전)
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '엠바사더 시그니처' 
  AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    -- 크리스마스 이브
    ('엠바사더 시그니처', '1N2D', '2026-12-24', NULL, '크리스마스 이브',
     1350000, 2026, true, '1인당 1,350,000동 추가'),
    
    -- 연말 (12/31)
    ('엠바사더 시그니처', '1N2D', '2026-12-31', NULL, '연말',
     1350000, 2026, true, '1인당 1,350,000동 추가'),
    
    -- 베트남 독립기념일 (09/02)
    ('엠바사더 시그니처', '1N2D', '2026-09-02', NULL, '베트남 독립기념일',
     800000, 2026, true, '1인당 800,000동 추가'),
    
    -- 베트남 통일의 날 / 노동절 (04/30 ~ 05/01)
    ('엠바사더 시그니처', '1N2D', '2026-04-30', '2026-05-01', '통일의 날 / 노동절',
     0, 2026, false, '미정 - 추후 확정 예정');


-- ============================================================
-- STEP 8: PostgREST 스키마 캐시 새로고침
-- ============================================================
NOTIFY pgrst, 'reload schema';


-- ============================================================
-- STEP 9: 데이터 확인 쿼리
-- ============================================================

-- 요금표 확인
SELECT 
    cruise_name AS "크루즈",
    schedule_type AS "일정",
    room_type AS "객실",
    TO_CHAR(price_adult, 'FM999,999,999') || '동' AS "성인1인",
    CASE WHEN price_child IS NOT NULL 
         THEN TO_CHAR(price_child, 'FM999,999,999') || '동' 
         ELSE '-' END AS "아동1인",
    CASE WHEN price_infant IS NOT NULL 
         THEN TO_CHAR(price_infant, 'FM999,999,999') || '동' 
         ELSE '-' END AS "유아",
    TO_CHAR(price_extra_bed, 'FM999,999,999') || '동' AS "엑스트라베드",
    TO_CHAR(price_single, 'FM999,999,999') || '동' AS "싱글차지"
FROM public.cruise_rate_card
WHERE cruise_name = '엠바사더 시그니처' 
  AND valid_year = 2026
ORDER BY display_order;

-- 공휴일 추가요금 확인
SELECT 
    cruise_name AS "크루즈",
    holiday_date AS "날짜",
    holiday_date_end AS "종료일",
    holiday_name AS "공휴일명",
    CASE WHEN is_confirmed 
         THEN TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동'
         ELSE '미정' END AS "추가요금(1인)",
    CASE WHEN is_confirmed THEN '✅ 확정' ELSE '⏳ 미정' END AS "상태"
FROM public.cruise_holiday_surcharge
WHERE cruise_name = '엠바사더 시그니처' 
  AND valid_year = 2026
ORDER BY holiday_date;


-- ============================================================
-- 완료 메시지
-- ============================================================
DO $$
BEGIN
    RAISE NOTICE '
    ✅ 크루즈 요금표 시스템 구축 완료!
    
    📋 생성된 테이블:
    1. cruise_rate_card       - 크루즈 객실 요금표
    2. cruise_holiday_surcharge - 공휴일/특별일 추가요금
    
    📊 입력된 데이터:
    - 엠바사더 시그니처 2026년 1박2일: 4개 객실 유형
    - 공휴일 추가요금: 4건 (12/24, 12/31, 09/02, 04/30~05/01)
    
    🔄 다음 단계:
    - 다른 크루즈 요금표 추가 (같은 INSERT 패턴 사용)
    - 견적서 작성 시 자동 가격 조회 기능 연동
    ';
END $$;
