-- Update reservations where re_quote_id IS NULL and re_type = 'car_sht'
-- Set re_status = 'confirmed'
-- 안전을 위해 트랜잭션과 영향을 받는 행을 확인할 수 있는 SELECT 포함

BEGIN;

-- 1) 변경 대상 확인
SELECT COUNT(*) AS will_update_count
FROM reservation
WHERE re_quote_id IS NULL
  AND re_type = 'car_sht'
  AND re_status IS DISTINCT FROM 'confirmed';

-- 2) 실제 업데이트 (위의 쿼리로 확인한 뒤 실행하세요)
UPDATE reservation
SET re_status = 'confirmed', re_update_at = now()
WHERE re_quote_id IS NULL
  AND re_type = 'car_sht'
  AND re_status IS DISTINCT FROM 'confirmed';

-- 3) 변경 후 확인
SELECT COUNT(*) AS updated_count
FROM reservation
WHERE re_quote_id IS NULL
  AND re_type = 'car_sht'
  AND re_status = 'confirmed';

COMMIT;
