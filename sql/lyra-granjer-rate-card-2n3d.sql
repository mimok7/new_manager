-- ============================================================================
-- Lyra Granjer Cruise - Rate Card (2N3D)
-- 라이라 그랜져 크루즈 - 객실요금 데이터 (2박 3일)
-- ============================================================================
-- 입력 기준 데이터:
--   2N3D (2박 3일)
--   시즌 1: 2026/01/01 ~ 04/30 (저수기)
--   시즌 2: 2026/05/01 ~ 09/30 (성수기)
--   시즌 3: 2026/10/01 ~ 12/31 (최성수기)
-- 
-- 특징:
--   - 11개 객실 타입 (일반실 4종류 + 패밀리 5종류 + 럭셔리 2종류)
--   - 단일 결제 방법 (신용카드만)
--   - 총 33개 가격 행 (11 rooms × 3 seasons)
--   - 모든 가격 = 1박 2일 가격의 2배
--   - 패밀리 스위트: 정원제 (아동 요금 없음, 엑스트라베드 불가)
--   - 라 스위트 드 LYRA, 오너스: 엑스트라베드 불가
--   - 유아 정책: price_infant = price_adult × 30%
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '2N3D';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '2N3D';

-- ============================================================================
-- Section 1: Low Season (저수기) - 2026/01/01 - 04/30
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
-- 저수기: 오아시스 스위트 (1층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오아시스 스위트 (1층)',
  'Oasis Suite (1st Floor)',
  12200000,
  6200000,
  3660000,
  9300000,
  NULL,
  21000000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 하모니 스위트 (2층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '하모니 스위트 (2층)',
  'Harmony Suite (2nd Floor)',
  13200000,
  6700000,
  3960000,
  10000000,
  NULL,
  22400000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 스카이 스위트 (3층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 스위트 (3층)',
  'Sky Suite (3rd Floor)',
  14400000,
  7300000,
  4320000,
  10900000,
  NULL,
  24400000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 스카이 테라스 스위트 (3층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 테라스 스위트 (3층)',
  'Sky Terrace Suite (3rd Floor)',
  20000000,
  10100000,
  6000000,
  15100000,
  NULL,
  33800000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 오아시스 패밀리 (1층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오아시스 패밀리 스위트 (1층/4인)',
  'Oasis Family Suite (1st FL/4pax)',
  11100000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 하모니 패밀리 (2층/4-5인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (2층/4-5인)',
  'Harmony Family Suite (2nd FL/4-5pax)',
  11900000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 스카이 패밀리 (3층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 패밀리 스위트 (3층/4인)',
  'Sky Family Suite (3rd FL/4pax)',
  13000000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 스카이 테라스 패밀리 (3층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 테라스 패밀리 스위트 (3층/4인)',
  'Sky Terrace Family Suite (3rd FL/4pax)',
  14300000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 듀플렉스 패밀리 (3-4층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '듀플렉스 패밀리 스위트 (3-4층/4인)',
  'Duplex Family Suite (3-4 FL/4pax)',
  15600000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 라 스위트 드 LYRA (2층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '라 스위트 드 LYRA (2층)',
  'La Suite de LYRA (2nd Floor)',
  25700000,
  12900000,
  7710000,
  NULL,
  NULL,
  43600000,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
),
-- 저수기: 오너스 스위트
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오너스 스위트',
  'Ornus Suite',
  49600000,
  25000000,
  14880000,
  NULL,
  NULL,
  84200000,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  '시즌1 (01/01-04/30)',
  true
);

-- ============================================================================
-- Section 2: High Season (성수기) - 2026/05/01 - 09/30
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
-- 성수기: 오아시스 스위트 (1층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오아시스 스위트 (1층)',
  'Oasis Suite (1st Floor)',
  11700000,
  6000000,
  3510000,
  8900000,
  NULL,
  20200000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 하모니 스위트 (2층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '하모니 스위트 (2층)',
  'Harmony Suite (2nd Floor)',
  12600000,
  6400000,
  3780000,
  9500000,
  NULL,
  21400000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 스카이 스위트 (3층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 스위트 (3층)',
  'Sky Suite (3rd Floor)',
  13800000,
  7100000,
  4140000,
  10400000,
  NULL,
  23600000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 스카이 테라스 스위트 (3층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 테라스 스위트 (3층)',
  'Sky Terrace Suite (3rd Floor)',
  19100000,
  9700000,
  5730000,
  14400000,
  NULL,
  32600000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 오아시스 패밀리 (1층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오아시스 패밀리 스위트 (1층/4인)',
  'Oasis Family Suite (1st FL/4pax)',
  10600000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 하모니 패밀리 (2층/4-5인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (2층/4-5인)',
  'Harmony Family Suite (2nd FL/4-5pax)',
  11300000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 스카이 패밀리 (3층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 패밀리 스위트 (3층/4인)',
  'Sky Family Suite (3rd FL/4pax)',
  12400000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 스카이 테라스 패밀리 (3층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 테라스 패밀리 스위트 (3층/4인)',
  'Sky Terrace Family Suite (3rd FL/4pax)',
  13700000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 듀플렉스 패밀리 (3-4층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '듀플렉스 패밀리 스위트 (3-4층/4인)',
  'Duplex Family Suite (3-4 FL/4pax)',
  15000000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 라 스위트 드 LYRA (2층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '라 스위트 드 LYRA (2층)',
  'La Suite de LYRA (2nd Floor)',
  24600000,
  12300000,
  7380000,
  NULL,
  NULL,
  41600000,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
),
-- 성수기: 오너스 스위트
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오너스 스위트',
  'Ornus Suite',
  47200000,
  23700000,
  14160000,
  NULL,
  NULL,
  80200000,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  '시즌2 (05/01-09/30)',
  true
);

-- ============================================================================
-- Section 3: Peak Season (최성수기) - 2026/10/01 - 12/31
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
-- 최성수기: 오아시스 스위트 (1층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오아시스 스위트 (1층)',
  'Oasis Suite (1st Floor)',
  12900000,
  6600000,
  3870000,
  9700000,
  NULL,
  22000000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 하모니 스위트 (2층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '하모니 스위트 (2층)',
  'Harmony Suite (2nd Floor)',
  13800000,
  7000000,
  4140000,
  10400000,
  NULL,
  23600000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 스카이 스위트 (3층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 스위트 (3층)',
  'Sky Suite (3rd Floor)',
  15200000,
  7700000,
  4560000,
  11500000,
  NULL,
  26000000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 스카이 테라스 스위트 (3층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 테라스 스위트 (3층)',
  'Sky Terrace Suite (3rd Floor)',
  21000000,
  10600000,
  6300000,
  15800000,
  NULL,
  31600000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 오아시스 패밀리 (1층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오아시스 패밀리 스위트 (1층/4인)',
  'Oasis Family Suite (1st FL/4pax)',
  11600000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 하모니 패밀리 (2층/4-5인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (2층/4-5인)',
  'Harmony Family Suite (2nd FL/4-5pax)',
  12600000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 스카이 패밀리 (3층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 패밀리 스위트 (3층/4인)',
  'Sky Family Suite (3rd FL/4pax)',
  13800000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 스카이 테라스 패밀리 (3층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '스카이 테라스 패밀리 스위트 (3층/4인)',
  'Sky Terrace Family Suite (3rd FL/4pax)',
  15100000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 듀플렉스 패밀리 (3-4층/4인)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '듀플렉스 패밀리 스위트 (3-4층/4인)',
  'Duplex Family Suite (3-4 FL/4pax)',
  16500000,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 라 스위트 드 LYRA (2층)
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '라 스위트 드 LYRA (2층)',
  'La Suite de LYRA (2nd Floor)',
  27000000,
  13600000,
  8100000,
  NULL,
  NULL,
  46000000,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
),
-- 최성수기: 오너스 스위트
(
  '라이라 그랜져 크루즈',
  '2N3D',
  '오너스 스위트',
  'Ornus Suite',
  52000000,
  26200000,
  15600000,
  NULL,
  NULL,
  89000000,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  '시즌3 (10/01-12/31)',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

SELECT '=== 2N3D 시즌1 (저수기: 01/01-04/30) ===' AS status;

SELECT 
  season_name as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌1 (01/01-04/30)'
ORDER BY price_adult DESC;

SELECT '=== 2N3D 시즌2 (성수기: 05/01-09/30) ===' AS status;

SELECT 
  season_name as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌2 (05/01-09/30)'
ORDER BY price_adult DESC;

SELECT '=== 2N3D 시즌3 (최성수기: 10/01-12/31) ===' AS status;

SELECT 
  season_name as "시즌",
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND season_name = '시즌3 (10/01-12/31)'
ORDER BY price_adult DESC;

-- 데이터 개수 확인
SELECT '=== 2N3D 데이터 개수 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '2N3D') as "객실가격행 (33행 예상: 11 rooms x 3 seasons)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '2N3D') as "휴일추가행";

-- 시즌별 객실 분류
SELECT '=== 2N3D 엑스트라베드 가능 객실 ===' AS status;

SELECT 
  season_name as "시즌",
  COUNT(*) as "객실수"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND extra_bed_available = true
GROUP BY season_name
ORDER BY season_name;

SELECT '=== 2N3D 정원제 객실 (엑스트라베드 불가) ===' AS status;

SELECT 
  season_name as "시즌",
  COUNT(*) as "객실수"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND extra_bed_available = false
GROUP BY season_name
ORDER BY season_name;

-- 전체 일정 확인
SELECT '=== 라이라 그랜져 크루즈 전체 일정 ===' AS status;

SELECT 
  schedule_type as "상품타입",
  COUNT(*) as "가격행"
FROM cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
GROUP BY schedule_type
ORDER BY schedule_type;
