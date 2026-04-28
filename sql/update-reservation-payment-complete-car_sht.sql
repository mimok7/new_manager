-- Mark reservation_payment.payment_status = 'completed' for payments linked to reservations
-- where reservation.re_type = 'car_sht' and reservation.re_quote_id IS NULL.
-- Also append an automated memo note and update timestamps.

BEGIN;

-- 1) 확인: 몇 건이 대상인지 확인
SELECT COUNT(*) AS will_update_count
FROM reservation_payment rp
JOIN reservation r ON rp.reservation_id = r.re_id
WHERE r.re_quote_id IS NULL
  AND r.re_type = 'car_sht'
  AND rp.payment_status IS DISTINCT FROM 'completed';

-- 2) 실제 업데이트 (위의 쿼리로 대상 수 확인 후 실행)
UPDATE reservation_payment rp
SET payment_status = 'completed',
    memo = CASE
      WHEN rp.memo IS NULL OR rp.memo = '' THEN '자동처리: car_sht 예약(quote NULL) - 상태를 completed로 변경함'
      ELSE rp.memo || E'\n자동처리: car_sht 예약(quote NULL) - 상태를 completed로 변경함'
    END,
    updated_at = now()
FROM reservation r
WHERE rp.reservation_id = r.re_id
  AND r.re_quote_id IS NULL
  AND r.re_type = 'car_sht'
  AND rp.payment_status IS DISTINCT FROM 'completed';

-- 3) 확인: 몇 건이 완료 상태가 되었는지 확인
SELECT COUNT(*) AS updated_count
FROM reservation_payment rp
JOIN reservation r ON rp.reservation_id = r.re_id
WHERE r.re_quote_id IS NULL
  AND r.re_type = 'car_sht'
  AND rp.payment_status = 'completed';

COMMIT;
