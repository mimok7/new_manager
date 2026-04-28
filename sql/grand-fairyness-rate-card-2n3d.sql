-- ============================================================================
-- Grand Fairyness Cruise - Rate Card (2N3D)
-- 그랜드 파이어니스 크루즈 - 객실요금 데이터 (2박 3일)
-- ============================================================================
-- 입력 기준 데이터:
--   2N3D (2박 3일)
--   시즌 1: 2026년 (시즌 구분 없음, 연중 단일 요금)
-- 
-- 특징:
--   - 10개 객실 타입
--   - 2개 결제 방법 (신용카드, VND 송금)
--   - 총 20개 가격 행 (10 rooms × 2 payment methods)
--   - 결제 방법별 상이한 요금
--   - 트리플 & 더 에센스/오셔니아: 엑스트라베드 불가
--   - 더 오너스 스위트 (2/3/4인): 아동요금 = 성인요금 (동일 가격 정책)
--   - 6개 휴일 추가요금 (1,250,000~1,600,000동/인)
-- ============================================================================

-- 기존 데이터 정리 (2N3D만 삭제, 1N2D는 유지)
DELETE FROM cruise_rate_card 
WHERE cruise_name = '그랜드 파이어니스 크루즈' AND schedule_type = '2N3D';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '그랜드 파이어니스 크루즈' AND schedule_type = '2N3D';

-- ============================================================================
-- Section 1: Credit Card Payment (신용카드 결제) - 2026/01/01 - 12/31
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
-- 신용카드: 오션스위트룸
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '오션스위트룸 (신용카드)',
  'Ocean Suite Room (Credit Card)',
  9850000,
  5900000,
  NULL,
  8850000,
  7900000,
  15700000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 오션스위트 트리플룸
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '오션스위트 트리플룸 (신용카드)',
  'Ocean Suite Triple Room (Credit Card)',
  9850000,
  5900000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 오션발코니 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '오션발코니 스위트 (신용카드)',
  'Ocean Balcony Suite (Credit Card)',
  9850000,
  5900000,
  NULL,
  8850000,
  7900000,
  15700000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 베란다 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '베란다 스위트 (신용카드)',
  'Veranda Suite (Credit Card)',
  11750000,
  5900000,
  NULL,
  10550000,
  7900000,
  18800000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 이그제큐티브 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '이그제큐티브 스위트 (신용카드)',
  'Executive Suite (Credit Card)',
  12750000,
  5900000,
  NULL,
  11400000,
  7900000,
  20400000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 더 에센스 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 에센스 스위트 (신용카드)',
  'The Essence Suite (Credit Card)',
  17500000,
  5900000,
  NULL,
  NULL,
  NULL,
  28000000,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 더 오셔니아 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오셔니아 스위트 (신용카드)',
  'The Oceania Suite (Credit Card)',
  29000000,
  5900000,
  NULL,
  NULL,
  NULL,
  46350000,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 더 오너스 스위트 (2인)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오너스 스위트 2인 (신용카드)',
  'The Ornus Suite 2pax (Credit Card)',
  43500000,
  43500000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 더 오너스 스위트 (3인)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오너스 스위트 3인 (신용카드)',
  'The Ornus Suite 3pax (Credit Card)',
  32500000,
  32500000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
),
-- 신용카드: 더 오너스 스위트 (4인)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오너스 스위트 4인 (신용카드)',
  'The Ornus Suite 4pax (Credit Card)',
  26900000,
  26900000,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
);

-- ============================================================================
-- Section 2: VND Transfer Payment (VND 송금 결제) - 2026/01/01 - 12/31
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
-- VND송금: 오션스위트룸
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '오션스위트룸 (VND송금)',
  'Ocean Suite Room (VND Transfer)',
  9600000,
  5750000,
  NULL,
  7650000,
  7650000,
  15300000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- VND송금: 오션스위트 트리플룸
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '오션스위트 트리플룸 (VND송금)',
  'Ocean Suite Triple Room (VND Transfer)',
  9600000,
  5750000,
  NULL,
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
-- VND송금: 오션발코니 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '오션발코니 스위트 (VND송금)',
  'Ocean Balcony Suite (VND Transfer)',
  9600000,
  5750000,
  NULL,
  7650000,
  7650000,
  15300000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- VND송금: 베란다 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '베란다 스위트 (VND송금)',
  'Veranda Suite (VND Transfer)',
  11400000,
  5750000,
  NULL,
  9100000,
  7650000,
  18400000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- VND송금: 이그제큐티브 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '이그제큐티브 스위트 (VND송금)',
  'Executive Suite (VND Transfer)',
  12400000,
  5750000,
  NULL,
  9900000,
  7650000,
  19900000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- VND송금: 더 에센스 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 에센스 스위트 (VND송금)',
  'The Essence Suite (VND Transfer)',
  17000000,
  5750000,
  NULL,
  NULL,
  NULL,
  27200000,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- VND송금: 더 오셔니아 스위트
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오셔니아 스위트 (VND송금)',
  'The Oceania Suite (VND Transfer)',
  28300000,
  5750000,
  NULL,
  NULL,
  NULL,
  44900000,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  'VND 송금',
  true
),
-- VND송금: 더 오너스 스위트 (2인)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오너스 스위트 2인 (VND송금)',
  'The Ornus Suite 2pax (VND Transfer)',
  42300000,
  42300000,
  NULL,
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
-- VND송금: 더 오너스 스위트 (3인)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오너스 스위트 3인 (VND송금)',
  'The Ornus Suite 3pax (VND Transfer)',
  31700000,
  31700000,
  NULL,
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
-- VND송금: 더 오너스 스위트 (4인)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '더 오너스 스위트 4인 (VND송금)',
  'The Ornus Suite 4pax (VND Transfer)',
  26200000,
  26200000,
  NULL,
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
  surcharge_child,
  surcharge_type,
  valid_year,
  currency,
  is_confirmed
) VALUES
-- 2026-01-28 ~ 01-31 (설 연휴)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '2026-01-28',
  '2026-01-31',
  '설 연휴',
  1500000,
  1500000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-02-15 ~ 02-21 (발렌타인/청명)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '2026-02-15',
  '2026-02-21',
  '청명절',
  1600000,
  1600000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-04-30 ~ 05-01 (황금연휴)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '2026-04-30',
  '2026-05-01',
  '황금연휴',
  1500000,
  1500000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-08-30 ~ 09-01 (가을 연휴)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '2026-08-30',
  '2026-09-01',
  '가을 연휴',
  1250000,
  1250000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-12-24 (크리스마스 이브)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '2026-12-24',
  NULL,
  '크리스마스',
  1500000,
  1500000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-12-31 (연말)
(
  '그랜드 파이어니스 크루즈',
  '2N3D',
  '2026-12-31',
  NULL,
  '연말',
  1500000,
  1500000,
  'per_person',
  2026,
  'VND',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

-- 신용카드 결제 요금 요약
SELECT '=== 2N3D 신용카드 결제 요금 요약 ===' AS status;

SELECT 
  season_name as "결제방법",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '신용카드'
ORDER BY room_type;

-- VND 송금 결제 요금 요약
SELECT '=== 2N3D VND 송금 결제 요금 요약 ===' AS status;

SELECT 
  season_name as "결제방법",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = 'VND 송금'
ORDER BY room_type;

-- 휴일 추가요금 요약
SELECT '=== 2N3D 휴일 추가요금 ===' AS status;

SELECT
  holiday_date as "시작일",
  holiday_date_end as "종료일",
  holiday_name as "휴일명",
  surcharge_per_person as "성인추가요금",
  surcharge_child as "아동추가요금"
FROM cruise_holiday_surcharge
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '2N3D'
ORDER BY holiday_date;

-- 데이터 개수 확인 (2N3D)
SELECT '=== 2N3D 데이터 개수 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '그랜드 파이어니스 크루즈' AND schedule_type = '2N3D') as "객실가격행 (20행 예상: 10 rooms x 2 payment)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '그랜드 파이어니스 크루즈' AND schedule_type = '2N3D') as "휴일추가행 (6행 예상)";

-- 결제 방법별 객실 요금 비교 (season_name 기준)
SELECT '=== 2N3D 결제 방법별 가격 비교 (season_name 기준) ===' AS status;

SELECT 
  REPLACE(cc.room_type, ' (신용카드)', '') as "객실명",
  cc.season_name as "신용카드_결제방법",
  cc.price_adult as "신용카드_성인",
  vnd.season_name as "VND송금_결제방법",
  vnd.price_adult as "VND송금_성인",
  (cc.price_adult - vnd.price_adult) as "차이",
  ROUND(((1 - vnd.price_adult::float / cc.price_adult) * 100)::numeric, 1) as "할인율_%"
FROM (
  SELECT room_type, season_name, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '그랜드 파이어니스 크루즈' AND schedule_type = '2N3D' AND season_name = '신용카드'
) cc
FULL JOIN (
  SELECT room_type, season_name, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '그랜드 파이어니스 크루즈' AND schedule_type = '2N3D' AND season_name = 'VND 송금'
) vnd ON REPLACE(cc.room_type, ' (신용카드)', '') = REPLACE(vnd.room_type, ' (VND송금)', '')
ORDER BY cc.price_adult DESC;

-- 전체 schedule_type 처리 확인
SELECT '=== 그랜드 페어리니스 크루즈 전체 schedule_type 처리 ===' AS status;

SELECT 
  schedule_type,
  COUNT(*) as "가격행"
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
GROUP BY schedule_type;
