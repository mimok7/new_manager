-- ============================================================================
-- Dolphin Halong Cruise - One-Day Tour (하이브리드 방식)
-- 돌핀 하롱 크루즈 - 당일투어 패키지
-- ============================================================================
-- 입력 기준 데이터:
--   당일투어 (One-Day Tour)
--   요금 구분: 평일(월-목) vs 주말(금-일)
--   나이별 가격: 성인, 5-12세, 2-4세
--   추가 옵션: KIDS CLUB, 방갈로, 랍스터
--   특별 요금: 크리스마스, 새해, 발렌타인 (+350,000동 각)
-- 
-- 특징:
--   - 당일투어 (overnight 아님)
--   - 2개 요금 타입: 평일 / 주말 (season_name 활용)
--   - 3개 나이 카테고리: 성인, 5-12세, 2-4세
--   - 엑스트라베드 불가 (당일투어 특성)
--   - 선택 옵션: cruise_tour_options 테이블에서 관리
-- ============================================================================

-- ============================================================================
-- 1. cruise_tour_options 테이블 생성
-- ============================================================================
-- 기존 테이블 확인 후 필요시만 생성

CREATE TABLE IF NOT EXISTS cruise_tour_options (
  option_id BIGSERIAL PRIMARY KEY,
  cruise_name VARCHAR(255) NOT NULL,
  schedule_type VARCHAR(50) NOT NULL,
  option_name VARCHAR(100) NOT NULL,
  option_name_en VARCHAR(100),
  option_price BIGINT NOT NULL,
  option_type VARCHAR(20) DEFAULT 'addon',
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_cruise_tour_options_cruise 
  ON cruise_tour_options(cruise_name, schedule_type);
CREATE INDEX IF NOT EXISTS idx_cruise_tour_options_active 
  ON cruise_tour_options(is_active);

-- ============================================================================
-- 2. 기존 데이터 정리
-- ============================================================================
DELETE FROM cruise_rate_card 
WHERE cruise_name = '돌핀 하롱 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '돌핀 하롱 크루즈' AND schedule_type = 'DAY';

DELETE FROM cruise_tour_options 
WHERE cruise_name = '돌핀 하롱 크루즈' AND schedule_type = 'DAY';

-- ============================================================================
-- 3. 기본 요금 데이터 (cruise_rate_card)
-- 평일(月-木): 요금 낮음
-- 주말(金-日): 요금 높음
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
-- 평일 (월-목)
(
  '돌핀 하롱 크루즈',
  'DAY',
  'Dolphin Halong One-Day Tour',
  'Dolphin Halong One-Day Tour',
  600000,
  500000,
  400000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '평일 (월-목)',
  true
),
-- 주말 (금-일)
(
  '돌핀 하롱 크루즈',
  'DAY',
  'Dolphin Halong One-Day Tour',
  'Dolphin Halong One-Day Tour',
  800000,
  650000,
  500000,
  NULL,
  NULL,
  NULL,
  false,
  2026,
  '2026-01-01',
  '2026-12-31',
  'VND',
  '주말 (금-일)',
  true
);

-- ============================================================================
-- 4. 특별 요금 데이터 (cruise_holiday_surcharge)
-- 크리스마스, 새해, 발렌타인: 각 +350,000동
-- ============================================================================

INSERT INTO cruise_holiday_surcharge (
  cruise_name,
  schedule_type,
  holiday_name,
  holiday_date,
  holiday_date_end,
  surcharge_per_person,
  surcharge_child,
  valid_year,
  currency
) VALUES
-- 크리스마스 (+350,000동)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '크리스마스',
  '2026-12-24',
  '2026-12-26',
  350000,
  350000,
  2026,
  'VND'
),
-- 새해 (+350,000동)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '새해',
  '2026-12-31',
  '2027-01-02',
  350000,
  350000,
  2026,
  'VND'
),
-- 발렌타인 (+350,000동)
(
  '돌핀 하롱 크루즈',
  'DAY',
  '발렌타인',
  '2026-02-14',
  '2026-02-14',
  350000,
  350000,
  2026,
  'VND'
);

-- ============================================================================
-- 5. 선택 옵션 데이터 (cruise_tour_options)
-- KIDS CLUB, 방갈로, 랍스터
-- ============================================================================

INSERT INTO cruise_tour_options (
  cruise_name,
  schedule_type,
  option_name,
  option_name_en,
  option_price,
  option_type,
  description,
  is_active
) VALUES
-- KIDS CLUB: +100,000동
(
  '돌핀 하롱 크루즈',
  'DAY',
  'KIDS CLUB',
  'Kids Club Activity',
  100000,
  'addon',
  '어린이를 위한 특별 활동 및 관리 프로그램',
  true
),
-- 방갈로: 1,900,000동
(
  '돌핀 하롱 크루즈',
  'DAY',
  '방갈로',
  'Bungalow Stay (Overnight)',
  1900000,
  'upgrade',
  '당일 후 숙박 가능한 해상 방갈로 (별도 숙박 상품)',
  true
),
-- 랍스터: +500,000동
(
  '돌핀 하롱 크루즈',
  'DAY',
  '랍스터',
  'Lobster Dinner Add-on',
  500000,
  'addon',
  '저녁 식사 시 신선한 랍스터 요리 추가',
  true
);

-- ============================================================================
-- Verification Queries (검증용 쿼리)
-- ============================================================================

SELECT '=== Dolphin Halong One-Day Tour 기본 요금 ===' AS "검증 항목";

SELECT 
  season_name as "요금타입",
  room_type as "상품명",
  price_adult as "성인(동)",
  price_child as "5-12세(동)",
  price_infant as "2-4세(동)"
FROM cruise_rate_card
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY price_adult;

SELECT '=== 특별 요금 (holiday surcharge) ===' AS "검증 항목";

SELECT 
  holiday_name as "특별일",
  surcharge_per_person as "성인추가(동)",
  surcharge_child as "아동추가(동)",
  holiday_date as "시작일",
  holiday_date_end as "종료일"
FROM cruise_holiday_surcharge
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY holiday_date;

SELECT '=== 선택 옵션 (cruise_tour_options) ===' AS "검증 항목";

SELECT 
  option_name as "옵션명",
  option_name_en as "옵션명(영문)",
  option_price as "가격(동)",
  option_type as "옵션타입",
  description as "설명"
FROM cruise_tour_options
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_price;

SELECT '=== 가격 계산 예시 ===' AS "검증 항목";

SELECT 
  '평일 성인 (기본)' as "예시",
  600000 as "요금(동)"
UNION ALL
SELECT '평일 성인 + KIDS CLUB', 600000 + 100000
UNION ALL
SELECT '평일 성인 + 랍스터', 600000 + 500000
UNION ALL
SELECT '평일 성인 + 크리스마스 특별요금', 600000 + 350000
UNION ALL
SELECT '주말 성인 (기본)', 800000
UNION ALL
SELECT '주말 성인 + KIDS CLUB + 랍스터', 800000 + 100000 + 500000;

SELECT '=== 데이터 개수 확인 ===' AS "검증 항목";

SELECT 
  (SELECT COUNT(*) FROM cruise_rate_card 
   WHERE cruise_name = '돌핀 하롱 크루즈' 
   AND schedule_type = 'DAY') as "기본요금행 (2행: 평일/주말)",
  (SELECT COUNT(*) FROM cruise_holiday_surcharge 
   WHERE cruise_name = '돌핀 하롱 크루즈' 
   AND schedule_type = 'DAY') as "특별요금행 (3행: 크리스마스/새해/발렌타인)",
  (SELECT COUNT(*) FROM cruise_tour_options 
   WHERE cruise_name = '돌핀 하롱 크루즈' 
   AND schedule_type = 'DAY') as "선택옵션행 (3행: KIDS CLUB/방갈로/랍스터)";

SELECT '=== 완전한 요금 조회 쿼리 ===' AS "검증 항목";

SELECT 
  '기본 요금' as "카테고리",
  season_name as "상세",
  price_adult as "성인",
  price_child as "아동",
  price_infant as "유아"
FROM cruise_rate_card
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '선택 옵션',
  option_name,
  option_price,
  option_price,
  NULL
FROM cruise_tour_options
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
UNION ALL
SELECT 
  '특별 요금',
  holiday_name,
  surcharge_per_person,
  surcharge_child,
  NULL
FROM cruise_holiday_surcharge
WHERE cruise_name = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY';
