-- =====================================================
-- 012-grand-pioneers-cruise-data.sql
-- Grand Pioneers Cruise 상세 정보 (8개 객실 타입)
-- =====================================================
-- 실행 전 011-cruise-info-columns.sql 먼저 실행 필요

-- 기존 Grand Pioneers 데이터 삭제 (재실행 가능하도록)
DELETE FROM cruise_info WHERE cruise_code LIKE 'GP-%' OR cruise_name = '그랜드 파이어니스 크루즈';

-- ── 공통 데이터 변수 ──
-- 크루즈명: 그랜드 파이어니스 크루즈
-- 등급: 6성급 (아시아 최고 크루즈 수상)
-- 수용인원: 160명
-- 일정: 1박2일

-- =====================================================
-- 1. Ocean Suite (오션 스위트)
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
  'GP-OS', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'Ocean Suite', '30㎡', '오션뷰 스위트룸. 발코니 없음. 더블 또는 트윈 배치 가능. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명일 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '더블 또는 트윈', 2, 3, false, false, false,
  false, false, true,
  NULL, '발코니 없음. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함',
  '주류/소프트드링크 별도, 마사지/스파 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존"]'::jsonb,
  1,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 2. Ocean Suite TLP (오션 스위트 TLP - 3인실)
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
  'GP-OT', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'Ocean Suite Triple', '43㎡', '3인 전용 객실. 싱글베드 3개 배치. 발코니 없음. 트리플 전용 객실로 그룹 여행에 적합. 싱글차지 이용불가. 기본인원 성인 3인 (성인2명 + 아동1명일 경우 3인 성인요금). 최대인원 성인 3인 + 아동 1인.',
  '싱글 3개', 3, 3, false, false, false,
  false, false, false,
  NULL, '발코니 없음. 엑스트라베드 불가. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함',
  '주류/소프트드링크 별도, 마사지/스파 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존"]'::jsonb,
  2,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 3. Ocean Balcony Suite (오션 발코니 스위트)
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
  'GP-OB', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'Ocean Balcony Suite', '40㎡', '프라이빗 발코니가 있는 오션뷰 스위트룸. 더블 또는 트윈 배치 가능. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명일 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인. 객실 층은 랜덤배정, 높은 층일수록 오션뷰가 구조물로 가려질 수 있음.',
  '더블 또는 트윈', 2, 3, true, false, false,
  false, false, true,
  '프라이빗 발코니', '객실 층 랜덤배정. 금속 구조물로 오션뷰가 가려질 수 있음. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함',
  '주류/소프트드링크 별도, 마사지/스파 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존"]'::jsonb,
  3,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 4. Veranda Suite (베란다 스위트) ★ 추천
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
  'GP-VS', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'Veranda Suite', '40㎡', '완벽한 오션뷰 타입의 프라이빗 발코니 보유 객실. 더블 또는 트윈 배치 가능. 모든 객실은 커넥팅룸 타입 구성(가족 여행 추천). 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명일 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인. 스테이하롱에서 가장 추천하는 객실입니다.',
  '더블 또는 트윈', 2, 3, true, false, false,
  true, true, true,
  '프라이빗 발코니, 커넥팅룸 가능', '객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함',
  '주류/소프트드링크 별도, 마사지/스파 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존"]'::jsonb,
  4,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 5. Executive Suite (이그제큐티브 스위트)
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
  'GP-ES', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'Executive Suite', '40㎡', '프라이빗 발코니가 있는 이그제큐티브 스위트. 더블 또는 트윈 배치 가능. 베란다 스위트와 면적, 디자인 동일하고 객실 층만 다름. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명일 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인. 객실 층 랜덤배정, 4층은 5층 레스토랑으로 저녁 시간대 소음 가능.',
  '더블 또는 트윈', 2, 3, true, false, false,
  false, false, true,
  '프라이빗 발코니', '객실 층 랜덤배정. 4층은 레스토랑 인접으로 저녁 소음 가능. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함',
  '주류/소프트드링크 별도, 마사지/스파 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존"]'::jsonb,
  5,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true}'::jsonb
);

-- =====================================================
-- 6. The Essence Suite - VIP (더 에센스 스위트)
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
  'GP-TE', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'The Essence Suite', '60㎡', 'VIP 등급 스위트. 크루즈의 뱃머리에 단독 발코니 보유. 킹베드 전용. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명일 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인 엑스트라 베드) 또는 성인 2인 + 아동 2인. 옆 객실과 진입로 및 테이블 공간 공유로 객실 1개만 예약은 불편할 수 있음. VIP 혜택: 대기실 VIP공간, 객실 내 웰컴과일 세트, 객실 내 레드와인 1병, 티타임 서비스, 식사시간 중 차/커피 무료, 스파 내 사우나 30분 무료(2인), 스파 20% 할인.',
  '킹', 2, 3, true, true, false,
  false, false, true,
  'VIP 어메니티, 대기실 VIP공간, 웰컴과일/와인, 사우나 30분 무료, 스파 할인', 'VIP 객실. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함, VIP 어메니티 포함',
  '주류/소프트드링크 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존", "VIP 라운지", "스파"]'::jsonb,
  6,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true, "vip_lounge": true, "spa": true}'::jsonb
);

-- =====================================================
-- 7. Oceania Suite - VIP (오세아니아 스위트)
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
  'GP-OA', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'Oceania Suite', '95㎡', 'VIP 최상급 스위트. 크루즈의 전면에 대형 단독 테라스 및 자쿠지 보유. 킹베드 고정. 싱글차지 이용불가. 기본인원 성인 2인 (아동동반 없이 아동도 성인요금 적용). 최대인원 성인 2인 (침실 2개가 객실 내 위치하지만 성인 2인으로 예약시 침실 2개 중 1개만 오픈). VIP 전용 라운지 이용, 전담 버틀러 배정. VIP 혜택: 대기실 VIP공간, 객실 내 웰컴과일 세트, 객실 내 스파클링 1병, 티타임 서비스, 식사시간 중 차/커피 무료, 스파 내 사우나 30분 무료(2인), 전담 버틀러, 60분 전신마사지 무료(2인), 애프터눈티.',
  '킹', 2, 2, true, true, true,
  false, false, false,
  'VVIP 어메니티, 전용 버틀러, 대형 테라스, 자쿠지, 60분 마사지 무료', 'VVIP 객실. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함, VVIP 어메니티 포함',
  '주류/소프트드링크 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존", "VIP 라운지", "스파", "자쿠지"]'::jsonb,
  7,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true, "vip_lounge": true, "spa": true, "jacuzzi": true}'::jsonb
);

-- =====================================================
-- 8. The Owners Suite (더 오너스 스위트) - 최상위
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
  'GP-TO', '그랜드 파이어니스 크루즈', 'Grand Pioneers Cruise', '아시아 최고의 크루즈로 선정된 6성급 프리미엄 크루즈', '1박2일', '프리미엄',
  'The Owns Suite', '150㎡', '최상위 스위트. 크루즈의 전면에 대형 단독 테라스 및 자쿠지 보유. 킹베드 고정. 싱글차지 이용불가. 기본인원 성인 2인 (아동동반 없이 아동도 성인요금 적용). 최대인원 성인 2인. VIP 전용 라운지 이용, 전담 버틀러 배정. VIP 혜택: 대기실 VIP공간, 객실 내 웰컴과일 세트, 객실 내 스파클링 1병, 티타임 서비스, 식사시간 중 차/커피 무료, 스파 내 사우나 30분 무료(2인), 전담 버틀러, 60분 전신마사지 무료(2인), 애프터눈티.',
  '킹', 2, 2, true, true, true,
  false, false, false,
  'VVIP 풀패키지, 전용 버틀러, 전용 선데크, 자쿠지, 60분 마사지 무료', 'VVIP 최상위 객실. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "차량픽업 - 호텔 앞으로 차량 도착. 차량번호 확인 후 승차"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 편도 약 2시간 30분 (150km). 고속도로 통상 1회 정차 (약 20분)"},
      {"time": "10:40", "activity": "크루즈 선착장 도착 및 체크인 - 성함 호출 또는 부킹코드 제시. 알러지/고수 여부 확인"},
      {"time": "12:15", "activity": "텐더보트 승선 - 약 5분 이동"},
      {"time": "12:25", "activity": "크루즈 본선 승선 - 웰컴드링크 제공. 직원 환영 공연. 객실로 이동"},
      {"time": "13:00", "activity": "점심 뷔페 - 해산물, BBQ, 초밥 등. 음료/주류 별도 주문"},
      {"time": "15:30", "activity": "승솟동굴 투어 - 약 120계단, 해발 25m. 운동화 권장"},
      {"time": "17:30", "activity": "해피아워 - 선데크 핑거푸드, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스 식사 - 쉐프 정찬, 마술 공연"},
      {"time": "21:00", "activity": "자유시간 - 오징어 낚시, 스파, 수영장"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 선데크, 수영장, 객실 발코니에서"},
      {"time": "06:00", "activity": "선데크 태극권 - 의무 아님, 날씨에 따라 변경 가능"},
      {"time": "06:30", "activity": "아침 조식 - 간단한 조식, 음료 제공"},
      {"time": "07:30", "activity": "루온 동굴 투어 - 카약 또는 뱀부보트 선택. 야생원숭이 사진 촬영"},
      {"time": "09:00", "activity": "객실 체크아웃 및 브런치 - 음료 결제"},
      {"time": "10:30", "activity": "크루즈 하선 - 텐더보트로 선착장 복귀"},
      {"time": "11:00", "activity": "차량 승차 - 캐리어 탑승 확인. 휴게소 1회 정차"},
      {"time": "14:00", "activity": "하노이 도착 - 목적지 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "보딩코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "보딩코드 발급 후 이용일자 31일 전까지", "penalty": "100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소/환불/날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '외부 투어(동굴/카약/대나무보트) 포함, 식사(뷔페/코스) 포함, 선상 오징어 낚시 포함, VVIP 어메니티 포함',
  '주류/소프트드링크 별도, 개인 지출',
  '6성급', '160명',
  '아시아 최고 크루즈 수상 (Asia''s Best Cruise)',
  '["온수 수영장", "엘리베이터 (전 층)", "의료센터", "GYM", "미니골프", "BAR", "키즈존", "VIP 라운지", "스파", "자쿠지"]'::jsonb,
  8,
  '{"heated_pool": true, "elevator": true, "medical_center": true, "gym": true, "mini_golf": true, "bar": true, "kids_zone": true, "vip_lounge": true, "spa": true, "jacuzzi": true}'::jsonb
);

-- =====================================================
-- 검증 데이터
-- =====================================================
SELECT cruise_name, room_name, room_area, has_balcony, is_vip, has_butler, is_recommended, display_order
FROM cruise_info
WHERE cruise_name = '그랜드 파이어니스 크루즈'
ORDER BY display_order;
