-- =====================================================
-- 024-athena-premium-cruise-info-2026.sql
-- 아테나 프리미엄 크루즈 상세 정보 (7개 객실 타입)
-- =====================================================
-- 의존성: 011-cruise-info-columns.sql 실행 완료 필요
-- 크루즈명: 아테나 프리미엄
-- 영문명: Athena Premium Cruise (ATHENA PREMIUM HaLong Bay Cruise)
-- 등급: 6성급
-- 일정: 1박 2일
-- 승선정원: 130명 | 보유객실: 41개 | 선체길이: 109.9m
-- 출항연도: 2026년 | 건조국가: 베트남
-- 운항시작: 2026-06-01
-- 선사: 아테나 그룹 (그랜드 파이어니스 동일 선사)
-- 참고: cruise_rate_card 데이터는 014-athena-premium-cruise-2026-data.sql 참조
-- =====================================================

-- 기존 아테나 프리미엄 cruise_info 삭제 (재실행 가능)
DELETE FROM cruise_info
WHERE cruise_code LIKE 'ATHE-%'
   OR cruise_name = '아테나 프리미엄';

-- =====================================================
-- 공통 상수 (모든 객실 공용)
-- cruise_name     : '아테나 프리미엄'
-- description     : 아래 공통 설명
-- itinerary       : 1박2일 투어일정표
-- cancellation_policy : 표준 취소 규정
-- star_rating     : '6성급'
-- capacity        : '130명'
-- =====================================================

-- =====================================================
-- 1. 아테나 오션뷰 (ATHENA OCEAN VIEW)
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
  'ATHE-OV', '아테나 프리미엄', 'Athena Premium Cruise',
  '아테나 그룹의 최고급형 6성급 크루즈. 엘리베이터, 온천(온탕), 수영장 등 20종 이상의 부대시설 보유. 그랜드 파이어니스와 동일한 선체 규모(109.9m)의 2026년 최고 기대작',
  '1박2일', '프리미엄',

  'Athena Ocean View', '30㎡',
  '트윈베드(싱글 2개) 고정. 싱글차지: 1인 혼자 사용 시. 기본인원: 성인 2인 (성인1명+아동1명인 경우 2인 성인요금 적용). 최대인원: 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인+아동 2인 (아동 1인은 성인 엑스트라 요금). 아테나 프리미엄의 발코니 없는 기본 객실타입. 1층에 2개 객실 보유. 엔진룸 인접으로 소음 가능.',

  '트윈 (싱글 2개)', 2, 3,
  false,  -- has_balcony: 발코니 없음
  false,  -- is_vip
  false,  -- has_butler
  false,  -- is_recommended
  false,  -- connecting_available
  true,   -- extra_bed_available
  '욕조, 스탠딩샤워',
  '엔진룸 인접으로 소음 가능. 발코니 없음. 1층 2개만 운영.',

  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "픽업차량 승차 (전날 밤 안내드린 승차시간에 호텔에서 승차)"},
      {"time": "10:40", "activity": "하롱 국제 크루즈 선착장 도착/하차. 직원 명단 확인 후 체크인. 대기실 약 1시간~1시간 30분 대기"},
      {"time": "12:15", "activity": "크루즈 본선 승선 (웰컴 드링크 후 투어 진행)"},
      {"time": "12:45", "activity": "점심 뷔페식사 (3층 레스토랑, 음료/주류 별도주문)"},
      {"time": "14:45", "activity": "외부투어: 승솟동굴 (운동화 착용 권장, 도보 약 40분 코스, 크루즈 직원 영어 동행. 원하지 않으면 수영장 이용)"},
      {"time": "15:45", "activity": "외부투어: 티톱섬 (전망대 450계단 가파름. 해변 이용 시 소액 현금 준비 권장. 원하지 않으면 크루즈 수영장 이용 추천)"},
      {"time": "18:00", "activity": "해피아워 (선데크, 핑거푸드·간식 무료 제공. 쿠킹클래스 참여 가능)"},
      {"time": "19:00", "activity": "디너 코스식사 (3층 지정좌석. 베지테리언/키즈 메뉴 별도 요청 가능. 생일·기념일 이벤트 5일 전 사전신청 100만동)"},
      {"time": "20:30", "activity": "자유시간 / 오징어낚시 체험 (1층 크루즈 뒷편)"},
      {"time": "22:00", "activity": "1일차 공식일정 종료 (선데크, 수영장에서 풍경 감상 또는 휴식)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "06:30", "activity": "태극권 체험 (선데크)"},
      {"time": "07:00", "activity": "아침 조식 (3층, 뷔페식, 쌀국수 메뉴 제공. 바나나 지참 시 루온동굴 투어에 유용)"},
      {"time": "08:00", "activity": "외부투어: 루온동굴 (카약 2인 직접 노 젓기 무료, 뱀부보트 무료. 야생원숭이 관람 가능. 해수면에 따라 투어 불가 경우도 있음)"},
      {"time": "09:00", "activity": "객실 체크아웃 (짐 문 앞, 1층 리셉션에 카드 반납, 별도주문 음료/술 결제)"},
      {"time": "09:30", "activity": "브런치 뷔페식사 (3층, 하선 전 마지막 뷔페)"},
      {"time": "10:30", "activity": "선착장 대기실 도착 (통상 11시~11시 30분경 차량 승차)"},
      {"time": "14:00", "activity": "하노이 도착 및 모든 일정 종료 (약 2시간 30분~3시간 소요, 도로상황에 따라 차이)"}
    ]}
  ]'::jsonb,

  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정에 의한 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,

  '승솟동굴 투어 포함\n티톱섬 투어 포함\n루온동굴 투어 (카약/뱀부보트 무료) 포함\n식사 포함 (점심뷔페, 디너코스, 조식뷔페, 브런치뷔페)\n해피아워 핑거푸드 포함\n쿠킹클래스 참여 가능',
  '이동차량 별도 추가옵션\n음료/주류 별도 주문 (하선 시 합산 결제)\n선내 마사지 별도\n생일·기념일 이벤트 별도 신청 (100만동)\n팁 (권장)',

  '6성급', '130명',
  '2026년 최고 기대작 | 그랜드 파이어니스와 동일 선체 규모 109.9m | 5성급 운영 선사의 6성급 론칭',
  '["수영장", "엘리베이터", "GYM", "미니골프", "도서관", "포커룸", "메디컬센터", "공용샤워실", "요가룸", "라운지", "시네마", "포켓볼", "사우나", "스크린골프", "BAR", "온천(탕)", "노래방", "마사지", "프라이빗 레스토랑", "레스토랑"]'::jsonb,
  1,
  '{"pool": true, "elevator": true, "gym": true, "mini_golf": true, "library": true, "poker_room": true, "medical": true, "public_shower": true, "yoga": true, "lounge": true, "cinema": true, "billiards": true, "sauna": true, "screen_golf": true, "bar": true, "hot_spring": true, "karaoke": true, "massage": true, "private_restaurant": true, "restaurant": true}'::jsonb
);

-- =====================================================
-- 2. 이그제큐티브 발코니 (EXECUTIVE BALCONY)
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
  'ATHE-EB', '아테나 프리미엄', 'Athena Premium Cruise',
  '아테나 그룹의 최고급형 6성급 크루즈. 엘리베이터, 온천(온탕), 수영장 등 20종 이상의 부대시설 보유. 그랜드 파이어니스와 동일한 선체 규모(109.9m)의 2026년 최고 기대작',
  '1박2일', '프리미엄',

  'Executive Balcony', '42㎡',
  '킹베드 또는 트윈베드(싱글 2개) 선택 가능. 싱글차지: 1인 혼자 사용 시. 기본인원: 성인 2인 (성인1명+아동1명인 경우 2인 성인요금 적용). 최대인원: 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인+아동 2인 (아동 1인은 성인 엑스트라 요금). 아테나 프리미엄의 기본 발코니 객실타입. 1층에 12개 객실 보유.',

  '킹베드 또는 트윈 (싱글 2개)', 2, 3,
  true,   -- has_balcony
  false,  -- is_vip
  false,  -- has_butler
  false,  -- is_recommended
  true,   -- connecting_available
  true,   -- extra_bed_available
  '발코니, 욕조, 스탠딩샤워, 커넥팅룸',
  NULL,

  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "픽업차량 승차 (전날 밤 안내드린 승차시간에 호텔에서 승차)"},
      {"time": "10:40", "activity": "하롱 국제 크루즈 선착장 도착/하차. 직원 명단 확인 후 체크인. 대기실 약 1시간~1시간 30분 대기"},
      {"time": "12:15", "activity": "크루즈 본선 승선 (웰컴 드링크 후 투어 진행)"},
      {"time": "12:45", "activity": "점심 뷔페식사 (3층 레스토랑, 음료/주류 별도주문)"},
      {"time": "14:45", "activity": "외부투어: 승솟동굴 (운동화 착용 권장, 도보 약 40분 코스, 크루즈 직원 영어 동행. 원하지 않으면 수영장 이용)"},
      {"time": "15:45", "activity": "외부투어: 티톱섬 (전망대 450계단 가파름. 해변 이용 시 소액 현금 준비 권장. 원하지 않으면 크루즈 수영장 이용 추천)"},
      {"time": "18:00", "activity": "해피아워 (선데크, 핑거푸드·간식 무료 제공. 쿠킹클래스 참여 가능)"},
      {"time": "19:00", "activity": "디너 코스식사 (3층 지정좌석. 베지테리언/키즈 메뉴 별도 요청 가능. 생일·기념일 이벤트 5일 전 사전신청 100만동)"},
      {"time": "20:30", "activity": "자유시간 / 오징어낚시 체험 (1층 크루즈 뒷편)"},
      {"time": "22:00", "activity": "1일차 공식일정 종료"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "06:30", "activity": "태극권 체험 (선데크)"},
      {"time": "07:00", "activity": "아침 조식 (3층, 뷔페식, 쌀국수 메뉴 제공)"},
      {"time": "08:00", "activity": "외부투어: 루온동굴 (카약 2인 무료, 뱀부보트 무료. 야생원숭이 관람 가능)"},
      {"time": "09:00", "activity": "객실 체크아웃 (짐 문 앞, 1층 리셉션에 카드 반납, 별도주문 음료/술 결제)"},
      {"time": "09:30", "activity": "브런치 뷔페식사 (3층, 하선 전 마지막 뷔페)"},
      {"time": "10:30", "activity": "선착장 대기실 도착 (통상 11시~11시 30분경 차량 승차)"},
      {"time": "14:00", "activity": "하노이 도착 및 모든 일정 종료 (약 2시간 30분~3시간 소요)"}
    ]}
  ]'::jsonb,

  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정에 의한 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,

  '승솟동굴 투어 포함\n티톱섬 투어 포함\n루온동굴 투어 (카약/뱀부보트 무료) 포함\n식사 포함 (점심뷔페, 디너코스, 조식뷔페, 브런치뷔페)\n해피아워 핑거푸드 포함',
  '이동차량 별도 추가옵션\n음료/주류 별도 주문\n선내 마사지 별도\n생일·기념일 이벤트 별도 신청 (100만동)',

  '6성급', '130명',
  '2026년 최고 기대작 | 그랜드 파이어니스와 동일 선체 규모 109.9m',
  '["수영장", "엘리베이터", "GYM", "미니골프", "도서관", "포커룸", "메디컬센터", "공용샤워실", "요가룸", "라운지", "시네마", "포켓볼", "사우나", "스크린골프", "BAR", "온천(탕)", "노래방", "마사지", "프라이빗 레스토랑", "레스토랑"]'::jsonb,
  2,
  '{"pool": true, "elevator": true, "gym": true, "mini_golf": true, "library": true, "poker_room": true, "medical": true, "public_shower": true, "yoga": true, "lounge": true, "cinema": true, "billiards": true, "sauna": true, "screen_golf": true, "bar": true, "hot_spring": true, "karaoke": true, "massage": true, "private_restaurant": true, "restaurant": true}'::jsonb
);

-- =====================================================
-- 3. 트리플 발코니 (TRIPLE BALCONY) — 엑스트라/싱글차지 불가
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
  'ATHE-TB', '아테나 프리미엄', 'Athena Premium Cruise',
  '아테나 그룹의 최고급형 6성급 크루즈. 엘리베이터, 온천(온탕), 수영장 등 20종 이상의 부대시설 보유. 그랜드 파이어니스와 동일한 선체 규모(109.9m)의 2026년 최고 기대작',
  '1박2일', '프리미엄',

  'Triple Balcony', '42㎡',
  '싱글베드 3개 구성 (더블+싱글 아님). 싱글차지: 1인 싱글차지 불가. 기본인원: 성인 3인 투숙 (성인2명+아동1명인 경우 3인 성인요금 적용). 최대인원: 성인 3인 (엑스트라 베드 불가) 또는 성인 3인+아동 1인 (엑스트라 베드 불가). 1층에 2개 객실 보유. 엑스트라 베드 추가가 불가한 객실 타입.',

  '싱글베드 3개', 3, 3,
  true,   -- has_balcony
  false,  -- is_vip
  false,  -- has_butler
  false,  -- is_recommended
  true,   -- connecting_available
  false,  -- extra_bed_available: 엑스트라 불가
  '발코니, 욕조, 스탠딩샤워, 커넥팅룸',
  '싱글차지 불가. 엑스트라 베드 추가 불가. 1층 2개만 운영.',

  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "픽업차량 승차 (전날 밤 안내드린 승차시간에 호텔에서 승차)"},
      {"time": "10:40", "activity": "하롱 국제 크루즈 선착장 도착/하차. 직원 명단 확인 후 체크인. 대기실 약 1시간~1시간 30분 대기"},
      {"time": "12:15", "activity": "크루즈 본선 승선 (웰컴 드링크 후 투어 진행)"},
      {"time": "12:45", "activity": "점심 뷔페식사 (3층 레스토랑, 음료/주류 별도주문)"},
      {"time": "14:45", "activity": "외부투어: 승솟동굴 (운동화 착용 권장, 도보 약 40분 코스, 크루즈 직원 영어 동행)"},
      {"time": "15:45", "activity": "외부투어: 티톱섬 (전망대 450계단 가파름. 원하지 않으면 크루즈 수영장 이용 추천)"},
      {"time": "18:00", "activity": "해피아워 (선데크, 핑거푸드·간식 무료 제공. 쿠킹클래스 참여 가능)"},
      {"time": "19:00", "activity": "디너 코스식사 (3층 지정좌석. 베지테리언/키즈 메뉴 별도 요청 가능)"},
      {"time": "20:30", "activity": "자유시간 / 오징어낚시 체험 (1층 크루즈 뒷편)"},
      {"time": "22:00", "activity": "1일차 공식일정 종료"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "06:30", "activity": "태극권 체험 (선데크)"},
      {"time": "07:00", "activity": "아침 조식 (3층, 뷔페식, 쌀국수 메뉴 제공)"},
      {"time": "08:00", "activity": "외부투어: 루온동굴 (카약 2인 무료, 뱀부보트 무료. 야생원숭이 관람 가능)"},
      {"time": "09:00", "activity": "객실 체크아웃 (짐 문 앞, 1층 리셉션에 카드 반납, 별도주문 음료/술 결제)"},
      {"time": "09:30", "activity": "브런치 뷔페식사 (3층, 하선 전 마지막 뷔페)"},
      {"time": "10:30", "activity": "선착장 대기실 도착 (통상 11시~11시 30분경 차량 승차)"},
      {"time": "14:00", "activity": "하노이 도착 및 모든 일정 종료"}
    ]}
  ]'::jsonb,

  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정에 의한 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,

  '승솟동굴 투어 포함\n티톱섬 투어 포함\n루온동굴 투어 (카약/뱀부보트 무료) 포함\n식사 포함 (점심뷔페, 디너코스, 조식뷔페, 브런치뷔페)\n해피아워 핑거푸드 포함',
  '이동차량 별도 추가옵션\n음료/주류 별도 주문\n선내 마사지 별도\n생일·기념일 이벤트 별도 신청 (100만동)',

  '6성급', '130명',
  '2026년 최고 기대작 | 그랜드 파이어니스와 동일 선체 규모 109.9m',
  '["수영장", "엘리베이터", "GYM", "미니골프", "도서관", "포커룸", "메디컬센터", "공용샤워실", "요가룸", "라운지", "시네마", "포켓볼", "사우나", "스크린골프", "BAR", "온천(탕)", "노래방", "마사지", "프라이빗 레스토랑", "레스토랑"]'::jsonb,
  3,
  '{"pool": true, "elevator": true, "gym": true, "mini_golf": true, "library": true, "poker_room": true, "medical": true, "public_shower": true, "yoga": true, "lounge": true, "cinema": true, "billiards": true, "sauna": true, "screen_golf": true, "bar": true, "hot_spring": true, "karaoke": true, "massage": true, "private_restaurant": true, "restaurant": true}'::jsonb
);

-- =====================================================
-- 4. 커넥팅 발코니 (CONNECTING BALCONY) — 싱글차지 불가
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
  'ATHE-CB', '아테나 프리미엄', 'Athena Premium Cruise',
  '아테나 그룹의 최고급형 6성급 크루즈. 엘리베이터, 온천(온탕), 수영장 등 20종 이상의 부대시설 보유. 그랜드 파이어니스와 동일한 선체 규모(109.9m)의 2026년 최고 기대작',
  '1박2일', '프리미엄',

  'Connecting Balcony', '70㎡',
  '두 개의 객실이 중앙문으로 분리·연결되는 커넥팅 타입. 침대: 더블베드 2개 또는 트윈베드 2세트 또는 싱글베드 4개 선택. 두 객실 합산 면적 70㎡. 싱글차지: 싱글차지 불가. 기본인원: 성인 2인 (성인1명+아동1명인 경우 2인 성인요금 적용). 최대인원: 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인+아동 2인 (아동 1인은 성인 엑스트라 요금). 1층에 2개의 커넥팅룸만 제공.',

  '더블베드 2개 / 트윈 2세트 / 싱글 4개 선택', 2, 3,
  true,   -- has_balcony
  false,  -- is_vip
  false,  -- has_butler
  false,  -- is_recommended
  true,   -- connecting_available
  true,   -- extra_bed_available
  '발코니, 욕조, 스탠딩샤워, 커넥팅룸 (두 객실 중앙문 연결)',
  '싱글차지 불가. 두 객실 합산 70㎡. 1층 2개 커넥팅룸만 운영.',

  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "픽업차량 승차 (전날 밤 안내드린 승차시간에 호텔에서 승차)"},
      {"time": "10:40", "activity": "하롱 국제 크루즈 선착장 도착/하차. 직원 명단 확인 후 체크인. 대기실 약 1시간~1시간 30분 대기"},
      {"time": "12:15", "activity": "크루즈 본선 승선 (웰컴 드링크 후 투어 진행)"},
      {"time": "12:45", "activity": "점심 뷔페식사 (3층 레스토랑, 음료/주류 별도주문)"},
      {"time": "14:45", "activity": "외부투어: 승솟동굴 (운동화 착용 권장, 도보 약 40분 코스, 크루즈 직원 영어 동행)"},
      {"time": "15:45", "activity": "외부투어: 티톱섬 (전망대 450계단 가파름. 원하지 않으면 크루즈 수영장 이용 추천)"},
      {"time": "18:00", "activity": "해피아워 (선데크, 핑거푸드·간식 무료 제공. 쿠킹클래스 참여 가능)"},
      {"time": "19:00", "activity": "디너 코스식사 (3층 지정좌석. 베지테리언/키즈 메뉴 별도 요청 가능)"},
      {"time": "20:30", "activity": "자유시간 / 오징어낚시 체험 (1층 크루즈 뒷편)"},
      {"time": "22:00", "activity": "1일차 공식일정 종료"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "06:30", "activity": "태극권 체험 (선데크)"},
      {"time": "07:00", "activity": "아침 조식 (3층, 뷔페식, 쌀국수 메뉴 제공)"},
      {"time": "08:00", "activity": "외부투어: 루온동굴 (카약 2인 무료, 뱀부보트 무료. 야생원숭이 관람 가능)"},
      {"time": "09:00", "activity": "객실 체크아웃 (짐 문 앞, 1층 리셉션에 카드 반납, 별도주문 음료/술 결제)"},
      {"time": "09:30", "activity": "브런치 뷔페식사 (3층, 하선 전 마지막 뷔페)"},
      {"time": "10:30", "activity": "선착장 대기실 도착 (통상 11시~11시 30분경 차량 승차)"},
      {"time": "14:00", "activity": "하노이 도착 및 모든 일정 종료"}
    ]}
  ]'::jsonb,

  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정에 의한 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,

  '승솟동굴 투어 포함\n티톱섬 투어 포함\n루온동굴 투어 (카약/뱀부보트 무료) 포함\n식사 포함 (점심뷔페, 디너코스, 조식뷔페, 브런치뷔페)\n해피아워 핑거푸드 포함',
  '이동차량 별도 추가옵션\n음료/주류 별도 주문\n선내 마사지 별도\n생일·기념일 이벤트 별도 신청 (100만동)',

  '6성급', '130명',
  '2026년 최고 기대작 | 그랜드 파이어니스와 동일 선체 규모 109.9m',
  '["수영장", "엘리베이터", "GYM", "미니골프", "도서관", "포커룸", "메디컬센터", "공용샤워실", "요가룸", "라운지", "시네마", "포켓볼", "사우나", "스크린골프", "BAR", "온천(탕)", "노래방", "마사지", "프라이빗 레스토랑", "레스토랑"]'::jsonb,
  4,
  '{"pool": true, "elevator": true, "gym": true, "mini_golf": true, "library": true, "poker_room": true, "medical": true, "public_shower": true, "yoga": true, "lounge": true, "cinema": true, "billiards": true, "sauna": true, "screen_golf": true, "bar": true, "hot_spring": true, "karaoke": true, "massage": true, "private_restaurant": true, "restaurant": true}'::jsonb
);

-- =====================================================
-- 5. 프리미엄 발코니 (PREMIUM BALCONY) ⭐ 추천
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
  'ATHE-PB', '아테나 프리미엄', 'Athena Premium Cruise',
  '아테나 그룹의 최고급형 6성급 크루즈. 엘리베이터, 온천(온탕), 수영장 등 20종 이상의 부대시설 보유. 그랜드 파이어니스와 동일한 선체 규모(109.9m)의 2026년 최고 기대작',
  '1박2일', '프리미엄',

  'Premium Balcony', '45㎡',
  '킹베드 또는 트윈(싱글 2개) 선택 가능. 싱글차지: 1인 혼자 사용 시. 기본인원: 성인 2인 (성인1명+아동1명인 경우 2인 성인요금 적용). 최대인원: 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인+아동 2인 (아동 1인은 성인 엑스트라 요금). 2층에 18개 객실 보유. 스테이하롱 추천 객실 타입.',

  '킹베드 또는 트윈 (싱글 2개)', 2, 3,
  true,   -- has_balcony
  false,  -- is_vip
  false,  -- has_butler
  true,   -- is_recommended ⭐
  true,   -- connecting_available
  true,   -- extra_bed_available
  '발코니, 욕조, 스탠딩샤워, 커넥팅룸',
  NULL,

  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "픽업차량 승차 (전날 밤 안내드린 승차시간에 호텔에서 승차)"},
      {"time": "10:40", "activity": "하롱 국제 크루즈 선착장 도착/하차. 직원 명단 확인 후 체크인. 대기실 약 1시간~1시간 30분 대기"},
      {"time": "12:15", "activity": "크루즈 본선 승선 (웰컴 드링크 후 투어 진행)"},
      {"time": "12:45", "activity": "점심 뷔페식사 (3층 레스토랑, 음료/주류 별도주문)"},
      {"time": "14:45", "activity": "외부투어: 승솟동굴 (운동화 착용 권장, 도보 약 40분 코스, 크루즈 직원 영어 동행)"},
      {"time": "15:45", "activity": "외부투어: 티톱섬 (전망대 450계단 가파름. 원하지 않으면 크루즈 수영장 이용 추천)"},
      {"time": "18:00", "activity": "해피아워 (선데크, 핑거푸드·간식 무료 제공. 쿠킹클래스 참여 가능)"},
      {"time": "19:00", "activity": "디너 코스식사 (3층 지정좌석. 베지테리언/키즈 메뉴 별도 요청 가능)"},
      {"time": "20:30", "activity": "자유시간 / 오징어낚시 체험 (1층 크루즈 뒷편)"},
      {"time": "22:00", "activity": "1일차 공식일정 종료"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "06:30", "activity": "태극권 체험 (선데크)"},
      {"time": "07:00", "activity": "아침 조식 (3층, 뷔페식, 쌀국수 메뉴 제공)"},
      {"time": "08:00", "activity": "외부투어: 루온동굴 (카약 2인 무료, 뱀부보트 무료. 야생원숭이 관람 가능)"},
      {"time": "09:00", "activity": "객실 체크아웃 (짐 문 앞, 1층 리셉션에 카드 반납, 별도주문 음료/술 결제)"},
      {"time": "09:30", "activity": "브런치 뷔페식사 (3층, 하선 전 마지막 뷔페)"},
      {"time": "10:30", "activity": "선착장 대기실 도착 (통상 11시~11시 30분경 차량 승차)"},
      {"time": "14:00", "activity": "하노이 도착 및 모든 일정 종료"}
    ]}
  ]'::jsonb,

  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정에 의한 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,

  '승솟동굴 투어 포함\n티톱섬 투어 포함\n루온동굴 투어 (카약/뱀부보트 무료) 포함\n식사 포함 (점심뷔페, 디너코스, 조식뷔페, 브런치뷔페)\n해피아워 핑거푸드 포함',
  '이동차량 별도 추가옵션\n음료/주류 별도 주문\n선내 마사지 별도\n생일·기념일 이벤트 별도 신청 (100만동)',

  '6성급', '130명',
  '2026년 최고 기대작 | 그랜드 파이어니스와 동일 선체 규모 109.9m',
  '["수영장", "엘리베이터", "GYM", "미니골프", "도서관", "포커룸", "메디컬센터", "공용샤워실", "요가룸", "라운지", "시네마", "포켓볼", "사우나", "스크린골프", "BAR", "온천(탕)", "노래방", "마사지", "프라이빗 레스토랑", "레스토랑"]'::jsonb,
  5,
  '{"pool": true, "elevator": true, "gym": true, "mini_golf": true, "library": true, "poker_room": true, "medical": true, "public_shower": true, "yoga": true, "lounge": true, "cinema": true, "billiards": true, "sauna": true, "screen_golf": true, "bar": true, "hot_spring": true, "karaoke": true, "massage": true, "private_restaurant": true, "restaurant": true}'::jsonb
);

-- =====================================================
-- 6. 캡틴뷰 스위트 (CAPTAIN'S VIEW SUITE) — VIP
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
  'ATHE-CV', '아테나 프리미엄', 'Athena Premium Cruise',
  '아테나 그룹의 최고급형 6성급 크루즈. 엘리베이터, 온천(온탕), 수영장 등 20종 이상의 부대시설 보유. 그랜드 파이어니스와 동일한 선체 규모(109.9m)의 2026년 최고 기대작',
  '1박2일', '프리미엄',

  'Captain''s View Suite', '55㎡',
  '킹베드 고정 타입. VIP 객실. 미네랄 온천수가 공급되는 자쿠지 보유. 이탈리아 최고급 GESSI 제품들로 갖춰진 욕실. 싱글차지: 1인 혼자 사용 시. 기본인원: 성인 2인 (성인1명+아동1명인 경우 2인 성인요금 적용). 최대인원: 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인+아동 2인 (아동 1인은 성인 엑스트라 요금).',

  '킹베드 (고정)', 2, 3,
  true,   -- has_balcony
  true,   -- is_vip
  false,  -- has_butler
  false,  -- is_recommended
  true,   -- connecting_available
  true,   -- extra_bed_available
  '발코니, 미네랄 온천수 자쿠지, 욕조, 스탠딩샤워, 커넥팅룸, GESSI 욕실 제품',
  NULL,

  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "픽업차량 승차 (전날 밤 안내드린 승차시간에 호텔에서 승차)"},
      {"time": "10:40", "activity": "하롱 국제 크루즈 선착장 도착/하차. 직원 명단 확인 후 체크인. 대기실 약 1시간~1시간 30분 대기"},
      {"time": "12:15", "activity": "크루즈 본선 승선 (웰컴 드링크 후 투어 진행)"},
      {"time": "12:45", "activity": "점심 뷔페식사 (3층 레스토랑, 음료/주류 별도주문)"},
      {"time": "14:45", "activity": "외부투어: 승솟동굴 (운동화 착용 권장, 도보 약 40분 코스, 크루즈 직원 영어 동행)"},
      {"time": "15:45", "activity": "외부투어: 티톱섬 (전망대 450계단 가파름. 원하지 않으면 크루즈 수영장 이용 추천)"},
      {"time": "18:00", "activity": "해피아워 (선데크, 핑거푸드·간식 무료 제공. 쿠킹클래스 참여 가능)"},
      {"time": "19:00", "activity": "디너 코스식사 (3층 지정좌석. 베지테리언/키즈 메뉴 별도 요청 가능)"},
      {"time": "20:30", "activity": "자유시간 / 오징어낚시 체험 (1층 크루즈 뒷편)"},
      {"time": "22:00", "activity": "1일차 공식일정 종료"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "06:30", "activity": "태극권 체험 (선데크)"},
      {"time": "07:00", "activity": "아침 조식 (3층, 뷔페식, 쌀국수 메뉴 제공)"},
      {"time": "08:00", "activity": "외부투어: 루온동굴 (카약 2인 무료, 뱀부보트 무료. 야생원숭이 관람 가능)"},
      {"time": "09:00", "activity": "객실 체크아웃 (짐 문 앞, 1층 리셉션에 카드 반납, 별도주문 음료/술 결제)"},
      {"time": "09:30", "activity": "브런치 뷔페식사 (3층, 하선 전 마지막 뷔페)"},
      {"time": "10:30", "activity": "선착장 대기실 도착 (통상 11시~11시 30분경 차량 승차)"},
      {"time": "14:00", "activity": "하노이 도착 및 모든 일정 종료"}
    ]}
  ]'::jsonb,

  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정에 의한 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,

  '승솟동굴 투어 포함\n티톱섬 투어 포함\n루온동굴 투어 (카약/뱀부보트 무료) 포함\n식사 포함 (점심뷔페, 디너코스, 조식뷔페, 브런치뷔페)\n해피아워 핑거푸드 포함',
  '이동차량 별도 추가옵션\n음료/주류 별도 주문\n선내 마사지 별도\n생일·기념일 이벤트 별도 신청 (100만동)',

  '6성급', '130명',
  '2026년 최고 기대작 | 그랜드 파이어니스와 동일 선체 규모 109.9m',
  '["수영장", "엘리베이터", "GYM", "미니골프", "도서관", "포커룸", "메디컬센터", "공용샤워실", "요가룸", "라운지", "시네마", "포켓볼", "사우나", "스크린골프", "BAR", "온천(탕)", "노래방", "마사지", "프라이빗 레스토랑", "레스토랑"]'::jsonb,
  6,
  '{"pool": true, "elevator": true, "gym": true, "mini_golf": true, "library": true, "poker_room": true, "medical": true, "public_shower": true, "yoga": true, "lounge": true, "cinema": true, "billiards": true, "sauna": true, "screen_golf": true, "bar": true, "hot_spring": true, "jacuzzi": true, "karaoke": true, "massage": true, "private_restaurant": true, "restaurant": true}'::jsonb
);

-- =====================================================
-- 7. 엘리트 스위트 (ELITE SUITE) — VIP
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
  'ATHE-ES', '아테나 프리미엄', 'Athena Premium Cruise',
  '아테나 그룹의 최고급형 6성급 크루즈. 엘리베이터, 온천(온탕), 수영장 등 20종 이상의 부대시설 보유. 그랜드 파이어니스와 동일한 선체 규모(109.9m)의 2026년 최고 기대작',
  '1박2일', '프리미엄',

  'Elite Suite', '70㎡',
  '킹베드 고정 타입. VIP 최상위 객실. 미네랄 온천수가 공급되는 자쿠지 보유. 이탈리아 최고급 GESSI 제품들로 갖춰진 욕실. 싱글차지: 1인 혼자 사용 시. 기본인원: 성인 2인 (성인1명+아동1명인 경우 2인 성인요금 적용). 최대인원: 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인+아동 2인 (아동 1인은 성인 엑스트라 요금).',

  '킹베드 (고정)', 2, 3,
  true,   -- has_balcony
  true,   -- is_vip
  false,  -- has_butler
  false,  -- is_recommended
  true,   -- connecting_available
  true,   -- extra_bed_available
  '발코니, 미네랄 온천수 자쿠지, 욕조, 스탠딩샤워, 커넥팅룸, GESSI 욕실 제품',
  NULL,

  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "픽업차량 승차 (전날 밤 안내드린 승차시간에 호텔에서 승차)"},
      {"time": "10:40", "activity": "하롱 국제 크루즈 선착장 도착/하차. 직원 명단 확인 후 체크인. 대기실 약 1시간~1시간 30분 대기"},
      {"time": "12:15", "activity": "크루즈 본선 승선 (웰컴 드링크 후 투어 진행)"},
      {"time": "12:45", "activity": "점심 뷔페식사 (3층 레스토랑, 음료/주류 별도주문)"},
      {"time": "14:45", "activity": "외부투어: 승솟동굴 (운동화 착용 권장, 도보 약 40분 코스, 크루즈 직원 영어 동행)"},
      {"time": "15:45", "activity": "외부투어: 티톱섬 (전망대 450계단 가파름. 원하지 않으면 크루즈 수영장 이용 추천)"},
      {"time": "18:00", "activity": "해피아워 (선데크, 핑거푸드·간식 무료 제공. 쿠킹클래스 참여 가능)"},
      {"time": "19:00", "activity": "디너 코스식사 (3층 지정좌석. 베지테리언/키즈 메뉴 별도 요청 가능)"},
      {"time": "20:30", "activity": "자유시간 / 오징어낚시 체험 (1층 크루즈 뒷편)"},
      {"time": "22:00", "activity": "1일차 공식일정 종료"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "06:30", "activity": "태극권 체험 (선데크)"},
      {"time": "07:00", "activity": "아침 조식 (3층, 뷔페식, 쌀국수 메뉴 제공)"},
      {"time": "08:00", "activity": "외부투어: 루온동굴 (카약 2인 무료, 뱀부보트 무료. 야생원숭이 관람 가능)"},
      {"time": "09:00", "activity": "객실 체크아웃 (짐 문 앞, 1층 리셉션에 카드 반납, 별도주문 음료/술 결제)"},
      {"time": "09:30", "activity": "브런치 뷔페식사 (3층, 하선 전 마지막 뷔페)"},
      {"time": "10:30", "activity": "선착장 대기실 도착 (통상 11시~11시 30분경 차량 승차)"},
      {"time": "14:00", "activity": "하노이 도착 및 모든 일정 종료"}
    ]}
  ]'::jsonb,

  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정에 의한 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,

  '승솟동굴 투어 포함\n티톱섬 투어 포함\n루온동굴 투어 (카약/뱀부보트 무료) 포함\n식사 포함 (점심뷔페, 디너코스, 조식뷔페, 브런치뷔페)\n해피아워 핑거푸드 포함',
  '이동차량 별도 추가옵션\n음료/주류 별도 주문\n선내 마사지 별도\n생일·기념일 이벤트 별도 신청 (100만동)',

  '6성급', '130명',
  '2026년 최고 기대작 | 그랜드 파이어니스와 동일 선체 규모 109.9m',
  '["수영장", "엘리베이터", "GYM", "미니골프", "도서관", "포커룸", "메디컬센터", "공용샤워실", "요가룸", "라운지", "시네마", "포켓볼", "사우나", "스크린골프", "BAR", "온천(탕)", "노래방", "마사지", "프라이빗 레스토랑", "레스토랑"]'::jsonb,
  7,
  '{"pool": true, "elevator": true, "gym": true, "mini_golf": true, "library": true, "poker_room": true, "medical": true, "public_shower": true, "yoga": true, "lounge": true, "cinema": true, "billiards": true, "sauna": true, "screen_golf": true, "bar": true, "hot_spring": true, "jacuzzi": true, "karaoke": true, "massage": true, "private_restaurant": true, "restaurant": true}'::jsonb
);

-- =====================================================
-- 검증 쿼리 (주석 해제 후 실행하여 데이터 확인)
-- =====================================================
-- SELECT COUNT(*) FROM cruise_info WHERE cruise_name = '아테나 프리미엄';
-- 기대값: 7

-- SELECT
--   cruise_code,
--   room_name,
--   room_area,
--   has_balcony,
--   is_vip,
--   is_recommended,
--   extra_bed_available,
--   max_adults,
--   max_guests,
--   display_order
-- FROM cruise_info
-- WHERE cruise_name = '아테나 프리미엄'
-- ORDER BY display_order;
