-- ============================================================================
-- Hermes Cruise - Rate Card
-- 헤르메스 크루즈 - 객실요금 데이터
-- ============================================================================
-- 입력 기준 데이터:
--   연중 동일 요금 (2026/01/01 - 12/31)
-- 
-- 특징:
--   - 8개 객실 타입 (발코니/트리플/패밀리, 주니어/시니어/로얄/프레지던트)
--   - 연중 단일 요금제 (시즌2 삭제, 시즌1로 통일)
--   - 휴일 추가요금 (성인/아동 구분 저장)
--   - 발코니만 엑스트라베드 및 싱글차지 지원
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '헤르메스 크루즈';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '헤르메스 크루즈';

-- ============================================================================
-- Section 1: Annual Rate (2026/01/01 - 12/31) - 연중 동일
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
-- 주니어 스위트 발코니
(
  '헤르메스 크루즈',
  '1N2D',
  '주니어 스위트 발코니',
  'Junior Suite Balcony',
  4150000,
  3100000,
  2075000,
  4150000,
  2075000,
  6700000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 주니어 스위트 트리플
(
  '헤르메스 크루즈',
  '1N2D',
  '주니어 스위트 트리플',
  'Junior Suite Triple',
  4150000,
  3100000,
  2075000,
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
-- 주니어 스위트 패밀리 커넥팅
(
  '헤르메스 크루즈',
  '1N2D',
  '주니어 스위트 패밀리 커넥팅',
  'Junior Suite Family Connecting',
  4150000,
  3100000,
  2075000,
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
-- 시니어 스위트 발코니
(
  '헤르메스 크루즈',
  '1N2D',
  '시니어 스위트 발코니',
  'Senior Suite Balcony',
  4500000,
  3350000,
  2250000,
  4500000,
  2250000,
  7300000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 시니어 스위트 트리플
(
  '헤르메스 크루즈',
  '1N2D',
  '시니어 스위트 트리플',
  'Senior Suite Triple',
  4500000,
  3350000,
  2250000,
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
-- 시니어 스위트 패밀리 커넥팅
(
  '헤르메스 크루즈',
  '1N2D',
  '시니어 스위트 패밀리 커넥팅',
  'Senior Suite Family Connecting',
  4500000,
  3350000,
  2250000,
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
-- 로얄 스위트 위드 테라스
(
  '헤르메스 크루즈',
  '1N2D',
  '로얄 스위트 위드 테라스',
  'Royal Suite with Terrace',
  6000000,
  4450000,
  3000000,
  6000000,
  3000000,
  9500000,
  true,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  NULL,
  true
),
-- 프레지던트 스위트
(
  '헤르메스 크루즈',
  '1N2D',
  '프레지던트 스위트',
  'President Suite',
  7100000,
  4800000,
  3550000,
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
-- 2026-09-01
(
  '헤르메스 크루즈',
  '1N2D',
  '2026-09-01',
  NULL,
  '연휴',
  850000,
  500000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-12-24
(
  '헤르메스 크루즈',
  '1N2D',
  '2026-12-24',
  NULL,
  '크리스마스 이브',
  1300000,
  1000000,
  'per_person',
  2026,
  'VND',
  true
),
-- 2026-12-31
(
  '헤르메스 크루즈',
  '1N2D',
  '2026-12-31',
  NULL,
  '연말연시',
  1300000,
  1000000,
  'per_person',
  2026,
  'VND',
  true
);

-- ============================================================================
-- Section 3: Verification Queries (검증용 쿼리)
-- ============================================================================

-- 연중 요금 요약
SELECT '=== 헤르메스 크루즈 | 연중 요금 (2026/01/01-12/31) ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "2번째유아",
  price_extra_bed as "엑스트라베드",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '헤르메스 크루즈'
ORDER BY room_type;

-- 휴일 추가요금 요약
SELECT '=== 휴일 추가요금 ===' AS status;

SELECT
  holiday_date as "날짜",
  holiday_name as "휴일명",
  surcharge_per_person as "성인추가요금",
  surcharge_child as "아동추가요금"
FROM cruise_holiday_surcharge
WHERE cruise_name = '헤르메스 크루즈'
ORDER BY holiday_date;

-- 데이터 개수 확인
SELECT '=== 데이터 개수 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '헤르메스 크루즈') as "객실가격행 (16행 예상)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '헤르메스 크루즈') as "휴일추가행 (3행 예상)";

-- 데이터 개수 통계
SELECT '=== 헤르메스 크루즈 | 데이터 통계 ===' AS status;

SELECT 
  COUNT(*) as "객실가격행 (8행 예상)"
FROM cruise_rate_card
WHERE cruise_name = '헤르메스 크루즈';

-- 발코니/트리플 엑스트라베드 정책 확인
SELECT '=== 엑스트라베드 정책 확인 ===' AS status;

SELECT 
  CASE WHEN extra_bed_available THEN '발코니 (추가가능)' 
       ELSE '트리플/패밀리 (불가)' END as 객실타입,
  COUNT(*) as "객실행수"
FROM cruise_rate_card
WHERE cruise_name = '헤르메스 크루즈'
GROUP BY extra_bed_available
ORDER BY extra_bed_available DESC;

-- 발코니 엑스트라베드 정책 확인
SELECT '=== 헤르메스 크루즈 | 발코니 엑스트라베드 정책 ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_extra_bed as "엑스트라베드",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '헤르메스 크루즈'
  AND extra_bed_available = true
ORDER BY room_type;
