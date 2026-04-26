-- ============================================================================
-- 045-saquila-yacht-one-day-tour.sql
-- 사퀼라 요트 크루즈 (SAQUILA YACHT) - 당일투어 패키지
-- ============================================================================
-- 크루즈명: 사퀼라 요트 크루즈 (SAQUILA YACHT)
-- 유형: 당일투어 (DAY)
-- 출항연도: 2024년 5월
-- 선체길이: 56.18m / 승선정원: 150명 / 지상 3층
-- 투어코스: 승솟동굴 → 루온동굴 → 티톱섬
-- 적용기간: 2026년 12월 31일까지
-- 요금:
--   성인 1인당: 1,700,000동
--   아동 5-11세: 1,400,000동
--   아동 2-4세:  550,000동
-- 추가옵션:
--   카약킹 1인당: 150,000동
--   셔틀리무진 왕복/편도 1인당: 800,000동
-- ============================================================================

-- ============================================================================
-- 1. 기존 데이터 정리
-- ============================================================================
DELETE FROM cruise_rate_card
WHERE cruise_name = '사퀼라 요트 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name = '사퀼라 요트 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_tour_options
WHERE cruise_name = '사퀼라 요트 크루즈' AND schedule_type = 'DAY';

-- ============================================================================
-- 2. 기본 요금 데이터 (cruise_rate_card)
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
(
  '사퀼라 요트 크루즈',
  'DAY',
  'Saquila Yacht One-Day Tour',
  'Saquila Yacht One-Day Tour',
  1700000,
  1400000,
  550000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '기본요금',
  '5~11세: 1,400,000동, 2~4세: 550,000동',
  '2세 미만 요금은 별도 문의',
  true,
  1,
  '성인 1,700,000동 / 아동 5-11세 1,400,000동 / 아동 2-4세 550,000동'
);

-- ============================================================================
-- 3. 선택 옵션 데이터 (cruise_tour_options)
-- 카약킹 옵션 및 셔틀리무진
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
-- 카약킹: 1인당 150,000동
(
  '사퀼라 요트 크루즈',
  'DAY',
  '카약킹',
  'Kayaking',
  150000,
  'addon',
  '루온동굴 카약킹 1인당 추가요금 (현장결제 가능)',
  true
),
-- 셔틀리무진: 1인당 800,000동 (왕복/편도)
(
  '사퀼라 요트 크루즈',
  'DAY',
  '셔틀리무진',
  'Shuttle Limousine',
  800000,
  'addon',
  '하노이 올드쿼터(호안끼엠) 픽업/드랍 셔틀리무진 1인당 왕복/편도 요금',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

-- SELECT '=== 사퀼라 요트 크루즈 기본 요금 ===' AS "검증 항목";
-- 
-- SELECT
--   season_name as "요금구분",
--   room_type as "상품명",
--   TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
--   TO_CHAR(price_child, 'FM999,999,999') || '동' as "아동 5-11세",
--   TO_CHAR(price_infant, 'FM999,999,999') || '동' as "아동 2-4세",
--   child_age_range as "나이범위",
--   infant_policy as "유아정책"
-- FROM cruise_rate_card
-- WHERE cruise_name = '사퀼라 요트 크루즈'
--   AND schedule_type = 'DAY'
-- ORDER BY display_order;
-- 
-- SELECT '=== 선택 옵션 ===' AS "검증 항목";
-- 
-- SELECT
--   option_name as "옵션명",
--   option_name_en as "영문명",
--   TO_CHAR(option_price, 'FM999,999,999') || '동' as "가격",
--   option_type as "타입",
--   description as "설명"
-- FROM cruise_tour_options
-- WHERE cruise_name = '사퀼라 요트 크루즈'
--   AND schedule_type = 'DAY'
-- ORDER BY option_price;
-- 
-- SELECT '=== 가격 계산 예시 ===' AS "검증 항목";
-- 
-- SELECT '✅ 성인 1인' as "예시", TO_CHAR(1700000, 'FM999,999,999') || '동' as "요금"
-- UNION ALL
-- SELECT '✅ 성인 1인 + 아동(5-11세) 1인', TO_CHAR(1700000 + 1400000, 'FM999,999,999') || '동'
-- UNION ALL
-- SELECT '✅ 성인 1인 + 아동(2-4세) 1인', TO_CHAR(1700000 + 550000, 'FM999,999,999') || '동'
-- UNION ALL
-- SELECT '✅ 성인 1인 + 카약킹', TO_CHAR(1700000 + 150000, 'FM999,999,999') || '동'
-- UNION ALL
-- SELECT '✅ 성인 1인 + 셔틀리무진', TO_CHAR(1700000 + 800000, 'FM999,999,999') || '동'
-- UNION ALL
-- SELECT '✅ 성인 1인 + 셔틀 + 카약킹', TO_CHAR(1700000 + 800000 + 150000, 'FM999,999,999') || '동';
