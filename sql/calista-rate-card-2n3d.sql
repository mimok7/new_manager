-- ============================================================================
-- Calista Cruise - Rate Card
-- 칼리스타 크루즈 - 객실요금 데이터
-- ============================================================================
-- 입력 기준 데이터:
--   2N3D (2박 3일)
--   시즌1: 2026/01/01 - 04/30 (고가기)
--   시즌2: 2026/05/01 - 09/30 (프로모션)
--   시즌3: 2026/10/01 - 12/31 (고가기)
-- 
-- 특징:
--   - 6개 객실 타입
--   - 시즌별 요금 차등
--   - 모든 객실 동일 아동 요금: 5,550,000동
--   - 아동+엑스트라: 7,650,000동
--   - 2번째 유아부터: 5,900,000동/인
--   - President Suite: 엑스트라베드 불가능
--   - 휴일 추가요금: 1,200,000동/인 (성인/아동 동일)
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D';

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
  '2N3D',
  '칼리스타 오션',
  'Calista Ocean',
  9300000,
  5550000,
  5900000,
  9300000,
  7650000,
  15800000,
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
  '2N3D',
  '칼리스타 베이',
  'Calista Bay',
  10000000,
  5550000,
  5900000,
  10000000,
  7650000,
  18600000,
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
  '2N3D',
  '칼리스타 레거시',
  'Calista Legacy',
  12000000,
  5550000,
  5900000,
  12000000,
  7650000,
  20400000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- Horizon Suite
(
  '칼리스타 크루즈',
  '2N3D',
  'Horizon Suite',
  'Horizon Suite',
  18200000,
  5550000,
  5900000,
  18200000,
  7650000,
  31000000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- Majesty Suite
(
  '칼리스타 크루즈',
  '2N3D',
  'Majesty Suite',
  'Majesty Suite',
  20400000,
  5550000,
  5900000,
  20400000,
  7650000,
  34900000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  NULL,
  true
),
-- President Suite (엑스트라베드 불가)
(
  '칼리스타 크루즈',
  '2N3D',
  'President Suite',
  'President Suite',
  44600000,
  5550000,
  5900000,
  NULL,
  7650000,
  75800000,
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
  '2N3D',
  '칼리스타 오션',
  'Calista Ocean',
  7950000,
  5550000,
  5900000,
  3975000,
  7650000,
  13600000,
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
  '2N3D',
  '칼리스타 베이',
  'Calista Bay',
  8500000,
  5550000,
  5900000,
  3975000,
  7650000,
  14500000,
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
  '2N3D',
  '칼리스타 레거시',
  'Calista Legacy',
  9300000,
  5550000,
  5900000,
  9300000,
  7650000,
  15900000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- Horizon Suite
(
  '칼리스타 크루즈',
  '2N3D',
  'Horizon Suite',
  'Horizon Suite',
  16600000,
  5550000,
  5900000,
  16600000,
  7650000,
  28200000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- Majesty Suite
(
  '칼리스타 크루즈',
  '2N3D',
  'Majesty Suite',
  'Majesty Suite',
  18800000,
  5550000,
  5900000,
  18800000,
  7650000,
  32000000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  NULL,
  true
),
-- President Suite (엑스트라베드 불가)
(
  '칼리스타 크루즈',
  '2N3D',
  'President Suite',
  'President Suite',
  40300000,
  5550000,
  5900000,
  NULL,
  7650000,
  68600000,
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
  '2N3D',
  '칼리스타 오션',
  'Calista Ocean',
  9300000,
  5550000,
  5900000,
  9300000,
  7650000,
  15800000,
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
  '2N3D',
  '칼리스타 베이',
  'Calista Bay',
  10950000,
  5550000,
  5900000,
  10950000,
  7650000,
  18600000,
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
  '2N3D',
  '칼리스타 레거시',
  'Calista Legacy',
  12000000,
  5550000,
  5900000,
  12000000,
  7650000,
  20400000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- Horizon Suite
(
  '칼리스타 크루즈',
  '2N3D',
  'Horizon Suite',
  'Horizon Suite',
  18200000,
  5550000,
  5900000,
  18200000,
  7650000,
  31000000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- Majesty Suite
(
  '칼리스타 크루즈',
  '2N3D',
  'Majesty Suite',
  'Majesty Suite',
  20400000,
  5550000,
  5900000,
  20400000,
  7650000,
  34900000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- President Suite (엑스트라베드 불가)
(
  '칼리스타 크루즈',
  '2N3D',
  'President Suite',
  'President Suite',
  44600000,
  5550000,
  5900000,
  NULL,
  7650000,
  75800000,
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
  '2N3D',
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
  '2N3D',
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
  '2N3D',
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
-- Verification Queries (검증용 쿼리)
-- ============================================================================

-- Season 1 요금 요약
SELECT '=== SEASON 1 (고가기: 2026/01/01-04/30) ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "2번째유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND valid_from = '2026-01-01'
ORDER BY room_type;

-- Season 2 요금 요약
SELECT '=== SEASON 2 (프로모션: 2026/05/01-09/30) ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "2번째유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND valid_from = '2026-05-01'
ORDER BY room_type;

-- Season 3 요금 요약
SELECT '=== SEASON 3 (고가기: 2026/10/01-12/31) ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "2번째유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND valid_from = '2026-10-01'
ORDER BY room_type;

-- 휴일 추가요금 요약
SELECT '=== 휴일 추가요금 ===' AS status;

SELECT
  holiday_date as "날짜",
  holiday_date_end as "종료일",
  holiday_name as "휴일명",
  surcharge_per_person as "성인추가요금",
  surcharge_child as "아동추가요금"
FROM cruise_holiday_surcharge
WHERE cruise_name = '칼리스타 크루즈'
ORDER BY holiday_date;

-- 데이터 개수 확인
SELECT '=== 데이터 개수 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '칼리스타 크루즈') as "객실가격행 (18행 예상)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '칼리스타 크루즈') as "휴일추가행 (3행 예상)";

-- 시즌별 객실 개수 확인
SELECT '=== 시즌별 객실 개수 ===' AS status;

SELECT 
  CASE WHEN valid_from = '2026-01-01' THEN '시즌1 (고가기)' 
       WHEN valid_from = '2026-05-01' THEN '시즌2 (프로모션)'
       ELSE '시즌3 (고가기)' END as 시즌,
  COUNT(*) as "객실행수 (6행 예상)"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
GROUP BY valid_from
ORDER BY valid_from;

-- 아동 요금 통일성 확인 (모두 5,550,000)
SELECT '=== 아동 요금 통일성 확인 ===' AS status;

SELECT DISTINCT
  price_child as "아동요금",
  COUNT(*) as "객실행수"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND price_child > 0
GROUP BY price_child;

-- 2번째 유아 요금 확인 (모두 5,900,000)
SELECT '=== 2번째 유아 요금 확인 ===' AS status;

SELECT DISTINCT
  price_infant as "2번째유아요금",
  COUNT(*) as "객실행수"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND price_infant > 0
GROUP BY price_infant;

-- 엑스트라베드 정책 확인
SELECT '=== 엑스트라베드 정책 확인 ===' AS status;

SELECT 
  CASE WHEN extra_bed_available THEN '엑스트라베드 가능' 
       ELSE '엑스트라베드 불가' END as 정책,
  COUNT(*) as "객실행수"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
GROUP BY extra_bed_available
ORDER BY extra_bed_available DESC;

-- President Suite 검증 (엑스트라베드 불가능)
SELECT '=== President Suite 검증 ===' AS status;

SELECT 
  valid_from as "시즌시작",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  extra_bed_available as "엑스트라베드",
  price_extra_bed as "엑스트라베드요금",
  CASE WHEN NOT extra_bed_available AND price_extra_bed IS NULL THEN '✓ 정상' 
       ELSE '✗ 오류' END as "검증"
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈'
  AND room_type = 'President Suite'
ORDER BY valid_from;

-- 시즌별 가격 비교
SELECT '=== 시즌별 가격 비교 ===' AS status;

SELECT 
  s1.room_type as "객실명",
  s1.price_adult as "시즌1_성인",
  s2.price_adult as "시즌2_성인",
  s3.price_adult as "시즌3_성인",
  ROUND((s1.price_adult - s2.price_adult) / s2.price_adult * 100, 1) as "S1대비S2_%"
FROM (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '칼리스타 크루즈' AND valid_from = '2026-01-01'
) s1
JOIN (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '칼리스타 크루즈' AND valid_from = '2026-05-01'
) s2 ON s1.room_type = s2.room_type
JOIN (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '칼리스타 크루즈' AND valid_from = '2026-10-01'
) s3 ON s1.room_type = s3.room_type
ORDER BY s1.room_type;
