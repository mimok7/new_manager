-- ============================================================
-- 다이아나 크루즈 유아 요금(price_infant) 일괄 업데이트
-- ============================================================
-- 다이아나 크루즈의 모든 객실(시즌1, 시즌2, 시즌3)에 대해
-- 유아 요금을 900,000동으로 업데이트합니다.
-- (기존 infant_policy: '객실당 유아 1인 무료, 2인째부터 900,000동/인')

UPDATE public.cruise_rate_card
SET price_infant = 900000
WHERE cruise_name = '다이아나 크루즈'
  AND valid_year = 2026;

-- 업데이트 결과 확인
SELECT 
    room_type, 
    season_name, 
    valid_from, 
    valid_to, 
    price_infant, 
    infant_policy
FROM public.cruise_rate_card
WHERE cruise_name = '다이아나 크루즈'
  AND valid_year = 2026
ORDER BY display_order, valid_from;
