-- ============================================================
-- 크루즈 요금표 추가: 엠바사더 오버나이트 + 칼리스타 크루즈
-- ============================================================
-- 실행 전 create-cruise-rate-card.sql 이 먼저 실행되어야 합니다.
-- 이 파일은 재실행해도 안전합니다 (DELETE 후 INSERT).
-- ============================================================


-- ============================================================
-- STEP 0: 테이블 컬럼 확장 (이미 존재하면 무시)
-- ============================================================
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS price_child_extra_bed NUMERIC(15, 0);
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS extra_bed_available BOOLEAN DEFAULT true;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS includes_vehicle BOOLEAN DEFAULT false;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS vehicle_type TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS infant_policy TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS season_name TEXT;
ALTER TABLE public.cruise_rate_card ADD COLUMN IF NOT EXISTS is_promotion BOOLEAN DEFAULT false;


-- ============================================================
-- ============================================================
--  1. 엠바사더 오버나이트 크루즈 2026년 1박2일
-- ============================================================
-- ============================================================

-- 기존 데이터 정리
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '엠바사더 오버나이트' 
  AND schedule_type = '1N2D' 
  AND valid_year = 2026;

-- 객실 요금 입력
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en, 
     price_adult, price_child, price_infant, price_extra_bed, price_single,
     valid_year, display_order, notes)
VALUES
    -- 1. 디럭스룸
    ('엠바사더 오버나이트', '1N2D', '디럭스룸', 'Deluxe Room',
     3750000, 2750000, 950000, 3750000, 6800000,
     2026, 1, '아동: 5세~11세, 유아: 0세~4세'),
    
    -- 2. 프리미엄룸
    ('엠바사더 오버나이트', '1N2D', '프리미엄룸', 'Premium Room',
     4000000, NULL, NULL, 4000000, 7300000,
     2026, 2, NULL),
    
    -- 3. 스위트룸
    ('엠바사더 오버나이트', '1N2D', '스위트룸', 'Suite Room',
     4700000, NULL, NULL, 4700000, 8800000,
     2026, 3, NULL),
    
    -- 4. 캡틴스위트
    ('엠바사더 오버나이트', '1N2D', '캡틴스위트', 'Captain Suite',
     5050000, NULL, NULL, 5050000, 9450000,
     2026, 4, NULL);


-- 공휴일 추가요금
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '엠바사더 오버나이트' 
  AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('엠바사더 오버나이트', '1N2D', '2026-12-24', NULL, '크리스마스 이브',
     1350000, 2026, true, '1인당 1,350,000동 추가'),
    
    ('엠바사더 오버나이트', '1N2D', '2026-12-31', NULL, '연말',
     1350000, 2026, true, '1인당 1,350,000동 추가'),
    
    ('엠바사더 오버나이트', '1N2D', '2026-09-02', NULL, '베트남 독립기념일',
     800000, 2026, true, '1인당 800,000동 추가'),
    
    ('엠바사더 오버나이트', '1N2D', '2026-04-30', '2026-05-01', '통일의 날 / 노동절',
     0, 2026, false, '미정 - 추후 확정 예정');


-- ============================================================
-- ============================================================
--  2. 칼리스타 크루즈 2026년 1박2일
-- ============================================================
-- ============================================================
-- 특이사항:
--   - 3개 시즌별 가격 차등 적용
--   - 아동 엑스트라베드 사용 시 별도 가격 (price_child_extra_bed)
--   - 일부 객실 셔틀차량/단독차량 포함
--   - President Suite: 엑스트라베드 불가
--   - 유아 정책: 객실당 1인 무료, 2인째부터 295만동/인
-- ============================================================

-- 기존 데이터 정리
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '칼리스타 크루즈' 
  AND valid_year = 2026;


-- ─────────────────────────────────────────────
-- 시즌 1: 2026/01/01 ~ 04/30 (일반)
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en, 
     price_adult, price_child, price_child_extra_bed, price_infant, price_extra_bed, price_single,
     extra_bed_available, includes_vehicle, vehicle_type, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    -- 칼리스타 오션
    ('칼리스타 크루즈', '1N2D', '칼리스타 오션', 'Calista Ocean',
     4650000, 2775000, 3825000, NULL, 4650000, 7900000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 1, NULL),
    
    -- 칼리스타 베이
    ('칼리스타 크루즈', '1N2D', '칼리스타 베이', 'Calista Bay',
     5475000, 5000000, 5475000, NULL, 5000000, 9300000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 2, NULL),
    
    -- 칼리스타 레거시
    ('칼리스타 크루즈', '1N2D', '칼리스타 레거시', 'Calista Legacy',
     6000000, NULL, NULL, NULL, 6000000, 10200000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 3, NULL),
    
    -- Horizon Suite (셔틀차량 포함)
    ('칼리스타 크루즈', '1N2D', 'Horizon Suite', 'Horizon Suite',
     9100000, NULL, NULL, NULL, 9100000, 15500000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 4, '셔틀차량 포함'),
    
    -- Majesty Suite (셔틀차량 포함)
    ('칼리스타 크루즈', '1N2D', 'Majesty Suite', 'Majesty Suite',
     10200000, NULL, NULL, NULL, 10200000, 17450000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 5, '셔틀차량 포함'),
    
    -- President Suite (단독차량 포함, 엑스트라베드 불가)
    ('칼리스타 크루즈', '1N2D', 'President Suite', 'President Suite',
     22300000, NULL, NULL, NULL, NULL, 37900000,
     false, true, '단독차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-01-01', '2026-04-30', 6, '단독차량 포함, 엑스트라베드 불가');


-- ─────────────────────────────────────────────
-- 시즌 2: 2026/05/01 ~ 09/30 (프로모션)
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en, 
     price_adult, price_child, price_child_extra_bed, price_infant, price_extra_bed, price_single,
     extra_bed_available, includes_vehicle, vehicle_type, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    -- 칼리스타 오션
    ('칼리스타 크루즈', '1N2D', '칼리스타 오션', 'Calista Ocean',
     3975000, 2775000, 3825000, NULL, 3975000, 6800000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     '프로모션', true,
     2026, '2026-05-01', '2026-09-30', 1, '프로모션 요금'),
    
    -- 칼리스타 베이
    ('칼리스타 크루즈', '1N2D', '칼리스타 베이', 'Calista Bay',
     4250000, NULL, NULL, NULL, 4250000, 7250000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     '프로모션', true,
     2026, '2026-05-01', '2026-09-30', 2, '프로모션 요금'),
    
    -- 칼리스타 레거시
    ('칼리스타 크루즈', '1N2D', '칼리스타 레거시', 'Calista Legacy',
     4650000, NULL, NULL, NULL, 4650000, 7950000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     '프로모션', true,
     2026, '2026-05-01', '2026-09-30', 3, '프로모션 요금'),
    
    -- Horizon Suite (셔틀차량 포함)
    ('칼리스타 크루즈', '1N2D', 'Horizon Suite', 'Horizon Suite',
     8300000, NULL, NULL, NULL, 8300000, 14100000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     '프로모션', true,
     2026, '2026-05-01', '2026-09-30', 4, '프로모션 요금, 셔틀차량 포함'),
    
    -- Majesty Suite (셔틀차량 포함)
    ('칼리스타 크루즈', '1N2D', 'Majesty Suite', 'Majesty Suite',
     9400000, NULL, NULL, NULL, 9400000, 16000000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     '프로모션', true,
     2026, '2026-05-01', '2026-09-30', 5, '프로모션 요금, 셔틀차량 포함'),
    
    -- President Suite (단독차량 포함, 엑스트라베드 불가)
    ('칼리스타 크루즈', '1N2D', 'President Suite', 'President Suite',
     20150000, NULL, NULL, NULL, NULL, 34300000,
     false, true, '단독차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     '프로모션', true,
     2026, '2026-05-01', '2026-09-30', 6, '프로모션 요금, 단독차량 포함, 엑스트라베드 불가');


-- ─────────────────────────────────────────────
-- 시즌 3: 2026/10/01 ~ 12/31 (일반 = 시즌1과 동일)
-- ─────────────────────────────────────────────
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en, 
     price_adult, price_child, price_child_extra_bed, price_infant, price_extra_bed, price_single,
     extra_bed_available, includes_vehicle, vehicle_type, infant_policy,
     season_name, is_promotion,
     valid_year, valid_from, valid_to, display_order, notes)
VALUES
    -- 칼리스타 오션
    ('칼리스타 크루즈', '1N2D', '칼리스타 오션', 'Calista Ocean',
     4650000, 2775000, 3825000, NULL, 4650000, 7900000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 1, NULL),
    
    -- 칼리스타 베이
    ('칼리스타 크루즈', '1N2D', '칼리스타 베이', 'Calista Bay',
     5475000, 5000000, 5475000, NULL, 5000000, 9300000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 2, NULL),
    
    -- 칼리스타 레거시
    ('칼리스타 크루즈', '1N2D', '칼리스타 레거시', 'Calista Legacy',
     6000000, NULL, NULL, NULL, 6000000, 10200000,
     true, false, NULL, '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 3, NULL),
    
    -- Horizon Suite (셔틀차량 포함)
    ('칼리스타 크루즈', '1N2D', 'Horizon Suite', 'Horizon Suite',
     9100000, NULL, NULL, NULL, 9100000, 15500000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 4, '셔틀차량 포함'),
    
    -- Majesty Suite (셔틀차량 포함)
    ('칼리스타 크루즈', '1N2D', 'Majesty Suite', 'Majesty Suite',
     10200000, NULL, NULL, NULL, 10200000, 17450000,
     true, true, '셔틀차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 5, '셔틀차량 포함'),
    
    -- President Suite (단독차량 포함, 엑스트라베드 불가)
    ('칼리스타 크루즈', '1N2D', 'President Suite', 'President Suite',
     22300000, NULL, NULL, NULL, NULL, 37900000,
     false, true, '단독차량', '객실당 유아(1~4세) 1인 무료, 2인째부터 2,950,000동/인',
     NULL, false,
     2026, '2026-10-01', '2026-12-31', 6, '단독차량 포함, 엑스트라베드 불가');


-- ============================================================
-- 칼리스타 크루즈 공휴일 추가요금
-- ============================================================
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '칼리스타 크루즈' 
  AND valid_year = 2026;

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('칼리스타 크루즈', '1N2D', '2026-04-30', '2026-05-01', '통일의 날 / 노동절',
     1200000, 2026, true, '1인당 1,200,000동 추가'),
    
    ('칼리스타 크루즈', '1N2D', '2026-12-24', NULL, '크리스마스 이브',
     1200000, 2026, true, '1인당 1,200,000동 추가'),
    
    ('칼리스타 크루즈', '1N2D', '2026-12-31', NULL, '연말',
     1200000, 2026, true, '1인당 1,200,000동 추가');


-- ============================================================
-- PostgREST 스키마 캐시 새로고침
-- ============================================================
NOTIFY pgrst, 'reload schema';


-- ============================================================
-- 데이터 확인 쿼리
-- ============================================================

-- ▶ 엠바사더 오버나이트 요금 확인
SELECT 
    '엠바사더 오버나이트' AS "━━━ 크루즈 ━━━",
    room_type AS "객실",
    TO_CHAR(price_adult, 'FM999,999,999') || '동' AS "성인1인",
    COALESCE(TO_CHAR(price_child, 'FM999,999,999') || '동', '-') AS "아동1인",
    COALESCE(TO_CHAR(price_infant, 'FM999,999,999') || '동', '-') AS "유아",
    COALESCE(TO_CHAR(price_extra_bed, 'FM999,999,999') || '동', '-') AS "엑스트라베드",
    TO_CHAR(price_single, 'FM999,999,999') || '동' AS "싱글차지"
FROM public.cruise_rate_card
WHERE cruise_name = '엠바사더 오버나이트' AND valid_year = 2026
ORDER BY display_order;

-- ▶ 칼리스타 크루즈 요금 확인 (시즌별)
SELECT 
    '칼리스타 크루즈' AS "━━━ 크루즈 ━━━",
    room_type AS "객실",
    valid_from || ' ~ ' || valid_to AS "시즌",
    COALESCE(season_name, '일반') AS "구분",
    TO_CHAR(price_adult, 'FM999,999,999') || '동' AS "성인1인",
    COALESCE(TO_CHAR(price_child, 'FM999,999,999') || '동', '-') AS "아동1인",
    COALESCE(TO_CHAR(price_child_extra_bed, 'FM999,999,999') || '동', '-') AS "아동(엑스트라)",
    CASE WHEN extra_bed_available 
         THEN COALESCE(TO_CHAR(price_extra_bed, 'FM999,999,999') || '동', '-')
         ELSE '불가' END AS "엑스트라베드",
    TO_CHAR(price_single, 'FM999,999,999') || '동' AS "싱글차지",
    CASE WHEN includes_vehicle THEN vehicle_type ELSE '-' END AS "차량포함"
FROM public.cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND valid_year = 2026
ORDER BY valid_from, display_order;

-- ▶ 전체 크루즈 요금 요약
SELECT 
    cruise_name AS "크루즈",
    schedule_type AS "일정",
    valid_year AS "년도",
    COALESCE(valid_from::TEXT, '연중') || ' ~ ' || COALESCE(valid_to::TEXT, '연중') AS "적용기간",
    COUNT(*) AS "객실수",
    TO_CHAR(MIN(price_adult), 'FM999,999,999') || '동' AS "최저가(성인)",
    TO_CHAR(MAX(price_adult), 'FM999,999,999') || '동' AS "최고가(성인)"
FROM public.cruise_rate_card
WHERE is_active = true
GROUP BY cruise_name, schedule_type, valid_year, valid_from, valid_to
ORDER BY cruise_name, valid_from;

-- ▶ 전체 공휴일 추가요금 확인
SELECT 
    cruise_name AS "크루즈",
    holiday_date AS "날짜",
    holiday_date_end AS "종료일",
    holiday_name AS "공휴일명",
    CASE WHEN is_confirmed 
         THEN TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동'
         ELSE '미정' END AS "추가요금(1인)",
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
    ✅ 크루즈 요금표 추가 완료!
    
    📊 추가된 데이터:
    
    1. 엠바사더 오버나이트 2026년 1박2일
       - 4개 객실: 디럭스룸, 프리미엄룸, 스위트룸, 캡틴스위트
       - 공휴일 추가요금: 4건
    
    2. 칼리스타 크루즈 2026년 1박2일
       - 6개 객실 × 3개 시즌 = 18개 가격 행
       - 시즌: 01-04월(일반), 05-09월(프로모션), 10-12월(일반)
       - 공휴일 추가요금: 3건
       - 특이사항: 아동 엑스트라벤드 별도가, 차량포함 객실, President Suite 엑스트라 불가
    
    📋 추가된 컬럼:
       - price_child_extra_bed: 아동 엑스트라베드 사용 시 가격
       - extra_bed_available: 엑스트라베드 가능 여부
       - includes_vehicle: 차량 포함 여부
       - vehicle_type: 차량 유형
       - infant_policy: 유아 정책
       - season_name: 시즌명
       - is_promotion: 프로모션 여부
    ';
END $$;
