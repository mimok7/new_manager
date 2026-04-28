-- ============================================================
-- 라이라 그랜져 크루즈 1박2일/2박3일 가격 완전 업데이트
-- ============================================================
-- 1박2일: 제시된 가격표 적용
-- 2박3일: 1박2일 가격의 2배 적용

-- ========== 2박3일 기존 데이터 삭제 ==========
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '라이라 그랜져 크루즈' 
  AND schedule_type = '2N3D'
  AND valid_year = 2026;

-- ========== 1박2일 시즌1 (01/01 ~ 04/30) 업데이트 ==========
UPDATE public.cruise_rate_card
SET price_adult = 6100000, price_child = 3100000, price_extra_bed = 4650000, price_single = 10500000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '오아시스 스위트 (1층)';

UPDATE public.cruise_rate_card
SET price_adult = 6600000, price_child = 3350000, price_extra_bed = 5000000, price_single = 11200000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '하모니 스위트 (2층)';

UPDATE public.cruise_rate_card
SET price_adult = 7200000, price_child = 3650000, price_extra_bed = 5450000, price_single = 12200000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '스카이 스위트 (3층)';

UPDATE public.cruise_rate_card
SET price_adult = 10000000, price_child = 5050000, price_extra_bed = 7550000, price_single = 16900000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '스카이 테라스 스위트 (3층)';

UPDATE public.cruise_rate_card
SET price_adult = 5550000, price_child = 3100000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '오아시스 패밀리 스위트 (1층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 5950000, price_child = 3350000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '하모니 패밀리 스위트 (2층/4~5인)';

UPDATE public.cruise_rate_card
SET price_adult = 6500000, price_child = 3650000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '스카이 패밀리 스위트 (3층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 7150000, price_child = 5050000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '스카이 테라스 패밀리 스위트 (3층/4명)';

UPDATE public.cruise_rate_card
SET price_adult = 7800000, price_child = 5050000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '듀플렉스 패밀리 스위트 (3-4층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 12850000, price_child = 6450000, price_single = 21800000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '라 스위트 드 LYRA (2층)';

UPDATE public.cruise_rate_card
SET price_adult = 24800000, price_child = 12500000, price_single = 42100000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-01-01' AND room_type = '오너스 스위트';

-- ========== 1박2일 시즌2 (05/01 ~ 09/30) 업데이트 ==========
UPDATE public.cruise_rate_card
SET price_adult = 5850000, price_child = 3000000, price_extra_bed = 4450000, price_single = 10100000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '오아시스 스위트 (1층)';

UPDATE public.cruise_rate_card
SET price_adult = 6300000, price_child = 3200000, price_extra_bed = 4750000, price_single = 10700000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '하모니 스위트 (2층)';

UPDATE public.cruise_rate_card
SET price_adult = 6900000, price_child = 3550000, price_extra_bed = 5200000, price_single = 11800000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '스카이 스위트 (3층)';

UPDATE public.cruise_rate_card
SET price_adult = 9550000, price_child = 4850000, price_extra_bed = 7200000, price_single = 16300000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '스카이 테라스 스위트 (3층)';

UPDATE public.cruise_rate_card
SET price_adult = 5300000, price_child = 3000000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '오아시스 패밀리 스위트 (1층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 5650000, price_child = 3200000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '하모니 패밀리 스위트 (2층/4~5인)';

UPDATE public.cruise_rate_card
SET price_adult = 6200000, price_child = 3550000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '스카이 패밀리 스위트 (3층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 6850000, price_child = 4850000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '스카이 테라스 패밀리 스위트 (3층/4명)';

UPDATE public.cruise_rate_card
SET price_adult = 7500000, price_child = 4850000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '듀플렉스 패밀리 스위트 (3-4층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 12300000, price_child = 6150000, price_single = 20800000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '라 스위트 드 LYRA (2층)';

UPDATE public.cruise_rate_card
SET price_adult = 23600000, price_child = 11850000, price_single = 40100000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-05-01' AND room_type = '오너스 스위트';

-- ========== 1박2일 시즌3 (10/01 ~ 12/31) 업데이트 ==========
UPDATE public.cruise_rate_card
SET price_adult = 6450000, price_child = 3300000, price_extra_bed = 4850000, price_single = 11000000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '오아시스 스위트 (1층)';

UPDATE public.cruise_rate_card
SET price_adult = 6900000, price_child = 3500000, price_extra_bed = 5200000, price_single = 11800000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '하모니 스위트 (2층)';

UPDATE public.cruise_rate_card
SET price_adult = 7600000, price_child = 3850000, price_extra_bed = 5750000, price_single = 13000000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '스카이 스위트 (3층)';

UPDATE public.cruise_rate_card
SET price_adult = 10500000, price_child = 5300000, price_extra_bed = 7900000, price_single = 15800000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '스카이 테라스 스위트 (3층)';

UPDATE public.cruise_rate_card
SET price_adult = 5800000, price_child = 3300000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '오아시스 패밀리 스위트 (1층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 6300000, price_child = 3500000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '하모니 패밀리 스위트 (2층/4~5인)';

UPDATE public.cruise_rate_card
SET price_adult = 6900000, price_child = 3850000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '스카이 패밀리 스위트 (3층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 7550000, price_child = 5300000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '스카이 테라스 패밀리 스위트 (3층/4명)';

UPDATE public.cruise_rate_card
SET price_adult = 8250000, price_child = 5300000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '듀플렉스 패밀리 스위트 (3-4층/4인)';

UPDATE public.cruise_rate_card
SET price_adult = 13500000, price_child = 6800000, price_single = 23000000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '라 스위트 드 LYRA (2층)';

UPDATE public.cruise_rate_card
SET price_adult = 26000000, price_child = 13100000, price_single = 44500000
WHERE cruise_name = '라이라 그랜져 크루즈' AND schedule_type = '1N2D' AND valid_year = 2026
  AND valid_from = '2026-10-01' AND room_type = '오너스 스위트';

-- ========== 2박3일 데이터 삽입 (1박2일의 2배 가격) ==========
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en,
     price_adult, price_child, price_extra_bed, price_single,
     extra_bed_available, single_available, infant_policy,
     valid_year, valid_from, valid_to, display_order, notes)
SELECT
    cruise_name, '2N3D', room_type, room_type_en,
    price_adult * 2, price_child * 2, price_extra_bed * 2, price_single * 2,
    extra_bed_available, single_available, infant_policy,
    valid_year, valid_from, valid_to, display_order, '2박3일: 1박2일 가격의 2배'
FROM public.cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026;

-- 업데이트 결과 확인
SELECT 
    schedule_type,
    valid_from,
    room_type,
    price_adult,
    price_child,
    price_extra_bed,
    price_single
FROM public.cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
ORDER BY schedule_type, valid_from, display_order;
