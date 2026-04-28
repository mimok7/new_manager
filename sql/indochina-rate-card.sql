-- ============================================================================
-- Indochina Cruise - Rate Card (신용카드 / VND 송금)
-- 인도차이나 크루즈 - 객실요금 데이터
-- ============================================================================
-- 입력 기준 데이터:
--   시즌1: 2026/05/01 - 09/30 (성수기)
--   시즌2: 2026/10/01 - 12/31 (비수기 + 연말)
-- 
-- 결제방식:
--   신용카드 / VND 송금 (season_name 컬럼)
--
-- 객실: 주니어/스위트/이그제큐티브/프레지던트 (4가지)
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '인도차이나 크루즈';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '인도차이나 크루즈';

-- ============================================================================
-- Section 1: Season 1 (2026/05/01 - 09/30) - 신용카드
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
-- 주니어 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '주니어 스위트',
  'Junior Suite',
  4000000,
  3400000,
  4250000,
  4200000,
  4250000,
  6550000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '신용카드',
  true
),
-- 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '스위트',
  'Suite',
  4700000,
  3400000,
  4250000,
  4200000,
  4250000,
  8200000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '신용카드',
  true
),
-- 이그제큐티브 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  5500000,
  3400000,
  4250000,
  4200000,
  4250000,
  9900000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '신용카드',
  true
),
-- 프레지던트 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  9100000,
  3400000,
  4250000,
  4200000,
  4250000,
  15900000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '신용카드',
  true
);

-- ============================================================================
-- Section 2: Season 1 (2026/05/01 - 09/30) - VND 송금
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
-- 주니어 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '주니어 스위트',
  'Junior Suite',
  3800000,
  3300000,
  4250000,
  4050000,
  4250000,
  6400000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  'VND 송금',
  true
),
-- 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '스위트',
  'Suite',
  4550000,
  3300000,
  4250000,
  4050000,
  4250000,
  8000000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  'VND 송금',
  true
),
-- 이그제큐티브 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  5350000,
  3300000,
  4250000,
  4050000,
  4250000,
  9600000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  'VND 송금',
  true
),
-- 프레지던트 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  8850000,
  3300000,
  4250000,
  4050000,
  4250000,
  15600000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  'VND 송금',
  true
);

-- ============================================================================
-- Section 3: Season 2 (2026/10/01 - 12/31) - 신용카드
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
-- 주니어 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '주니어 스위트',
  'Junior Suite',
  4200000,
  3400000,
  4250000,
  4200000,
  4250000,
  7100000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '스위트',
  'Suite',
  5000000,
  3400000,
  4250000,
  4200000,
  4250000,
  8600000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 이그제큐티브 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  5800000,
  3400000,
  4250000,
  4200000,
  4250000,
  10200000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 프레지던트 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  9550000,
  3400000,
  4250000,
  4200000,
  4250000,
  16700000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
);

-- ============================================================================
-- Section 4: Season 2 (2026/10/01 - 12/31) - VND 송금
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
-- 주니어 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '주니어 스위트',
  'Junior Suite',
  4050000,
  3300000,
  4250000,
  4050000,
  4250000,
  6900000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '스위트',
  'Suite',
  4850000,
  3300000,
  4250000,
  4050000,
  4250000,
  8400000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- 이그제큐티브 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  5550000,
  3300000,
  4250000,
  4050000,
  4250000,
  10000000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- 프레지던트 스위트
(
  '인도차이나 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  9250000,
  3300000,
  4250000,
  4050000,
  4250000,
  16400000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
);

-- ============================================================================
-- Section 5: Holiday Surcharges (휴일 추가요금)
-- ============================================================================

INSERT INTO cruise_holiday_surcharge (
  cruise_name,
  schedule_type,
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person,
  surcharge_type,
  valid_year,
  currency,
  is_confirmed
) VALUES
-- 크리스마스 이브 (12/24)
(
  '인도차이나 크루즈',
  '1N2D',
  '2026-12-24',
  NULL,
  '크리스마스 이브',
  1100000,
  'per_person',
  2026,
  'VND',
  true
),
-- 연말 (12/30)
(
  '인도차이나 크루즈',
  '1N2D',
  '2026-12-30',
  NULL,
  '연말',
  1100000,
  'per_person',
  2026,
  'VND',
  true
),
-- 연말연시 (12/31)
(
  '인도차이나 크루즈',
  '1N2D',
  '2026-12-31',
  NULL,
  '연말연시',
  1100000,
  'per_person',
  2026,
  'VND',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

-- Season 1 신용카드 요약
SELECT '=== SEASON 1 - 신용카드 ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  season_name as "결제방식"
FROM cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈'
  AND valid_from = '2026-05-01'
  AND season_name = '신용카드'
ORDER BY room_type;

-- Season 1 VND 송금 요약
SELECT '=== SEASON 1 - VND 송금 ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  season_name as "결제방식"
FROM cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈'
  AND valid_from = '2026-05-01'
  AND season_name = 'VND 송금'
ORDER BY room_type;

-- Season 2 신용카드 요약
SELECT '=== SEASON 2 - 신용카드 ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  season_name as "결제방식"
FROM cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈'
  AND valid_from = '2026-10-01'
  AND season_name = '신용카드'
ORDER BY room_type;

-- Season 2 VND 송금 요약
SELECT '=== SEASON 2 - VND 송금 ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  season_name as "결제방식"
FROM cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈'
  AND valid_from = '2026-10-01'
  AND season_name = 'VND 송금'
ORDER BY room_type;

-- 홀리데이 추가요금 요약
SELECT '=== 홀리데이 추가요금 ===' AS status;

SELECT
  holiday_date as "날짜",
  holiday_name as "휴일명",
  surcharge_per_person as "1인당추가요금"
FROM cruise_holiday_surcharge
WHERE cruise_name = '인도차이나 크루즈'
ORDER BY holiday_date;

-- 데이터 개수 확인
SELECT '=== 데이터 개수 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '인도차이나 크루즈') as "객실가격행 (16행 예상)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '인도차이나 크루즈') as "휴일추가행 (3행 예상)";

-- 결제방식별 개수 확인
SELECT '=== 결제방식별 개수 ===' AS status;

SELECT 
  season_name as "결제방식",
  COUNT(*) as "객실행수 (4행 예상)"
FROM cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈'
GROUP BY season_name
ORDER BY season_name;

-- 시즌별 개수 확인
SELECT '=== 시즌별 개수 ===' AS status;

SELECT 
  DATE_TRUNC('month', valid_from)::DATE as "시성_시작",
  COUNT(*) as "객실행수 (8행 예상)"
FROM cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈'
GROUP BY DATE_TRUNC('month', valid_from)
ORDER BY DATE_TRUNC('month', valid_from);
