-- ============================================================================
-- Calista Cruise - Rate Card (1N2D) [FINAL]
-- 칼리스타 크루즈 - 객실요금 데이터 (1박 2일)
-- ============================================================================
-- 입력 기준 데이터:
--   1N2D (1박 2일)
--   시즌1: 2026/01/01 - 04/30 (고가기)
--   시즌2: 2026/05/01 - 09/30 (프로모션)
--   시즌3: 2026/10/01 - 12/31 (고가기)
-- 
-- 특징:
--   - 6개 객실 타입 (한글명)
--   - 시즌별 요금 차등
--   - 모든 객실 아동 요금 통일: 2,775,000동
--   - 모든 객실 아동엑베 통일: 3,825,000동
--   - 2번째 유아부터: 2,950,000동/인
--   - 프레지던트 스위트: 엑스트라베드 불가능 (NULL)
--   - 휴일 추가요금: 1,200,000동/인 (성인/아동 동일)
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D';

-- ============================================================================
-- Section 1: Season 1 (2026/01/01 - 04/30) - 고가기
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
-- 칼리스타 오션
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 오션',
  'Calista Ocean',
  4650000,
  2775000,
  2950000,
  4650000,
  3825000,
  7900000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- 칼리스타 베이
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 베이',
  'Calista Bay',
  5000000,
  2775000,
  2950000,
  5000000,
  3825000,
  9300000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- 칼리스타 레거시
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 레거시',
  'Calista Legacy',
  6000000,
  2775000,
  2950000,
  6000000,
  3825000,
  10200000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- 호라이즌 스위트
(
  '칼리스타 크루즈',
  '1N2D',
  '호라이즌 스위트',
  'Horizon Suite',
  9100000,
  2775000,
  2950000,
  9100000,
  3825000,
  15500000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- 메저스티 스위트
(
  '칼리스타 크루즈',
  '1N2D',
  '메저스티 스위트',
  'Majesty Suite',
  10200000,
  2775000,
  2950000,
  10200000,
  3825000,
  17450000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- 프레지던트 스위트 (엑스트라베드 불가)
(
  '칼리스타 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  22300000,
  2775000,
  2950000,
  NULL,
  3825000,
  37900000,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
);

-- ============================================================================
-- Section 2: Season 2 (2026/05/01 - 09/30) - 프로모션
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
-- 칼리스타 오션
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 오션',
  'Calista Ocean',
  3975000,
  2775000,
  2950000,
  3975000,
  3825000,
  6800000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- 칼리스타 베이
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 베이',
  'Calista Bay',
  4250000,
  2775000,
  2950000,
  4250000,
  3825000,
  7250000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- 칼리스타 레거시
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 레거시',
  'Calista Legacy',
  4650000,
  2775000,
  2950000,
  4650000,
  3825000,
  7950000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- 호라이즌 스위트
(
  '칼리스타 크루즈',
  '1N2D',
  '호라이즌 스위트',
  'Horizon Suite',
  8300000,
  2775000,
  2950000,
  8300000,
  3825000,
  14100000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- 메저스티 스위트
(
  '칼리스타 크루즈',
  '1N2D',
  '메저스티 스위트',
  'Majesty Suite',
  9400000,
  2775000,
  2950000,
  9400000,
  3825000,
  16000000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- 프레지던트 스위트 (엑스트라베드 불가)
(
  '칼리스타 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  20150000,
  2775000,
  2950000,
  NULL,
  3825000,
  34300000,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
);

-- ============================================================================
-- Section 3: Season 3 (2026/10/01 - 12/31) - 고가기
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
-- 칼리스타 오션
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 오션',
  'Calista Ocean',
  4650000,
  2775000,
  2950000,
  4650000,
  3825000,
  7900000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 칼리스타 베이
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 베이',
  'Calista Bay',
  5475000,
  2775000,
  2950000,
  5475000,
  3825000,
  9300000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 칼리스타 레거시
(
  '칼리스타 크루즈',
  '1N2D',
  '칼리스타 레거시',
  'Calista Legacy',
  6000000,
  2775000,
  2950000,
  6000000,
  3825000,
  10200000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 호라이즌 스위트
(
  '칼리스타 크루즈',
  '1N2D',
  '호라이즌 스위트',
  'Horizon Suite',
  9100000,
  2775000,
  2950000,
  9100000,
  3825000,
  15500000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 메저스티 스위트
(
  '칼리스타 크루즈',
  '1N2D',
  '메저스티 스위트',
  'Majesty Suite',
  10200000,
  2775000,
  2950000,
  10200000,
  3825000,
  17450000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 프레지던트 스위트 (엑스트라베드 불가)
(
  '칼리스타 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  22300000,
  2775000,
  2950000,
  NULL,
  3825000,
  37900000,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
);

-- ============================================================================
-- Section 4: Holiday Surcharges (휴일 추가요금)
-- ============================================================================

INSERT INTO cruise_holiday_surcharge (
  cruise_name,
  schedule_type,
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person,
  surcharge_child,
  surcharge_type,
  valid_year,
  currency,
  is_confirmed
) VALUES
-- 2026-04-30 ~ 05-01 (황금연휴)
(
  '칼리스타 크루즈',
  '1N2D',
  '2026-04-30',
  '2026-05-01',
  '황금연휴',
  1200000,
  1200000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-12-24 (크리스마스 이브)
(
  '칼리스타 크루즈',
  '1N2D',
  '2026-12-24',
  NULL,
  '크리스마스 이브',
  1200000,
  1200000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-12-31 (연말연시)
(
  '칼리스타 크루즈',
  '1N2D',
  '2026-12-31',
  NULL,
  '연말연시',
  1200000,
  1200000,
  'per_person',
  2026,
  'VND',
  true
);

-- ============================================================================
-- Verification Queries - 칼리스타 1박2일
-- ============================================================================

SELECT '=== 칼리스타 1박2일 | 시즌1 고가기 (2026/01/01 ~ 04/30) ===' AS status;

SELECT 
  room_type as "객실",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아(2순)",
  price_extra_bed as "엑스트라",
  price_child_extra_bed as "아동엑베",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "엑베"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D' AND valid_from = '2026-01-01'
ORDER BY CASE WHEN room_type = '칼리스타 오션' THEN 1 WHEN room_type = '칼리스타 베이' THEN 2 WHEN room_type = '칼리스타 레거시' THEN 3 WHEN room_type = '호라이즌 스위트' THEN 4 WHEN room_type = '메저스티 스위트' THEN 5 ELSE 6 END;

SELECT '=== 칼리스타 1박2일 | 시즌2 프로모션 (2026/05/01 ~ 09/30) ===' AS status;

SELECT 
  room_type as "객실",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아(2순)",
  price_extra_bed as "엑스트라",
  price_child_extra_bed as "아동엑베",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "엑베"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D' AND valid_from = '2026-05-01'
ORDER BY CASE WHEN room_type = '칼리스타 오션' THEN 1 WHEN room_type = '칼리스타 베이' THEN 2 WHEN room_type = '칼리스타 레거시' THEN 3 WHEN room_type = '호라이즌 스위트' THEN 4 WHEN room_type = '메저스티 스위트' THEN 5 ELSE 6 END;

SELECT '=== 칼리스타 1박2일 | 시즌3 고가기 (2026/10/01 ~ 12/31) ===' AS status;

SELECT 
  room_type as "객실",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아(2순)",
  price_extra_bed as "엑스트라",
  price_child_extra_bed as "아동엑베",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "엑베"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D' AND valid_from = '2026-10-01'
ORDER BY CASE WHEN room_type = '칼리스타 오션' THEN 1 WHEN room_type = '칼리스타 베이' THEN 2 WHEN room_type = '칼리스타 레거시' THEN 3 WHEN room_type = '호라이즌 스위트' THEN 4 WHEN room_type = '메저스티 스위트' THEN 5 ELSE 6 END;

SELECT '=== 칼리스타 1박2일 | 휴일 추가요금 ===' AS status;

SELECT
  holiday_date as "날짜",
  holiday_date_end as "종료일",
  holiday_name as "휴일명",
  surcharge_per_person as "성인",
  surcharge_child as "아동"
FROM cruise_holiday_surcharge
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D'
ORDER BY holiday_date;

SELECT '=== 칼리스타 1박2일 | 데이터 통계 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D') as "객실가격 총 행수 (18행)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '1N2D') as "휴일추가 총 행수 (3행)";
