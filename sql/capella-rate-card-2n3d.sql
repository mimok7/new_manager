-- ============================================================================
-- Capella Cruise - Rate Card (2N3D)
-- 카펠라 크루즈 - 객실요금 데이터 (2박 3일)
-- ============================================================================
-- 입력 기준 데이터:
--   2N3D (2박 3일)
--   시즌 1: 2026/01/01 ~ 04/30 (저수기)
--   시즌 2: 2026/05/01 ~ 09/30 (성수기)
--   시즌 3: 2026/10/01 ~ 12/31 (최성수기)
-- 
-- 특징:
--   - 10개 객실 타입 (일반실 4종류 + 패밀리 3종류 + 럭셔리 3종류)
--   - 단일 결제 방법 (신용카드만)
--   - 총 30개 가격 행 (10 rooms × 3 seasons)
--   - 3계절 요금 차등제: 저수기 < 성수기 < 최성수기
--   - 패밀리 스위트: 정원제 (아동 요금 없음)
--   - 라 스위트 드 카펠라, 오너스: 엑스트라베드 불가
--   - 유아 정책: 1인 무료 / 2인부터 성인 30% 요금
-- ============================================================================

-- 기존 데이터 정리
DELETE FROM cruise_rate_card 
WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D';

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
  is_active
) VALUES
-- 저수기: 오아시스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '오아시스 스위트',
  'Oasis Suite',
  10800000,
  5500000,
  NULL,
  8200000,
  5500000,
  15900000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  true
),
-- 저수기: 하모니 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 스위트',
  'Harmony Suite',
  11600000,
  6000000,
  NULL,
  8700000,
  6000000,
  17100000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  true
),
-- 저수기: 스카이 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 스위트',
  'Sky Suite',
  12600000,
  6500000,
  NULL,
  9500000,
  6500000,
  18700000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  true
),
-- 저수기: 스카이 테라스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 테라스 스위트',
  'Sky Terrace Suite',
  15400000,
  7900000,
  NULL,
  11500000,
  7900000,
  22700000,
  true,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  true
),
-- 저수기: 하모니 패밀리 스위트 (4인)
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (4인)',
  'Harmony Family Suite (4pax)',
  10200000,
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
  true
),
-- 저수기: 하모니 패밀리 스위트 (5인)
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (5인)',
  'Harmony Family Suite (5pax)',
  9600000,
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
  true
),
-- 저수기: 스카이 패밀리 스위트 (4인)
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 패밀리 스위트 (4인)',
  'Sky Family Suite (4pax)',
  10800000,
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
  true
),
-- 저수기: 라 스위트 드 카펠라
(
  '카펠라 크루즈',
  '2N3D',
  '라 스위트 드 카펠라',
  'La Suite de Capella',
  22300000,
  11400000,
  NULL,
  NULL,
  NULL,
  33100000,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
  true
),
-- 저수기: 오너스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '오너스 스위트',
  'Ornus Suite',
  33300000,
  16800000,
  NULL,
  NULL,
  NULL,
  49400000,
  false,
  2026,
  '2026-01-01',
  '2026-04-30',
  'VND',
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
  is_active
) VALUES
-- 성수기: 오아시스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '오아시스 스위트',
  'Oasis Suite',
  10300000,
  5200000,
  NULL,
  7600000,
  5200000,
  15500000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  true
),
-- 성수기: 하모니 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 스위트',
  'Harmony Suite',
  11000000,
  5600000,
  NULL,
  8200000,
  5600000,
  16600000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  true
),
-- 성수기: 스카이 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 스위트',
  'Sky Suite',
  12000000,
  6100000,
  NULL,
  8900000,
  6100000,
  18200000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  true
),
-- 성수기: 스카이 테라스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 테라스 스위트',
  'Sky Terrace Suite',
  14600000,
  7300000,
  NULL,
  10800000,
  7300000,
  22000000,
  true,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  true
),
-- 성수기: 하모니 패밀리 스위트 (4인)
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (4인)',
  'Harmony Family Suite (4pax)',
  9700000,
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
  true
),
-- 성수기: 하모니 패밀리 스위트 (5인)
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (5인)',
  'Harmony Family Suite (5pax)',
  9300000,
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
  true
),
-- 성수기: 스카이 패밀리 스위트 (4인)
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 패밀리 스위트 (4인)',
  'Sky Family Suite (4pax)',
  10400000,
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
  true
),
-- 성수기: 라 스위트 드 카펠라
(
  '카펠라 크루즈',
  '2N3D',
  '라 스위트 드 카펠라',
  'La Suite de Capella',
  21600000,
  10800000,
  NULL,
  NULL,
  NULL,
  31600000,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
  true
),
-- 성수기: 오너스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '오너스 스위트',
  'Ornus Suite',
  30400000,
  15200000,
  NULL,
  NULL,
  NULL,
  45100000,
  false,
  2026,
  '2026-05-01',
  '2026-09-30',
  'VND',
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
  is_active
) VALUES
-- 최성수기: 오아시스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '오아시스 스위트',
  'Oasis Suite',
  11300000,
  5700000,
  NULL,
  8300000,
  5700000,
  17000000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  true
),
-- 최성수기: 하모니 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 스위트',
  'Harmony Suite',
  12200000,
  6100000,
  NULL,
  9000000,
  6100000,
  18400000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  true
),
-- 최성수기: 스카이 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 스위트',
  'Sky Suite',
  13200000,
  6700000,
  NULL,
  9800000,
  6700000,
  20000000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  true
),
-- 최성수기: 스카이 테라스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 테라스 스위트',
  'Sky Terrace Suite',
  16000000,
  8100000,
  NULL,
  11900000,
  8100000,
  24400000,
  true,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  true
),
-- 최성수기: 하모니 패밀리 스위트 (4인)
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (4인)',
  'Harmony Family Suite (4pax)',
  10600000,
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
  true
),
-- 최성수기: 하모니 패밀리 스위트 (5인)
(
  '카펠라 크루즈',
  '2N3D',
  '하모니 패밀리 스위트 (5인)',
  'Harmony Family Suite (5pax)',
  10100000,
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
  true
),
-- 최성수기: 스카이 패밀리 스위트 (4인)
(
  '카펠라 크루즈',
  '2N3D',
  '스카이 패밀리 스위트 (4인)',
  'Sky Family Suite (4pax)',
  11400000,
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
  true
),
-- 최성수기: 라 스위트 드 카펠라
(
  '카펠라 크루즈',
  '2N3D',
  '라 스위트 드 카펠라',
  'La Suite de Capella',
  23300000,
  11700000,
  NULL,
  NULL,
  NULL,
  35600000,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  true
),
-- 최성수기: 오너스 스위트
(
  '카펠라 크루즈',
  '2N3D',
  '오너스 스위트',
  'Ornus Suite',
  34800000,
  17600000,
  NULL,
  NULL,
  NULL,
  52400000,
  false,
  2026,
  '2026-10-01',
  '2026-12-31',
  'VND',
  true
);

-- ============================================================================
-- Section 4: Holiday Surcharges (휴일 추가요금)
-- 참고: TET, 크리스마스 등 특수일은 별도 공지 필요
-- ============================================================================

-- (추가 요금 정보 필요 시 여기에 INSERT 추가)

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

-- 시즌별 객실 요금 요약
SELECT '=== 2N3D 시즌1 (저수기: 01/01-04/30) ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND valid_from = '2026-01-01'
ORDER BY price_adult DESC;

SELECT '=== 2N3D 시즌2 (성수기: 05/01-09/30) ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND valid_from = '2026-05-01'
ORDER BY price_adult DESC;

SELECT '=== 2N3D 시즌3 (최성수기: 10/01-12/31) ===' AS status;

SELECT 
  room_type as "객실명",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아",
  price_extra_bed as "엑스트라베드",
  price_single as "싱글차지",
  CASE WHEN extra_bed_available THEN 'O' ELSE 'X' END as "추가가능"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
  AND schedule_type = '2N3D'
  AND valid_from = '2026-10-01'
ORDER BY price_adult DESC;

-- 데이터 개수 확인
SELECT '=== 2N3D 데이터 개수 ===' AS status;

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D') as "객실가격행 (30행 예상: 10 rooms x 3 seasons)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D') as "휴일추가행 (미정)";

-- 시즌별 가격 비교
SELECT '=== 2N3D 시즌별 가격 비교 ===' AS status;

SELECT 
  s1.room_type as "객실명",
  s1.price_adult as "시즌1_저수기",
  s2.price_adult as "시즌2_성수기",
  s3.price_adult as "시즌3_최성수기",
  (s2.price_adult - s1.price_adult) as "상승폭_1→2",
  (s3.price_adult - s2.price_adult) as "상승폭_2→3",
  (s3.price_adult - s1.price_adult) as "총상승폭"
FROM (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D' AND valid_from = '2026-01-01'
) s1
FULL JOIN (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D' AND valid_from = '2026-05-01'
) s2 ON s1.room_type = s2.room_type
FULL JOIN (
  SELECT room_type, price_adult FROM cruise_rate_card 
  WHERE cruise_name = '카펠라 크루즈' AND schedule_type = '2N3D' AND valid_from = '2026-10-01'
) s3 ON s1.room_type = s3.room_type
ORDER BY s3.price_adult DESC;

-- 전체 schedule_type 확인
SELECT '=== 카펠라 크루즈 전체 schedule_type 처리 ===' AS status;

SELECT 
  schedule_type,
  COUNT(*) as "가격행"
FROM cruise_rate_card
WHERE cruise_name = '카펠라 크루즈'
GROUP BY schedule_type;
