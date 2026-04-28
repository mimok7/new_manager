-- ============================================================
-- 크루즈 객실 요금표 추가 템플릿
-- ============================================================
-- 사용법: 아래 템플릿의 값을 변경하여 새 크루즈 요금 추가
-- 
-- 주의사항:
--   1. cruise_name은 기존 room_price_cruises.json의 이름과 일치시킬 것
--   2. schedule_type: '1N2D', '2N3D', '3N4D' 중 선택
--   3. 가격은 VND 단위 (소수점 없이)
--   4. 아동/유아 가격이 없으면 NULL
--   5. display_order로 표시 순서 제어
-- ============================================================


-- =============================================
-- [크루즈명] [년도]년 [일정] 객실요금 추가
-- =============================================

/*
-- 기존 데이터 정리 (재실행 시)
DELETE FROM public.cruise_rate_card 
WHERE cruise_name = '[크루즈명]' 
  AND schedule_type = '[일정유형]' 
  AND valid_year = [년도];

-- 객실 요금 입력
INSERT INTO public.cruise_rate_card 
    (cruise_name, schedule_type, room_type, room_type_en, 
     price_adult, price_child, price_infant, price_extra_bed, price_single,
     valid_year, display_order, notes)
VALUES
    -- 객실 1
    ('[크루즈명]', '[1N2D]', '[객실명]', '[Room Name EN]',
     [성인가격], [아동가격 or NULL], [유아가격 or NULL], [엑스트라베드 or NULL], [싱글차지 or NULL],
     [년도], 1, '[비고]'),
    
    -- 객실 2
    ('[크루즈명]', '[1N2D]', '[객실명]', '[Room Name EN]',
     [성인가격], [아동가격 or NULL], [유아가격 or NULL], [엑스트라베드 or NULL], [싱글차지 or NULL],
     [년도], 2, '[비고]');


-- 공휴일 추가요금
DELETE FROM public.cruise_holiday_surcharge 
WHERE cruise_name = '[크루즈명]' 
  AND valid_year = [년도];

INSERT INTO public.cruise_holiday_surcharge
    (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name,
     surcharge_per_person, valid_year, is_confirmed, notes)
VALUES
    ('[크루즈명]', '[1N2D]', '[YYYY-MM-DD]', NULL, '[공휴일명]',
     [추가요금], [년도], true, '[비고]');
*/


-- =============================================
-- 조회용 유틸리티 쿼리
-- =============================================

-- 전체 크루즈 요금 요약
SELECT 
    cruise_name,
    schedule_type,
    valid_year,
    COUNT(*) as room_count,
    MIN(price_adult) as min_price,
    MAX(price_adult) as max_price
FROM public.cruise_rate_card
WHERE is_active = true
GROUP BY cruise_name, schedule_type, valid_year
ORDER BY cruise_name, schedule_type;

-- 특정 크루즈 상세 요금
-- SELECT * FROM public.cruise_rate_card 
-- WHERE cruise_name = '엠바사더 시그니처' AND valid_year = 2026
-- ORDER BY display_order;

-- 특정 날짜의 추가요금 확인
-- SELECT * FROM public.cruise_holiday_surcharge
-- WHERE holiday_date <= '2026-12-24' 
--   AND (holiday_date_end >= '2026-12-24' OR holiday_date = '2026-12-24')
--   AND valid_year = 2026;
