-- ============================================================================
-- Luna Halong Cruise - One-Day Tour
-- 루나 하롱 크루즈 - 당일투어 패키지
-- ============================================================================
-- 입력 기준 데이터:
--   당일투어 (One-Day Tour)
--   적용 기간: 2026년 12월 31일까지
--   나이별 가격: 성인, 5-12세, 2-5세, 2세 미만 (FREE), 2세 미만 3번째 유아
--   추가 옵션: 1층 디럭스, 2층 프리미엄, 셔틀 리무진
-- 
-- 특징:
--   - 당일투어 (overnight 아님)
--   - 단일 요금제 (신용카드 / VND 구분 없음)
--   - 5개 나이 카테고리: 성인, 5-12세, 2-5세, 2세 미만(FREE), 3번째 유아
--   - 엑스트라베드 불가 (당일투어 특성)
--   - 선택 옵션: cruise_tour_options 테이블에서 관리
-- ============================================================================

-- ============================================================================
-- 1. 기존 데이터 정리
-- ============================================================================
DELETE FROM cruise_rate_card 
WHERE cruise_name = '루나 하롱 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '루나 하롱 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_tour_options 
WHERE cruise_name = '루나 하롱 크루즈' AND schedule_type = 'DAY';

-- ============================================================================
-- 2. 기본 요금 데이터 (cruise_rate_card)
-- 단일 요금제 (구분 없음)
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
-- 크루즈 티켓 기본 요금 (이동차량 제외)
(
  '루나 하롱 크루즈',
  'DAY',
  'Luna Halong One-Day Tour',
  'Luna Halong One-Day Tour',
  1580000,
  1250000,
  900000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '기본 요금',
  true
);

-- ============================================================================
-- 3. 2세 미만 특별 요금
-- - 2세 미만: FREE
-- - 2세 미만 3번째 유아: 900,000동
-- (cruise_holiday_surcharge 활용)
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
-- 2세 미만: FREE (요금 0원)
(
  '루나 하롱 크루즈',
  'DAY',
  '2세 미만 유아 (FREE)',
  '2026-01-01',
  '2026-12-30',
  0,
  NULL,
  2026,
  'VND'
),
-- 2세 미만 3번째 유아: 900,000동 (holiday_date 분리하여 유니크 제약 회피)
(
  '루나 하롱 크루즈',
  'DAY',
  '2세 미만 3번째 유아',
  '2026-01-02',
  '2026-12-31',
  900000,
  NULL,
  2026,
  'VND'
);

-- ============================================================================
-- 4. 선택 옵션 데이터 (cruise_tour_options)
-- 1층 디럭스, 2층 프리미엄, 셔틀 리무진
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
-- 1층 디럭스: 1,500,000동
(
  '루나 하롱 크루즈',
  'DAY',
  '1층 디럭스 객실예약',
  'Deluxe Room Booking (1F)',
  1500000,
  'upgrade',
  '1층 디럭스 객실 1개 (발코니, 소파, 침대, 욕조 구비)',
  true
),
-- 2층 프리미엄: 1,850,000동
(
  '루나 하롱 크루즈',
  'DAY',
  '2층 프리미엄 객실예약',
  'Premium Room Booking (2F)',
  1850000,
  'upgrade',
  '2층 프리미엄 객실 1개 (발코니, 소파, 침대, 욕조 구비)',
  true
),
-- 셔틀 리무진: 700,000동
(
  '루나 하롱 크루즈',
  'DAY',
  '셔틀 리무진 차량',
  'Shuttle Limousine (Round Trip)',
  700000,
  'addon',
  '공항 또는 숙소 셔틀 리무진 왕복 (1인당)',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

SELECT '=== Luna Halong One-Day Tour 기본 요금 ===' AS "검증 항목";

SELECT 
  season_name as "요금제",
  room_type as "상품명",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-12세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "2-5세"
FROM cruise_rate_card
WHERE cruise_name = '루나 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY price_adult;

SELECT '=== 2세 미만 및 특별 요금 ===' AS "검증 항목";

SELECT 
  holiday_name as "요금 구분",
  TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동' as "요금",
  holiday_date as "적용 시작",
  holiday_date_end as "적용 종료"
FROM cruise_holiday_surcharge
WHERE cruise_name = '루나 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY surcharge_per_person DESC;

SELECT '=== 선택 옵션 (cruise_tour_options) ===' AS "검증 항목";

SELECT 
  option_name as "옵션명",
  option_name_en as "영문명",
  TO_CHAR(option_price, 'FM999,999,999') || '동' as "가격",
  option_type as "타입",
  description as "설명"
FROM cruise_tour_options
WHERE cruise_name = '루나 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price;

SELECT '=== 가격 계산 예시 ===' AS "검증 항목";

SELECT 
  '✅ 기본: 성인 1인' as "예시",
  TO_CHAR(1580000, 'FM999,999,999') || '동' as "요금"
UNION ALL
SELECT '✅ 기본: 성인 1인 + 아동(5-12세) 1인', TO_CHAR(1580000 + 1250000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 기본: 성인 1인 + 2세 미만 유아 (FREE)', TO_CHAR(1580000 + 0, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 기본: 성인 1인 + 2세 미만 3번째 유아', TO_CHAR(1580000 + 900000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 성인 + 1층 디럭스', TO_CHAR(1580000 + 1500000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 성인 + 2층 프리미엄', TO_CHAR(1580000 + 1850000, 'FM999,999,999') || '동'
UNION ALL
SELECT '✅ 성인 + 셔틀 리무진', TO_CHAR(1580000 + 700000, 'FM999,999,999') || '동';

SELECT '=== 데이터 개수 확인 ===' AS "검증 항목";

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '루나 하롱 크루즈' 
   AND schedule_type = 'DAY') as "기본요금행 (1행)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge 
   WHERE cruise_name = '루나 하롱 크루즈' 
   AND schedule_type = 'DAY') as "특별요금행 (2행: 2세미만)",
  (SELECT COUNT(*) FROM cruise_tour_options 
   WHERE cruise_name = '루나 하롱 크루즈' 
   AND schedule_type = 'DAY') as "선택옵션행 (3행)";

SELECT '=== 완전한 요금 조회 쿼리 ===' AS "검증 항목";

SELECT 
  '기본 요금' as "카테고리",
  season_name as "상세",
  TO_CHAR(price_adult, 'FM999,999,999') || '동' as "성인",
  TO_CHAR(price_child, 'FM999,999,999') || '동' as "5-12세",
  TO_CHAR(price_infant, 'FM999,999,999') || '동' as "2-5세"
FROM cruise_rate_card
WHERE cruise_name = '루나 하롱 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '특별 요금',
  holiday_name,
  TO_CHAR(surcharge_per_person, 'FM999,999,999') || '동',
  NULL,
  NULL
FROM cruise_holiday_surcharge
WHERE cruise_name = '루나 하롱 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '선택 옵션',
  option_name,
  TO_CHAR(option_price, 'FM999,999,999') || '동',
  option_type,
  NULL
FROM cruise_tour_options
WHERE cruise_name = '루나 하롱 크루즈'
  AND schedule_type = 'DAY';
