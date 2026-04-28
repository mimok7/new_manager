-- ============================================================
-- 엠바사더 크루즈 패키지 데이터 업로드
-- 대상: 엠바사더 시그니처, 엠바사더 오버나이트
-- 패키지: A / B / Full
-- ============================================================

-- 1) 기존 엠바사더 패키지 삭제 (중복 방지)
DELETE FROM public.package_items
WHERE package_id IN (
  SELECT id FROM public.package_master 
  WHERE package_code IN ('AMB-A', 'AMB-B', 'AMB-FULL')
);

DELETE FROM public.package_master
WHERE package_code IN ('AMB-A', 'AMB-B', 'AMB-FULL');

-- 2) 엠바사더 A 패키지
INSERT INTO public.package_master (package_code, name, description, base_price, is_active, price_config)
VALUES (
  'AMB-A',
  '엠바사더 A 패키지',
  '디럭스룸 또는 시그니쳐 발코니룸 1객실 + 뱀부보트 또는 카약킹 + 점심/저녁 음료 1잔 무료',
  8000000,
  true,
  '{
    "price_per_person": 4000000,
    "price_2_person": 8000000,
    "cruise_names": ["엠바사더 시그니처", "엠바사더 오버나이트"],
    "schedule_type": "1N2D",
    "rooms": ["디럭스룸", "시그니쳐 발코니룸"],
    "includes": {
      "activity": ["뱀부보트", "카약킹"],
      "meal_drinks": "점심/저녁식사 음료 1잔 무료 (캔맥주, 콜라, 사이다 등)",
      "transport": false,
      "lobster": false,
      "vip_seat": false
    },
    "valid_year": 2026
  }'::jsonb
);

-- 3) 엠바사더 B 패키지
INSERT INTO public.package_master (package_code, name, description, base_price, is_active, price_config)
VALUES (
  'AMB-B',
  '엠바사더 B 패키지',
  '디럭스룸 또는 시그니쳐 발코니룸 1객실 + 뱀부보트 또는 카약킹 + 점심/저녁 음료 1잔 무료 + 크루즈 셔틀 리무진 왕복 (2인)',
  8750000,
  true,
  '{
    "price_per_person": 4375000,
    "price_2_person": 8750000,
    "cruise_names": ["엠바사더 시그니처", "엠바사더 오버나이트"],
    "schedule_type": "1N2D",
    "rooms": ["디럭스룸", "시그니쳐 발코니룸"],
    "includes": {
      "activity": ["뱀부보트", "카약킹"],
      "meal_drinks": "점심/저녁식사 음료 1잔 무료 (캔맥주, 콜라, 사이다 등)",
      "transport": true,
      "transport_detail": "크루즈 셔틀 리무진 왕복 (2인)",
      "lobster": false,
      "vip_seat": false
    },
    "valid_year": 2026
  }'::jsonb
);

-- 4) 엠바사더 Full 패키지
INSERT INTO public.package_master (package_code, name, description, base_price, is_active, price_config)
VALUES (
  'AMB-FULL',
  '엠바사더 Full 패키지',
  '프리미엄 또는 시그니쳐 이그제큐티브 1객실 + 뱀부보트 또는 카약킹 + 점심/저녁 음료 1잔 무료 + 크루즈 셔틀 리무진 왕복 (2인) + 랍스터 반마리 + 디너 최고 위치 지정',
  9850000,
  true,
  '{
    "price_per_person": 4925000,
    "price_2_person": 9850000,
    "cruise_names": ["엠바사더 시그니처", "엠바사더 오버나이트"],
    "schedule_type": "1N2D",
    "rooms": ["프리미엄", "시그니쳐 이그제큐티브"],
    "includes": {
      "activity": ["뱀부보트", "카약킹"],
      "meal_drinks": "점심/저녁식사 음료 1잔 무료 (캔맥주, 콜라, 사이다 등)",
      "transport": true,
      "transport_detail": "크루즈 셔틀 리무진 왕복 (2인)",
      "lobster": true,
      "lobster_detail": "점심 또는 저녁식사 시 랍스터 1인당 반마리",
      "vip_seat": true,
      "vip_seat_detail": "디너식사 시 가장 좋은 위치 지정"
    },
    "valid_year": 2026
  }'::jsonb
);

-- 5) 패키지별 구성 아이템 저장 (package_items)

-- A 패키지 아이템
INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'room', 1, '디럭스룸 또는 시그니쳐 발코니룸 1객실',
  '{"room_options": ["디럭스룸", "시그니쳐 발코니룸"], "room_count": 1}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-A';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'activity', 2, '뱀부보트 또는 카약킹',
  '{"options": ["뱀부보트", "카약킹"], "choice": "택1"}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-A';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'meal', 3, '점심/저녁식사 음료 1잔 무료',
  '{"meals": ["점심", "저녁"], "free_drinks": 1, "drink_types": ["캔맥주", "콜라", "사이다"]}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-A';

-- B 패키지 아이템
INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'room', 1, '디럭스룸 또는 시그니쳐 발코니룸 1객실',
  '{"room_options": ["디럭스룸", "시그니쳐 발코니룸"], "room_count": 1}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-B';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'activity', 2, '뱀부보트 또는 카약킹',
  '{"options": ["뱀부보트", "카약킹"], "choice": "택1"}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-B';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'meal', 3, '점심/저녁식사 음료 1잔 무료',
  '{"meals": ["점심", "저녁"], "free_drinks": 1, "drink_types": ["캔맥주", "콜라", "사이다"]}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-B';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'transport', 4, '크루즈 셔틀 리무진 왕복 (2인)',
  '{"type": "셔틀 리무진", "direction": "왕복", "capacity": 2}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-B';

-- Full 패키지 아이템
INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'room', 1, '프리미엄 또는 시그니쳐 이그제큐티브 1객실',
  '{"room_options": ["프리미엄", "시그니쳐 이그제큐티브"], "room_count": 1}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-FULL';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'activity', 2, '뱀부보트 또는 카약킹',
  '{"options": ["뱀부보트", "카약킹"], "choice": "택1"}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-FULL';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'meal', 3, '점심/저녁식사 음료 1잔 무료 + 랍스터 반마리',
  '{"meals": ["점심", "저녁"], "free_drinks": 1, "drink_types": ["캔맥주", "콜라", "사이다"], "lobster": true, "lobster_detail": "1인당 반마리"}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-FULL';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'transport', 4, '크루즈 셔틀 리무진 왕복 (2인)',
  '{"type": "셔틀 리무진", "direction": "왕복", "capacity": 2}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-FULL';

INSERT INTO public.package_items (package_id, service_type, item_order, description, default_data)
SELECT id, 'special', 5, '디너식사 시 가장 좋은 위치 지정',
  '{"vip_seat": true}'::jsonb
FROM public.package_master WHERE package_code = 'AMB-FULL';

-- 6) 저장 결과 확인
SELECT pm.package_code, pm.name, pm.base_price, pm.is_active,
       pm.price_config->>'price_per_person' AS price_per_person,
       pm.price_config->>'price_2_person' AS price_2_person,
       pm.price_config->'cruise_names' AS cruise_names
FROM public.package_master pm
WHERE pm.package_code IN ('AMB-A', 'AMB-B', 'AMB-FULL')
ORDER BY pm.base_price;

SELECT pi.service_type, pi.item_order, pi.description, pm.package_code
FROM public.package_items pi
JOIN public.package_master pm ON pi.package_id = pm.id
WHERE pm.package_code IN ('AMB-A', 'AMB-B', 'AMB-FULL')
ORDER BY pm.base_price, pi.item_order;
