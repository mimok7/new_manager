-- ============================================================
-- cruise_rate_card: season_name = '신용카드' 값을 NULL로 변경 (행 삭제 아님)
-- 1) 아래 SELECT로 대상 확인
-- 2) 확인 후 UPDATE 블록의 주석을 해제하거나 직접 실행하여 season_name을 NULL로 설정
-- ============================================================

-- 대상 개수 확인
SELECT COUNT(*) AS target_count
FROM public.cruise_rate_card
WHERE season_name = '신용카드';

-- 대상 상세 확인 (검토용)
SELECT
  id,
  cruise_name,
  schedule_type,
  season_name,
  valid_year,
  valid_from,
  valid_to,
  room_type,
  price_adult,
  price_child,
  price_infant,
  display_order
FROM public.cruise_rate_card
WHERE season_name = '신용카드'
ORDER BY valid_year, valid_from, display_order;

-- ===== 안전 권장: 업데이트 전에 백업 생성 (주석 해제하여 실행) =====
-- CREATE TABLE IF NOT EXISTS public.cruise_rate_card_backup_creditcard AS
-- SELECT * FROM public.cruise_rate_card WHERE season_name = '신용카드';

-- ===== season_name을 NULL로 설정 (행 삭제 아님) =====
-- 트랜잭션 사용 권장: 주석 해제하여 실행
-- BEGIN;
-- UPDATE public.cruise_rate_card
-- SET season_name = NULL
-- WHERE season_name = '신용카드'
-- RETURNING id, cruise_name, schedule_type, valid_year, valid_from, room_type, season_name;
-- COMMIT;

-- 업데이트 후 확인 (업데이트 실행 후 사용)
-- SELECT COUNT(*) AS remaining_creditcard_rows FROM public.cruise_rate_card WHERE season_name = '신용카드';

