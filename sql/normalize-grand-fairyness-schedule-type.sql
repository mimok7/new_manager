-- Normalize schedule_type for Grand Fairyness Cruise
-- 목적: schedule_type에 포함된 접미사 '-S1','-S2','-S3' 등을 제거하여 '1N2D' 형태로 통일
-- 사용법: 먼저 Preview 쿼리로 변경 대상 확인 → 트랜잭션으로 UPDATE 실행 → Verify로 결과 확인

-- ============================================================================
-- 1) Preview: 변경될 레코드 확인
-- ============================================================================
SELECT schedule_type, COUNT(*) AS cnt
FROM cruise_rate_card
WHERE schedule_type ~ '-S[0-9]+$'
GROUP BY schedule_type;

SELECT *
FROM cruise_rate_card
WHERE schedule_type ~ '-S[0-9]+$'
ORDER BY schedule_type, room_type
LIMIT 100;

SELECT schedule_type, COUNT(*) AS cnt
FROM cruise_holiday_surcharge
WHERE schedule_type ~ '-S[0-9]+$'
GROUP BY schedule_type;

SELECT *
FROM cruise_holiday_surcharge
WHERE schedule_type ~ '-S[0-9]+$'
ORDER BY holiday_date
LIMIT 100;

-- ============================================================================
-- 2) Safe UPDATE: 트랜잭션 블록
-- ============================================================================
-- 주의: 실행 전 Preview 결과를 반드시 확인하세요.
BEGIN;

-- cruise_rate_card의 schedule_type에서 '-S숫자' 접미사 제거
UPDATE cruise_rate_card
SET schedule_type = regexp_replace(schedule_type, '-S[0-9]+$', '')
WHERE schedule_type ~ '-S[0-9]+$';

-- cruise_holiday_surcharge도 동일한 패턴이 있으면 제거
UPDATE cruise_holiday_surcharge
SET schedule_type = regexp_replace(schedule_type, '-S[0-9]+$', '')
WHERE schedule_type ~ '-S[0-9]+$';

COMMIT;

-- ============================================================================
-- 3) Verify: 변경 후 상태 확인
-- ============================================================================
SELECT schedule_type, COUNT(*) AS cnt
FROM cruise_rate_card
GROUP BY schedule_type
ORDER BY schedule_type;

SELECT schedule_type, COUNT(*) AS cnt
FROM cruise_holiday_surcharge
GROUP BY schedule_type
ORDER BY schedule_type;

-- 추가 확인: 특정 예시를 재조회 (예: 1N2D)
SELECT *
FROM cruise_rate_card
WHERE schedule_type = '1N2D'
ORDER BY room_type;
