-- ============================================================
-- 라이라 그랜져 크루즈 패밀리 스위트 아동 요금 업데이트
-- ============================================================
-- 패밀리 스위트 객실들에 누락되었던 아동 요금을 일괄 추가합니다.

-- 시즌1: 01/01 ~ 04/30
UPDATE public.cruise_rate_card
SET price_child = 3100000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '오아시스 패밀리 스위트 (1층/4인)';

UPDATE public.cruise_rate_card
SET price_child = 3350000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '하모니 패밀리 스위트 (2층/4~5인)';

UPDATE public.cruise_rate_card
SET price_child = 3650000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND room_type = '스카이 패밀리 스위트 (3층/4인)';

UPDATE public.cruise_rate_card
SET price_child = 5050000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-01-01'
  AND (room_type = '스카이 테라스 패밀리 스위트 (3층/4명)' 
       OR room_type = '듀플렉스 패밀리 스위트 (3-4층/4인)');

-- 시즌2: 05/01 ~ 09/30
UPDATE public.cruise_rate_card
SET price_child = 3000000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '오아시스 패밀리 스위트 (1층/4인)';

UPDATE public.cruise_rate_card
SET price_child = 3200000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '하모니 패밀리 스위트 (2층/4~5인)';

UPDATE public.cruise_rate_card
SET price_child = 3550000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND room_type = '스카이 패밀리 스위트 (3층/4인)';

UPDATE public.cruise_rate_card
SET price_child = 4850000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-05-01'
  AND (room_type = '스카이 테라스 패밀리 스위트 (3층/4명)' 
       OR room_type = '듀플렉스 패밀리 스위트 (3-4층/4인)');

-- 시즌3: 10/01 ~ 12/31
UPDATE public.cruise_rate_card
SET price_child = 3300000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '오아시스 패밀리 스위트 (1층/4인)';

UPDATE public.cruise_rate_card
SET price_child = 3500000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '하모니 패밀리 스위트 (2층/4~5인)';

UPDATE public.cruise_rate_card
SET price_child = 3850000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND room_type = '스카이 패밀리 스위트 (3층/4인)';

UPDATE public.cruise_rate_card
SET price_child = 5300000
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND valid_from = '2026-10-01'
  AND (room_type = '스카이 테라스 패밀리 스위트 (3층/4명)' 
       OR room_type = '듀플렉스 패밀리 스위트 (3-4층/4인)');

-- 업데이트 결과 확인
SELECT 
    valid_from,
    room_type,
    price_adult,
    price_child,
    notes
FROM public.cruise_rate_card
WHERE cruise_name = '라이라 그랜져 크루즈'
  AND valid_year = 2026
  AND room_type LIKE '%패밀리%'
ORDER BY valid_from, display_order;
