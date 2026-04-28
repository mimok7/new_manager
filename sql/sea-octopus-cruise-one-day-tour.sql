-- ============================================================================
-- Sea Octopus Cruise - One-Day Tour
-- 씨옥토퍼스 크루즈 - 당일투어 패키지
-- ============================================================================
-- 입력 기준 데이터:
--   당일투어 (One-Day Tour)
--   적용 기간: 2026년 12월 31일까지
--   결제 방식: 신용카드 결제 (ONEPAY)
--   나이별 가격: 성인, 5-11세 아동
--   추가 옵션: 크루즈 셔틀 리무진
-- 
-- 특징:
--   - 당일투어 (overnight 아님)
--   - 신용카드 결제만
--   - 2개 나이 카테고리: 성인, 5-11세 아동
--   - 세금 및 봉사료 일체 포함
--   - 엑스트라베드 불가 (당일투어 특성)
--   - 선택 옵션: cruise_tour_options 테이블에서 관리
-- ============================================================================

-- ============================================================================
-- 1. 기존 데이터 정리
-- ============================================================================
DELETE FROM cruise_rate_card 
WHERE cruise_name = '씨옥토퍼스 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '씨옥토퍼스 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_tour_options 
WHERE cruise_name = '씨옥토퍼스 크루즈' AND schedule_type = 'DAY';

-- ============================================================================
-- 2. 기본 요금 데이터 (cruise_rate_card)
-- 신용카드 결제 (ONEPAY)
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
-- 신용카드 결제 (ONEPAY)
(
  '씨옥토퍼스 크루즈',
  'DAY',
  'Sea Octopus One-Day Tour',
  'Sea Octopus One-Day Tour',
  1400000,
  1050000,
  0,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  '5~11세',
  '12세 이상은 성인 요금',
  true,
  1,
  '신용카드 결제 (ONEPAY), 세금 및 봉사료 포함'
);

-- ============================================================================
-- 3. 선택 옵션 데이터 (cruise_tour_options)
-- 크루즈 셔틀 리무진
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
-- 크루즈 셔틀 리무진: 800,000동
(
  '씨옥토퍼스 크루즈',
  'DAY',
  '크루즈 셔틀 리무진',
  'Cruise Shuttle Limousine',
  800000,
  'addon',
  '호텔에서 크루즈 선착장까지 왕복 리무진 (1인당)',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

SELECT '=== Sea Octopus Cruise One-Day Tour 기본 요금 ===' AS "검증 항목";

SELECT 
  season_name as "결제방식",
  room_type as "상품명",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-11세 아동"
FROM cruise_rate_card
WHERE cruise_name = '씨옥토퍼스 크루즈'
  AND schedule_type = 'DAY'
ORDER BY display_order;

SELECT '=== 선택 옵션 (cruise_tour_options) ===' AS "검증 항목";

SELECT 
  option_name as "옵션명",
  option_name_en as "영문명",
  TO_CHAR(option_price, 'FM999,999,999') || '동' as "가격",
  option_type as "타입",
  description as "설명"
FROM cruise_tour_options
WHERE cruise_name = '씨옥토퍼스 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price;

SELECT '=== 가격 계산 예시 ===' AS "검증 항목";

SELECT 
  '✅ 기본: 성인 1인' as "예시",
  TO_CHAR(1400000, 'FM999,999,999') || '동' as "요금"
UNION ALL
SELECT '✅ 기본: 성인 + 5-11세 아동', TO_CHAR(1400000 + 1050000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 기본: 성인 2인 + 아동 1인', TO_CHAR((1400000 * 2) + 1050000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 기본: 성인 1인 + 셔틀 리무진', TO_CHAR(1400000 + 800000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 기본: 성인 + 아동 + 셔틀 리무진 (1인당 리무진)', TO_CHAR((1400000 + 1050000) + (800000 * 2), 'FM999,999,999') || '동';

SELECT '=== 데이터 개수 확인 ===' AS "검증 항목";

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '씨옥토퍼스 크루즈' 
   AND schedule_type = 'DAY') as "기본요금행 (1행: 신용카드)",
  (SELECT COUNT(*) FROM cruise_tour_options 
   WHERE cruise_name = '씨옥토퍼스 크루즈' 
   AND schedule_type = 'DAY') as "선택옵션행 (1행: 셔틀리무진)";

SELECT '=== 완전한 요금 조회 쿼리 ===' AS "검증 항목";

SELECT 
  '기본 요금' as "카테고리",
  season_name as "상세",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-11세 아동",
  valid_from || ' ~ ' || valid_to as "적용기간",
  notes as "비고"
FROM cruise_rate_card
WHERE cruise_name = '씨옥토퍼스 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '선택 옵션',
  option_name,
  TO_CHAR(option_price, 'FM999,999,999') || '동',
  option_type,
  '연중',
  description
FROM cruise_tour_options
WHERE cruise_name = '씨옥토퍼스 크루즈'
  AND schedule_type = 'DAY'
ORDER BY "카테고리" DESC;

SELECT '✅ Sea Octopus Cruise One-Day Tour 데이터 입력 완료!'::TEXT as "완료";
