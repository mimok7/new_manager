-- ============================================================
-- cruise_rate_card: season_name = 'VND 송금' 행 확인 및 삭제 스크립트
-- 1) 먼저 아래 SELECT로 삭제 대상 확인
-- 2) 확인 후 DELETE 블록의 주석을 해제하거나 실행하여 삭제
-- ============================================================

-- 삭제 대상 개수 확인
SELECT COUNT(*) AS delete_count
FROM public.cruise_rate_card
WHERE season_name = 'VND 송금';

-- 삭제 대상 상세 확인 (검토용)
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
WHERE season_name = 'VND 송금'
ORDER BY valid_year, valid_from, display_order;

-- ===== 안전 권장: 삭제 전에 백업 생성 =====
-- (원하면 주석 해제하여 별도 테이블에 백업)
-- CREATE TABLE IF NOT EXISTS public.cruise_rate_card_backup AS
-- SELECT * FROM public.cruise_rate_card WHERE season_name = 'VND 송금';

-- ===== 삭제: 아래 블록의 주석을 해제하면 실제 삭제가 수행됩니다 =====
-- BEGIN;
-- DELETE FROM public.cruise_rate_card
-- WHERE season_name = 'VND 송금'
-- RETURNING *;
-- COMMIT;

-- 삭제 후 확인용 (삭제 실행 후 사용)
-- SELECT COUNT(*) AS remaining_vnd_rows FROM public.cruise_rate_card WHERE season_name = 'VND 송금';
