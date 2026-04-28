-- ============================================================
-- 당일 크루즈 요금표: 돌핀 하롱 + 엠바사더 당일
-- schedule_type = 'DAY'
-- ============================================================
-- 당일 크루즈 특성:
--   room_type = '평일 (월~목)' / '주말 (금~일)' 또는 '당일 크루즈'
--   price_adult = 성인, price_child = 아동(5~12세), price_infant = 유아(2~4세)

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

-- 유니크 제약조건 수정: season_name 추가 (결제방법/요금제별 구분 가능)
ALTER TABLE public.cruise_rate_card DROP CONSTRAINT IF EXISTS cruise_rate_card_unique;
ALTER TABLE public.cruise_rate_card ADD CONSTRAINT cruise_rate_card_unique 
    UNIQUE (cruise_name, schedule_type, room_type, valid_year, valid_from, season_name);


-- ============================================================
--  1. 돌핀 하롱 크루즈 (원데이 투어)
-- ============================================================
-- 그랜드 오프닝 특별가: 2025/10/01 ~ 2026/03/31
-- 2개 요금제: 신용카드 / 리무진 패키지
-- 평일 (월~목) / 주말 (금~일) 구분
-- 아동: 5~12세, 유아: 2~4세
-- KIDS CLUB: 아동 1인당 10만동 추가 (성인 동반 필수)

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '돌핀 하롱 크루즈' AND valid_year = 2026;

-- 일반 요금제
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_infant,
     child_age_range, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('돌핀 하롱 크루즈', 'DAY', '평일 (월~목)', 'Weekday (Mon-Thu)',
     1750000, 1350000, 600000,
     '아동: 5~12세, 유아: 2~4세', 'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
     '신용카드', false,
     2026, '2025-10-01', '2026-03-31', 1, '그랜드 오프닝 특별가'),

    ('돌핀 하롱 크루즈', 'DAY', '주말 (금~일)', 'Weekend (Fri-Sun)',
     1975000, 1525000, 750000,
     '아동: 5~12세, 유아: 2~4세', 'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
     '신용카드', false,
     2026, '2025-10-01', '2026-03-31', 2, '그랜드 오프닝 특별가 (주말 -25,000동)');

-- 리무진 패키지 요금제
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_infant,
     child_age_range, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('돌핀 하롱 크루즈', 'DAY', '평일 (월~목)', 'Weekday (Mon-Thu)',
     2450000, 2000000, 1250000,
     '아동: 5~12세, 유아: 2~4세', 'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
     '리무진 패키지', false,
     2026, '2025-10-01', '2026-03-31', 3, '그랜드 오프닝 특별가, 리무진 포함'),

    ('돌핀 하롱 크루즈', 'DAY', '주말 (금~일)', 'Weekend (Fri-Sun)',
     2650000, 2200000, 1400000,
     '아동: 5~12세, 유아: 2~4세', 'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
     '리무진 패키지', false,
     2026, '2025-10-01', '2026-03-31', 4, '그랜드 오프닝 특별가, 리무진 포함');

-- 신규 요금제 (2026-04-01부터 리무진 패키지 단종, 신용카드만 판매)
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_infant,
     child_age_range, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('돌핀 하롱 크루즈', 'DAY', '평일 (월~목)', 'Weekday (Mon-Thu)',
     2050000, 1600000, 750000,
     '아동: 5~12세, 유아: 2~4세', 'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
     '신용카드', false,
     2026, '2026-04-01', '2026-12-31', 5, '기간한정 판매상품'),

    ('돌핀 하롱 크루즈', 'DAY', '주말 (금~일)', 'Weekend (Fri-Sun)',
     2275000, 1725000, 850000,
     '아동: 5~12세, 유아: 2~4세', 'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
     '신용카드', false,
     2026, '2026-04-01', '2026-12-31', 6, '기간한정 판매상품');

-- 돌핀 하롱 공휴일/특별일
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '돌핀 하롱 크루즈' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('돌핀 하롱 크루즈', 'DAY', '2025-12-24', '2025-12-25', '크리스마스',
     350000, 2026, true, '1인당 350,000동 추가'),
    ('돌핀 하롱 크루즈', 'DAY', '2025-12-31', '2026-01-01', '연말연시',
     350000, 2026, true, '1인당 350,000동 추가'),
    ('돌핀 하롱 크루즈', 'DAY', '2026-02-14', '2026-02-22', '설 연휴 (구정)',
     350000, 2026, true, '1인당 350,000동 추가');


-- ============================================================
--  2. 엠바사더 당일 크루즈
-- ============================================================
-- 평일/주말 구분 없음 (연중 동일)
-- 2개 결제방법: 신용카드(ONEPAY) / VND 송금
-- 아동: 5~11세, 유아: 2~4세, 2세 미만: 별도
-- 추가옵션: 랍스터 30만동, 디럭스룸 150만동, 프리미엄룸 175만동, 셔틀 왕복 55만동

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '엠바사더 당일 크루즈' AND valid_year = 2026;

INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_infant,
     child_age_range, infant_policy,
     season_name,
     valid_year, display_order, notes)
VALUES
    ('엠바사더 당일 크루즈', 'DAY', '당일 크루즈', 'Day Cruise',
     1600000, 1350000, 1200000,
     '아동: 5~11세, 유아: 2~4세', '2세 미만 유아 1인당 350,000동',
     '신용카드',
     2026, 1, '랍스터 반마리 300,000동, 디럭스룸 1,500,000동/1룸, 프리미엄룸 1,750,000동/1룸, 셔틀 왕복 550,000동/인'),

    ('엠바사더 당일 크루즈', 'DAY', '당일 크루즈', 'Day Cruise',
     1520000, 1300000, 1150000,
     '아동: 5~11세, 유아: 2~4세', '2세 미만 유아 1인당 300,000동',
     'VND 송금',
     2026, 2, '랍스터 반마리 300,000동, 디럭스룸 1,500,000동/1룸, 프리미엄룸 1,750,000동/1룸, 셔틀 왕복 550,000동/인');


-- 돌핀 하롱 크루즈 추가 옵션
DELETE FROM public.cruise_tour_options 
WHERE cruise_name = '돌핀 하롱 크루즈' AND schedule_type = 'DAY';

INSERT INTO public.cruise_tour_options 
    (cruise_name, schedule_type, option_name, option_name_en, option_price, option_type, description, is_active)
VALUES
    ('돌핀 하롱 크루즈', 'DAY', '선데크 방갈로', 'Sun Deck Bungalow', 1900000, 'upgrade', '선데크 프라이빗 방갈로 (1박)', true),
    ('돌핀 하롱 크루즈', 'DAY', '랍스터 음식', 'Lobster (Fresh Sea Food)', 500000, 'addon', '신선한 랍스터 반마리', true);

NOTIFY pgrst, 'reload schema';

-- 확인 쿼리
SELECT cruise_name AS "크루즈", schedule_type AS "일정",
    room_type AS "구분", COALESCE(season_name, '일반') AS "요금제",
    TO_CHAR(price_adult, 'FM999,999,999') || '동' AS "성인",
    COALESCE(TO_CHAR(price_child, 'FM999,999,999') || '동', '-') AS "아동",
    COALESCE(TO_CHAR(price_infant, 'FM999,999,999') || '동', '-') AS "유아"
FROM public.cruise_rate_card
WHERE valid_year = 2026 AND schedule_type = 'DAY'
ORDER BY cruise_name, display_order;

DO $$
BEGIN RAISE NOTICE '✅ 당일 크루즈 요금 입력 완료: 돌핀 하롱(4행) + 엠바사더 당일(2행) + 공휴일 3건'; END $$;
