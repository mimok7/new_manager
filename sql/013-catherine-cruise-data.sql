-- =====================================================
-- 013-catherine-cruise-data.sql
-- Catherine Cruise 상세 정보 (5개 객실 타입)
-- =====================================================
-- 실행 전 011-cruise-info-columns.sql 먼저 실행 필요

-- 기존 Catherine Cruise 데이터 삭제 (재실행 가능하도록)
DELETE FROM cruise_info WHERE cruise_code LIKE 'CATH-%' OR cruise_name = '캐서린 크루즈';

-- ── 공통 데이터 ──
-- 크루즈명: 캐서린 크루즈
-- 등급: 6성급 (하롱베이 최초 6성급)
-- 수용인원: 160명 (기본값)
-- 일정: 1박2일
-- 출항: 2023년

-- =====================================================
-- 1. Premier Suite (프리미어 스위트)
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
  'CATH-PS', '캐서린 크루즈', 'Catherine Cruise', '하롱베이 최초의 6성급 크루즈. 세계적 수준의 인테리어와 베트남 + 인도차이나 스타일의 럭셔리한 디자인', '1박2일', '프리미엄',
  'Premier Suite', '40㎡', '발코니 객실. 더블 또는 트윈 베드 선택 가능. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인 (아동 1인은 성인 엑스트라 요금). 층이 높아질수록 금액이 높음. 1층은 퀸사이즈, 2층 3층부터 업그레이드 가능.',
  '더블 또는 트윈', 2, 3, true, false, false,
  true, true, true,
  '프라이빗 발코니, 욕조, 스탠딩샤워, 커넥팅룸', NULL,
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "호텔 픽업"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "승선"},
      {"time": "12:45", "activity": "점심 뷔페"},
      {"time": "14:10", "activity": "승솟동굴 투어 ★★★★★"},
      {"time": "16:00", "activity": "티톱섬 방문"},
      {"time": "17:30", "activity": "해피아워 & 쿠킹클래스"},
      {"time": "19:00", "activity": "디너 코스 요리"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시 등)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상"},
      {"time": "06:15", "activity": "태극권 (타이치)"},
      {"time": "06:45", "activity": "조식 뷔페"},
      {"time": "07:15", "activity": "루온동굴 투어 (카약/뱀부보트) ★★★★★"},
      {"time": "09:30", "activity": "체크아웃"},
      {"time": "09:45", "activity": "브런치 뷔페"},
      {"time": "10:40", "activity": "하선"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "승선코드 발급 전", "penalty": "무료 취소"},
    {"condition": "출발 31일 전", "penalty": "1,000,000 VND"},
    {"condition": "출발 21~30일 전", "penalty": "요금의 15%"},
    {"condition": "출발 17~20일 전", "penalty": "요금의 50%"},
    {"condition": "출발 16일 이내 또는 노쇼", "penalty": "취소/환불 불가"},
    {"condition": "천재지변/정부명령/크루즈 결항", "penalty": "전액 환불"}
  ]'::jsonb,
  '승솟동굴 & 루온동굴 투어 포함\n식사 (뷔페/코스) 포함\n해피아워 & 쿠킹클래스 포함\n카약 & 뱀부보트 포함\n기본 피크닉 식사 포함',
  '음료 & 주류 별도 주문\n팁 관례 (권장)\n선내 스파/마사지 별도',
  '6성급', '160명',
  '하롱베이 최초 6성급 크루즈 (2023년 출항)',
  '["수영장", "엘리베이터 (4층)", "GYM", "미니골프", "BAR", "레스토랑", "스파", "선데크"]'::jsonb,
  1,
  '{"swimming_pool": true, "elevator": true, "gym": true, "mini_golf": true, "bar": true, "restaurant": true, "spa": true, "sundeck": true}'::jsonb
);

-- =====================================================
-- 2. Premier Triple (프리미어 트리플)
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
  'CATH-PT', '캐서린 크루즈', 'Catherine Cruise', '하롱베이 최초의 6성급 크루즈. 세계적 수준의 인테리어와 베트남 + 인도차이나 스타일의 럭셔리한 디자인', '1박2일', '프리미엄',
  'Premier Suite Triple', '45㎡', '3인 전용 객실. 더블 베드 + 싱글 베드 구성. 싱글차지 이용불가, 기본인원 성인 3인 (성인2명 + 아동1명인 경우 3인 성인요금), 최대인원 성인 3인 + 아동 1인. 간혹 2층이나 3층으로 업그레이드 되며 엑스트라 베드로 3인이 세팅되는 경우가 있음. 트리플 객실 원하시면 사전에 요청 필요.',
  '더블 + 싱글', 3, 3, true, false, false,
  true, true, false,
   'Triple 객실로 엑스트라 베드 없음', NULL,
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "호텔 픽업"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "승선"},
      {"time": "12:45", "activity": "점심 뷔페"},
      {"time": "14:10", "activity": "승솟동굴 투어 ★★★★★"},
      {"time": "16:00", "activity": "티톱섬 방문"},
      {"time": "17:30", "activity": "해피아워 & 쿠킹클래스"},
      {"time": "19:00", "activity": "디너 코스 요리"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시 등)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상"},
      {"time": "06:15", "activity": "태극권 (타이치)"},
      {"time": "06:45", "activity": "조식 뷔페"},
      {"time": "07:15", "activity": "루온동굴 투어 (카약/뱀부보트) ★★★★★"},
      {"time": "09:30", "activity": "체크아웃"},
      {"time": "09:45", "activity": "브런치 뷔페"},
      {"time": "10:40", "activity": "하선"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "승선코드 발급 전", "penalty": "무료 취소"},
    {"condition": "출발 31일 전", "penalty": "1,000,000 VND"},
    {"condition": "출발 21~30일 전", "penalty": "요금의 15%"},
    {"condition": "출발 17~20일 전", "penalty": "요금의 50%"},
    {"condition": "출발 16일 이내 또는 노쇼", "penalty": "취소/환불 불가"},
    {"condition": "천재지변/정부명령/크루즈 결항", "penalty": "전액 환불"}
  ]'::jsonb,
  '승솟동굴 & 루온동굴 투어 포함\n식사 (뷔페/코스) 포함\n해피아워 & 쿠킹클래스 포함\n카약 & 뱀부보트 포함\n기본 피크닉 식사 포함',
  '음료 & 주류 별도 주문\n팁 관례 (권장)\n선내 스파/마사지 별도',
  '6성급', '160명',
  '하롱베이 최초 6성급 크루즈 (2023년 출항)',
  '["수영장", "엘리베이터 (4층)", "GYM", "미니골프", "BAR", "레스토랑", "스파", "선데크"]'::jsonb,
  2,
  '{"swimming_pool": true, "elevator": true, "gym": true, "mini_golf": true, "bar": true, "restaurant": true, "spa": true, "sundeck": true}'::jsonb
);

-- =====================================================
-- 3. Royal Suite (로얄 스위트) - VIP
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
  'CATH-RS', '캐서린 크루즈', 'Catherine Cruise', '하롱베이 최초의 6성급 크루즈. 세계적 수준의 인테리어와 베트남 + 인도차이나 스타일의 럭셔리한 디자인', '1박2일', '프리미엄',
  'Royal Suite', '56㎡', 'VIP 로얄 스위트. 킹베드 고정. 크루즈의 후미에 단독 테라스 제공. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인 (아동 1인은 성인 엑스트라 요금). 욕조가 욕실 외부에 있어서 부부/연인이 아닌 경우 이용이 어려울 수 있음.',
  '킹', 2, 2, true, true, false,
  false, false, false,
  'VIP 어메니티\n프라이빗 테라스\n발마사지 30분 무료\n제철과일 세트',
  'VIP 객실로 엑스트라 베드 없음 (최대 2인)',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "호텔 픽업"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "승선"},
      {"time": "12:45", "activity": "점심 뷔페"},
      {"time": "14:10", "activity": "승솟동굴 투어 ★★★★★"},
      {"time": "16:00", "activity": "티톱섬 방문"},
      {"time": "17:30", "activity": "해피아워 & 쿠킹클래스"},
      {"time": "19:00", "activity": "디너 코스 요리"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시 등)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상"},
      {"time": "06:15", "activity": "태극권 (타이치)"},
      {"time": "06:45", "activity": "조식 뷔페"},
      {"time": "07:15", "activity": "루온동굴 투어 (카약/뱀부보트) ★★★★★"},
      {"time": "09:30", "activity": "체크아웃"},
      {"time": "09:45", "activity": "브런치 뷔페"},
      {"time": "10:40", "activity": "하선"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "승선코드 발급 전", "penalty": "무료 취소"},
    {"condition": "출발 31일 전", "penalty": "1,000,000 VND"},
    {"condition": "출발 21~30일 전", "penalty": "요금의 15%"},
    {"condition": "출발 17~20일 전", "penalty": "요금의 50%"},
    {"condition": "출발 16일 이내 또는 노쇼", "penalty": "취소/환불 불가"},
    {"condition": "천재지변/정부명령/크루즈 결항", "penalty": "전액 환불"}
  ]'::jsonb,
  '승솟동굴 & 루온동굴 투어 포함\n식사 (뷔페/코스) 포함\n해피아워 & 쿠킹클래스 포함\n카약 & 뱀부보트 포함\n기본 피크닉 식사 포함\n바디마사지 30분 무료',
  '음료 & 주류 별도 주문\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 최초 6성급 크루즈 (2023년 출항)',
  '["수영장", "엘리베이터 (4층)", "GYM", "미니골프", "BAR", "레스토랑", "스파", "선데크"]'::jsonb,
  3,
  '{"swimming_pool": true, "elevator": true, "gym": true, "mini_golf": true, "bar": true, "restaurant": true, "spa": true, "sundeck": true}'::jsonb
);

-- =====================================================
-- 4. Grand Suite (그랜드 스위트) - VIP
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
  'CATH-GS', '캐서린 크루즈', 'Catherine Cruise', '하롱베이 최초의 6성급 크루즈. 세계적 수준의 인테리어와 베트남 + 인도차이나 스타일의 럭셔리한 디자인', '1박2일', '프리미엄',
  'Grand Suite', '85㎡', 'VIP 그랜드 스위트. 킹베드 고정. 크루즈의 후미에 단독 테라스 제공. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드). 욕조가 욕실 외부에 있어서 부부/연인이 아닌 경우 이용이 어려울 수 있음. 4층 객실로 5층의 선데크로 인해 다소 소음이 있을 수 있음.',
  '킹', 2, 3, true, true, false,
  false, false, false,
  'VIP 어메니티\n넓은 객실\n바디마사지 30분 무료\n럭셔리 어메니티',
  'VIP 객실로 엑스트라 베드 없음 (최대 2인)',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "호텔 픽업"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "승선"},
      {"time": "12:45", "activity": "점심 뷔페"},
      {"time": "14:10", "activity": "승솟동굴 투어 ★★★★★"},
      {"time": "16:00", "activity": "티톱섬 방문"},
      {"time": "17:30", "activity": "해피아워 & 쿠킹클래스"},
      {"time": "19:00", "activity": "디너 코스 요리"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시 등)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상"},
      {"time": "06:15", "activity": "태극권 (타이치)"},
      {"time": "06:45", "activity": "조식 뷔페"},
      {"time": "07:15", "activity": "루온동굴 투어 (카약/뱀부보트) ★★★★★"},
      {"time": "09:30", "activity": "체크아웃"},
      {"time": "09:45", "activity": "브런치 뷔페"},
      {"time": "10:40", "activity": "하선"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "승선코드 발급 전", "penalty": "무료 취소"},
    {"condition": "출발 31일 전", "penalty": "1,000,000 VND"},
    {"condition": "출발 21~30일 전", "penalty": "요금의 15%"},
    {"condition": "출발 17~20일 전", "penalty": "요금의 50%"},
    {"condition": "출발 16일 이내 또는 노쇼", "penalty": "취소/환불 불가"},
    {"condition": "천재지변/정부명령/크루즈 결항", "penalty": "전액 환불"}
  ]'::jsonb,
  '승솟동굴 & 루온동굴 투어 포함\n식사 (뷔페/코스) 포함\n해피아워 & 쿠킹클래스 포함\n카약 & 뱀부보트 포함\n기본 피크닉 식사 포함\n바디마사지 30분 무료',
  '음료 & 주류 별도 주문\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 최초 6성급 크루즈 (2023년 출항)',
  '["수영장", "엘리베이터 (4층)", "GYM", "미니골프", "BAR", "레스토랑", "스파", "선데크"]'::jsonb,
  4,
  '{"swimming_pool": true, "elevator": true, "gym": true, "mini_golf": true, "bar": true, "restaurant": true, "spa": true, "sundeck": true}'::jsonb
);

-- =====================================================
-- 5. Villa President (빌라 프레지던트) - VIP 최상위
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
  'CATH-VP', '캐서린 크루즈', 'Catherine Cruise', '하롱베이 최초의 6성급 크루즈. 세계적 수준의 인테리어와 베트남 + 인도차이나 스타일의 럭셔리한 디자인', '1박2일', '프리미엄',
  'Villa President', '200㎡', '최상위 VIP 빌라 프레지던트. 킹침대 원형 베드 고정. 크루즈의 후미에 단독 테라스 제공. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인 (아동 1인은 성인 엑스트라 요금). 욕조가 욕실 외부에 있어서 부부/연인이 아닌 경우 이용이 어려울 수 있음. 객실 내 다이닝 테이블이 있어서 객실에서의 저녁식사 가능.',
  '킹', 2, 2, true, true, true,
  false, false, false,
  'VIP 풀패키지\n전용 다이닝 공간\n보틀 와인 제공\n바디마사지 60분 무료\n프리미엄 어메니티\n전용 버틀러 서비스 (문의)',
  'VIP 최상위 객실로 엑스트라 베드 없음 (최대 2인)',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "호텔 픽업"},
      {"time": "10:40", "activity": "선착장 도착 및 체크인"},
      {"time": "12:15", "activity": "승선"},
      {"time": "12:45", "activity": "점심 뷔페"},
      {"time": "14:10", "activity": "승솟동굴 투어 ★★★★★"},
      {"time": "16:00", "activity": "티톱섬 방문"},
      {"time": "17:30", "activity": "해피아워 & 쿠킹클래스"},
      {"time": "19:00", "activity": "디너 코스 요리"},
      {"time": "21:00", "activity": "자유시간 (오징어낚시 등)"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상"},
      {"time": "06:15", "activity": "태극권 (타이치)"},
      {"time": "06:45", "activity": "조식 뷔페"},
      {"time": "07:15", "activity": "루온동굴 투어 (카약/뱀부보트) ★★★★★"},
      {"time": "09:30", "activity": "체크아웃"},
      {"time": "09:45", "activity": "브런치 뷔페"},
      {"time": "10:40", "activity": "하선"},
      {"time": "14:00", "activity": "하노이 도착"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "승선코드 발급 전", "penalty": "무료 취소"},
    {"condition": "출발 31일 전", "penalty": "1,000,000 VND"},
    {"condition": "출발 21~30일 전", "penalty": "요금의 15%"},
    {"condition": "출발 17~20일 전", "penalty": "요금의 50%"},
    {"condition": "출발 16일 이내 또는 노쇼", "penalty": "취소/환불 불가"},
    {"condition": "천재지변/정부명령/크루즈 결항", "penalty": "전액 환불"}
  ]'::jsonb,
  '승솟동굴 & 루온동굴 투어 포함\n식사 (뷔페/코스) 포함\n해피아워 & 쿠킹클래스 포함\n카약 & 뱀부보트 포함\n기본 피크닉 식사 포함\n제철과일 세트\n보틀 와인 제공\n웰컴 차 세트\n바디마사지 60분 무료',
  '음료 & 주류 (와인 제외) 별도 주문\n팁 관례 (권장)',
  '6성급', '160명',
  '하롱베이 최초 6성급 크루즈 (2023년 출항)',
  '["수영장", "엘리베이터 (4층)", "GYM", "미니골프", "BAR", "레스토랑", "스파", "선데크"]'::jsonb,
  5,
  '{"swimming_pool": true, "elevator": true, "gym": true, "mini_golf": true, "bar": true, "restaurant": true, "spa": true, "sundeck": true}'::jsonb
);

-- 확인
SELECT cruise_name, room_name, room_area, has_balcony, is_vip, has_butler, display_order
FROM cruise_info
WHERE cruise_name = '캐서린 크루즈'
ORDER BY display_order;
