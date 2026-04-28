-- =====================================================
-- 026-saquila-yacht-cruise-info-2026.sql
-- 사퀼라 요트 크루즈 상세 정보
-- 출항연도: 2024년 5월 / 당일크루즈 / 지상 3층 / 선체길이 56.18m / 승선정원 150명
-- =====================================================
-- 실행 전 011-cruise-info-columns.sql 먼저 실행 필요

-- 기존 사퀼라 데이터 삭제 (재실행 가능하도록)
DELETE FROM cruise_info WHERE cruise_code LIKE 'SQ-%' OR cruise_name = '사퀼라 요트 크루즈';

-- ── 공통 데이터 ──
-- 크루즈명: 사퀼라 요트 크루즈 (SAQUILA YACHT)
-- 출항: 2024년 5월
-- 선체길이: 56.18m / 승선정원: 150명 / 선체층수: 지상 3층 / 건조국가: VIETNAM
-- 일정: 당일크루즈

-- =====================================================
-- 1. 성인 (기본 탑승 요금)
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
  'SQ-ADT', '사퀼라 요트 크루즈', 'Saquila Yacht Cruise', '하롱베이 최고급 당일크루즈 요트. 2024년 5월 출항. 승솟동굴·티톱섬·루온동굴 투어코스. 사계절 수영장 보유. 스테이하롱 No.1 추천 당일 크루즈.', '당일', '데이크루즈',
  '성인', NULL, '성인 1인당 탑승 기준 요금. 2세 미만 무료. 만 2~4세 아동 550,000동. 만 5~11세 아동 1,400,000동. 별도 추가옵션으로 카약킹 1인당 150,000동.',
  NULL, 1, 1, false, false, false,
  true, false, false,
  NULL, '당일크루즈는 중국 단체관광객들로 인한 혼잡이 있을 수 있습니다. 부모님을 모시는 여행에는 추천하지 않습니다. 운동화 착용 권장 (승솟동굴 약 120계단). 음료 및 주류는 크루즈 내 별도 결제.',
  '[
    {"day": 1, "title": "당일일정", "schedule": [
      {"time": "06:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업 (하노이 올드쿼터/호안끼엠 인근)"},
      {"time": "06:00", "activity": "하롱베이로 이동 - 고속도로 이용 (편도 약 2시간 30분)"},
      {"time": "08:30", "activity": "하롱국제 크루즈 선착장 도착 - 크루즈 직원 체크인 안내, 예약확인서 불필요, 여권 사진으로 OK"},
      {"time": "08:50", "activity": "크루즈 승선 - 직원 안내에 따라 선착장 정박 크루즈 승선"},
      {"time": "09:00", "activity": "크루즈 출항 - 간단한 아침조식 제공, 하롱베이 풍경 감상, 하롱명산 BAI THO, 레스토랑 좌석 지정"},
      {"time": "10:15", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 영어가이드 동행, 운동화 착용, 약 40분 코스"},
      {"time": "11:30", "activity": "점심 세미뷔페 - 쉐프가 준비한 코스메뉴와 세미뷔페 구성"},
      {"time": "12:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 100m 터널형 동굴 관람, 야생원숭이 구경 (카약킹 별도요금)"},
      {"time": "13:30", "activity": "티톱섬 투어 - 전망대(450계단) 또는 해변 휴식 (스테이하롱 추천코스 아님)"},
      {"time": "15:00", "activity": "전통 차 체험 - 베트남 전통 차 시음 및 다과"},
      {"time": "16:00", "activity": "크루즈 하선 - 선착장 복귀 하선, 차량탑승 안내 전달"},
      {"time": "19:00", "activity": "하노이 도착 - 하노이 올드쿼터 하차 (교통상황에 따라 상이)"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"},
    {"condition": "교통사고·생명위급 질병 입원 (영문진단서 제출 필요)", "penalty": "크루즈사 심사 후 환자 본인에 한해 예외 적용 가능 (100% 보장 아님)"}
  ]'::jsonb,
  '웰컴드링크, 간단한 아침조식, 외부투어 영어가이드, 외부투어 관광지 입장료, 수영장 이용, 점심 세미뷔페, 루온동굴 뱀부보트, 전통 차체험 시음 및 다과, 선상안전보험 및 서비스 차지',
  '이동차량 서비스, 별도 주문하는 음료 및 주류, 루온동굴 카약킹 (2인당 300,000동 / 현장결제), 항공요금 및 공항픽드랍 서비스, 생일 및 기념일 이벤트',
  NULL, 150,
  NULL,
  '["1층 로비 라운지 / 수영장 라운지", "1층 레스토랑 (랜덤 배정)", "2층 레스토랑 (랜덤 배정)", "2층 선데크 (자유 이용)", "3층 선데크 (자유 이용)", "프라이빗 객실 (지하1층, 별도요금)", "개별 락커 및 샤워룸 (지하1층, 자유이용)", "사계절 수영장 (온수풀 운영)"]'::jsonb,
  1
);

-- =====================================================
-- 2. 아동 (만 5~11세)
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
  'SQ-CHD', '사퀼라 요트 크루즈', 'Saquila Yacht Cruise', '하롱베이 최고급 당일크루즈 요트. 2024년 5월 출항. 승솟동굴·티톱섬·루온동굴 투어코스. 사계절 수영장 보유. 스테이하롱 No.1 추천 당일 크루즈.', '당일', '데이크루즈',
  '아동 (만 5~11세)', NULL, '만 5세 이상 만 11세 이하 아동 1인당 탑승 기준 요금. 만 2~4세 아동은 별도 요금(550,000동) 적용. 만 2세 미만은 무료.',
  NULL, 0, 1, false, false, false,
  false, false, false,
  NULL, '아동 연령 기준: 만 2세 미만 무료, 만 2~4세 550,000동, 만 5~11세 본 요금 적용. 운동화 착용 권장 (승솟동굴 약 120계단).',
  '[
    {"day": 1, "title": "당일일정", "schedule": [
      {"time": "06:00", "activity": "하노이 차량 픽업 - 전날 밤 9시경 전달된 시간에 호텔 앞 픽업 (하노이 올드쿼터/호안끼엠 인근)"},
      {"time": "06:00", "activity": "하롱베이로 이동 - 고속도로 이용 (편도 약 2시간 30분)"},
      {"time": "08:30", "activity": "하롱국제 크루즈 선착장 도착 - 크루즈 직원 체크인 안내, 예약확인서 불필요, 여권 사진으로 OK"},
      {"time": "08:50", "activity": "크루즈 승선 - 직원 안내에 따라 선착장 정박 크루즈 승선"},
      {"time": "09:00", "activity": "크루즈 출항 - 간단한 아침조식 제공, 하롱베이 풍경 감상, 하롱명산 BAI THO, 레스토랑 좌석 지정"},
      {"time": "10:15", "activity": "승솟동굴 투어 - 하롱베이 최대 동굴, 영어가이드 동행, 운동화 착용, 약 40분 코스"},
      {"time": "11:30", "activity": "점심 세미뷔페 - 쉐프가 준비한 코스메뉴와 세미뷔페 구성"},
      {"time": "12:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택, 100m 터널형 동굴 관람, 야생원숭이 구경 (카약킹 별도요금)"},
      {"time": "13:30", "activity": "티톱섬 투어 - 전망대(450계단) 또는 해변 휴식"},
      {"time": "15:00", "activity": "전통 차 체험 - 베트남 전통 차 시음 및 다과"},
      {"time": "16:00", "activity": "크루즈 하선 - 선착장 복귀 하선, 차량탑승 안내 전달"},
      {"time": "19:00", "activity": "하노이 도착 - 하노이 올드쿼터 하차 (교통상황에 따라 상이)"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"},
    {"condition": "교통사고·생명위급 질병 입원 (영문진단서 제출 필요)", "penalty": "크루즈사 심사 후 환자 본인에 한해 예외 적용 가능 (100% 보장 아님)"}
  ]'::jsonb,
  '웰컴드링크, 간단한 아침조식, 외부투어 영어가이드, 외부투어 관광지 입장료, 수영장 이용, 점심 세미뷔페, 루온동굴 뱀부보트, 전통 차체험 시음 및 다과, 선상안전보험 및 서비스 차지',
  '이동차량 서비스, 별도 주문하는 음료 및 주류, 루온동굴 카약킹 (2인당 300,000동 / 현장결제), 항공요금 및 공항픽드랍 서비스, 생일 및 기념일 이벤트',
  NULL, 150,
  NULL,
  '["1층 로비 라운지 / 수영장 라운지", "1층 레스토랑 (랜덤 배정)", "2층 레스토랑 (랜덤 배정)", "2층 선데크 (자유 이용)", "3층 선데크 (자유 이용)", "프라이빗 객실 (지하1층, 별도요금)", "개별 락커 및 샤워룸 (지하1층, 자유이용)", "사계절 수영장 (온수풀 운영)"]'::jsonb,
  2
);

-- =====================================================
-- 3. 셔틀리무진 (왕복/편도 선택)
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
  'SQ-SHT', '사퀼라 요트 크루즈', 'Saquila Yacht Cruise', '하롱베이 최고급 당일크루즈 요트. 2024년 5월 출항. 승솟동굴·티톱섬·루온동굴 투어코스. 사계절 수영장 보유. 스테이하롱 No.1 추천 당일 크루즈.', '당일', '데이크루즈',
  '셔틀리무진 (1인당 왕복/편도)', NULL, '하노이 올드쿼터(호안끼엠 인근) 픽업·드랍 전용 셔틀리무진 차량. 1인당 왕복 또는 편도 요금. 좌석 랜덤승차 방식. 크루즈 승선일과 하선일에만 이용 가능.',
  NULL, 1, 1, false, false, false,
  false, false, false,
  NULL, '하노이 올드쿼터(호안끼엠 인근) 픽업·드랍만 가능. 좌석은 남는 좌석에 랜덤승차. 이동 중 휴게소 정차 (쇼핑휴게소 가능성 있음). 차량번호와 정확한 승차시간은 투어 전날 밤 10시경 전달. 승차인원 과다 시 대형버스 변경 가능. 차량 내 음식물 취식 금지. 안전벨트 고장 차량 가능성 있음.',
  '[
    {"day": 1, "title": "셔틀리무진 운행일정", "schedule": [
      {"time": "06:00", "activity": "AM 06:00 올드쿼터 내 호텔 픽업 (정확한 시간·차량번호는 전날 밤 10시경 전달)"},
      {"time": "08:30", "activity": "AM 08:30 하롱국제 크루즈 선착장 하차"},
      {"time": "16:00", "activity": "크루즈 하선 후 선착장 앞 차량 탑승 (크루즈 직원 안내)"},
      {"time": "19:00", "activity": "하노이 올드쿼터 하차 (교통상황에 따라 상이)"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '하노이 올드쿼터(호안끼엠 인근) 왕복 또는 편도 차량 서비스',
  '올드쿼터 외 지역 픽업·드랍, 항공요금 및 공항픽드랍',
  NULL, NULL,
  NULL,
  NULL,
  3
);
