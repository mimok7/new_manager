-- ============================================================================
-- 015-victorious-triple-rooms-2026.sql
-- 빅토리어스 크루즈: 주니어 오션 스위트 / 시니어 발코니 스위트 트리플 객실 추가
-- 적용 내용: 기존 주니어/시니어 객실 행을 복제하여 트리플 객실명으로 INSERT
-- 작성자: 자동 생성
-- 날짜: 2026-05-04
-- ============================================================================

BEGIN;

-- 1) 원본(주니어 오션 스위트, 시니어 발코니 스위트)을 기준으로 트리플 객실명으로 복제
WITH source_rows AS (
  SELECT
    cruise_name,
    schedule_type,
    room_type,
    room_type_en,
    price_adult,
    price_child,
    price_infant,
    valid_year,
    valid_from,
    valid_to,
    display_order,
    currency,
    is_active,
    notes,
    includes_vehicle,
    vehicle_type,
    infant_policy,
    season_name,
    is_promotion,
    child_age_range
  FROM public.cruise_rate_card
  WHERE cruise_name = '빅토리어스 크루즈'
    AND room_type IN ('주니어 오션 스위트', '시니어 발코니 스위트')
), mapped_rows AS (
  SELECT
    cruise_name,
    schedule_type,
    CASE
      WHEN room_type = '주니어 오션 스위트' THEN '주니어 오션 스위트 트리플 객실'
      WHEN room_type = '시니어 발코니 스위트' THEN '시니어 발코니 스위트 트리플 객실'
    END AS new_room_type,
    room_type_en,
    price_adult,
    price_child,
    price_infant,
    valid_year,
    valid_from,
    valid_to,
    display_order,
    currency,
    is_active,
    notes,
    includes_vehicle,
    vehicle_type,
    infant_policy,
    season_name,
    is_promotion,
    child_age_range
  FROM source_rows
)
INSERT INTO public.cruise_rate_card (
  cruise_name,
  schedule_type,
  room_type,
  room_type_en,
  price_adult,
  price_child,
  price_child_older,
  price_child_extra_bed,
  price_infant,
  price_extra_bed,
  price_single,
  valid_year,
  valid_from,
  valid_to,
  display_order,
  currency,
  is_active,
  notes,
  extra_bed_available,
  includes_vehicle,
  vehicle_type,
  infant_policy,
  season_name,
  is_promotion,
  child_age_range,
  single_available
)
SELECT
  cruise_name,
  schedule_type,
  new_room_type,
  room_type_en,
  price_adult,
  price_child,
  NULL,
  NULL,
  COALESCE(price_infant, 0),
  NULL,
  NULL,
  valid_year,
  valid_from,
  valid_to,
  display_order,
  currency,
  is_active,
  CONCAT(COALESCE(notes, ''), CASE WHEN COALESCE(notes, '') = '' THEN '' ELSE ' - ' END, '트리플 객실 (성인/아동 요금만 적용, 엑스트라베드/싱글차지 없음)'),
  false,
  false,
  NULL,
  infant_policy,
  season_name,
  is_promotion,
  child_age_range,
  false
FROM mapped_rows m
WHERE NOT EXISTS (
  SELECT 1
  FROM public.cruise_rate_card e
  WHERE e.cruise_name = m.cruise_name
    AND e.schedule_type = m.schedule_type
    AND e.room_type = m.new_room_type
    AND e.valid_year = m.valid_year
    AND COALESCE(e.valid_from, DATE '1900-01-01') = COALESCE(m.valid_from, DATE '1900-01-01')
    AND COALESCE(e.valid_to, DATE '2999-12-31') = COALESCE(m.valid_to, DATE '2999-12-31')
);

COMMIT;

-- 2) 검증: 추가된 트리플 객실 확인
SELECT cruise_name, schedule_type, room_type, price_adult, price_child, price_infant, extra_bed_available, single_available, valid_year, valid_from, valid_to, notes
FROM public.cruise_rate_card
WHERE cruise_name = '빅토리어스 크루즈'
  AND room_type IN ('주니어 오션 스위트 트리플 객실', '시니어 발코니 스위트 트리플 객실')
ORDER BY valid_year, valid_from, room_type;

-- 끝
