-- ============================================================================
-- Catamaran Cruise - One-Day Tour
-- 카타마란 크루즈 - 당일투어 패키지
-- ============================================================================
-- 입력 기준 데이터:
--   당일투어 (One-Day Tour)
--   적용 기간: 2026년 12월 31일까지
--   요금 구분:
--     1) 신용카드 결제 (ONEPAY): 요금 높음
--     2) VND 송금 (계좌이체): 요금 낮음
--   나이별 가격:
--     - 신용카드: 성인, 7-10세, 4-6세, 4세 미만(FREE)
--     - VND 송금: 성인, 7-10세, 2-4세, 4세 미만(FREE)
--   추가 옵션: 셔틀버스 왕복
-- 
-- 특징:
--   - 당일투어 (overnight 아님)
--   - 2개 결제 방식: 신용카드 / VND 송금 (season_name 활용)
--   - 나이대별 세분화 (신용카드와 VND 송금 시 유아 나이 범위 다름)
--   - 4세 미만: FREE 정책
--   - 엑스트라베드 불가 (당일투어 특성)
--   - 선택 옵션: cruise_tour_options 테이블에서 관리
-- ============================================================================

-- ============================================================================
-- 1. 기존 데이터 정리
-- ============================================================================
DELETE FROM cruise_rate_card 
WHERE cruise_name = '카타마란 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '카타마란 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_tour_options 
WHERE cruise_name = '카타마란 크루즈' AND schedule_type = 'DAY';

-- ============================================================================
-- 2. 기본 요금 데이터 (cruise_rate_card)
-- 신용카드 결제 (ONEPAY): 요금 높음
-- VND 송금 (계좌이체): 요금 낮음
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
  '카타마란 크루즈',
  'DAY',
  'Catamaran One-Day Tour',
  'Catamaran One-Day Tour',
  1650000,
  1200000,
  850000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  '7~10세: 1,200,000동, 4~6세: 850,000동',
  '4세 미만: FREE',
  true,
  1,
  '신용카드 결제 (ONEPAY), 4세 미만 무료'
);

-- ============================================================================
-- 3. 4세 미만 유아 FREE 정책 (cruise_holiday_surcharge 활용)
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
-- 4세 미만: FREE (요금 0원)
(
  '카타마란 크루즈',
  'DAY',
  '4세 미만 유아 (FREE)',
  '2026-01-01',
  '2026-12-31',
  0,
  2026,
  'VND',
  '4세 미만 유아 무료'
);

-- ============================================================================
-- 4. 선택 옵션 데이터 (cruise_tour_options)
-- 셔틀버스 왕복
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
-- 셔틀버스 왕복: 800,000동
(
  '카타마란 크루즈',
  'DAY',
  '셔틀버스 왕복',
  'Shuttle Bus (Round Trip)',
  800000,
  'addon',
  '공항 또는 숙소 셔틀버스 왕복 (1인당)',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

SELECT '=== Catamaran Cruise One-Day Tour 기본 요금 ===' AS "검증 항목";

SELECT 
  season_name as "결제방식",
  room_type as "상품명",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "7-10세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "4-6세"
FROM cruise_rate_card
WHERE cruise_name = '카타마란 크루즈'
  AND schedule_type = 'DAY'
ORDER BY display_order;

SELECT '=== 4세 미만 FREE 정책 ===' AS "검증 항목";

SELECT 
  holiday_name as "연령층",
  TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동' as "요금",
  holiday_date || ' ~ ' || holiday_date_end as "적용기간",
  notes as "비고"
FROM cruise_holiday_surcharge
WHERE cruise_name = '카타마란 크루즈'
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
WHERE cruise_name = '카타마란 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price;

SELECT '=== 가격 계산 예시 ===' AS "검증 항목";

SELECT 
  '✅ 신용카드: 성인 1인' as "예시",
  TO_CHAR(1650000, 'FM999,999,999') || '동' as "요금"
UNION ALL
SELECT '✅ 신용카드: 성인 + 7-10세 아동', TO_CHAR(1650000 + 1200000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 신용카드: 성인 + 4-6세 유아', TO_CHAR(1650000 + 850000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 신용카드: 성인 + 4세 미만 (FREE)', TO_CHAR(1650000 + 0, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 신용카드 + 셔틀버스 왕복', TO_CHAR(1650000 + 800000, 'FM999,999,999') || '동';

SELECT '=== 데이터 개수 확인 ===' AS "검증 항목";

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '카타마란 크루즈' 
   AND schedule_type = 'DAY') as "기본요금행 (1행: 신용카드만)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge 
   WHERE cruise_name = '카타마란 크루즈' 
   AND schedule_type = 'DAY') as "FREE정책행 (1행: 4세미만)",
  (SELECT COUNT(*) FROM cruise_tour_options 
   WHERE cruise_name = '카타마란 크루즈' 
   AND schedule_type = 'DAY') as "선택옵션행 (1행: 셔틀버스)";

SELECT '=== 완전한 요금 조회 쿼리 ===' AS "검증 항목";

SELECT 
  '기본 요금' as "카테고리",
  season_name as "상세",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "7-10세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "4-6세",
  valid_from || ' ~ ' || valid_to as "적용기간"
FROM cruise_rate_card
WHERE cruise_name = '카타마란 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  'FREE 정책',
  holiday_name,
  TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동',
  NULL,
  NULL,
  holiday_date || ' ~ ' || holiday_date_end
FROM cruise_holiday_surcharge
WHERE cruise_name = '카타마란 크루즈'
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
WHERE cruise_name = '카타마란 크루즈'
  AND schedule_type = 'DAY'
ORDER BY "카테고리", "상세";

SELECT '✅ Catamaran Cruise One-Day Tour 데이터 입력 완료!'::TEXT as "완료";
