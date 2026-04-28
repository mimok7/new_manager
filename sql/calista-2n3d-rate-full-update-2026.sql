-- ============================================================================
-- 칼리스타 크루즈 2026년 2박3일 전체 요금 교체
-- 실행위치: Supabase Dashboard → SQL Editor
-- 작성일: 2026-04-03
-- 출처: 카페 공지 (2026.02.16)
-- ============================================================================
-- 변경 내용 요약:
--
--   [공통]
--   아동 기본:     5,550,000 → 5,400,000 (-150,000)
--   아동 엑스트라: 7,650,000 → 7,500,000 (-150,000)
--   유아(2순위~):  5,900,000 유지
--
--   [시즌1&3 정가 / 01~04월, 10~12월]
--   칼리스타 오션    성인: 9,300,000 → 8,900,000   싱글: 15,800,000 → 15,200,000
--   칼리스타 베이 S1 성인: 10,000,000 → 10,550,000  싱글: 18,600,000 → 18,000,000
--   칼리스타 베이 S3 성인: 10,950,000 → 10,550,000  싱글: 18,600,000 → 18,000,000
--   칼리스타 레거시  성인: 12,000,000 → 11,600,000  싱글: 20,400,000 → 19,750,000
--   호라이즌 스위트  성인: 18,200,000 → 17,750,000  싱글: 31,000,000 → 30,200,000
--   메저스티 스위트  성인: 20,400,000 → 20,150,000  싱글: 34,900,000 → 34,100,000
--   프레지던트      성인: 44,600,000 → 44,200,000  싱글: 75,800,000 → 75,100,000 (아동 불가)
--
--   [시즌2 프로모션 / 05~09월]
--   칼리스타 오션    성인: 7,950,000 → 7,425,000   싱글: 13,600,000 → 12,700,000
--   칼리스타 베이    성인: 8,500,000 → 7,900,000   싱글: 14,500,000 → 13,550,000
--   칼리스타 레거시  성인: 9,300,000 → 8,700,000   싱글: 15,900,000 → 14,900,000
--   호라이즌 스위트  성인: 16,600,000 → 15,600,000  싱글: 28,200,000 → 26,600,000
--   메저스티 스위트  성인: 18,800,000 → 17,850,000  싱글: 32,000,000 → 30,100,000
--   프레지던트      성인: 40,300,000 → 38,250,000  싱글: 68,600,000 → 64,800,000 (아동 불가)
--
--   [휴일 추가요금] 변동 없음
--   2026/04/30~05/01 | 2026/12/24 | 2026/12/31 → 각 1,200,000동/인
-- ============================================================================

BEGIN;

-- ① 기존 데이터 백업 (롤백 시 참고용)
CREATE TEMP TABLE _calis_2n3d_bak AS
SELECT * FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D' AND valid_year = 2026;

-- ② 2026년 2N3D 전체 삭제
DELETE FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D' AND valid_year = 2026;

DELETE FROM cruise_holiday_surcharge
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D';

-- ============================================================================
-- ③ 시즌1: 2026/01/01 - 04/30 (정가)
-- ============================================================================
INSERT INTO cruise_rate_card (
  cruise_name, schedule_type, room_type, room_type_en,
  price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single,
  extra_bed_available, valid_year, valid_from, valid_to, currency, season_name, is_active
) VALUES
-- 칼리스타 오션
(
  '칼리스타 크루즈', '2N3D', '칼리스타 오션', 'Calista Ocean',
  8900000, 5400000, 5900000, 8900000, 7500000, 15200000,
  true, 2026, '2026-01-01', '2026-04-30', 'VND', NULL, true
),
-- 칼리스타 베이
(
  '칼리스타 크루즈', '2N3D', '칼리스타 베이', 'Calista Bay',
  10550000, 5400000, 5900000, 10550000, 7500000, 18000000,
  true, 2026, '2026-01-01', '2026-04-30', 'VND', NULL, true
),
-- 칼리스타 레거시
(
  '칼리스타 크루즈', '2N3D', '칼리스타 레거시', 'Calista Legacy',
  11600000, 5400000, 5900000, 11600000, 7500000, 19750000,
  true, 2026, '2026-01-01', '2026-04-30', 'VND', NULL, true
),
-- 호라이즌 스위트 (셔틀차량 포함)
(
  '칼리스타 크루즈', '2N3D', '호라이즌 스위트', 'Horizon Suite',
  17750000, 5400000, 5900000, 17750000, 7500000, 30200000,
  true, 2026, '2026-01-01', '2026-04-30', 'VND', NULL, true
),
-- 메저스티 스위트 (셔틀차량 포함)
(
  '칼리스타 크루즈', '2N3D', '메저스티 스위트', 'Majesty Suite',
  20150000, 5400000, 5900000, 20150000, 7500000, 34100000,
  true, 2026, '2026-01-01', '2026-04-30', 'VND', NULL, true
),
-- 프레지던트 스위트 (단독차량 포함, 아동/유아 불가)
(
  '칼리스타 크루즈', '2N3D', '프레지던트 스위트', 'President Suite',
  44200000, NULL, NULL, NULL, NULL, 75100000,
  false, 2026, '2026-01-01', '2026-04-30', 'VND', NULL, true
);

-- ============================================================================
-- ④ 시즌2: 2026/05/01 - 09/30 (프로모션)
-- ============================================================================
INSERT INTO cruise_rate_card (
  cruise_name, schedule_type, room_type, room_type_en,
  price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single,
  extra_bed_available, valid_year, valid_from, valid_to, currency, season_name, is_active
) VALUES
-- 칼리스타 오션
(
  '칼리스타 크루즈', '2N3D', '칼리스타 오션', 'Calista Ocean',
  7425000, 5400000, 5900000, 7425000, 7500000, 12700000,
  true, 2026, '2026-05-01', '2026-09-30', 'VND', NULL, true
),
-- 칼리스타 베이
(
  '칼리스타 크루즈', '2N3D', '칼리스타 베이', 'Calista Bay',
  7900000, 5400000, 5900000, 7900000, 7500000, 13550000,
  true, 2026, '2026-05-01', '2026-09-30', 'VND', NULL, true
),
-- 칼리스타 레거시
(
  '칼리스타 크루즈', '2N3D', '칼리스타 레거시', 'Calista Legacy',
  8700000, 5400000, 5900000, 8700000, 7500000, 14900000,
  true, 2026, '2026-05-01', '2026-09-30', 'VND', NULL, true
),
-- 호라이즌 스위트 (셔틀차량 포함)
(
  '칼리스타 크루즈', '2N3D', '호라이즌 스위트', 'Horizon Suite',
  15600000, 5400000, 5900000, 15600000, 7500000, 26600000,
  true, 2026, '2026-05-01', '2026-09-30', 'VND', NULL, true
),
-- 메저스티 스위트 (셔틀차량 포함)
(
  '칼리스타 크루즈', '2N3D', '메저스티 스위트', 'Majesty Suite',
  17850000, 5400000, 5900000, 17850000, 7500000, 30100000,
  true, 2026, '2026-05-01', '2026-09-30', 'VND', NULL, true
),
-- 프레지던트 스위트 (단독차량 포함, 아동/유아 불가)
(
  '칼리스타 크루즈', '2N3D', '프레지던트 스위트', 'President Suite',
  38250000, NULL, NULL, NULL, NULL, 64800000,
  false, 2026, '2026-05-01', '2026-09-30', 'VND', NULL, true
);

-- ============================================================================
-- ⑤ 시즌3: 2026/10/01 - 12/31 (정가)
-- ============================================================================
INSERT INTO cruise_rate_card (
  cruise_name, schedule_type, room_type, room_type_en,
  price_adult, price_child, price_infant, price_extra_bed, price_child_extra_bed, price_single,
  extra_bed_available, valid_year, valid_from, valid_to, currency, season_name, is_active
) VALUES
-- 칼리스타 오션
(
  '칼리스타 크루즈', '2N3D', '칼리스타 오션', 'Calista Ocean',
  8900000, 5400000, 5900000, 8900000, 7500000, 15200000,
  true, 2026, '2026-10-01', '2026-12-31', 'VND', NULL, true
),
-- 칼리스타 베이
(
  '칼리스타 크루즈', '2N3D', '칼리스타 베이', 'Calista Bay',
  10550000, 5400000, 5900000, 10550000, 7500000, 18000000,
  true, 2026, '2026-10-01', '2026-12-31', 'VND', NULL, true
),
-- 칼리스타 레거시
(
  '칼리스타 크루즈', '2N3D', '칼리스타 레거시', 'Calista Legacy',
  11600000, 5400000, 5900000, 11600000, 7500000, 19750000,
  true, 2026, '2026-10-01', '2026-12-31', 'VND', NULL, true
),
-- 호라이즌 스위트 (셔틀차량 포함)
(
  '칼리스타 크루즈', '2N3D', '호라이즌 스위트', 'Horizon Suite',
  17750000, 5400000, 5900000, 17750000, 7500000, 30200000,
  true, 2026, '2026-10-01', '2026-12-31', 'VND', NULL, true
),
-- 메저스티 스위트 (셔틀차량 포함)
(
  '칼리스타 크루즈', '2N3D', '메저스티 스위트', 'Majesty Suite',
  20150000, 5400000, 5900000, 20150000, 7500000, 34100000,
  true, 2026, '2026-10-01', '2026-12-31', 'VND', NULL, true
),
-- 프레지던트 스위트 (단독차량 포함, 아동/유아 불가)
(
  '칼리스타 크루즈', '2N3D', '프레지던트 스위트', 'President Suite',
  44200000, NULL, NULL, NULL, NULL, 75100000,
  false, 2026, '2026-10-01', '2026-12-31', 'VND', NULL, true
);

-- ============================================================================
-- ⑥ 휴일 추가요금 재삽입 (기존과 동일)
-- ============================================================================
INSERT INTO cruise_holiday_surcharge (
  cruise_name, schedule_type, holiday_date, holiday_date_end,
  holiday_name, surcharge_per_person, surcharge_child, surcharge_type,
  valid_year, currency, is_confirmed
) VALUES
('칼리스타 크루즈', '2N3D', '2026-04-30', '2026-05-01', '황금연휴',      1200000, 1200000, 'per_person', 2026, 'VND', true),
('칼리스타 크루즈', '2N3D', '2026-12-24', NULL,          '크리스마스 이브', 1200000, 1200000, 'per_person', 2026, 'VND', true),
('칼리스타 크루즈', '2N3D', '2026-12-31', NULL,          '연말연시',        1200000, 1200000, 'per_person', 2026, 'VND', true);

-- ============================================================================
-- ⑦ 검증 쿼리
-- ============================================================================
SELECT '=== 칼리스타 2N3D 시즌1 정가 (01/01~04/30) ===' AS label;
SELECT room_type as 객실, price_adult as 성인, price_child as 아동,
       price_extra_bed as 엑스트라, price_child_extra_bed as 아동엑베, price_single as 싱글차지
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D' AND valid_from = '2026-01-01'
ORDER BY price_adult;

SELECT '=== 칼리스타 2N3D 시즌2 프로모션 (05/01~09/30) ===' AS label;
SELECT room_type as 객실, price_adult as 성인, price_child as 아동,
       price_extra_bed as 엑스트라, price_child_extra_bed as 아동엑베, price_single as 싱글차지
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D' AND valid_from = '2026-05-01'
ORDER BY price_adult;

SELECT '=== 칼리스타 2N3D 시즌3 정가 (10/01~12/31) ===' AS label;
SELECT room_type as 객실, price_adult as 성인, price_child as 아동,
       price_extra_bed as 엑스트라, price_child_extra_bed as 아동엑베, price_single as 싱글차지
FROM cruise_rate_card
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D' AND valid_from = '2026-10-01'
ORDER BY price_adult;

SELECT '=== 휴일 추가요금 ===' AS label;
SELECT holiday_date, holiday_date_end, holiday_name, surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = '칼리스타 크루즈' AND schedule_type = '2N3D'
ORDER BY holiday_date;

DROP TABLE _calis_2n3d_bak;
COMMIT;
