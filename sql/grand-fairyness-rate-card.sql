-- ============================================================================
-- Grand Fairyness Cruise - Rate Card (CORRECTED)
-- 그랜드 파이어니스 크루즈 - 객실요금 데이터 (정정 완료)
-- ============================================================================
-- 입력 기준 데이터:
--   시즌1 (동계): 2026/02/01 - 02/28 (정가)
--   시즌2 (춘/하계): 2026/03/01 - 12/31 (일부 인하)
-- 
-- 정정 사항:
--   - 모든 객실에 아동요금(price_child) 입력됨
--   - 트리플룸, 에센스, 오셔니아 아동가: S1 = 3,200,000 / S2 = 3,200,000 (럭셔리 포함)
--   - 엑스트라베드 불가 객실: NULL 입력
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '그랜드 파이어니스 크루즈';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '그랜드 파이어니스 크루즈';

-- ============================================================================
-- Section 1: Season 1 (2026/02/01 - 02/28) - 정가 (기준 요금)
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
  is_active
) VALUES
-- 오션스위트룸
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '오션스위트룸',
  'Ocean Suite Room',
  5250000,
  3200000,
  NULL,
  4800000,
  4250000,
  8600000,
  true,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 오션스위트 트리플룸 (아동 가능)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '오션스위트 트리플룸',
  'Ocean Suite Triple Room',
  5300000,
  3200000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 오션발코니 스위트
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '오션발코니 스위트',
  'Ocean Balcony Suite',
  5250000,
  3200000,
  NULL,
  4800000,
  4250000,
  8600000,
  true,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 베란다 스위트
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '베란다 스위트',
  'Veranda Suite',
  6300000,
  3200000,
  NULL,
  5600000,
  4300000,
  10200000,
  true,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 이그제큐티브 스위트
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  6800000,
  3200000,
  NULL,
  6100000,
  4300000,
  11000000,
  true,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 더 에센스 스위트 (럭셔리, 아동 가능)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 에센스 스위트',
  'The Essence Suite',
  9300000,
  3200000,
  NULL,
  NULL,
  NULL,
  15000000,
  false,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 더 오셔니아 스위트 (럭셔리, 아동 가능)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오셔니아 스위트',
  'The Oceania Suite',
  15300000,
  3200000,
  NULL,
  13800000,
  NULL,
  24600000,
  true,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 더 오너스 스위트 (2인) - 아동가 = 성인가 (정원 2인)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오너스 스위트 (2인)',
  'The Owns Suite (2pax)',
  22900000,
  22900000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 더 오너스 스위트 (3인) - 아동가 = 성인가 (정원 3인)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오너스 스위트 (3인)',
  'The Owns Suite (3pax)',
  17100000,
  17100000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
),
-- 더 오너스 스위트 (4인) - 아동가 = 성인가 (정원 4인)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오너스 스위트 (4인)',
  'The Owns Suite (4pax)',
  14200000,
  14200000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-02-01',
  '2026-02-28',
  'VND',
  true
);

-- ============================================================================
-- Section 2: Season 2 (2026/03/01 - 12/31) - 인하 적용 (3월부터 할인 공지)
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
  is_active
) VALUES
-- 오션스위트룸 (성인 50,000 인하, 아동 50,000 인하)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '오션스위트룸',
  'Ocean Suite Room',
  5200000,
  3150000,
  NULL,
  4700000,
  4200000,
  8600000,
  true,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 오션스위트 트리플룸 (성인 변동 없음, 아동 150,000 인하)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '오션스위트 트리플룸',
  'Ocean Suite Triple Room',
  5300000,
  3150000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 오션발코니 스위트 (성인 50,000 인하, 아동 50,000 인하)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '오션발코니 스위트',
  'Ocean Balcony Suite',
  5200000,
  3150000,
  NULL,
  4700000,
  4200000,
  8600000,
  true,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 베란다 스위트 (성인 100,000 인하, 아동 50,000 인하)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '베란다 스위트',
  'Veranda Suite',
  6200000,
  3150000,
  NULL,
  5600000,
  4200000,
  10200000,
  true,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 이그제큐티브 스위트 (성인 100,000 인하, 아동 50,000 인하, 엑스트라 50,000 인하)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  6700000,
  3150000,
  NULL,
  6050000,
  4200000,
  11000000,
  true,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 더 에센스 스위트 (성인 변동 없음, 아동 유지 3,200,000)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 에센스 스위트',
  'The Essence Suite',
  9300000,
  3200000,
  NULL,
  NULL,
  NULL,
  15000000,
  false,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 더 오셔니아 스위트 (성인 변동 없음, 아동 유지 3,200,000)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오셔니아 스위트',
  'The Oceania Suite',
  15300000,
  3200000,
  NULL,
  13800000,
  NULL,
  24600000,
  true,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 더 오너스 스위트 (2인) - 아동가 = 성인가, 변동 없음
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오너스 스위트 (2인)',
  'The Owns Suite (2pax)',
  22900000,
  22900000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 더 오너스 스위트 (3인) - 아동가 = 성인가, 변동 없음
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오너스 스위트 (3인)',
  'The Owns Suite (3pax)',
  17100000,
  17100000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
),
-- 더 오너스 스위트 (4인) - 아동가 = 성인가, 변동 없음
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '더 오너스 스위트 (4인)',
  'The Owns Suite (4pax)',
  14200000,
  14200000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-03-01',
  '2026-12-31',
  'VND',
  true
);

-- ============================================================================
-- Section 3: Holiday Surcharges (휴일 추가요금)
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
-- 명절 연휴 (1/28-1/31)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '2026-01-28',
  '2026-01-31',
  '명절 연휴',
  1500000,
  'per_person',
  2026,
  'VND',
  true
),
-- 구정 연휴 (2/15-2/21) - 최고 추가요금
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '2026-02-15',
  '2026-02-21',
  '구정 연휴',
  1600000,
  'per_person',
  2026,
  'VND',
  true
),
-- 노동절 연휴 (4/30-5/01)
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '2026-04-30',
  '2026-05-01',
  '노동절 연휴',
  1500000,
  'per_person',
  2026,
  'VND',
  true
),
-- 추석 연휴 (8/30-9/01) - 최저 추가요금
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '2026-08-30',
  '2026-09-01',
  '추석 연휴',
  1250000,
  'per_person',
  2026,
  'VND',
  true
),
-- 크리스마스 이브 (12/24) - 단일 날짜
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '2026-12-24',
  NULL,
  '크리스마스 이브',
  1500000,
  'per_person',
  2026,
  'VND',
  true
),
-- 연말연시 (12/31) - 단일 날짜
(
  '그랜드 파이어니스 크루즈',
  '1N2D',
  '2026-12-31',
  NULL,
  '연말연시',
  1500000,
  'per_person',
  2026,
  'VND',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

-- 시즌별 객실 가격 요약 (시즌1)
SELECT 'SEASON 1: 2026/02/01 - 02/28' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_child_extra_bed as "아동엑스트라",
  price_extra_bed as "엑스트라",
  price_single as "싱글"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D'
  AND valid_to = '2026-02-28'
ORDER BY room_type;

-- 시즌별 객실 가격 요약 (시즌2)
SELECT 'SEASON 2: 2026/03/01 - 12/31' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_child_extra_bed as "아동엑스트라",
  price_extra_bed as "엑스트라",
  price_single as "싱글"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D'
  AND valid_to = '2026-12-31'
ORDER BY room_type;

-- 휴일 추가요금 요약
SELECT 'HOLIDAY SURCHARGES' AS status;

SELECT
  holiday_date as "시작",
  holiday_date_end as "종료",
  holiday_name as "휴일명",
  surcharge_per_person as "1인당추가요금"
FROM cruise_holiday_surcharge
WHERE cruise_name = '그랜드 파이어니스 크루즈'
ORDER BY holiday_date;

-- 데이터 개수 확인
SELECT 'COUNT SUMMARY' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '그랜드 파이어니스 크루즈') as "객실가격행",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '그랜드 파이어니스 크루즈') as "휴일추가행";
