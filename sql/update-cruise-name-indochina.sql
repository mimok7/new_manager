-- ============================================================
-- cruise_rate_card: cruise_name '인도차이나 크루즈' -> '인도차이나 그랜드 크루즈' 변경
-- 안전 절차: 먼저 대상 확인 후 업데이트 실행 권장
-- ============================================================

-- 1) 변경 대상 확인
SELECT COUNT(*) AS target_count
FROM public.cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈';

SELECT id, cruise_name, schedule_type, valid_year, valid_from, room_type
FROM public.cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈'
ORDER BY valid_year, valid_from, display_order;

-- 2) (선택) 백업 생성 - 주석 해제하여 실행
-- CREATE TABLE IF NOT EXISTS public.cruise_rate_card_backup_indochina AS
-- SELECT * FROM public.cruise_rate_card WHERE cruise_name = '인도차이나 크루즈';

-- 3) 실제 업데이트 (트랜잭션 권장)
-- BEGIN;
UPDATE public.cruise_rate_card
SET cruise_name = '인도차이나 그랜드 크루즈'
WHERE cruise_name = '인도차이나 크루즈'
RETURNING id, cruise_name, schedule_type, valid_year, valid_from, room_type;
-- COMMIT;

-- 4) 업데이트 확인
SELECT COUNT(*) AS remaining_old_name
FROM public.cruise_rate_card
WHERE cruise_name = '인도차이나 크루즈';

SELECT id, cruise_name, schedule_type, valid_year, valid_from, room_type
FROM public.cruise_rate_card
WHERE cruise_name = '인도차이나 그랜드 크루즈'
ORDER BY valid_year, valid_from, display_order;
