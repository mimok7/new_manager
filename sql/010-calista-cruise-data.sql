-- =====================================================
-- 010-calista-cruise-data.sql
-- Calista Cruise 상세 정보 (6개 객실 타입)
-- =====================================================
-- 실행 전 011-cruise-info-columns.sql 먼저 실행 필요

-- 기존 Calista Cruise 데이터 삭제 (재실행 가능하도록)
DELETE FROM cruise_info WHERE cruise_code LIKE 'CALIS-%' OR cruise_name = '칼리스타 크루즈';

-- ── 공통 데이터 ──
-- 크루즈명: 칼리스타 크루즈
-- 등급: 6성급 (하롱베이 TOP3)
-- 수용인원: 160명 (기본값)
-- 일정: 1박2일
-- 특징: 사계절 온수풀, 자쿠지, 엘리베이터, 2025년 스테이하롱 예약율 1위

-- =====================================================
-- 1. Calista Ocean (칼리스타 오션)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order,
  features
) VALUES (
  'CALIS-OC', '칼리스타 크루즈', 'Calista Cruise', '고급스러운 실내 인테리어와 우수한 서비스의 6성급 크루즈. 사계절 온수풀, 자쿠지, 엘리베이터 보유. 2025년 하롱베이 TOP3 크루즈로 스테이하롱 예약율 1위', '1박2일', '프리미엄',
  'Calista Ocean', '30㎡', '킹베드 고정 객실. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인 (아동 1인은 성인 엑스트라 요금). 크루즈 엔진룸 옆에 위치하여 다소 소음과 진동 가능. 3층 1개 제외하고 1층보다 다소 좁음.',
  '킹', 2, 3, true, false, false,
  false, true, true,
  '발코니, 욕조, 스탠딩샤워, 커넥팅룸', '엔진룸 인접으로 소음/진동 가능',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 및 하롱베이로 이동 (약 2시간 30분, 150km)"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "크루즈 승선 및 안전지침"},
      {"time": "13:00", "activity": "점심 뷔페 (해산물, BBQ, 초밥 등)"},
      {"time": "15:00", "activity": "진주양식마을 투어 (카약/뱀부보트 선택)"},
      {"time": "15:30", "activity": "전통 차 워크샵 및 시음"},
      {"time": "17:00", "activity": "해피아워 - 선데크 간식 및 음료"},
      {"time": "19:00", "activity": "디너 코스 식사 및 베트남 전통악기 공연"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시, 스파, 수영장)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 (선데크/수영장/발코니)"},
      {"time": "06:15", "activity": "선데크 태극권 (선택)"},
      {"time": "06:45", "activity": "아침 조식"},
      {"time": "07:20", "activity": "승솟동굴 투어 (약 120계단, 해발 25m)"},
      {"time": "09:30", "activity": "체크아웃 및 브런치 식사"},
      {"time": "10:40", "activity": "크루즈 하선"},
      {"time": "11:00", "activity": "차량 승차 (휴게소 1회 정차)"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '진주마을 투어 (카약/뱀부보트) 포함\n식사 (뷔페/코스) 포함\n해피아워 간식 포함\n전통 차 워크샵 포함\n승솟동굴 투어 포함',
  '음료/주류 별도 주문\n선내 스파/마사지 별도\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 TOP3 크루즈 (2025년 스테이하롱 예약율 1위)',
  '["온수 수영장 (사계절)", "자쿠지", "엘리베이터", "GYM", "스파", "키즈룸"]'::jsonb,
  1,
  '{"heated_pool": true, "jacuzzi": true, "elevator": true, "gym": true, "spa": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 2. Calista Bay (칼리스타 베이)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order,
  features
) VALUES (
  'CALIS-BY', '칼리스타 크루즈', 'Calista Cruise', '고급스러운 실내 인테리어와 우수한 서비스의 6성급 크루즈. 사계절 온수풀, 자쿠지, 엘리베이터 보유. 2025년 하롱베이 TOP3 크루즈로 스테이하롱 예약율 1위', '1박2일', '프리미엄',
  'Calista Bay', '32㎡', '더블 또는 트윈 베드 선택 가능. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인 (아동 1인은 성인 엑스트라 요금). Ocean 객실과 달리 욕조가 제공되며 커넥팅룸 타입 보유. 표준 타입으로 분류.',
  '더블 또는 트윈', 2, 3, true, false, false,
  false, true, true,
  '발코니, 욕조, 스탠딩샤워, 커넥팅룸', NULL,
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 및 하롱베이로 이동 (약 2시간 30분, 150km)"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "크루즈 승선 및 안전지침"},
      {"time": "13:00", "activity": "점심 뷔페 (해산물, BBQ, 초밥 등)"},
      {"time": "15:00", "activity": "진주양식마을 투어 (카약/뱀부보트 선택)"},
      {"time": "15:30", "activity": "전통 차 워크샵 및 시음"},
      {"time": "17:00", "activity": "해피아워 - 선데크 간식 및 음료"},
      {"time": "19:00", "activity": "디너 코스 식사 및 베트남 전통악기 공연"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시, 스파, 수영장)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 (선데크/수영장/발코니)"},
      {"time": "06:15", "activity": "선데크 태극권 (선택)"},
      {"time": "06:45", "activity": "아침 조식"},
      {"time": "07:20", "activity": "승솟동굴 투어 (약 120계단, 해발 25m)"},
      {"time": "09:30", "activity": "체크아웃 및 브런치 식사"},
      {"time": "10:40", "activity": "크루즈 하선"},
      {"time": "11:00", "activity": "차량 승차 (휴게소 1회 정차)"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '진주마을 투어 (카약/뱀부보트) 포함\n식사 (뷔페/코스) 포함\n해피아워 간식 포함\n전통 차 워크샵 포함\n승솟동굴 투어 포함',
  '음료/주류 별도 주문\n선내 스파/마사지 별도\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 TOP3 크루즈 (2025년 스테이하롱 예약율 1위)',
  '["온수 수영장 (사계절)", "자쿠지", "엘리베이터", "GYM", "스파", "키즈룸"]'::jsonb,
  2,
  '{"heated_pool": true, "jacuzzi": true, "elevator": true, "gym": true, "spa": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 3. Calista Legacy (칼리스타 레거시) ⭐ 추천
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order,
  features
) VALUES (
  'CALIS-LG', '칼리스타 크루즈', 'Calista Cruise', '고급스러운 실내 인테리어와 우수한 서비스의 6성급 크루즈. 사계절 온수풀, 자쿠지, 엘리베이터 보유. 2025년 하롱베이 TOP3 크루즈로 스테이하롱 예약율 1위', '1박2일', '프리미엄',
  'Calista Legacy', '33㎡', '더블 또는 트윈 베드 선택 가능. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드). 스테이하롱에서 가장 추천하는 2층, 3층, 4층의 완전한 오션뷰 객실. Bay와 다른 인테리어 및 면적. 층은 랜덤배정. (2층: 자쿠지 이용층, 4층: 선데크 아래로 소음 가능)',
  '더블 또는 트윈', 2, 3, true, false, false,
  true, true, true,
  '발코니, 욕조, 스탠딩샤워, 커넥팅룸, 완전 오션뷰', '객실 층 랜덤배정 (2층: 자쿠지 이용층, 4층: 선데크 소음)',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 및 하롱베이로 이동 (약 2시간 30분, 150km)"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "크루즈 승선 및 안전지침"},
      {"time": "13:00", "activity": "점심 뷔페 (해산물, BBQ, 초밥 등)"},
      {"time": "15:00", "activity": "진주양식마을 투어 (카약/뱀부보트 선택)"},
      {"time": "15:30", "activity": "전통 차 워크샵 및 시음"},
      {"time": "17:00", "activity": "해피아워 - 선데크 간식 및 음료"},
      {"time": "19:00", "activity": "디너 코스 식사 및 베트남 전통악기 공연"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시, 스파, 수영장)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 (선데크/수영장/발코니)"},
      {"time": "06:15", "activity": "선데크 태극권 (선택)"},
      {"time": "06:45", "activity": "아침 조식"},
      {"time": "07:20", "activity": "승솟동굴 투어 (약 120계단, 해발 25m)"},
      {"time": "09:30", "activity": "체크아웃 및 브런치 식사"},
      {"time": "10:40", "activity": "크루즈 하선"},
      {"time": "11:00", "activity": "차량 승차 (휴게소 1회 정차)"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '진주마을 투어 (카약/뱀부보트) 포함\n식사 (뷔페/코스) 포함\n해피아워 간식 포함\n전통 차 워크샵 포함\n승솟동굴 투어 포함',
  '음료/주류 별도 주문\n선내 스파/마사지 별도\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 TOP3 크루즈 (2025년 스테이하롱 예약율 1위)',
  '["온수 수영장 (사계절)", "자쿠지", "엘리베이터", "GYM", "스파", "키즈룸"]'::jsonb,
  3,
  '{"heated_pool": true, "jacuzzi": true, "elevator": true, "gym": true, "spa": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 4. Calista Horizon (칼리스타 호라이즌) - VIP
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order,
  features
) VALUES (
  'CALIS-HZ', '칼리스타 크루즈', 'Calista Cruise', '고급스러운 실내 인테리어와 우수한 서비스의 6성급 크루즈. 사계절 온수풀, 자쿠지, 엘리베이터 보유. 2025년 하롱베이 TOP3 크루즈로 스테이하롱 예약율 1위', '1박2일', '프리미엄',
  'Horizon Suite', '65㎡', 'VIP 호라이즌 스위트. 킹베드 고정. 크루즈의 후미에 단독 테라스 및 4인용 월풀 제공. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드). VIP 라운지 접근권, 전용 레스토랑 이용, 무료 셔틀 제공.',
  '킹', 2, 3, true, true, false,
  false, false, true,
  'VIP 어메니티\n프라이빗 테라스 + 4인용 월풀\n발마사지 30분 무료\n제철과일 세트\n하우스 와인 1병',
  NULL,
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 및 하롱베이로 이동 (약 2시간 30분, 150km)"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "크루즈 승선 및 안전지침"},
      {"time": "13:00", "activity": "점심 뷔페 (해산물, BBQ, 초밥 등)"},
      {"time": "15:00", "activity": "진주양식마을 투어 (카약/뱀부보트 선택)"},
      {"time": "15:30", "activity": "전통 차 워크샵 및 시음"},
      {"time": "17:00", "activity": "해피아워 - 선데크 간식 및 음료"},
      {"time": "19:00", "activity": "디너 코스 식사 및 베트남 전통악기 공연"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시, 스파, 수영장)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 (선데크/수영장/발코니)"},
      {"time": "06:15", "activity": "선데크 태극권 (선택)"},
      {"time": "06:45", "activity": "아침 조식"},
      {"time": "07:20", "activity": "승솟동굴 투어 (약 120계단, 해발 25m)"},
      {"time": "09:30", "activity": "체크아웃 및 브런치 식사"},
      {"time": "10:40", "activity": "크루즈 하선"},
      {"time": "11:00", "activity": "차량 승차 (휴게소 1회 정차)"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '진주마을 투어 (카약/뱀부보트) 포함\n식사 (뷔페/코스) 포함\n해피아워 간식 포함\n전통 차 워크샵 포함\n승솟동굴 투어 포함\nVIP 어메니티 포함',
  '음료/주류 별도 주문\n선내 스파/마사지 별도 (발마사지 제외)\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 TOP3 크루즈 (2025년 스테이하롱 예약율 1위)',
  '["온수 수영장 (사계절)", "자쿠지", "엘리베이터", "GYM", "스파", "키즈룸", "VIP 라운지", "프라이빗 월풀"]'::jsonb,
  4,
  '{"heated_pool": true, "jacuzzi": true, "elevator": true, "gym": true, "spa": true, "kids_zone": true, "vip_lounge": true, "private_pool": true}'::jsonb
);

-- =====================================================
-- 5. Calista Majesty (칼리스타 매제스티) - VIP
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order,
  features
) VALUES (
  'CALIS-MJ', '칼리스타 크루즈', 'Calista Cruise', '고급스러운 실내 인테리어와 우수한 서비스의 6성급 크루즈. 사계절 온수풀, 자쿠지, 엘리베이터 보유. 2025년 하롱베이 TOP3 크루즈로 스테이하롱 예약율 1위', '1박2일', '프리미엄',
  'Majesty Suite', '78㎡', 'VIP 매제스티 스위트. 킹베드 고정. 크루즈의 후미에 단독 테라스 및 4인용 월풀 제공. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드). 호라이즌보다 넓은 공간. VIP 라운지, 전용 레스토랑 이용, 무료 셔틀 제공.',
  '킹', 2, 3, true, true, false,
  false, false, true,
  'VIP 어메니티\n프라이빗 테라스 + 4인용 월풀\n발마사지 30분 무료\n제철과일 세트\n하우스 와인 1병',
  NULL,
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 및 하롱베이로 이동 (약 2시간 30분, 150km)"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "크루즈 승선 및 안전지침"},
      {"time": "13:00", "activity": "점심 뷔페 (해산물, BBQ, 초밥 등)"},
      {"time": "15:00", "activity": "진주양식마을 투어 (카약/뱀부보트 선택)"},
      {"time": "15:30", "activity": "전통 차 워크샵 및 시음"},
      {"time": "17:00", "activity": "해피아워 - 선데크 간식 및 음료"},
      {"time": "19:00", "activity": "디너 코스 식사 및 베트남 전통악기 공연"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시, 스파, 수영장)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 (선데크/수영장/발코니)"},
      {"time": "06:15", "activity": "선데크 태극권 (선택)"},
      {"time": "06:45", "activity": "아침 조식"},
      {"time": "07:20", "activity": "승솟동굴 투어 (약 120계단, 해발 25m)"},
      {"time": "09:30", "activity": "체크아웃 및 브런치 식사"},
      {"time": "10:40", "activity": "크루즈 하선"},
      {"time": "11:00", "activity": "차량 승차 (휴게소 1회 정차)"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '진주마을 투어 (카약/뱀부보트) 포함\n식사 (뷔페/코스) 포함\n해피아워 간식 포함\n전통 차 워크샵 포함\n승솟동굴 투어 포함\nVIP 어메니티 포함',
  '음료/주류 별도 주문\n선내 스파/마사지 별도 (발마사지 제외)\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 TOP3 크루즈 (2025년 스테이하롱 예약율 1위)',
  '["온수 수영장 (사계절)", "자쿠지", "엘리베이터", "GYM", "스파", "키즈룸", "VIP 라운지", "프라이빗 월풀"]'::jsonb,
  5,
  '{"heated_pool": true, "jacuzzi": true, "elevator": true, "gym": true, "spa": true, "kids_zone": true, "vip_lounge": true, "private_pool": true}'::jsonb
);

-- =====================================================
-- 6. President Suite (프레지던트 스위트) - VVIP
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order,
  features
) VALUES (
  'CALIS-PS', '칼리스타 크루즈', 'Calista Cruise', '고급스러운 실내 인테리어와 우수한 서비스의 6성급 크루즈. 사계절 온수풀, 자쿠지, 엘리베이터 보유. 2025년 하롱베이 TOP3 크루즈로 스테이하롱 예약율 1위', '1박2일', '프리미엄',
  'President Suite', '126㎡', '최상위 VVIP 프레지던트 스위트. 킹베드 고정. 크루즈의 후미에 단독 테라스 및 4인용 월풀 제공. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드). 칼리스타의 최고급 스위트. VIP 라운지, 전용 레스토랑, 객실 식사, 무료 셔틀 제공.',
  '킹', 2, 3, true, true, true,
  false, false, true,
  'VVIP 풀패키지\n프라이빗 테라스 + 4인용 월풀\n발마사지 30분 무료\n제철과일 세트\n하우스 와인 1병\n객실 레스토랑 식사',
  NULL,
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 및 하롱베이로 이동 (약 2시간 30분, 150km)"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "크루즈 승선 및 안전지침"},
      {"time": "13:00", "activity": "점심 뷔페 (해산물, BBQ, 초밥 등)"},
      {"time": "15:00", "activity": "진주양식마을 투어 (카약/뱀부보트 선택)"},
      {"time": "15:30", "activity": "전통 차 워크샵 및 시음"},
      {"time": "17:00", "activity": "해피아워 - 선데크 간식 및 음료"},
      {"time": "19:00", "activity": "디너 코스 식사 및 베트남 전통악기 공연"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시, 스파, 수영장)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 (선데크/수영장/발코니)"},
      {"time": "06:15", "activity": "선데크 태극권 (선택)"},
      {"time": "06:45", "activity": "아침 조식"},
      {"time": "07:20", "activity": "승솟동굴 투어 (약 120계단, 해발 25m)"},
      {"time": "09:30", "activity": "체크아웃 및 브런치 식사"},
      {"time": "10:40", "activity": "크루즈 하선"},
      {"time": "11:00", "activity": "차량 승차 (휴게소 1회 정차)"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '진주마을 투어 (카약/뱀부보트) 포함\n식사 (뷔페/코스) 포함\n해피아워 간식 포함\n전통 차 워크샵 포함\n승솟동굴 투어 포함\nVVIP 어메니티 풀패키지 포함\n전용 스태프 디너 서비스',
  '음료/주류 별도 주문\n선내 스파 별도 (발마사지 제외)\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 TOP3 크루즈 (2025년 스테이하롱 예약율 1위)',
  '["온수 수영장 (사계절)", "자쿠지", "엘리베이터", "GYM", "스파", "키즈룸", "VVIP 라운지", "프라이빗 월풀", "전용 레스토랑"]'::jsonb,
  6,
  '{"heated_pool": true, "jacuzzi": true, "elevator": true, "gym": true, "spa": true, "kids_zone": true, "vvip_lounge": true, "private_pool": true, "exclusive_restaurant": true}'::jsonb
);

-- =====================================================
-- 검증 쿼리
-- =====================================================
SELECT cruise_name, room_name, room_area, has_balcony, is_vip, has_butler, display_order
FROM cruise_info
WHERE cruise_name = '칼리스타 크루즈'
ORDER BY display_order;
