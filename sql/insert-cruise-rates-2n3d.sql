-- ============================================================
-- 크루즈 2박3일 요금표: 칼리스타 + 캐서린 + 그랜드 파이어니스
-- schedule_type = '2N3D'
-- ============================================================

-- 컬럼 확장
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
--  1. 칼리스타 크루즈 2N3D (6객실 × 3시즌 = 18행)
-- ============================================================
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D' AND valid_year = 2026;

-- 시즌1: 01/01~04/30
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, includes_vehicle, vehicle_type, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('칼리스타 크루즈', '2N3D', '칼리스타 오션', 'Calista Ocean',
     9300000, 5550000, 7650000, 9300000, 15800000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-01-01', '2026-04-30', 1, NULL),
    ('칼리스타 크루즈', '2N3D', '칼리스타 베이', 'Calista Bay',
     10000000, NULL, NULL, 10000000, 18600000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-01-01', '2026-04-30', 2, NULL),
    ('칼리스타 크루즈', '2N3D', '칼리스타 레거시', 'Calista Legacy',
     12000000, NULL, NULL, 12000000, 20400000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-01-01', '2026-04-30', 3, NULL),
    ('칼리스타 크루즈', '2N3D', 'Horizon Suite', 'Horizon Suite',
     18200000, NULL, NULL, 18200000, 31000000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-01-01', '2026-04-30', 4, '셔틀차량 포함'),
    ('칼리스타 크루즈', '2N3D', 'Majesty Suite', 'Majesty Suite',
     20400000, NULL, NULL, 20400000, 34900000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-01-01', '2026-04-30', 5, '셔틀차량 포함'),
    ('칼리스타 크루즈', '2N3D', 'President Suite', 'President Suite',
     44600000, NULL, NULL, NULL, 75800000,
     false, true, '단독차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-01-01', '2026-04-30', 6, '단독차량 포함, 엑스트라 불가');

-- 시즌2: 05/01~09/30 프로모션
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, includes_vehicle, vehicle_type, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('칼리스타 크루즈', '2N3D', '칼리스타 오션', 'Calista Ocean',
     7950000, 5550000, 7650000, 3975000, 13600000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     '프로모션', true, 2026, '2026-05-01', '2026-09-30', 1, NULL),
    ('칼리스타 크루즈', '2N3D', '칼리스타 베이', 'Calista Bay',
     8500000, NULL, NULL, 3975000, 14500000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     '프로모션', true, 2026, '2026-05-01', '2026-09-30', 2, NULL),
    ('칼리스타 크루즈', '2N3D', '칼리스타 레거시', 'Calista Legacy',
     9300000, NULL, NULL, 9300000, 15900000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     '프로모션', true, 2026, '2026-05-01', '2026-09-30', 3, NULL),
    ('칼리스타 크루즈', '2N3D', 'Horizon Suite', 'Horizon Suite',
     16600000, NULL, NULL, 16600000, 28200000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     '프로모션', true, 2026, '2026-05-01', '2026-09-30', 4, '셔틀차량 포함'),
    ('칼리스타 크루즈', '2N3D', 'Majesty Suite', 'Majesty Suite',
     18800000, NULL, NULL, 18800000, 32000000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     '프로모션', true, 2026, '2026-05-01', '2026-09-30', 5, '셔틀차량 포함'),
    ('칼리스타 크루즈', '2N3D', 'President Suite', 'President Suite',
     40300000, NULL, NULL, NULL, 68600000,
     false, true, '단독차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     '프로모션', true, 2026, '2026-05-01', '2026-09-30', 6, '단독차량 포함, 엑스트라 불가');

-- 시즌3: 10/01~12/31 (S1과 유사, 칼리스타 베이만 다름)
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, includes_vehicle, vehicle_type, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('칼리스타 크루즈', '2N3D', '칼리스타 오션', 'Calista Ocean',
     9300000, 5550000, 7650000, 9300000, 15800000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-10-01', '2026-12-31', 1, NULL),
    ('칼리스타 크루즈', '2N3D', '칼리스타 베이', 'Calista Bay',
     10950000, NULL, NULL, 10950000, 18600000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-10-01', '2026-12-31', 2, '시즌1 대비 베이 가격 상이'),
    ('칼리스타 크루즈', '2N3D', '칼리스타 레거시', 'Calista Legacy',
     12000000, NULL, NULL, 12000000, 20400000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-10-01', '2026-12-31', 3, NULL),
    ('칼리스타 크루즈', '2N3D', 'Horizon Suite', 'Horizon Suite',
     18200000, NULL, NULL, 18200000, 31000000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-10-01', '2026-12-31', 4, '셔틀차량 포함'),
    ('칼리스타 크루즈', '2N3D', 'Majesty Suite', 'Majesty Suite',
     20400000, NULL, NULL, 20400000, 34900000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-10-01', '2026-12-31', 5, '셔틀차량 포함'),
    ('칼리스타 크루즈', '2N3D', 'President Suite', 'President Suite',
     44600000, NULL, NULL, NULL, 75800000,
     false, true, '단독차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 5,900,000동/인',
     NULL, false, 2026, '2026-10-01', '2026-12-31', 6, '단독차량 포함, 엑스트라 불가');

-- 칼리스타 2N3D 공휴일
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('칼리스타 크루즈', '2N3D', '2026-04-30', '2026-05-01', '통일의 날 / 노동절',
     1200000, 2026, true, '1인당 1,200,000동 추가'),
    ('칼리스타 크루즈', '2N3D', '2026-12-24', NULL, '크리스마스 이브',
     1200000, 2026, true, '1인당 1,200,000동 추가'),
    ('칼리스타 크루즈', '2N3D', '2026-12-31', NULL, '연말',
     1200000, 2026, true, '1인당 1,200,000동 추가');


-- ============================================================
--  2. 캐서린 크루즈 2N3D (7객실, 연중 동일)
-- ============================================================
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D' AND valid_year = 2026;

INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_extra_bed, price_single,
     extra_bed_available, single_available,
     valid_year, display_order, notes)
VALUES
    ('캐서린 크루즈', '2N3D', '프리미어 스위트 (1층)', 'Premier Suite (1F)',
     10600000, 6600000, 9400000, 16900000,
     true, true, 2026, 1, NULL),
    ('캐서린 크루즈', '2N3D', '프리미어 스위트 트리플 (1층)', 'Premier Suite Triple (1F)',
     10600000, NULL, NULL, NULL,
     false, false, 2026, 2, '엑스트라/싱글 불가'),
    ('캐서린 크루즈', '2N3D', '프리미어 스위트 (2층)', 'Premier Suite (2F)',
     11200000, NULL, 10000000, 17800000,
     true, true, 2026, 3, NULL),
    ('캐서린 크루즈', '2N3D', '프리미어 스위트 (3층)', 'Premier Suite (3F)',
     11600000, NULL, 10500000, 18700000,
     true, true, 2026, 4, NULL),
    ('캐서린 크루즈', '2N3D', '로얄 스위트', 'Royal Suite',
     15000000, NULL, 13400000, 25000000,
     true, true, 2026, 5, NULL),
    ('캐서린 크루즈', '2N3D', '그랜드 스위트', 'Grand Suite',
     16700000, NULL, 15000000, 28200000,
     true, true, 2026, 6, NULL),
    ('캐서린 크루즈', '2N3D', '빌라 프레지던트', 'Villa President',
     31600000, 7000000, 28400000, 58300000,
     true, true, 2026, 7, NULL);

-- 캐서린 2N3D 공휴일
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('캐서린 크루즈', '2N3D', '2026-12-24', '크리스마스 이브',
     1500000, 2026, true, '1인당 1,500,000동 추가'),
    ('캐서린 크루즈', '2N3D', '2026-12-31', '연말',
     1500000, 2026, true, '1인당 1,500,000동 추가');


-- ============================================================
--  3. 그랜드 파이어니스 2N3D (10객실 × 2결제방법 = 20행)
-- ============================================================
-- season_name으로 결제방법 구분: '신용카드' / 'VND 송금'
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '그랜드 파이어니스' AND schedule_type = '2N3D' AND valid_year = 2026;

-- 신용카드 결제
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, single_available, season_name,
     valid_year, display_order, notes)
VALUES
    ('그랜드 파이어니스', '2N3D', '오션스위트룸', 'Ocean Suite Room',
     9850000, 5900000, 7900000, 8850000, 15700000,
     true, true, '신용카드', 2026, 1, NULL),
    ('그랜드 파이어니스', '2N3D', '오션스위트 트리플룸', 'Ocean Suite Triple Room',
     9850000, 5900000, NULL, NULL, NULL,
     false, false, '신용카드', 2026, 2, '트리플룸: 엑스트라/싱글 불가'),
    ('그랜드 파이어니스', '2N3D', '오션발코니 스위트', 'Ocean Balcony Suite',
     9850000, 5900000, 7900000, 8850000, 15700000,
     true, true, '신용카드', 2026, 3, NULL),
    ('그랜드 파이어니스', '2N3D', '베란다 스위트', 'Veranda Suite',
     11750000, 5900000, 7900000, 10550000, 18800000,
     true, true, '신용카드', 2026, 4, NULL),
    ('그랜드 파이어니스', '2N3D', '이그제큐티브 스위트', 'Executive Suite',
     12750000, 5900000, 7900000, 11400000, 20400000,
     true, true, '신용카드', 2026, 5, NULL),
    ('그랜드 파이어니스', '2N3D', '더 에센스 스위트', 'The Essence Suite',
     17500000, 5900000, NULL, NULL, 28000000,
     false, true, '신용카드', 2026, 6, '엑스트라 불가'),
    ('그랜드 파이어니스', '2N3D', '더 오셔니아 스위트', 'The Oceania Suite',
     29000000, 5900000, NULL, NULL, 46350000,
     false, true, '신용카드', 2026, 7, '엑스트라 불가'),
    ('그랜드 파이어니스', '2N3D', '더 오너스 스위트 (2인)', 'The Owners Suite (2pax)',
     43500000, NULL, NULL, NULL, NULL,
     false, false, '신용카드', 2026, 8, '아동=성인요금 동일, 엑스트라 불가'),
    ('그랜드 파이어니스', '2N3D', '더 오너스 스위트 (3인)', 'The Owners Suite (3pax)',
     32500000, NULL, NULL, NULL, NULL,
     false, false, '신용카드', 2026, 9, '3인 기준 1인당'),
    ('그랜드 파이어니스', '2N3D', '더 오너스 스위트 (4인)', 'The Owners Suite (4pax)',
     26900000, NULL, NULL, NULL, NULL,
     false, false, '신용카드', 2026, 10, '4인 기준 1인당');

-- VND 송금
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, single_available, season_name,
     valid_year, display_order, notes)
VALUES
    ('그랜드 파이어니스', '2N3D', '오션스위트룸', 'Ocean Suite Room',
     9600000, 5750000, 7650000, 7650000, 15300000,
     true, true, 'VND 송금', 2026, 1, NULL),
    ('그랜드 파이어니스', '2N3D', '오션스위트 트리플룸', 'Ocean Suite Triple Room',
     9600000, 5750000, NULL, NULL, NULL,
     false, false, 'VND 송금', 2026, 2, '트리플룸: 엑스트라/싱글 불가'),
    ('그랜드 파이어니스', '2N3D', '오션발코니 스위트', 'Ocean Balcony Suite',
     9600000, 5750000, 7650000, 7650000, 15300000,
     true, true, 'VND 송금', 2026, 3, NULL),
    ('그랜드 파이어니스', '2N3D', '베란다 스위트', 'Veranda Suite',
     11400000, 5750000, 7650000, 9100000, 18400000,
     true, true, 'VND 송금', 2026, 4, NULL),
    ('그랜드 파이어니스', '2N3D', '이그제큐티브 스위트', 'Executive Suite',
     12400000, 5750000, 7650000, 9900000, 19900000,
     true, true, 'VND 송금', 2026, 5, NULL),
    ('그랜드 파이어니스', '2N3D', '더 에센스 스위트', 'The Essence Suite',
     17000000, 5750000, NULL, NULL, 27200000,
     false, true, 'VND 송금', 2026, 6, '엑스트라 불가'),
    ('그랜드 파이어니스', '2N3D', '더 오셔니아 스위트', 'The Oceania Suite',
     28300000, 5750000, NULL, NULL, 44900000,
     false, true, 'VND 송금', 2026, 7, '엑스트라 불가'),
    ('그랜드 파이어니스', '2N3D', '더 오너스 스위트 (2인)', 'The Owners Suite (2pax)',
     42300000, NULL, NULL, NULL, NULL,
     false, false, 'VND 송금', 2026, 8, '아동=성인요금 동일, 엑스트라 불가'),
    ('그랜드 파이어니스', '2N3D', '더 오너스 스위트 (3인)', 'The Owners Suite (3pax)',
     31700000, NULL, NULL, NULL, NULL,
     false, false, 'VND 송금', 2026, 9, '3인 기준 1인당'),
    ('그랜드 파이어니스', '2N3D', '더 오너스 스위트 (4인)', 'The Owners Suite (4pax)',
     26200000, NULL, NULL, NULL, NULL,
     false, false, 'VND 송금', 2026, 10, '4인 기준 1인당');

-- 그랜드 파이어니스 2N3D 공휴일 (1N2D와 동일)
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '그랜드 파이어니스' AND schedule_type = '2N3D' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('그랜드 파이어니스', '2N3D', '2026-01-28', '2026-01-31', '설 연휴',
     1500000, 2026, true, '1인당 1,500,000동 추가'),
    ('그랜드 파이어니스', '2N3D', '2026-02-15', '2026-02-21', '설 연휴 (구정)',
     1600000, 2026, true, '1인당 1,600,000동 추가'),
    ('그랜드 파이어니스', '2N3D', '2026-04-30', '2026-05-01', '통일의 날 / 노동절',
     1500000, 2026, true, '1인당 1,500,000동 추가'),
    ('그랜드 파이어니스', '2N3D', '2026-08-30', '2026-09-01', '독립기념일 연휴',
     1250000, 2026, true, '1인당 1,250,000동 추가'),
    ('그랜드 파이어니스', '2N3D', '2026-12-24', NULL, '크리스마스 이브',
     1500000, 2026, true, '1인당 1,500,000동 추가'),
    ('그랜드 파이어니스', '2N3D', '2026-12-31', NULL, '연말',
     1500000, 2026, true, '1인당 1,500,000동 추가');


NOTIFY pgrst, 'reload schema';

-- 전체 2N3D 확인
SELECT cruise_name AS "크루즈", schedule_type AS "일정",
    COALESCE(season_name, '일반') AS "구분",
    COUNT(*) AS "행수",
    TO_CHAR(MIN(price_adult), 'FM999,999,999') || '동' AS "최저가",
    TO_CHAR(MAX(price_adult), 'FM999,999,999') || '동' AS "최고가"
FROM public.cruise_rate_card
WHERE valid_year = 2026 AND schedule_type = '2N3D'
GROUP BY cruise_name, schedule_type, season_name
ORDER BY cruise_name, season_name;

DO $$
BEGIN RAISE NOTICE '✅ 2N3D 요금 입력 완료: 칼리스타(18행) + 캐서린(7행) + 그랜드 파이어니스(20행) + 공휴일 11건'; END $$;
