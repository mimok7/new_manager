-- ============================================================
-- 크루즈 요금표 추가: 파라다이스 레거시 + 할로라 + 세리나
-- ============================================================
-- 실행 전 create-cruise-rate-card.sql 이 먼저 실행되어야 합니다.
-- 이 파일은 재실행해도 안전합니다 (DELETE 후 INSERT).
-- ============================================================


-- ============================================================
-- STEP 0: 테이블 컬럼 확장
-- ============================================================

-- cruise_rate_card 기존 컬럼 (이미 존재하면 무시)
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS price_child_extra_bed NUMERIC(15, 0);
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS extra_bed_available BOOLEAN DEFAULT true;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS includes_vehicle BOOLEAN DEFAULT false;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS vehicle_type TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS infant_policy TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS season_name TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS is_promotion BOOLEAN DEFAULT false;

-- 신규 컬럼: 할로라 대응 (아동 2단계 연령, 싱글 가능 여부)
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS price_child_older NUMERIC(15, 0);
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS child_age_range TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS single_available BOOLEAN DEFAULT true;

COMMENT ON COLUMN public.cruise_rate_card.price_child_older IS '고연령 아동 가격 (예: 8~11세, VND)';
COMMENT ON COLUMN public.cruise_rate_card.child_age_range IS '아동 연령 범위 설명 (예: 5~7세/8~11세)';
COMMENT ON COLUMN public.cruise_rate_card.single_available IS '싱글 사용 가능 여부 (false면 불가)';

-- cruise_holiday_surcharge 신규 컬럼: 아동 별도 추가요금
ALTER TABLE public.cruise_holiday_surcharge ADD COLUMN IF NOT EXISTS surcharge_child NUMERIC(15, 0);

COMMENT ON COLUMN public.cruise_holiday_surcharge.surcharge_child IS '아동 1인당 추가요금 (성인과 다를 경우, VND)';


-- ============================================================
-- ============================================================
--  1. 파라다이스 레거시 크루즈 2026년 1박2일
-- ============================================================
-- ============================================================
-- 특이사항:
--   - 3개 시즌 (01-04월, 05-09월, 10-12월)
--   - 아동 연령: 5~12세
--   - 아동 엑스트라 별도 가격
--   - 공휴일 추가요금: 성인/아동 별도 (1,350,000 / 750,000)
--   - 사전예약 특별할인 (2026.02.05까지 예약 시)
-- ============================================================

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '파라다이스 레거시' AND valid_year = 2026;

-- ─────────────────────────────────────────────
-- 시즌 1: 2026/01/01 ~ 04/30
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     child_age_range, extra_bed_available, single_available,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('파라다이스 레거시', '1N2D', '디럭스 발코니', 'Deluxe Balcony',
     4550000, 3600000, 4275000, 4550000, 8100000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 1, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
     4800000, 3600000, 4275000, 4800000, 8600000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 2, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '레거시 스위트', 'Legacy Suite',
     5850000, 3600000, 4275000, 5850000, 10300000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 3, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '갤러리 스위트', 'Gallery Suite',
     13100000, 3600000, 4275000, 13100000, 22900000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 4, '사전예약 특별할인 (2026.02.05까지 예약 시)');

-- ─────────────────────────────────────────────
-- 시즌 2: 2026/05/01 ~ 09/30
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     child_age_range, extra_bed_available, single_available,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('파라다이스 레거시', '1N2D', '디럭스 발코니', 'Deluxe Balcony',
     4400000, 3350000, 4025000, 4400000, 7500000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-05-01', '2026-09-30', 1, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
     4650000, 3350000, 4025000, 4650000, 8000000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-05-01', '2026-09-30', 2, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '레거시 스위트', 'Legacy Suite',
     5600000, 3350000, 4025000, 5600000, 9550000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-05-01', '2026-09-30', 3, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '갤러리 스위트', 'Gallery Suite',
     13000000, 3350000, 4025000, 13000000, 22300000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-05-01', '2026-09-30', 4, '사전예약 특별할인 (2026.02.05까지 예약 시)');

-- ─────────────────────────────────────────────
-- 시즌 3: 2026/10/01 ~ 12/31 (시즌1과 동일)
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     child_age_range, extra_bed_available, single_available,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('파라다이스 레거시', '1N2D', '디럭스 발코니', 'Deluxe Balcony',
     4550000, 3600000, 4275000, 4550000, 8100000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 1, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
     4800000, 3600000, 4275000, 4800000, 8600000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 2, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '레거시 스위트', 'Legacy Suite',
     5850000, 3600000, 4275000, 5850000, 10300000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 3, '사전예약 특별할인 (2026.02.05까지 예약 시)'),

    ('파라다이스 레거시', '1N2D', '갤러리 스위트', 'Gallery Suite',
     13100000, 3600000, 4275000, 13100000, 22900000,
     '5~12세', true, true,
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 4, '사전예약 특별할인 (2026.02.05까지 예약 시)');

-- 파라다이스 레거시 공휴일 추가요금 (성인/아동 별도)
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '파라다이스 레거시' AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_name,
     surcharge_per_person, surcharge_child, valid_year, is_confirmed, notes)
VALUES
    ('파라다이스 레거시', '1N2D', '2026-12-24', '크리스마스 이브',
     1350000, 750000, 2026, true, '성인 1,350,000동 / 아동 750,000동 추가'),

    ('파라다이스 레거시', '1N2D', '2026-12-31', '연말',
     1350000, 750000, 2026, true, '성인 1,350,000동 / 아동 750,000동 추가');


-- ============================================================
-- ============================================================
--  2. 할로라 크루즈 2026년 1박2일 (사전예약 특별할인)
-- ============================================================
-- ============================================================
-- 특이사항:
--   - 아동 연령 2단계: 5~7세 / 8~11세 (가격 다름!)
--   - 프리미엄 트리플룸: 엑스트라베드 불가, 싱글 불가
--   - 2개 시즌 (~05/31 오프닝, 06/01~12/31)
--   - 사전예약 특별할인 (2026.02.10까지 예약 시)
--   - 셔틀리무진 할인 별도
-- ============================================================

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '할로라 크루즈' AND valid_year = 2026;

-- ─────────────────────────────────────────────
-- 시즌 1: 오프닝 특별요금 (~2026/05/31)
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_older, price_extra_bed, price_single,
     child_age_range, extra_bed_available, single_available,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('할로라 크루즈', '1N2D', '디럭스룸', 'Deluxe Room',
     3650000, 1900000, 2750000, 2950000, 6150000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     '오프닝 특별요금', true,
     2026, '2026-01-01', '2026-05-31', 1, '사전예약 특별할인 (2026.02.10까지, 선착순 20명)'),

    ('할로라 크루즈', '1N2D', '프리미엄룸', 'Premium Room',
     3850000, 2000000, 2950000, 3100000, 6450000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     '오프닝 특별요금', true,
     2026, '2026-01-01', '2026-05-31', 2, '사전예약 특별할인 (2026.02.10까지, 선착순 20명)'),

    ('할로라 크루즈', '1N2D', '프리미엄 트리플룸', 'Premium Triple Room',
     3850000, 2000000, 2950000, NULL, NULL,
     '5~7세: price_child / 8~11세: price_child_older', false, false,
     '오프닝 특별요금', true,
     2026, '2026-01-01', '2026-05-31', 3, '엑스트라베드 불가, 싱글 불가'),

    ('할로라 크루즈', '1N2D', '스위트룸', 'Suite Room',
     4575000, 2350000, 3450000, 3700000, 7600000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     '오프닝 특별요금', true,
     2026, '2026-01-01', '2026-05-31', 4, '사전예약 특별할인 (2026.02.10까지, 선착순 20명)'),

    ('할로라 크루즈', '1N2D', '그랜드 스위트 룸', 'Grand Suite Room',
     6775000, 3450000, 5100000, 5450000, 11150000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     '오프닝 특별요금', true,
     2026, '2026-01-01', '2026-05-31', 5, '사전예약 특별할인 (2026.02.10까지, 선착순 20명)');

-- ─────────────────────────────────────────────
-- 시즌 2: 2026/06/01 ~ 12/31
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_older, price_extra_bed, price_single,
     child_age_range, extra_bed_available, single_available,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('할로라 크루즈', '1N2D', '디럭스룸', 'Deluxe Room',
     4275000, 2225000, 3250000, 3450000, 7150000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     NULL, false,
     2026, '2026-06-01', '2026-12-31', 1, NULL),

    ('할로라 크루즈', '1N2D', '프리미엄룸', 'Premium Room',
     4500000, 2350000, 3400000, 3625000, 7500000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     NULL, false,
     2026, '2026-06-01', '2026-12-31', 2, NULL),

    ('할로라 크루즈', '1N2D', '프리미엄 트리플룸', 'Premium Triple Room',
     4500000, 2350000, 3400000, NULL, NULL,
     '5~7세: price_child / 8~11세: price_child_older', false, false,
     NULL, false,
     2026, '2026-06-01', '2026-12-31', 3, '엑스트라베드 불가, 싱글 불가'),

    ('할로라 크루즈', '1N2D', '스위트룸', 'Suite Room',
     5200000, 2700000, 3950000, 4200000, 8600000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     NULL, false,
     2026, '2026-06-01', '2026-12-31', 4, NULL),

    ('할로라 크루즈', '1N2D', '그랜드 스위트 룸', 'Grand Suite Room',
     7700000, 3950000, 5800000, 6200000, 12600000,
     '5~7세: price_child / 8~11세: price_child_older', true, true,
     NULL, false,
     2026, '2026-06-01', '2026-12-31', 5, NULL);


-- ============================================================
-- ============================================================
--  3. 세리나 크루즈 2026년 1박2일 (사전예약 특별할인)
-- ============================================================
-- ============================================================
-- 특이사항:
--   - 아동 엑스트라 별도 가격
--   - 성인 엑스트라베드 별도 가격
--   - 사전예약 프로모션 (2026.02.05까지 예약 시, 선착순 50명)
--   - 셔틀리무진 할인 별도
--   - 날짜 범위 미지정 (연중 프로모션)
-- ============================================================

DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '세리나 크루즈' AND valid_year = 2026;

INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_child_extra_bed, price_extra_bed, price_single,
     extra_bed_available, single_available,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    ('세리나 크루즈', '1N2D', '오션 발코니', 'Ocean Balcony',
     4350000, 3300000, 3700000, 3900000, 7500000,
     true, true,
     '사전예약 프로모션', true,
     2026, NULL, NULL, 1, '사전예약 특별할인 (2026.02.05까지, 선착순 50명)'),

    ('세리나 크루즈', '1N2D', '시니어 발코니', 'Senior Balcony',
     4600000, 3500000, 3950000, 4150000, 8000000,
     true, true,
     '사전예약 프로모션', true,
     2026, NULL, NULL, 2, '사전예약 특별할인 (2026.02.05까지, 선착순 50명)'),

    ('세리나 크루즈', '1N2D', '이그제큐티브 발코니', 'Executive Balcony',
     5000000, 3800000, 4300000, 4525000, 8700000,
     true, true,
     '사전예약 프로모션', true,
     2026, NULL, NULL, 3, '사전예약 특별할인 (2026.02.05까지, 선착순 50명)'),

    ('세리나 크루즈', '1N2D', '문스위트 (VIP)', 'Moon Suite (VIP)',
     7450000, 5650000, 6350000, 6750000, 12900000,
     true, true,
     '사전예약 프로모션', true,
     2026, NULL, NULL, 4, '사전예약 특별할인 (2026.02.05까지, 선착순 50명)'),

    ('세리나 크루즈', '1N2D', '프레지던트 (VVIP)', 'President (VVIP)',
     15900000, 11900000, 13500000, 14300000, 27200000,
     true, true,
     '사전예약 프로모션', true,
     2026, NULL, NULL, 5, '사전예약 특별할인 (2026.02.05까지, 선착순 50명)');


-- ============================================================
-- PostgREST 스키마 캐시 새로고침
-- ============================================================
NOTIFY pgrst, 'reload schema';


-- ============================================================
-- 데이터 확인 쿼리
-- ============================================================

-- ▶ 파라다이스 레거시 요금 확인
SELECT 
    room_type AS "객실",
    valid_from || ' ~ ' || valid_to AS "시즌",
    TO_CHAR(price_adult, 'FM999,999,999') || '동' AS "성인",
    TO_CHAR(price_child, 'FM999,999,999') || '동' AS "아동",
    TO_CHAR(price_child_extra_bed, 'FM999,999,999') || '동' AS "아동엑스트라",
    TO_CHAR(price_extra_bed, 'FM999,999,999') || '동' AS "성인엑스트라",
    TO_CHAR(price_single, 'FM999,999,999') || '동' AS "싱글"
FROM public.cruise_rate_card
WHERE cruise_name = '파라다이스 레거시' AND valid_year = 2026
ORDER BY valid_from, display_order;

-- ▶ 할로라 크루즈 요금 확인
SELECT 
    room_type AS "객실",
    COALESCE(season_name, '일반') AS "시즌구분",
    valid_from || ' ~ ' || valid_to AS "기간",
    TO_CHAR(price_adult, 'FM999,999,999') || '동' AS "성인",
    TO_CHAR(price_child, 'FM999,999,999') || '동' AS "아동(5~7)",
    COALESCE(TO_CHAR(price_child_older, 'FM999,999,999') || '동', '-') AS "아동(8~11)",
    CASE WHEN extra_bed_available 
         THEN COALESCE(TO_CHAR(price_extra_bed, 'FM999,999,999') || '동', '-')
         ELSE '불가' END AS "엑스트라",
    CASE WHEN single_available 
         THEN COALESCE(TO_CHAR(price_single, 'FM999,999,999') || '동', '-')
         ELSE '불가' END AS "싱글"
FROM public.cruise_rate_card
WHERE cruise_name = '할로라 크루즈' AND valid_year = 2026
ORDER BY valid_from, display_order;

-- ▶ 세리나 크루즈 요금 확인
SELECT 
    room_type AS "객실",
    TO_CHAR(price_adult, 'FM999,999,999') || '동' AS "성인",
    TO_CHAR(price_child, 'FM999,999,999') || '동' AS "아동",
    TO_CHAR(price_child_extra_bed, 'FM999,999,999') || '동' AS "아동엑스트라",
    TO_CHAR(price_extra_bed, 'FM999,999,999') || '동' AS "성인엑스트라",
    TO_CHAR(price_single, 'FM999,999,999') || '동' AS "싱글"
FROM public.cruise_rate_card
WHERE cruise_name = '세리나 크루즈' AND valid_year = 2026
ORDER BY display_order;

-- ▶ 전체 크루즈 요금 요약
SELECT 
    cruise_name AS "크루즈",
    COUNT(*) AS "가격행수",
    COUNT(DISTINCT room_type) AS "객실수",
    TO_CHAR(MIN(price_adult), 'FM999,999,999') || '동' AS "최저가",
    TO_CHAR(MAX(price_adult), 'FM999,999,999') || '동' AS "최고가"
FROM public.cruise_rate_card
WHERE valid_year = 2026 AND is_active = true
GROUP BY cruise_name
ORDER BY cruise_name;

-- ▶ 전체 공휴일 추가요금 확인
SELECT 
    cruise_name AS "크루즈",
    holiday_date AS "날짜",
    holiday_name AS "공휴일",
    TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동' AS "성인추가",
    CASE WHEN surcharge_child IS NOT NULL 
         THEN TO_CHAR(surcharge_child, 'FM999,999,999') || '동'
         ELSE '성인과 동일' END AS "아동추가",
    CASE WHEN is_confirmed THEN '✅' ELSE '⏳' END AS "상태"
FROM public.cruise_holiday_surcharge
WHERE valid_year = 2026
ORDER BY cruise_name, holiday_date;


-- ============================================================
-- 완료 메시지
-- ============================================================
DO $$
BEGIN
    RAISE NOTICE '
    ✅ 3개 크루즈 요금표 추가 완료!
    
    📊 추가된 데이터:
    
    1. 파라다이스 레거시 2026년 1박2일
       - 4개 객실 × 3개 시즌 = 12개 가격 행
       - 아동 연령: 5~12세, 아동 엑스트라 별도
       - 공휴일: 12/24, 12/31 (성인/아동 별도 추가요금)
    
    2. 할로라 크루즈 2026년 1박2일
       - 5개 객실 × 2개 시즌 = 10개 가격 행
       - 아동 2단계: 5~7세 / 8~11세
       - 프리미엄 트리플룸: 엑스트라 불가, 싱글 불가
       - 오프닝 특별요금 (2026.02.10까지)
    
    3. 세리나 크루즈 2026년 1박2일
       - 5개 객실 (사전예약 프로모션)
       - 아동 엑스트라 / 성인 엑스트라 별도
       - 2026.02.05까지 선착순 50명 한정
    
    📋 추가된 컬럼:
       - price_child_older: 고연령 아동 가격
       - child_age_range: 아동 연령 범위 설명
       - single_available: 싱글 사용 가능 여부
       - surcharge_child: 아동 별도 추가요금 (공휴일)
    ';
END $$;
