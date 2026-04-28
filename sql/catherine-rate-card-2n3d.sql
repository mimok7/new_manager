-- ============================================================================
-- Catherine Cruise - Rate Card (2N3D)
-- 캐서린 크루즈 - 객실요금 데이터 (2박 3일)
-- ============================================================================
-- 입력 기준 데이터:
--   2N3D (2박 3일)
--   시즌 1: 2026년 (시즌 구분 없음)
-- 
-- 특징:
--   - 7개 객실 타입
--   - 단일 시즌 (연중 동일 요금)
--   - 객실별 상이한 아동 요금
--   - 2번째 유아: 1,200,000동/인
--   - 프리미어 스위트 트리플: 엑스트라베드 불가능
--   - 휴일 추가요금: 1,500,000동/인 (성인/아동 동일)
-- ============================================================================

-- 기존 데이터 정리 (2N3D만 삭제, 1N2D는 유지)
DELETE FROM cruise_rate_card 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D';

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
  '2N3D',
  '프리미어 스위트 (1층)',
  'Premier Suite (1F)',
  10600000,
  6600000,
  1200000,
  9400000,
  16900000,
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
  '2N3D',
  '프리미어 스위트 트리플 (1층)',
  'Premier Suite Triple (1F)',
  10600000,
  6600000,
  1200000,
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
  '2N3D',
  '프리미어 스위트 (2층)',
  'Premier Suite (2F)',
  11200000,
  6600000,
  1200000,
  10000000,
  17800000,
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
  '2N3D',
  '프리미어 스위트 (3층)',
  'Premier Suite (3F)',
  11600000,
  6600000,
  1200000,
  10500000,
  18700000,
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
  '2N3D',
  '로얄 스위트',
  'Royal Suite',
  15000000,
  6600000,
  1200000,
  13400000,
  25000000,
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
  '2N3D',
  '그랜드 스위트',
  'Grand Suite',
  16700000,
  6600000,
  1200000,
  15000000,
  28200000,
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
  '2N3D',
  '빌라 프레지던트',
  'Villa President',
  31600000,
  7000000,
  1200000,
  28400000,
  58300000,
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
-- 2026-12-24 (크리스마스)
(
  '캐서린 크루즈',
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
  '캐서린 크루즈',
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

-- 2N3D 요금 요약
SELECT '=== 2N3D 요금 요약 ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "2번째유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈'
  AND schedule_type = '2N3D'
ORDER BY room_type;

-- 휴일 추가요금 요약
SELECT '=== 2N3D 휴일 추가요금 ===' AS status;

SELECT
  holiday_date as "날짜",
  holiday_date_end as "종료일",
  holiday_name as "휴일명",
  surcharge_per_person as "성인추가요금",
  surcharge_child as "아동추가요금"
FROM cruise_holiday_surcharge
WHERE cruise_name = '캐서린 크루즈'
  AND schedule_type = '2N3D'
ORDER BY holiday_date;

-- 데이터 개수 확인 (2N3D)
SELECT '=== 2N3D 데이터 개수 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D') as "객실가격행 (7행 예상)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '캐서린 크루즈' AND schedule_type = '2N3D') as "휴일추가행 (2행 예상)";

-- 1N2D와 2N3D 모두 확인
SELECT '=== 캐서린 크루즈 전체 schedule_type 처리 ===' AS status;

SELECT 
  schedule_type,
  COUNT(*) as "가격행"
FROM cruise_rate_card
WHERE cruise_name = '캐서린 크루즈'
GROUP BY schedule_type;
