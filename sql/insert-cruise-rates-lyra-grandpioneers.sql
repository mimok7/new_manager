-- ============================================================
-- 크루즈 요금표: 라이라 그랜져 + 그랜드 파이어니스
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
--  1. 라이라 그랜져 크루즈 2026년 1박2일
-- ============================================================
-- 11개 객실 × 3시즌 = 33행
-- 패밀리 스위트: 성인만 가격, 아동/엑스트라/싱글 없음
-- 유아: 객실당 1명 무료, 2번째부터 성인요금의 30%

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '라이라 그랜져 크루즈' AND valid_year = 2026;

-- 시즌1: 01/01 ~ 04/30
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_extra_bed, price_single,
     extra_bed_available, single_available, infant_policy,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('라이라 그랜져 크루즈', '1N2D', '오아시스 스위트 (1층)', 'Oasis Suite (1F)',
     6100000, 3100000, 4650000, 10500000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 1, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '하모니 스위트 (2층)', 'Harmony Suite (2F)',
     6600000, 3350000, 5000000, 11200000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 2, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 스위트 (3층)', 'Sky Suite (3F)',
     7200000, 3650000, 5450000, 12200000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 3, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 테라스 스위트 (3층)', 'Sky Terrace Suite (3F)',
     10000000, 5050000, 7550000, 16900000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 4, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '오아시스 패밀리 스위트 (1층/4인)', 'Oasis Family Suite (1F/4pax)',
     5550000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 5, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '하모니 패밀리 스위트 (2층/4~5인)', 'Harmony Family Suite (2F/4-5pax)',
     5950000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 6, '4~5인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 패밀리 스위트 (3층/4인)', 'Sky Family Suite (3F/4pax)',
     6500000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 7, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 테라스 패밀리 스위트 (3층/4명)', 'Sky Terrace Family Suite (3F/4pax)',
     7150000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 8, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '듀플렉스 패밀리 스위트 (3-4층/4인)', 'Duplex Family Suite (3-4F/4pax)',
     7800000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 9, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '라 스위트 드 LYRA (2층)', 'La Suite de LYRA (2F)',
     12850000, 6450000, NULL, 21800000, false, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 10, '엑스트라베드 불가'),
    ('라이라 그랜져 크루즈', '1N2D', '오너스 스위트', 'Owners Suite',
     24800000, 12500000, NULL, 42100000, false, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-01-01', '2026-04-30', 11, '엑스트라베드 불가');

-- 시즌2: 05/01 ~ 09/30
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_extra_bed, price_single,
     extra_bed_available, single_available, infant_policy,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('라이라 그랜져 크루즈', '1N2D', '오아시스 스위트 (1층)', 'Oasis Suite (1F)',
     5850000, 3000000, 4450000, 10100000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 1, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '하모니 스위트 (2층)', 'Harmony Suite (2F)',
     6300000, 3200000, 4750000, 10700000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 2, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 스위트 (3층)', 'Sky Suite (3F)',
     6900000, 3550000, 5200000, 11800000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 3, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 테라스 스위트 (3층)', 'Sky Terrace Suite (3F)',
     9550000, 4850000, 7200000, 16300000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 4, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '오아시스 패밀리 스위트 (1층/4인)', 'Oasis Family Suite (1F/4pax)',
     5300000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 5, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '하모니 패밀리 스위트 (2층/4~5인)', 'Harmony Family Suite (2F/4-5pax)',
     5650000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 6, '4~5인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 패밀리 스위트 (3층/4인)', 'Sky Family Suite (3F/4pax)',
     6200000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 7, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 테라스 패밀리 스위트 (3층/4명)', 'Sky Terrace Family Suite (3F/4pax)',
     6850000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 8, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '듀플렉스 패밀리 스위트 (3-4층/4인)', 'Duplex Family Suite (3-4F/4pax)',
     7500000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 9, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '라 스위트 드 LYRA (2층)', 'La Suite de LYRA (2F)',
     12300000, 6150000, NULL, 20800000, false, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 10, '엑스트라베드 불가'),
    ('라이라 그랜져 크루즈', '1N2D', '오너스 스위트', 'Owners Suite',
     23600000, 11850000, NULL, 40100000, false, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-05-01', '2026-09-30', 11, '엑스트라베드 불가');

-- 시즌3: 10/01 ~ 12/31
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_extra_bed, price_single,
     extra_bed_available, single_available, infant_policy,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('라이라 그랜져 크루즈', '1N2D', '오아시스 스위트 (1층)', 'Oasis Suite (1F)',
     6450000, 3300000, 4850000, 11000000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 1, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '하모니 스위트 (2층)', 'Harmony Suite (2F)',
     6900000, 3500000, 5200000, 11800000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 2, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 스위트 (3층)', 'Sky Suite (3F)',
     7600000, 3850000, 5750000, 13000000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 3, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 테라스 스위트 (3층)', 'Sky Terrace Suite (3F)',
     10500000, 5300000, 7900000, 15800000, true, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 4, NULL),
    ('라이라 그랜져 크루즈', '1N2D', '오아시스 패밀리 스위트 (1층/4인)', 'Oasis Family Suite (1F/4pax)',
     5800000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 5, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '하모니 패밀리 스위트 (2층/4~5인)', 'Harmony Family Suite (2F/4-5pax)',
     6300000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 6, '4~5인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 패밀리 스위트 (3층/4인)', 'Sky Family Suite (3F/4pax)',
     6900000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 7, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '스카이 테라스 패밀리 스위트 (3층/4명)', 'Sky Terrace Family Suite (3F/4pax)',
     7550000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 8, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '듀플렉스 패밀리 스위트 (3-4층/4인)', 'Duplex Family Suite (3-4F/4pax)',
     8250000, NULL, NULL, NULL, false, false,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 9, '4인 기준 1인당 가격'),
    ('라이라 그랜져 크루즈', '1N2D', '라 스위트 드 LYRA (2층)', 'La Suite de LYRA (2F)',
     13500000, 6800000, NULL, 23000000, false, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 10, '엑스트라베드 불가'),
    ('라이라 그랜져 크루즈', '1N2D', '오너스 스위트', 'Owners Suite',
     26000000, 13100000, NULL, 44500000, false, true,
     '객실당 유아 1인 무료, 2인째부터 성인요금의 30%', 2026, '2026-10-01', '2026-12-31', 11, '엑스트라베드 불가');


-- ============================================================
--  2. 그랜드 파이어니스 크루즈 2026년 1박2일
-- ============================================================
-- 2시즌: ~02/28, 03/01~
-- 아동 엑스트라베드 별도 가격
-- 더 오너스 스위트: 인원별(2/3/4인) 가격 차등, 엑스트라 불가

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '그랜드 파이어니스' AND valid_year = 2026;

-- 시즌1: ~2026/02/28
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, single_available,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('그랜드 파이어니스', '1N2D', '오션스위트룸', 'Ocean Suite Room',
     5250000, 3200000, 4250000, 4800000, 8600000,
     true, true, 2026, '2026-01-01', '2026-02-28', 1, NULL),
    ('그랜드 파이어니스', '1N2D', '오션스위트 트리플룸', 'Ocean Suite Triple Room',
     5300000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-01-01', '2026-02-28', 2, '트리플룸: 엑스트라/싱글 불가'),
    ('그랜드 파이어니스', '1N2D', '오션발코니 스위트', 'Ocean Balcony Suite',
     5250000, NULL, 4250000, 4800000, 8600000,
     true, true, 2026, '2026-01-01', '2026-02-28', 3, NULL),
    ('그랜드 파이어니스', '1N2D', '베란다 스위트', 'Veranda Suite',
     6300000, NULL, 4300000, 5600000, 10200000,
     true, true, 2026, '2026-01-01', '2026-02-28', 4, NULL),
    ('그랜드 파이어니스', '1N2D', '이그제큐티브 스위트', 'Executive Suite',
     6800000, NULL, 4300000, 6100000, 11000000,
     true, true, 2026, '2026-01-01', '2026-02-28', 5, NULL),
    ('그랜드 파이어니스', '1N2D', '더 에센스 스위트', 'The Essence Suite',
     9300000, NULL, NULL, NULL, 15000000,
     false, true, 2026, '2026-01-01', '2026-02-28', 6, '엑스트라베드 불가'),
    ('그랜드 파이어니스', '1N2D', '더 오셔니아 스위트', 'The Oceania Suite',
     15300000, NULL, NULL, 13800000, 24600000,
     true, true, 2026, '2026-01-01', '2026-02-28', 7, '아동 불가'),
    ('그랜드 파이어니스', '1N2D', '더 오너스 스위트 (2인)', 'The Owners Suite (2pax)',
     22900000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-01-01', '2026-02-28', 8, '2인 기준, 아동=성인요금 동일, 엑스트라 불가'),
    ('그랜드 파이어니스', '1N2D', '더 오너스 스위트 (3인)', 'The Owners Suite (3pax)',
     17100000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-01-01', '2026-02-28', 9, '3인 기준 1인당 가격'),
    ('그랜드 파이어니스', '1N2D', '더 오너스 스위트 (4인)', 'The Owners Suite (4pax)',
     14200000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-01-01', '2026-02-28', 10, '4인 기준 1인당 가격');

-- 시즌2: 2026/03/01~
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, single_available,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('그랜드 파이어니스', '1N2D', '오션스위트룸', 'Ocean Suite Room',
     5200000, 3150000, 4200000, 4700000, 8600000,
     true, true, 2026, '2026-03-01', '2026-12-31', 1, '3월 이후 일부 인하'),
    ('그랜드 파이어니스', '1N2D', '오션스위트 트리플룸', 'Ocean Suite Triple Room',
     5300000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-03-01', '2026-12-31', 2, '트리플룸: 엑스트라/싱글 불가'),
    ('그랜드 파이어니스', '1N2D', '오션발코니 스위트', 'Ocean Balcony Suite',
     5200000, NULL, 4200000, 4700000, 8600000,
     true, true, 2026, '2026-03-01', '2026-12-31', 3, '3월 이후 일부 인하'),
    ('그랜드 파이어니스', '1N2D', '베란다 스위트', 'Veranda Suite',
     6200000, NULL, 4200000, 5600000, 10200000,
     true, true, 2026, '2026-03-01', '2026-12-31', 4, '3월 이후 일부 인하'),
    ('그랜드 파이어니스', '1N2D', '이그제큐티브 스위트', 'Executive Suite',
     6700000, NULL, 4200000, 6050000, 11000000,
     true, true, 2026, '2026-03-01', '2026-12-31', 5, '3월 이후 일부 인하'),
    ('그랜드 파이어니스', '1N2D', '더 에센스 스위트', 'The Essence Suite',
     9300000, 3200000, NULL, NULL, 15000000,
     false, true, 2026, '2026-03-01', '2026-12-31', 6, '3월부터 아동가격 추가, 엑스트라 불가'),
    ('그랜드 파이어니스', '1N2D', '더 오셔니아 스위트', 'The Oceania Suite',
     15300000, NULL, NULL, 13800000, 24600000,
     true, true, 2026, '2026-03-01', '2026-12-31', 7, '아동 불가'),
    ('그랜드 파이어니스', '1N2D', '더 오너스 스위트 (2인)', 'The Owners Suite (2pax)',
     22900000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-03-01', '2026-12-31', 8, '2인 기준, 아동=성인요금 동일, 엑스트라 불가'),
    ('그랜드 파이어니스', '1N2D', '더 오너스 스위트 (3인)', 'The Owners Suite (3pax)',
     17100000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-03-01', '2026-12-31', 9, '3인 기준 1인당 가격'),
    ('그랜드 파이어니스', '1N2D', '더 오너스 스위트 (4인)', 'The Owners Suite (4pax)',
     14200000, NULL, NULL, NULL, NULL,
     false, false, 2026, '2026-03-01', '2026-12-31', 10, '4인 기준 1인당 가격');

-- 그랜드 파이어니스 공휴일
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '그랜드 파이어니스' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('그랜드 파이어니스', '1N2D', '2026-01-28', '2026-01-31', '설 연휴',
     1500000, 2026, true, '1인당 1,500,000동 추가'),
    ('그랜드 파이어니스', '1N2D', '2026-02-15', '2026-02-21', '설 연휴 (구정)',
     1600000, 2026, true, '1인당 1,600,000동 추가'),
    ('그랜드 파이어니스', '1N2D', '2026-04-30', '2026-05-01', '통일의 날 / 노동절',
     1500000, 2026, true, '1인당 1,500,000동 추가'),
    ('그랜드 파이어니스', '1N2D', '2026-08-30', '2026-09-01', '독립기념일 연휴',
     1250000, 2026, true, '1인당 1,250,000동 추가'),
    ('그랜드 파이어니스', '1N2D', '2026-12-24', NULL, '크리스마스 이브',
     1500000, 2026, true, '1인당 1,500,000동 추가'),
    ('그랜드 파이어니스', '1N2D', '2026-12-31', NULL, '연말',
     1500000, 2026, true, '1인당 1,500,000동 추가');


NOTIFY pgrst, 'reload schema';

-- 전체 요약
SELECT cruise_name AS "크루즈", COUNT(*) AS "가격행수",
    COUNT(DISTINCT room_type) AS "객실수",
    TO_CHAR(MIN(price_adult), 'FM999,999,999') || '동' AS "최저가",
    TO_CHAR(MAX(price_adult), 'FM999,999,999') || '동' AS "최고가"
FROM public.cruise_rate_card WHERE valid_year = 2026 AND is_active = true
GROUP BY cruise_name ORDER BY cruise_name;

DO $$
BEGIN RAISE NOTICE '✅ 라이라 그랜져 + 그랜드 파이어니스 요금 입력 완료'; END $$;
