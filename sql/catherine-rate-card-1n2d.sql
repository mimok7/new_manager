-- ============================================================================
-- Catherine Cruise - Rate Card (1N2D) [FINAL]
-- 캐서린 크루즈 - 객실요금 데이터 (1박 2일)
-- ============================================================================
-- 입력 기준 데이터:
--   1N2D (1박 2일)
--   시즌: 연중 동일 (2026/01/01 - 12/31)
-- 
-- 특징:
--   - 7개 객실 타입 (한글명)
--   - 단일 시즌 (연중 동일 요금)
--   - 객실별 상이한 아동 요금 (대부분 3,300,000동, 빌라 프레지던트 3,500,000동)
--   - 2번째 유아부터: 600,000동/인
--   - 프리미어 스위트 트리플: 엑스트라베드 불가능 (NULL)
--   - 휴일 추가요금: 1,200,000동/인 (성인/아동 동일)
-- ============================================================================

-- 기존 데이터 정리 (1N2D만 삭제, 2N3D는 유지)
DELETE FROM cruise_rate_card 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '1N2D';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '1N2D';

-- ============================================================================
-- Section 1: Base Season (2026/01/01 - 12/31) - 연중
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
-- 프리미어 스위트 (1층)
(
  '캐서린 크루즈',
  '1N2D',
  '프리미어 스위트 (1층)',
  'Premier Suite (1F)',
  5300000,
  3300000,
  600000,
  4700000,
  4700000,
  8450000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 프리미어 스위트 트리플 (1층)
(
  '캐서린 크루즈',
  '1N2D',
  '프리미어 스위트 트리플 (1층)',
  'Premier Suite Triple (1F)',
  5300000,
  3300000,
  600000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 프리미어 스위트 (2층)
(
  '캐서린 크루즈',
  '1N2D',
  '프리미어 스위트 (2층)',
  'Premier Suite (2F)',
  5600000,
  3300000,
  600000,
  5000000,
  5000000,
  8900000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 프리미어 스위트 (3층)
(
  '캐서린 크루즈',
  '1N2D',
  '프리미어 스위트 (3층)',
  'Premier Suite (3F)',
  5800000,
  3300000,
  600000,
  5250000,
  5250000,
  9350000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 로얄 스위트
(
  '캐서린 크루즈',
  '1N2D',
  '로얄 스위트',
  'Royal Suite',
  7500000,
  3300000,
  600000,
  6700000,
  6700000,
  12500000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 그랜드 스위트
(
  '캐서린 크루즈',
  '1N2D',
  '그랜드 스위트',
  'Grand Suite',
  8350000,
  3300000,
  600000,
  7500000,
  7500000,
  14100000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 빌라 프레지던트
(
  '캐서린 크루즈',
  '1N2D',
  '빌라 프레지던트',
  'Villa President',
  15800000,
  3500000,
  600000,
  14200000,
  14200000,
  29150000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
);

-- ============================================================================
-- Section 2: Holiday Surcharges (휴일 추가요금)
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
  '캐서린 크루즈',
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
-- 2026-12-24 (크리스마스)
(
  '캐서린 크루즈',
  '1N2D',
  '2026-12-24',
  NULL,
  '크리스마스',
  1200000,
  1200000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-12-31 (연말)
(
  '캐서린 크루즈',
  '1N2D',
  '2026-12-31',
  NULL,
  '연말',
  1200000,
  1200000,
  'per_person',
  2026,
  'VND',
  true
);

-- ============================================================================
-- Verification Queries - 캐서린 1박2일
-- ============================================================================

SELECT '=== 캐서린 1박2일 | 연중 요금 (2026/01/01 ~ 12/31) ===' AS status;

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
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '1N2D'
ORDER BY CASE WHEN room_type = '프리미어 스위트 (1층)' THEN 1 WHEN room_type = '프리미어 스위트 트리플 (1층)' THEN 2 WHEN room_type = '프리미어 스위트 (2층)' THEN 3 WHEN room_type = '프리미어 스위트 (3층)' THEN 4 WHEN room_type = '로얄 스위트' THEN 5 WHEN room_type = '그랜드 스위트' THEN 6 ELSE 7 END;

SELECT '=== 캐서린 1박2일 | 휴일 추가요금 ===' AS status;

SELECT
  holiday_date as "날짜",
  holiday_date_end as "종료일",
  holiday_name as "휴일명",
  surcharge_per_person as "성인",
  surcharge_child as "아동"
FROM cruise_holiday_surcharge
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '1N2D'
ORDER BY holiday_date;

SELECT '=== 캐서린 1박2일 | 데이터 통계 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '1N2D') as "객실가격 총 행수 (7행)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '1N2D') as "휴일추가 총 행수 (3행)";
