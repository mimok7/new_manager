-- ============================================================
-- 인도차이나 관련 크루즈: 2026-01-01 행 삭제 및
-- valid_from=2026-10-01 -> 2026-01-01로 변경
-- 대상 cruise_name: '인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈'
-- 안전 절차: 먼저 SELECT로 대상 확인, 필요시 백업 후 DELETE/UPDATE 실행
-- ============================================================

-- 1) 삭제 대상 확인 (검토용)
SELECT id, cruise_name, schedule_type, valid_year, valid_from, valid_to, room_type, price_adult
FROM public.cruise_rate_card
WHERE cruise_name IN ('인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈')
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
ORDER BY cruise_name, schedule_type, valid_from, display_order;

-- 2) (선택) 삭제 대상 백업 생성 - 주석 해제하여 실행
-- CREATE TABLE IF NOT EXISTS public.cruise_rate_card_backup_indochina_20260101 AS
-- SELECT * FROM public.cruise_rate_card
-- WHERE cruise_name IN ('인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈')
--   AND valid_year = 2026
--   AND valid_from = '2026-01-01';

-- 3) 삭제 실행 (주석을 해제하여 실행)
-- BEGIN;
DELETE FROM public.cruise_rate_card
WHERE cruise_name IN ('인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈')
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
RETURNING id, cruise_name, schedule_type, room_type, valid_from, valid_to;
-- COMMIT;

-- 4) 2026-10-01인 행 확인 (업데이트 대상 확인)
SELECT id, cruise_name, schedule_type, valid_year, valid_from, valid_to, room_type, price_adult
FROM public.cruise_rate_card
WHERE cruise_name IN ('인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈')
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
ORDER BY cruise_name, schedule_type, valid_from, display_order;

-- 5) (선택) 업데이트 대상 백업 생성 - 주석 해제하여 실행
-- CREATE TABLE IF NOT EXISTS public.cruise_rate_card_backup_indochina_20261001 AS
-- SELECT * FROM public.cruise_rate_card
-- WHERE cruise_name IN ('인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈')
--   AND valid_year = 2026
--   AND valid_from = '2026-10-01';

-- 6) valid_from을 2026-01-01로 변경 (주석을 해제하여 실행)
-- BEGIN;
UPDATE public.cruise_rate_card
SET valid_from = '2026-01-01'
WHERE cruise_name IN ('인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈')
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
RETURNING id, cruise_name, schedule_type, room_type, valid_from, valid_to;
-- COMMIT;

-- 7) 변경 결과 확인
SELECT id, cruise_name, schedule_type, valid_year, valid_from, valid_to, room_type, price_adult
FROM public.cruise_rate_card
WHERE cruise_name IN ('인도차이나 그랜드 크루즈', '인도차이나 프리미엄 크루즈')
  AND valid_year = 2026
ORDER BY cruise_name, schedule_type, valid_from, display_order;
