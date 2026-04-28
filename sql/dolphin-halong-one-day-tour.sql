-- ============================================================================
-- Dolphin Halong Cruise - One-Day Tour
-- 돌핀 하롱 크루즈 - 당일투어 패키지
-- ============================================================================
-- 입력 기준 데이터:
--   당일투어 (One-Day Tour)
--   기간 1: 2025-10-01 ~ 2026-03-31 (그랜드 오프닝 특별가)
--   기간 2: 2026-04-01 ~ 2026-12-31 (기간한정 판매상품)
--   요금 구분:
--     1) 신용카드 결제: 평일(월~목) / 주말(금~일)
--     2) 리무진 패키지: 이동차량 + 생수/음료 1잔 포함 (2026-03-31까지)
--   나이별 가격: 성인, 5-12세, 2-4세
--   추가 옵션: 선데크 방갈로, 랍스터
-- 
-- 특징:
--   - 당일투어 (overnight 아님)
--   - 2개 기간별 요금제: 그랜드 오프닝(~03-31) / 기간한정(04-01~)
--   - 평일/주말 구분
--   - 3개 나이 카테고리: 성인, 5-12세, 2-4세 (2세 미만 별도)
--   - KIDS CLUB 옵션: 아동 1인당 100,000동 추가
--   - 엑스트라베드 불가 (당일투어 특성)
--   - 선택 옵션: cruise_tour_options 테이블에서 관리
-- ============================================================================

-- ============================================================================
-- 1. 기존 데이터 정리
-- ============================================================================
DELETE FROM cruise_rate_card 
WHERE cruise_name = '돌핀 하롱 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '돌핀 하롱 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_tour_options 
WHERE cruise_name = '돌핀 하롱 크루즈' AND schedule_type = 'DAY';

-- ============================================================================
-- 2. 기본 요금 데이터 (cruise_rate_card)
-- 기간 1: 2025-10-01 ~ 2026-03-31 (그랜드 오프닝 특별가)
-- 신용카드: 평일 / 주말 구분
-- 리무진 패키지: 평일 / 주말 구분 (이 기간에만 판매)
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
  child_age_range,
  infant_policy,
  is_active,
  display_order,
  notes
) VALUES
-- ========== 기간 1: 그랜드 오프닝 특별가 (2025-10-01 ~ 2026-03-31) ==========
-- 신용카드 결제 - 평일 (월~목)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '평일 (월~목)',
  'Weekday (Mon-Thu)',
  1750000,
  1350000,
  600000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2025-10-01',
  '2026-03-31',
  'VND',
  '신용카드',
  '아동: 5~12세, 유아: 2~4세',
  'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
  true,
  1,
  '그랜드 오프닝 특별가'
),
-- 신용카드 결제 - 주말 (금~일)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '주말 (금~일)',
  'Weekend (Fri-Sun)',
  1975000,
  1525000,
  750000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2025-10-01',
  '2026-03-31',
  'VND',
  '신용카드',
  '아동: 5~12세, 유아: 2~4세',
  'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
  true,
  2,
  '그랜드 오프닝 특별가 (주말 -25,000동)'
),
-- 리무진 패키지 - 평일 (월~목)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '평일 (월~목)',
  'Weekday (Mon-Thu)',
  2450000,
  2000000,
  1250000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2025-10-01',
  '2026-03-31',
  'VND',
  '리무진 패키지',
  '아동: 5~12세, 유아: 2~4세',
  'KIDS CLUB 이용 시 아동 1인당 100,000동 추가, 리무진 포함',
  true,
  3,
  '그랜드 오프닝 특별가, 리무진 + 생수/음료 포함'
),
-- 리무진 패키지 - 주말 (금~일)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '주말 (금~일)',
  'Weekend (Fri-Sun)',
  2650000,
  2200000,
  1400000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2025-10-01',
  '2026-03-31',
  'VND',
  '리무진 패키지',
  '아동: 5~12세, 유아: 2~4세',
  'KIDS CLUB 이용 시 아동 1인당 100,000동 추가, 리무진 포함',
  true,
  4,
  '그랜드 오프닝 특별가, 리무진 + 생수/음료 포함'
),
-- ========== 기간 2: 신규 요금제 (2026-04-01 ~ 2026-12-31) ==========
-- 신용카드만 판매 (리무진 패키지는 03-31까지만)
-- 신용카드 결제 - 평일 (월~목)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '평일 (월~목)',
  'Weekday (Mon-Thu)',
  2050000,
  1600000,
  750000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-04-01',
  '2026-12-31',
  'VND',
  '신용카드',
  '아동: 5~12세, 유아: 2~4세',
  'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
  true,
  5,
  '기간한정 판매상품 (2026-03-31까지 승선고객 한정)'
),
-- 신용카드 결제 - 주말 (금~일)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '주말 (금~일)',
  'Weekend (Fri-Sun)',
  2275000,
  1725000,
  850000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-04-01',
  '2026-12-31',
  'VND',
  '신용카드',
  '아동: 5~12세, 유아: 2~4세',
  'KIDS CLUB 이용 시 아동 1인당 100,000동 추가',
  true,
  6,
  '기간한정 판매상품 (2026-03-31까지 승선고객 한정)'
);

-- ============================================================================
-- 3. 공휴일/특별일 추가 요금 (cruise_holiday_surcharge)
-- ============================================================================

INSERT INTO cruise_holiday_surcharge (
  cruise_name,
  schedule_type,
  holiday_name,
  holiday_date,
  holiday_date_end,
  surcharge_per_person,
  valid_year,
  currency,
  notes
) VALUES
-- 크리스마스: 1인당 350,000동 추가
(
  '돌핀 하롱 크루즈',
  'DAY',
  '크리스마스',
  '2025-12-24',
  '2025-12-25',
  350000,
  2026,
  'VND',
  '1인당 350,000동 추가'
),
-- 연말연시 (12/31 ~ 1/1): 1인당 350,000동 추가
(
  '돌핀 하롱 크루즈',
  'DAY',
  '연말연시',
  '2025-12-31',
  '2026-01-01',
  350000,
  2026,
  'VND',
  '1인당 350,000동 추가'
),
-- 설 연휴 (구정): 1인당 350,000동 추가
(
  '돌핀 하롱 크루즈',
  'DAY',
  '설 연휴 (구정)',
  '2026-02-14',
  '2026-02-22',
  350000,
  2026,
  'VND',
  '1인당 350,000동 추가'
);

-- ============================================================================
-- 4. 선택 옵션 데이터 (cruise_tour_options)
-- 선데크 방갈로, 랍스터
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
-- 선데크 방갈로: 1,900,000동
(
  '돌핀 하롱 크루즈',
  'DAY',
  '선데크 방갈로',
  'Sun Deck Bungalow',
  1900000,
  'upgrade',
  '선데크 프라이빗 방갈로 1박 (최대 2인 정원)',
  true
),
-- 랍스터 음식: 500,000동
(
  '돌핀 하롱 크루즈',
  'DAY',
  '랍스터 음식',
  'Lobster (Fresh Sea Food)',
  500000,
  'addon',
  '신선한 랍스터 음식 추가',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

SELECT '=== Dolphin Halong One-Day Tour 기본 요금 (기간 1: 그랜드 오프닝) ===' AS "검증 항목";

SELECT 
  season_name as "요금제",
  room_type as "평일/주말",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-12세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "2-4세",
  valid_from || ' ~ ' || valid_to as "적용기간"
FROM cruise_rate_card
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
  AND valid_from <= '2026-03-31'
ORDER BY display_order;

SELECT '=== Dolphin Halong One-Day Tour 신규 요금 (기간 2: 04-01~) ===' AS "검증 항목";

SELECT 
  season_name as "요금제",
  room_type as "평일/주말",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-12세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "2-4세",
  valid_from || ' ~ ' || valid_to as "적용기간"
FROM cruise_rate_card
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
  AND valid_from >= '2026-04-01'
ORDER BY display_order;

SELECT '=== 공휴일/특별일 추가 요금 ===' AS "검증 항목";

SELECT 
  holiday_name as "특별일",
  holiday_date || ' ~ ' || holiday_date_end as "기간",
  TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동' as "추가요금",
  notes as "비고"
FROM cruise_holiday_surcharge
WHERE cruise_name = '돌핀 하롱 크루즈'
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
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price DESC;

SELECT '=== 가격 계산 예시 ===' AS "검증 항목";

SELECT 
  '✅ 그랜드오프닝 신용카드 평일: 성인 1인' as "예시",
  TO_CHAR(1750000, 'FM999,999,999') || '동' as "요금"
UNION ALL
SELECT '✅ 그랜드오프닝 신용카드 주말: 성인 1인', TO_CHAR(1975000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 그랜드오프닝 신용카드 주말: 성인 + 아동(5-12세)', TO_CHAR(1975000 + 1525000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 그랜드오프닝 리무진 평일: 성인 1인', TO_CHAR(2450000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 그랜드오프닝 리무진 주말: 성인 1인', TO_CHAR(2650000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 신규요금(04-01~) 신용카드 평일: 성인 1인', TO_CHAR(2050000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 신규요금(04-01~) 신용카드 주말: 성인 1인', TO_CHAR(2275000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 신용카드 평일 + 선데크 방갈로', TO_CHAR(1750000 + 1900000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 신용카드 평일 + 랍스터', TO_CHAR(1750000 + 500000, 'FM999,999,999') || '동';

SELECT '=== 데이터 개수 확인 ===' AS "검증 항목";

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '돌핀 하롱 크루즈' 
   AND schedule_type = 'DAY') as "기본요금행 (6행: 기간1 신용카드 2행 + 기간1 리무진 2행 + 기간2 신용카드 2행)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge 
   WHERE cruise_name = '돌핀 하롱 크루즈' 
   AND schedule_type = 'DAY') as "공휴일요금행 (3행: 크리스마스/연말연시/설)",
  (SELECT COUNT(*) FROM cruise_tour_options 
   WHERE cruise_name = '돌핀 하롱 크루즈' 
   AND schedule_type = 'DAY') as "선택옵션행 (2행: 선데크방갈로/랍스터)";

SELECT '=== 완전한 요금 조회 쿼리 ===' AS "검증 항목";

SELECT 
  '기본 요금' as "카테고리",
  season_name || ' - ' || room_type as "상세",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-12세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "2-4세",
  valid_from || ' ~ ' || valid_to as "적용기간"
FROM cruise_rate_card
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '공휴일 추가요금',
  holiday_name,
  TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동',
  NULL,
  NULL,
  holiday_date || ' ~ ' || holiday_date_end
FROM cruise_holiday_surcharge
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '선택 옵션',
  option_name,
  TO_CHAR(option_price, 'FM999,999,999') || '동',
  option_type,
  NULL,
  '연중'
FROM cruise_tour_options
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY "카테고리", "상세";

SELECT '✅ Dolphin Halong One-Day Tour 데이터 입력 완료!'::TEXT as "완료";
