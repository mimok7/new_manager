-- ============================================================================
-- Delete Grand Fairyness Cruise 1N2D Data
-- 그랜드 파이어니스 크루즈 - 1박2일 데이터 완전 삭제
-- ============================================================================
-- ============================================================================
-- Delete Grand Fairyness Cruise 1N2D Data
-- 그랜드 파이어니스 크루즈 - 1박2일 데이터 완전 삭제
--
-- 포함된 테이블 및 주요 컬럼 목록
-- 1) cruise_rate_card
--    - cruise_name
--    - schedule_type
--    - room_type
--    - room_type_en
--    - price_adult
--    - price_child
--    - price_infant
--    - price_extra_bed
--    - price_child_extra_bed
--    - price_single
--    - extra_bed_available
--    - valid_year
--    - valid_from
--    - valid_to
--    - currency
--    - is_active
--
-- 2) cruise_holiday_surcharge
--    - cruise_name
--    - schedule_type
--    - holiday_date
--    - holiday_date_end
--    - holiday_name
--    - surcharge_per_person
--    - surcharge_type
--    - valid_year
--    - currency
--    - is_confirmed
--
-- 사용 설명:
-- 1) 아래의 SELECT 쿼리로 삭제될 레코드를 먼저 확인하세요.
-- 2) 문제가 없으면 DELETE 문을 실행하세요.
-- 3) 트랜잭션을 사용하여 안전하게 삭제할 수 있습니다.
--

-- ============================================================================
-- Preview rows to be deleted (검토용)
-- ============================================================================

-- Preview cruise_rate_card rows (삭제 대상 미리보기)
SELECT
  cruise_name,
  schedule_type,
  room_type,
  price_adult,
  price_child,
  price_extra_bed,
  price_child_extra_bed,
  price_single,
  valid_from,
  valid_to
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type LIKE '1N2D%'
ORDER BY schedule_type, room_type;

-- Preview cruise_holiday_surcharge rows (삭제 대상 미리보기)
SELECT
  cruise_name,
  schedule_type,
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D'
ORDER BY holiday_date;

-- ============================================================================
-- Safe delete (트랜잭션 권장)
-- 실행 순서: 1) Preview 확인 → 2) 아래 BEGIN/DELETE/COMMIT 블록 실행
-- ============================================================================

BEGIN;

-- 휴일 추가요금 삭제
DELETE FROM cruise_holiday_surcharge
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D';

-- 객실 가격 삭제 (시즌1 및 시즌2 포함)
DELETE FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type LIKE '1N2D%';

COMMIT;

-- ============================================================================
-- Verification (삭제 확인)
-- ============================================================================

-- 남은 데이터 확인
SELECT 
  'cruise_rate_card' as table_name,
  COUNT(*) as remaining_rows
FROM cruise_rate_card
WHERE cruise_name = '그랜드 파이어니스 크루즈'

UNION ALL

SELECT 
  'cruise_holiday_surcharge' as table_name,
  COUNT(*) as remaining_rows
FROM cruise_holiday_surcharge
WHERE cruise_name = '그랜드 파이어니스 크루즈'
  AND schedule_type = '1N2D';
