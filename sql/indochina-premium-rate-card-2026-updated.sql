-- ============================================================================
-- Indochina Premium Cruise - Rate Card Updated (2026년 최신 기준)
-- 인도차이나 프리미엄 크루즈 - 객실요금 데이터 갱신
-- ============================================================================
-- 적용 기준:
--   시즌1: 2026/01/01 - 04/30 (1~4월) - 성수기
--   시즌2: 2026/05/01 - 09/30 (5~9월) - 비수기
--   시즌3: 2026/10/01 - 12/31 (10~12월) - 성수기+연말
--
-- 결제방식:
--   신용카드 (VISA/MASTER/JCB)
--   VND 송금 (신용카드 비교 1인당 150,000 할인)
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '인도차이나 프리미엄 크루즈';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '인도차이나 프리미엄 크루즈';

-- ============================================================================
-- Section 1: Season 1 (2026/01/01 - 04/30) 1~4월 - 신용카드
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '주니어 스위트',
  'Junior Suite',
  4650000,
  3550000,
  4250000,
  4650000,
  4250000,
  8500000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '신용카드',
  true
),
-- 스위트
(
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '스위트',
  'Suite',
  5650000,
  3550000,
  4250000,
  4650000,
  4250000,
  10600000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '신용카드',
  true
),
-- 이그제큐티브 스위트
(
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  6700000,
  3550000,
  4250000,
  4650000,
  4250000,
  12800000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '신용카드',
  true
),
-- 프레지던트 스위트
(
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  11300000,
  3550000,
  4250000,
  4650000,
  4250000,
  20900000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '신용카드',
  true
);

-- ============================================================================
-- Section 2: Season 2 (2026/05/01 - 09/30) 5~9월 - 신용카드
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '주니어 스위트',
  'Junior Suite',
  4400000,
  3550000,
  4250000,
  4650000,
  4250000,
  7900000,
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '스위트',
  'Suite',
  5450000,
  3550000,
  4250000,
  4650000,
  4250000,
  10000000,
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  6500000,
  3550000,
  4250000,
  4650000,
  4250000,
  12100000,
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  10800000,
  3550000,
  4250000,
  4650000,
  4250000,
  19900000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '신용카드',
  true
);

-- ============================================================================
-- Section 3: Season 3 (2026/10/01 - 12/31) 10~12월 - 신용카드
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '주니어 스위트',
  'Junior Suite',
  4650000,
  3550000,
  4250000,
  4650000,
  4250000,
  8500000,
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '스위트',
  'Suite',
  5650000,
  3550000,
  4250000,
  4650000,
  4250000,
  10600000,
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '이그제큐티브 스위트',
  'Executive Suite',
  6700000,
  3550000,
  4250000,
  4650000,
  4250000,
  12800000,
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
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  11300000,
  3550000,
  4250000,
  4650000,
  4250000,
  20900000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '신용카드',
  true
);

-- ============================================================================
-- Section 4: Holiday Surcharges (휴일 추가요금)
-- 성인: 1,100,000동 / 아동(2~11세): 550,000동
-- 주의: Unique constraint (cruise_name, schedule_type, holiday_date, valid_year)
--       admin/child를 한 행에 통합하여 저장 (surcharge_per_person=adult, surcharge_child=child)
-- ============================================================================

INSERT INTO cruise_holiday_surcharge (
  cruise_name,
  schedule_type,
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person,
  surcharge_type,
  surcharge_child,
  valid_year,
  currency,
  is_confirmed
) VALUES
-- 크리스마스 이브 12/24 (성인 + 아동)
(
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '2026-12-24',
  NULL,
  '크리스마스 이브',
  1100000,
  'per_person',
  550000,
  2026,
  'VND',
  true
),
-- 연말 12/31 (성인 + 아동)
(
  '인도차이나 프리미엄 크루즈',
  '1N2D',
  '2026-12-31',
  NULL,
  '연말',
  1100000,
  'per_person',
  550000,
  2026,
  'VND',
  true
);
