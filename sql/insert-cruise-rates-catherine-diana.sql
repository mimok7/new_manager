-- ============================================================
-- 크루즈 요금표: 캐서린 + 다이아나 크루즈
-- ============================================================

-- STEP 0: 컬럼 확장
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS price_child_extra_bed NUMERIC(15, 0);
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS extra_bed_available BOOLEAN DEFAULT true;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS includes_vehicle BOOLEAN DEFAULT false;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS vehicle_type TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS infant_policy TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS season_name TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS is_promotion BOOLEAN DEFAULT false;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS price_child_older NUMERIC(15, 0);
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS child_age_range TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS single_available BOOLEAN DEFAULT true;
ALTER TABLE public.cruise_holiday_surcharge ADD COLUMN IF NOT EXISTS surcharge_child NUMERIC(15, 0);


-- ============================================================
--  1. 캐서린 크루즈 2026년 1박2일
-- ============================================================
-- 연중 동일 가격, 프리미어 스위트 트리플: 엑스트라/싱글 불가
-- 엑스트라베드: 추가요금 아닌 대체요금 (성인2 + 엑스트라1 방식)

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '캐서린 크루즈' AND valid_year = 2026;

INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_extra_bed, price_single,
     extra_bed_available, single_available, infant_policy,
     valid_year, display_order, notes)
VALUES
    ('캐서린 크루즈', '1N2D', '프리미어 스위트 (1층)', 'Premier Suite (1F)',
     5300000, 3300000, 4700000, 8450000,
     true, true, NULL,
     2026, 1, '엑스트라베드는 추가요금이 아닌 대체요금 (성인2+엑스트라1)'),

    ('캐서린 크루즈', '1N2D', '프리미어 스위트 트리플 (1층)', 'Premier Suite Triple (1F)',
     5300000, NULL, NULL, NULL,
     false, false, NULL,
     2026, 2, '엑스트라베드 불가, 싱글 불가'),

    ('캐서린 크루즈', '1N2D', '프리미어 스위트 (2층)', 'Premier Suite (2F)',
     5600000, NULL, 5000000, 8900000,
     true, true, NULL,
     2026, 3, NULL),

    ('캐서린 크루즈', '1N2D', '프리미어 스위트 (3층)', 'Premier Suite (3F)',
     5800000, NULL, 5250000, 9350000,
     true, true, NULL,
     2026, 4, NULL),

    ('캐서린 크루즈', '1N2D', '로얄 스위트', 'Royal Suite',
     7500000, NULL, 6700000, 12500000,
     true, true, NULL,
     2026, 5, NULL),

    ('캐서린 크루즈', '1N2D', '그랜드 스위트', 'Grand Suite',
     8350000, NULL, 7500000, 14100000,
     true, true, NULL,
     2026, 6, NULL),

    ('캐서린 크루즈', '1N2D', '빌라 프레지던트', 'Villa President',
     15800000, 3500000, 14200000, 29150000,
     true, true, NULL,
     2026, 7, NULL);

-- 캐서린 공휴일
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '캐서린 크루즈' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('캐서린 크루즈', '1N2D', '2026-04-30', '2026-05-01', '통일의 날 / 노동절',
     1200000, 2026, true, '1인당 1,200,000동 추가'),
    ('캐서린 크루즈', '1N2D', '2026-12-24', NULL, '크리스마스 이브',
     1200000, 2026, true, '1인당 1,200,000동 추가'),
    ('캐서린 크루즈', '1N2D', '2026-12-31', NULL, '연말',
     1200000, 2026, true, '1인당 1,200,000동 추가');


-- ============================================================
--  2. 다이아나 크루즈 2026년 1박2일
-- ============================================================
-- 시즌1: 01/01-04/30, 10/01-12/01 (일반)
-- 시즌2: 05/01-09/30 (8% 할인)
-- 유아: 객실당 1명 무료, 2번째부터 90만동/인

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '다이아나 크루즈' AND valid_year = 2026;

-- 시즌1a: 01/01 ~ 04/30
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_extra_bed, price_single,
     infant_policy, valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('다이아나 크루즈', '1N2D', '주니어 발코니 (1층)', 'Junior Balcony (1F)',
     4700000, 3600000, 900000, 4700000, 7650000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-01-01', '2026-04-30', 1, NULL),
    ('다이아나 크루즈', '1N2D', '시니어 발코니 (1층)', 'Senior Balcony (1F)',
     5000000, 3800000, 900000, 5000000, 8000000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-01-01', '2026-04-30', 2, NULL),
    ('다이아나 크루즈', '1N2D', '이그제큐티브 발코니 (2층)', 'Executive Balcony (2F)',
     5250000, 4000000, 900000, 5250000, 8400000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-01-01', '2026-04-30', 3, NULL),
    ('다이아나 크루즈', '1N2D', '프리미어 발코니 (3층)', 'Premier Balcony (3F)',
     5750000, 4400000, 900000, 5750000, 9200000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-01-01', '2026-04-30', 4, NULL),
    ('다이아나 크루즈', '1N2D', '하롱 스위트 (2층 VIP)', 'Ha Long Suite (2F VIP)',
     8600000, 6550000, 900000, 8600000, 13800000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-01-01', '2026-04-30', 5, NULL),
    ('다이아나 크루즈', '1N2D', '란하 스위트 (3층 VIP)', 'Lan Ha Suite (3F VIP)',
     9750000, 7350000, 900000, 9750000, 15500000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-01-01', '2026-04-30', 6, NULL);

-- 시즌2: 05/01 ~ 09/30 (8% 할인)
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_infant, price_extra_bed, price_single,
     infant_policy, season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('다이아나 크루즈', '1N2D', '주니어 발코니 (1층)', 'Junior Balcony (1F)',
     4324000, 3312000, 900000, 4324000, 7038000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', '8% 할인', true,
     2026, '2026-05-01', '2026-09-30', 1, '일반가 대비 8% 할인 적용'),
    ('다이아나 크루즈', '1N2D', '시니어 발코니 (1층)', 'Senior Balcony (1F)',
     4600000, 3496000, 900000, 4600000, 7360000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', '8% 할인', true,
     2026, '2026-05-01', '2026-09-30', 2, '일반가 대비 8% 할인 적용'),
    ('다이아나 크루즈', '1N2D', '이그제큐티브 발코니 (2층)', 'Executive Balcony (2F)',
     4830000, 3680000, 900000, 4830000, 7728000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', '8% 할인', true,
     2026, '2026-05-01', '2026-09-30', 3, '일반가 대비 8% 할인 적용'),
    ('다이아나 크루즈', '1N2D', '프리미어 발코니 (3층)', 'Premier Balcony (3F)',
     5290000, 4048000, 900000, 5290000, 8464000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', '8% 할인', true,
     2026, '2026-05-01', '2026-09-30', 4, '일반가 대비 8% 할인 적용'),
    ('다이아나 크루즈', '1N2D', '하롱 스위트 (2층 VIP)', 'Ha Long Suite (2F VIP)',
     7912000, 6026000, 900000, 7912000, 12696000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', '8% 할인', true,
     2026, '2026-05-01', '2026-09-30', 5, '일반가 대비 8% 할인 적용'),
    ('다이아나 크루즈', '1N2D', '란하 스위트 (3층 VIP)', 'Lan Ha Suite (3F VIP)',
     8970000, 6762000, 900000, 8970000, 14260000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', '8% 할인', true,
     2026, '2026-05-01', '2026-09-30', 6, '일반가 대비 8% 할인 적용');

-- 시즌3: 10/01~12/01 (시즌1과 동일)
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_infant, price_extra_bed, price_single,
     infant_policy, valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('다이아나 크루즈', '1N2D', '주니어 발코니 (1층)', 'Junior Balcony (1F)',
     4700000, 3600000, 900000, 4700000, 7650000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-10-01', '2026-12-01', 1, NULL),
    ('다이아나 크루즈', '1N2D', '시니어 발코니 (1층)', 'Senior Balcony (1F)',
     5000000, 3800000, 900000, 5000000, 8000000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-10-01', '2026-12-01', 2, NULL),
    ('다이아나 크루즈', '1N2D', '이그제큐티브 발코니 (2층)', 'Executive Balcony (2F)',
     5250000, 4000000, 900000, 5250000, 8400000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-10-01', '2026-12-01', 3, NULL),
    ('다이아나 크루즈', '1N2D', '프리미어 발코니 (3층)', 'Premier Balcony (3F)',
     5750000, 4400000, 900000, 5750000, 9200000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-10-01', '2026-12-01', 4, NULL),
    ('다이아나 크루즈', '1N2D', '하롱 스위트 (2층 VIP)', 'Ha Long Suite (2F VIP)',
     8600000, 6550000, 900000, 8600000, 13800000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-10-01', '2026-12-01', 5, NULL),
    ('다이아나 크루즈', '1N2D', '란하 스위트 (3층 VIP)', 'Lan Ha Suite (3F VIP)',
     9750000, 7350000, 900000, 9750000, 15500000,
     '객실당 유아 1인 무료, 2인째부터 900,000동/인', 2026, '2026-10-01', '2026-12-01', 6, NULL);

-- 다이아나 공휴일
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '다이아나 크루즈' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_name,
     surcharge_per_person, surcharge_child, valid_year, is_confirmed, notes)
VALUES
    ('다이아나 크루즈', '1N2D', '2026-12-24', '크리스마스 이브',
     1300000, 1300000, 2026, true, '성인/아동 동일 1,300,000동 추가'),
    ('다이아나 크루즈', '1N2D', '2026-12-31', '연말',
     1300000, 1300000, 2026, true, '성인/아동 동일 1,300,000동 추가');

-- 다이아나 6~8월 토요일 추가요금 (범위로 표현)
INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, surcharge_child, valid_year, is_confirmed, notes)
VALUES
    ('다이아나 크루즈', '1N2D', '2026-06-01', '2026-08-31', '6~8월 매주 토요일',
     350000, 350000, 2026, true, '6월~8월 매주 토요일 승선 시 1인당 350,000동 추가 (성인/아동 동일)');


NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
    RAISE NOTICE '✅ 캐서린 + 다이아나 크루즈 요금 입력 완료';
END $$;
