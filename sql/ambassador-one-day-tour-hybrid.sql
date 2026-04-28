-- ============================================================================
-- Ambassador Cruise - One-Day Tour (하이브리드 방식)
-- 엠바사더 당일 크루즈 - 당일투어 패키지
-- ============================================================================
-- 입력 기준 데이터:
--   당일투어 (One-Day Tour)
--   요금 구분:
--     1) 크루즈 티켓만: 신용카드 (ONEPAY) vs VND 송금
--     2) 리무진 패키지: 이동차량 + 생수/음료 1잔 포함
--   나이별 가격: 성인, 5-12세, 2-5세, 2세 미만
--   추가 옵션: 발코니, 랍스터, 1층 디럭스룸, 2층 프리미엄룸, 셔틀리무진
-- 
-- 특징:
--   - 당일투어 (overnight 아님)
--   - 2개 결제 타입: 신용카드 / VND 송금 (season_name 활용)
--   - 4개 나이 카테고리: 성인, 5-11세, 2-4세, 2세 미만
--   - 엑스트라베드 불가 (당일투어 특성)
--   - 선택 옵션: cruise_tour_options 테이블에서 관리
-- ============================================================================

-- ============================================================================
-- 1. 기존 데이터 정리
-- ============================================================================
DELETE FROM cruise_rate_card 
WHERE cruise_name = '엠바사더 당일 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '엠바사더 당일 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_tour_options 
WHERE cruise_name = '엠바사더 당일 크루즈' AND schedule_type = 'DAY';

-- ============================================================================
-- 2. 기본 요금 데이터 (cruise_rate_card)
-- 신용카드 결제 (ONEPAY): 요금 높음
-- VND 송금: 요금 낮음
-- ============================================================================

INSERT INTO cruise_rate_card (
  cruise_name,
  schedule_type,
  room_type,
  room_type_en,
  price_adult,
  price_child,
  price_infant,
  price_extra_bed,
  price_child_extra_bed,
  price_single,
  extra_bed_available,
  valid_year,
  valid_from,
  valid_to,
  currency,
  season_name,
  is_active
) VALUES
-- 크루즈 티켓만 - 신용카드 결제 (ONEPAY)
(
  '엠바사더 당일 크루즈',
  'DAY',
  'Ambassador One-Day Tour',
  'Ambassador One-Day Tour',
  1600000,
  1350000,
  1200000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드 결제 (ONEPAY)',
  true
),
-- 크루즈 티켓만 - VND 송금
(
  '엠바사더 당일 크루즈',
  'DAY',
  'Ambassador One-Day Tour',
  'Ambassador One-Day Tour',
  1520000,
  1300000,
  1150000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- 리무진 패키지 - 신용카드 결제
(
  '엠바사더 당일 크루즈',
  'DAY',
  'Ambassador One-Day Tour + Limousine',
  'Ambassador One-Day Tour (Limousine Package)',
  2150000,
  1800000,
  1600000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '리무진 패키지 (신용카드)',
  true
),
-- 리무진 패키지 - VND 송금
(
  '엠바사더 당일 크루즈',
  'DAY',
  'Ambassador One-Day Tour + Limousine',
  'Ambassador One-Day Tour (Limousine Package)',
  2070000,
  1720000,
  1550000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '리무진 패키지 (VND 송금)',
  true
);

-- ============================================================================
-- 3. 2세 미만 유아 요금 (cruise_holiday_surcharge 활용)
-- Note: holiday_surcharge를 이용하여 임시 방편으로 저장
-- 실제로는 price_infant_special 컬럼이 필요하지만, 기존 테이블 활용
-- ============================================================================

INSERT INTO cruise_holiday_surcharge (
  cruise_name,
  schedule_type,
  holiday_name,
  holiday_date,
  holiday_date_end,
  surcharge_per_person,
  surcharge_child,
  valid_year,
  currency
) VALUES
-- 2세 미만 (신용카드): 350,000동
(
  '엠바사더 당일 크루즈',
  'DAY',
  '2세 미만 유아 (신용카드)',
  '2026-01-01',
  '2026-12-31',
  350000,
  NULL,
  2026,
  'VND'
),
-- 2세 미만 (VND 송금): 300,000동
(
  '엠바사더 당일 크루즈',
  'DAY',
  '2세 미만 유아 (VND 송금)',
  '2026-02-01',
  '2026-12-31',
  300000,
  NULL,
  2026,
  'VND'
);

-- ============================================================================
-- 4. 선택 옵션 데이터 (cruise_tour_options)
-- 랍스터, 디럭스룸, 프리미엄룸, 셔틀리무진
-- ============================================================================

INSERT INTO cruise_tour_options (
  cruise_name,
  schedule_type,
  option_name,
  option_name_en,
  option_price,
  option_type,
  description,
  is_active
) VALUES
-- 발코니: 300,000동
(
  '엠바사더 당일 크루즈',
  'DAY',
  '발코니',
  'Balcony',
  300000,
  'upgrade',
  '발코니 추가 (크루즈 성수기에는 적용 어려울 수 있음)',
  true
),
-- 랍스터: +300,000동
(
  '엠바사더 당일 크루즈',
  'DAY',
  '랍스터 반마리 추가',
  'Lobster Half Add-on',
  300000,
  'addon',
  '식사 시 신선한 랍스터 반마리 추가',
  true
),
-- 디럭스룸: 1,500,000동
(
  '엠바사더 당일 크루즈',
  'DAY',
  '디럭스룸 객실예약',
  'Deluxe Room Booking',
  1500000,
  'upgrade',
  '1층 디럭스 객실 1개 (최대 2인 정원, 객실 이용 시 최대 6명까지 가능)',
  true
),
-- 프리미엄룸: 1,750,000동
(
  '엠바사더 당일 크루즈',
  'DAY',
  '프리미엄룸 객실예약',
  'Premium Room Booking',
  1750000,
  'upgrade',
  '2층 프리미엄룸 객실 1개 (최대 2인 정원, 객실 이용 시 최대 6명까지 가능)',
  true
),
-- 셔틀리무진: 550,000동 (왕복)
(
  '엠바사더 당일 크루즈',
  'DAY',
  '셔틀리무진 왕복',
  'Shuttle Limousine (Round Trip)',
  550000,
  'addon',
  '공항 또는 숙소 셔틀 리무진 왕복 (1인당)',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

SELECT '=== Ambassador One-Day Tour 기본 요금 ===' AS "검증 항목";

SELECT 
  season_name as "요금제",
  room_type as "상품명",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-12세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "2-5세"
FROM cruise_rate_card
WHERE cruise_name = '엠바사더 당일 크루즈'
  AND schedule_type = 'DAY'
ORDER BY price_adult;

SELECT '=== 2세 미만 유아 요금 ===' AS "검증 항목";

SELECT 
  holiday_name as "유아 구분",
  surcharge_per_person as "요금(동)",
  holiday_date as "적용시작",
  holiday_date_end as "적용종료"
FROM cruise_holiday_surcharge
WHERE cruise_name = '엠바사더 당일 크루즈'
  AND schedule_type = 'DAY'
ORDER BY holiday_date;

SELECT '=== 선택 옵션 (cruise_tour_options) ===' AS "검증 항목";

SELECT 
  option_name as "옵션명",
  option_name_en as "영문명",
  TO_CHAR(option_price, 'FM999,999,999') || '동' as "가격",
  option_type as "타입",
  description as "설명"
FROM cruise_tour_options
WHERE cruise_name = '엠바사더 당일 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price;

SELECT '=== 가격 계산 예시 ===' AS "검증 항목";

SELECT 
  '✅ 크루즈 티켓만 (신용카드): 성인 1인' as "예시",
  TO_CHAR(1600000, 'FM999,999,999') || '동' as "요금"
UNION ALL
SELECT '✅ 크루즈 티켓만 (신용카드): 성인 + 2세미만 유아', TO_CHAR(1600000 + 350000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 크루즈 티켓만 (신용카드): 성인 + 랍스터', TO_CHAR(1600000 + 300000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 크루즈 티켓만 (VND): 성인 1인', TO_CHAR(1520000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 리무진 패키지 (신용카드): 성인 1인', TO_CHAR(2150000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 리무진 패키지 (신용카드): 성인 + 아동(5-12세)', TO_CHAR(2150000 + 1800000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 리무진 패키지 (신용카드): 성인 + 2세미만 유아', TO_CHAR(2150000 + 850000, 'FM999,999,999') || '동';

SELECT '=== 데이터 개수 확인 ===' AS "검증 항목";

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '엠바사더 당일 크루즈' 
   AND schedule_type = 'DAY') as "기본요금행 (4행: 크루즈 2행 + 리무진 2행)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge 
   WHERE cruise_name = '엠바사더 당일 크루즈' 
   AND schedule_type = 'DAY') as "특별요금행 (2행: 유아)",
  (SELECT COUNT(*) FROM cruise_tour_options 
   WHERE cruise_name = '엠바사더 당일 크루즈' 
   AND schedule_type = 'DAY') as "선택옵션행 (5행: 발코니 포함)";

SELECT '=== 완전한 요금 조회 쿼리 ===' AS "검증 항목";

SELECT 
  '기본 요금' as "카테고리",
  season_name as "상세",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-12세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "2-5세"
FROM cruise_rate_card
WHERE cruise_name = '엠바사더 당일 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '유아 요금',
  holiday_name,
  TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동',
  NULL,
  NULL
FROM cruise_holiday_surcharge
WHERE cruise_name = '엠바사더 당일 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '선택 옵션',
  option_name,
  TO_CHAR(option_price, 'FM999,999,999') || '동',
  option_type,
  NULL
FROM cruise_tour_options
WHERE cruise_name = '엠바사더 당일 크루즈'
  AND schedule_type = 'DAY';
