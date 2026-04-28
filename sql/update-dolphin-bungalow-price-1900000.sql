-- ============================================================
-- 돌핀 하롱 크루즈 방갈로 가격 변경: 1,800,000동 → 1,900,000동
-- 실행일: 2026-03-28
-- 대상 테이블: cruise_tour_options
-- ============================================================

UPDATE cruise_tour_options
SET
  option_price = 1900000,
  updated_at   = NOW()
WHERE cruise_name   = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
  AND option_name   LIKE '%방갈로%';

-- 결과 확인
SELECT
  cruise_name    AS "크루즈",
  schedule_type  AS "일정",
  option_name    AS "옵션명",
  option_price   AS "가격(동)"
FROM cruise_tour_options
WHERE cruise_name   = '돌핀 하롱 크루즈'
  AND schedule_type = 'DAY'
ORDER BY option_name;
