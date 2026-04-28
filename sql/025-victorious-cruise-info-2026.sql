-- =====================================================
-- 025-victorious-cruise-info-2026.sql
-- 빅토리어스 크루즈 상세 정보 (8개 객실 타입)
-- 출항연도: 2026년 5월 / 6성급 / LE ANH DESIGN / 지상 6층
-- =====================================================
-- 실행 전 011-cruise-info-columns.sql 먼저 실행 필요

-- 기존 빅토리어스 데이터 삭제 (재실행 가능하도록)
DELETE FROM cruise_info WHERE cruise_code LIKE 'VC-%' OR cruise_name = '빅토리어스 크루즈';

-- ── 공통 데이터 ──
-- 크루즈명: 빅토리어스 크루즈 (VICTORIOUS CRUISE)
-- 등급: 6성급
-- 출항: 2026년 5월
-- 선체층수: 지상 6층 / 건조국가: VIETNAM / 설계: LE ANH DESIGN
-- 일정: 1박2일

-- =====================================================
-- 1. 주니어 오션 스위트 (JUNIOR OCEAN SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-JOS', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', '프리미엄',
  '주니어 오션 스위트', '32㎡', '발코니 없이 오션뷰 욕조가 제공되는 객실. 더블베드 또는 트윈베드 선택 가능. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '더블 또는 트윈', 2, 3, false, false, false,
  false, false, true,
  NULL, '발코니 없음. 오션뷰 욕조 제공. 객실 내 금연.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 객실 또는 선데크에서 하롱의 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  1
);

-- =====================================================
-- 2. 시니어 발코니 스위트 (SENIOR BALCONY SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-SBS', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', '프리미엄',
  '시니어 발코니 스위트', '32㎡', '발코니와 욕조가 제공되는 객실. 더블베드 또는 트윈베드 선택 가능. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '더블 또는 트윈', 2, 3, true, false, false,
  false, false, true,
  NULL, '객실 내 금연 (흡연 시 발코니 또는 외부 선데크 이용).',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 발코니 또는 선데크에서 하롱의 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  2
);

-- =====================================================
-- 3. 엘리트 발코니 스위트 (ELITE BALCONY SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-EBS', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', '프리미엄',
  '엘리트 발코니 스위트', '40㎡', '넓은 발코니와 욕조가 제공되는 객실. 더블베드 또는 트윈베드 선택 가능. 객실 층은 랜덤 배정. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '더블 또는 트윈', 2, 3, true, false, false,
  true, false, true,
  '객실 내 제철 과일 세트 / 객실 미니바 무료 음료', '객실 내 금연 (흡연 시 발코니 또는 외부 선데크 이용). 객실 층은 랜덤 배정.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 발코니 또는 선데크에서 하롱의 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  3
);

-- =====================================================
-- 4. 이그제큐티브 테라스 스위트 (EXECUTIVE TERRACE SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-ETS', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', 'VIP',
  '이그제큐티브 테라스 스위트', '56㎡', '크루즈 뒷편 대형 단독 발코니(테라스)를 보유한 파노라마 뷰 객실. 원형 더블베드 고정. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '원형 더블베드 (고정)', 2, 3, true, true, false,
  true, false, true,
  '객실 내 제철 과일 세트 / 객실 미니바 무료 음료 / 허브 족욕 서비스 (2인)', '객실 내 금연 (흡연 시 발코니 또는 외부 선데크 이용). 원형 더블베드 고정 (트윈 변경 불가).',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 대형 테라스 발코니에서 파노라마 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  4
);

-- =====================================================
-- 5. VIP 오션 스위트 (VIP OCEAN SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-VOS', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', 'VIP',
  'VIP 오션 스위트', '80㎡', '크루즈 전면 대형 단독 발코니를 보유한 파노라마 뷰 VIP 객실. 원형 더블베드 고정. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '원형 더블베드 (고정)', 2, 3, true, true, false,
  false, false, true,
  '장미 꽃잎 장식 및 꽃다발 무료 세팅 / 와인 1병 및 제철 과일 세트 / 객실 미니바 무료 음료 / 허브 족욕 서비스 (2인) / 마사지 50% 할인', '객실 내 금연 (흡연 시 발코니 또는 외부 선데크 이용). 원형 더블베드 고정 (트윈 변경 불가).',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 전면 대형 발코니에서 파노라마 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  5
);

-- =====================================================
-- 6. VIP 허니문 스위트 (VIP HONEYMOON SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-VHS', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', 'VIP',
  'VIP 허니문 스위트', '90㎡', '크루즈 뒷편 대형 발코니를 보유한 최상위 VIP 허니문 전용 객실. 킹베드 고정. 최대 성인 2인만 투숙 가능 (엑스트라베드 불가). 싱글차지 1인 혼자 사용, 기본인원 성인 2인.',
  '킹베드 (고정)', 2, 2, true, true, false,
  false, false, false,
  '장미 꽃잎 장식 및 꽃다발 무료 세팅 / 와인 1병 및 제철 과일 세트 / 객실 미니바 무료 음료 / 허브 족욕 서비스 (2인) / 마사지 50% 할인 / 테라스 로맨틱 프라이빗 디너 (2일 전 예약)', '객실 내 금연 (흡연 시 발코니 또는 외부 선데크 이용). 킹베드 고정 (트윈 변경 불가). 엑스트라베드 불가. 최대 2인. 테라스 프라이빗 디너는 승선 2일 전까지 미리 예약 필요.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 또는 테라스 프라이빗 디너 (사전 예약 시) - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 대형 발코니에서 파노라마 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트, 테라스 프라이빗 디너 (별도 사전 예약)',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  6
);

-- =====================================================
-- 7. 패밀리 커넥팅 발코니 스위트 (FAMILY CONNECTING BALCONY SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-FCB', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', '패밀리',
  '패밀리 커넥팅 발코니 스위트', '35㎡ + 35㎡', '더블베드 객실과 트윈베드 객실이 연결된 커넥팅룸 타입. 4인~최대 6인 성인 이용에 적합. 각 객실별 발코니 제공. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '더블베드 + 트윈베드', 4, 6, true, false, false,
  false, true, true,
  NULL, '객실 내 금연 (흡연 시 발코니 또는 외부 선데크 이용). 커넥팅룸은 2개 객실 요금이 각각 적용됩니다.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 발코니 또는 선데크에서 하롱의 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  7
);

-- =====================================================
-- 8. 패밀리 그랜드 스위트 (FAMILY GRAND SUITE)
-- =====================================================
INSERT INTO cruise_info (
  cruise_code, cruise_name, name, description, duration, category,
  room_name, room_area, room_description,
  bed_type, max_adults, max_guests, has_balcony, is_vip, has_butler,
  is_recommended, connecting_available, extra_bed_available,
  special_amenities, warnings,
  itinerary, cancellation_policy, inclusions, exclusions,
  star_rating, capacity, awards, facilities, display_order
) VALUES (
  'VC-FGS', '빅토리어스 크루즈', 'Victorious Cruise', '하롱베이 신규출항 6성급 최고급형 크루즈. LE ANH DESIGN 작품. 전객실 완전한 오션뷰 및 욕조 제공.', '1박2일', '패밀리',
  '패밀리 그랜드 스위트', '40㎡ + 40㎡', '더블베드 객실과 트윈베드 객실이 연결된 커넥팅룸 타입. 4인~최대 6인 성인 이용에 적합. 싱글차지 1인 혼자 사용, 기본인원 성인 2인 (성인1명 + 아동1명인 경우 2인 성인요금), 최대인원 성인 3인 (성인 1인은 엑스트라 베드) 또는 성인 2인 + 아동 2인.',
  '더블베드 + 트윈베드', 4, 6, true, false, false,
  false, true, true,
  NULL, '객실 내 금연 (흡연 시 발코니 또는 외부 선데크 이용). 커넥팅룸은 2개 객실 요금이 각각 적용됩니다.',
  '[
    {"day": 1, "title": "1일차", "schedule": [
      {"time": "08:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업"},
      {"time": "08:00", "activity": "하롱베이로 이동 - 고속도로 이용, 이동 중 휴게소 정차 (편도 약 3시간)"},
      {"time": "11:00", "activity": "뚜언쩌우 선착장 도착 - 크루즈 직원 체크인 안내, 여권 사진 OK"},
      {"time": "12:00", "activity": "크루즈 승선 - 웰컴드링크, 객실 문서 체크인"},
      {"time": "13:00", "activity": "점심 뷔페식사 - 테이블 무제한 와인 제공, 음료/주류 별도"},
      {"time": "14:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 야생원숭이 구경 (원하는 경우만 참여)"},
      {"time": "15:30", "activity": "티톱섬 투어 - 전망대(운동화 필수) 또는 해변 휴식"},
      {"time": "17:00", "activity": "해피아워 - 선데크 핑거푸드, 무제한 드링크, 하롱베이 선셋 감상"},
      {"time": "19:00", "activity": "디너 코스식사 - 음료/주류 별도"},
      {"time": "21:00", "activity": "오징어 낚시 / 수영 - 1층 뒷편 오징어낚시, 1층/2층 수영장 이용"}
    ]},
    {"day": 2, "title": "2일차", "schedule": [
      {"time": "05:30", "activity": "일출 감상 - 발코니 또는 선데크에서 하롱의 일출 감상"},
      {"time": "06:00", "activity": "태극권 스트레칭 - 선데크 자율 참여"},
      {"time": "06:30", "activity": "이른 조식뷔페 - 쌀국수 등 메뉴 제공"},
      {"time": "07:45", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 운동화 착용"},
      {"time": "09:30", "activity": "객실 체크아웃 - 1층 리셉션 객실반납, 음료 결제 (신용카드 OK)"},
      {"time": "09:45", "activity": "브런치 뷔페 - 마지막 식사"},
      {"time": "11:00", "activity": "크루즈 하선 - 선착장 복귀 하선"},
      {"time": "11:30", "activity": "복귀차량 승차 - 하선 시 차량정보 전달"},
      {"time": "14:00", "activity": "하노이 도착 - 교통상황에 따라 상이, 호안끼엠 먼저 하차"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "크루즈 승선코드 발급 전", "penalty": "수수료없는 무료 취소 (승선일자 변경 무료)"},
    {"condition": "승선코드 발급 후 이용일자 31일 전까지", "penalty": "총 금액에서 100만동 위약금 (1인당 아님)"},
    {"condition": "이용일자 21~30일 전", "penalty": "15% 위약금"},
    {"condition": "이용일자 17~20일 전", "penalty": "50% 위약금"},
    {"condition": "이용일자 16일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍, 정부명령, 승선인원 미달, 크루즈사 사정", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '웰컴드링크, 총 4번의 식사 (점심뷔페/해피아워/디너코스/조식+브런치), 외부투어 영어가이드, 외부투어 관광지 입장료, 스파(근람물 제외) 등 부대시설, 카약킹 또는 뱀부보트, 해피아워 까나페, 선상안전보험 및 서비스차지',
  '이동차량 서비스, 음료 및 주류 별도, 마사지 및 스파 서비스, 노래방, 객실 미니냉장고 음료, 항공요금 및 공항픽드랍, 생일 및 기념일 이벤트',
  '6성급', NULL,
  'LE ANH DESIGN 작품 / 그랜드 파이어니스와 동일 디자인팀',
  '["리셉션/로비 (1층)", "스파&마사지 (1층)", "GYM/휘트니스 (1층)", "레스토랑 (1층)", "키즈클럽 (1층)", "사계절 수영장 (2층)", "선데크 (5층)", "엘리베이터"]'::jsonb,
  8
);

SELECT '빅토리어스 크루즈 cruise_info 데이터 입력 완료 (8개 객실 타입)' AS result;
SELECT cruise_code, room_name, has_balcony, is_vip, connecting_available, display_order
FROM cruise_info
WHERE cruise_name = '빅토리어스 크루즈'
ORDER BY display_order;
