-- ============================================================
-- 라이라 그랜져 크루즈 패밀리 스위트 아동 요금 업데이트
-- ============================================================
-- 1박2일 및 2박3일의 모든 패밀리 스위트에 아동 요금 추가

-- ========== 1박2일 시즌1 (01/01 ~ 04/30) 패밀리 스위트 아동 요금 ==========
UPDATE public.cruise_rate_card
SET price_child = 3100000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '오아시스 패밀리 스위트 (1층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 3350000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '하모니 패밀리 스위트 (2층 / 4-5인)';

UPDATE public.cruise_rate_card
SET price_child = 3650000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '스카이 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 5050000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '스카이 테라스 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 5050000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '듀플렉스 패밀리 스위트 (3층-4층 / 4인)';

-- ========== 1박2일 시즌2 (05/01 ~ 09/30) 패밀리 스위트 아동 요금 ==========
UPDATE public.cruise_rate_card
SET price_child = 3000000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '오아시스 패밀리 스위트 (1층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 3200000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '하모니 패밀리 스위트 (2층 / 4-5인)';

UPDATE public.cruise_rate_card
SET price_child = 3550000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '스카이 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 4850000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '스카이 테라스 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 4850000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '듀플렉스 패밀리 스위트 (3층-4층 / 4인)';

-- ========== 1박2일 시즌3 (10/01 ~ 12/31) 패밀리 스위트 아동 요금 ==========
UPDATE public.cruise_rate_card
SET price_child = 3300000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '오아시스 패밀리 스위트 (1층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 3500000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '하모니 패밀리 스위트 (2층 / 4-5인)';

UPDATE public.cruise_rate_card
SET price_child = 3850000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '스카이 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 5300000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '스카이 테라스 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 5300000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '1N2D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '듀플렉스 패밀리 스위트 (3층-4층 / 4인)';

-- ========== 2박3일 시즌1 (01/01 ~ 04/30) 패밀리 스위트 아동 요금 (1박2일의 2배) ==========
UPDATE public.cruise_rate_card
SET price_child = 6200000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '오아시스 패밀리 스위트 (1층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 6700000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '하모니 패밀리 스위트 (2층 / 4-5인)';

UPDATE public.cruise_rate_card
SET price_child = 7300000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '스카이 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 10100000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '스카이 테라스 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 10100000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '듀플렉스 패밀리 스위트 (3층-4층 / 4인)';

-- ========== 2박3일 시즌2 (05/01 ~ 09/30) 패밀리 스위트 아동 요금 (1박2일의 2배) ==========
UPDATE public.cruise_rate_card
SET price_child = 6000000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '오아시스 패밀리 스위트 (1층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 6400000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '하모니 패밀리 스위트 (2층 / 4-5인)';

UPDATE public.cruise_rate_card
SET price_child = 7100000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '스카이 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 9700000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '스카이 테라스 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 9700000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '듀플렉스 패밀리 스위트 (3층-4층 / 4인)';

-- ========== 2박3일 시즌3 (10/01 ~ 12/31) 패밀리 스위트 아동 요금 (1박2일의 2배) ==========
UPDATE public.cruise_rate_card
SET price_child = 6600000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '오아시스 패밀리 스위트 (1층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 7000000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '하모니 패밀리 스위트 (2층 / 4-5인)';

UPDATE public.cruise_rate_card
SET price_child = 7700000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '스카이 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 10600000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '스카이 테라스 패밀리 스위트 (3층 / 4인)';

UPDATE public.cruise_rate_card
SET price_child = 10600000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND schedule_type = '2N3D'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '듀플렉스 패밀리 스위트 (3층-4층 / 4인)';

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
  AND room_type LIKE '%패밀리%'
ORDER BY schedule_type, valid_from, display_order;
