-- =====================================================
-- 028-ambassador-cruise-info-2026.sql
-- 엠바사더 크루즈 상세 정보
-- 당일크루즈 / 5성급 / 중대형급 / 한국어 안내방송
-- =====================================================
-- 실행 전 011-cruise-info-columns.sql 먼저 실행 필요

-- 기존 엠바사더 크루즈 데이터 삭제 (재실행 가능하도록)
DELETE FROM cruise_info WHERE cruise_code LIKE 'AMB-%' OR cruise_name = '엠바사더 크루즈';

-- ── 공통 데이터 ──
-- 크루즈명: 엠바사더 크루즈 (AMBASSADOR CRUISE)
-- 등급: 5성급 / 중대형급
-- 일정: 당일크루즈
-- 투어코스: 승솟동굴 · 티톱섬 · 루온동굴
-- 특징: 한국어 일정표·안내방송 제공, 다양한 뷔페식사, 별도 프라이빗 객실 옵션
-- 예약마감: 출항일자 기준 3일 전부터 예약접수 불가
-- 결제: 신용카드 결제만 가능

-- =====================================================
-- 1. 엠바사더 리무진 패키지 (차량 포함)
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
  'AMB-LIM', '엠바사더 크루즈', 'Ambassador Cruise',
  '하롱베이 5성급 당일크루즈. 한국 관광객에게 가장 유명한 대표 당일크루즈. 승솟동굴·티톱섬·루온동굴 투어코스. 중대형급 크루즈. 한국어 일정표·안내방송 제공. 다양한 뷔페식사. 별도 프라이빗 객실 옵션. 스테이하롱 공식 에이전트. 출항 3일 전부터 예약접수 불가.',
  '당일', '데이크루즈',
  '엠바사더 리무진 패키지 (차량 포함)', NULL,
  '서머셋 그랜드 하노이 승·하차 + 크루즈 셔틀차량 왕복 포함 패키지. 2026년 6월 30일까지 승선만 해당. 성인 1인당 2,150,000동 / 만 5~12세 1,800,000동 / 만 2~4세 1,600,000동 / 만 2세 미만 850,000동. 성인에 한해 소프트드링크(콜라·사이다·환타·캔맥주) 1캔 무료 제공. 전쟁으로 인한 유류할증료 인상으로 1인당 50,000동 한시적 추가. 2026년 4월 15일부터는 크루즈 요금도 1인당 50,000동 추가(총 1인당 100,000동 한시적 추가).',
  NULL, 1, 1, false, false, false,
  false, false, false,
  '한국어 안내방송 및 한국어 일정표 제공. 셔틀차량: 대형버스 또는 16인승 합밴 랜덤배정. 세계 각국 불특정 다수가 함께 승차하는 차량으로 다소 소란스러울 수 있음. 차량좌석 지정 불가, 남는 자리에 승차. 차량운행·픽업순서·드랍순서는 크루즈사 담당(여행자 개입 불가). 이동 중 진주 상품 또는 공예품 판매 쇼핑몰에 정차할 수 있음. 호안끼엠 지역에서만 픽업·드랍 가능(기본 픽업위치: 서머셋 그랜드 하노이). 주말·차없는 거리 픽업·드랍은 차량진입 가능한 가장 가까운 위치로 변경.',
  '당일크루즈는 중국 단체관광객으로 인한 혼잡·소란이 있을 수 있습니다. 특히 점심뷔페 시 새치기·밀치기 등 마찰이 잦습니다. 부모님을 모시는 여행에는 추천하지 않습니다. 티톱섬 전망대 계단이 다소 험하므로 주의 필요. 음료 및 주류 반입 시 콜키지 비용 발생 가능. 외부음식 반입 가능. 출항일자 기준 3일 전부터 예약접수 불가. 차량정보(번호·시간)는 투어 전날 밤 21~22시 전달.',
  '[
    {"day": 1, "title": "당일일정", "schedule": [
      {"time": "06:45", "activity": "호안끼엠에서 픽업 - 서머셋 그랜드 하노이 앞 기본 픽업, 차량정보(번호·시간)는 전날 밤 21~22시 전달"},
      {"time": "08:30", "activity": "휴게소 1회 정차 - 안전사고 예방을 위해 모두 하차"},
      {"time": "08:50", "activity": "선착장 도착 및 하차 - 대기 중인 크루즈 직원이 안내"},
      {"time": "09:00", "activity": "크루즈 승선 및 자리착석 - 레스토랑 지정좌석 크루즈 직원 안내"},
      {"time": "10:30", "activity": "승솟동굴 투어 - 영어가이드 동행, 외부투어 시 현금 지참 권장 (매점 카드 불가)"},
      {"time": "11:30", "activity": "티톱섬 투어 - 전망대(험한 계단, 주의) 또는 해변 휴식, 현금 지참 권장"},
      {"time": "12:00", "activity": "점심식사 (뷔페) - 각종 BBQ·해산물·사시미 등으로 구성"},
      {"time": "13:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택 (카약 별도요금)"},
      {"time": "15:00", "activity": "해피아워 및 공연 - 간식 제공, 날씨 불량 시 실내 진행"},
      {"time": "16:15", "activity": "크루즈 하선 - 크루즈 직원 안내에 따라 하노이 복귀 차량 탑승"},
      {"time": "16:30", "activity": "차량 승차 및 하노이 이동 - 약 3시간 소요 (도로상황에 따라 상이)"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"},
    {"condition": "교통사고·생명위급 질병 입원 (영문진단서 제출 필요)", "penalty": "크루즈사 심사 후 환자 본인에 한해 예외 적용 가능 (100% 보장 아님)"},
    {"condition": "환불 처리 기간", "penalty": "취소신청서 작성일부터 통상 2개월 (주말·공휴일·명절 제외). 신용카드 결제 시 카드매출 취소 가능 시점은 카드사 취소, 불가 시 베트남동 기준으로 취소 당일 네이버 환율(하나은행 매매기준율, 환율우대 미적용)로 원화 환산 반환"}
  ]'::jsonb,
  '웰컴드링크, 아침조식, 점심식사(뷔페), 뱀부보트, 승솟동굴 투어, 티톱섬 투어, 해피아워, 자쿠지 이용, 영어가이드',
  '카약킹, 음료 및 주류, 프라이빗 객실, 랍스터',
  5, NULL,
  NULL,
  '["자쿠지 (성인 이용 부적합, 아이들 물놀이 수준)", "프라이빗 객실: 디럭스룸(1층) 욕실+침대(더블/트윈 랜덤)+오션뷰 발코니, 6명 정원, 객실당 150만동", "프라이빗 객실: 프리미엄룸(2층) 욕실+침대(더블/트윈 랜덤)+오션뷰 발코니, 6명 정원, 객실당 175만동", "1층 리셉션 (프라이빗 객실카드 수령)", "하롱국제 크루즈 선착장: 마트·스타벅스·하이랜드 커피 운영", "선착장 공용화장실 (1층·2층)", "선착장 실내 금연 (외부 흡연 가능)", "윈덤 하롱 호텔에서 도보 5분", "솔레일 하롱 호텔에서 도보 약 15분", "하얏트 플레이스·래디슨블루·더요트 호텔에서 차량 약 10분"]'::jsonb,
  1
);

-- =====================================================
-- 2. 크루즈 티켓 (차량 제외)
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
  'AMB-TKT', '엠바사더 크루즈', 'Ambassador Cruise',
  '하롱베이 5성급 당일크루즈. 한국 관광객에게 가장 유명한 대표 당일크루즈. 승솟동굴·티톱섬·루온동굴 투어코스. 중대형급 크루즈. 한국어 일정표·안내방송 제공. 다양한 뷔페식사. 별도 프라이빗 객실 옵션. 스테이하롱 공식 에이전트. 출항 3일 전부터 예약접수 불가.',
  '당일', '데이크루즈',
  '크루즈 티켓 (이동차량 제외)', NULL,
  '이동차량이 제외된 크루즈 티켓 요금. 요일에 따른 요금차이 없이 모든 요일 동일. 성인 1인당 1,600,000동 / 만 5~12세 1,350,000동 / 만 2~4세 1,200,000동 / 만 2세 미만 350,000동. 2026년 4월 15일부터 크루즈 요금 1인당 50,000동 한시적 추가.',
  NULL, 1, 1, false, false, false,
  false, false, false,
  '한국어 안내방송 및 한국어 일정표 제공. 체크인 방법(단독차량 이용 시): 하롱국제 크루즈 선착장 건물 앞 하차 → 건물 실내 엠바사더 대기실로 이동 → 직원에게 승선코드 제시 → 체크인 카운터 안내 → 잠시 대기 후 전기차로 약 2분 이동하여 승선.',
  '당일크루즈는 중국 단체관광객으로 인한 혼잡·소란이 있을 수 있습니다. 특히 점심뷔페 시 새치기·밀치기 등 마찰이 잦습니다. 부모님을 모시는 여행에는 추천하지 않습니다. 티톱섬 전망대 계단이 다소 험하므로 주의 필요. 음료 및 주류 반입 시 콜키지 비용 발생 가능. 외부음식 반입 가능. 출항일자 기준 3일 전부터 예약접수 불가.',
  '[
    {"day": 1, "title": "당일일정", "schedule": [
      {"time": "08:50", "activity": "하롱국제 크루즈 선착장 도착 - 건물 실내 엠바사더 대기실로 이동, 승선코드 제시 후 체크인, 전기차 탑승 후 약 2분 이동하여 승선"},
      {"time": "09:00", "activity": "크루즈 승선 및 자리착석 - 레스토랑 지정좌석 크루즈 직원 안내"},
      {"time": "10:30", "activity": "승솟동굴 투어 - 영어가이드 동행, 외부투어 시 현금 지참 권장 (매점 카드 불가)"},
      {"time": "11:30", "activity": "티톱섬 투어 - 전망대(험한 계단, 주의) 또는 해변 휴식, 현금 지참 권장"},
      {"time": "12:00", "activity": "점심식사 (뷔페) - 각종 BBQ·해산물·사시미 등으로 구성"},
      {"time": "13:30", "activity": "루온동굴 투어 - 카약 또는 뱀부보트 선택 (카약 별도요금)"},
      {"time": "15:00", "activity": "해피아워 및 공연 - 간식 제공, 날씨 불량 시 실내 진행"},
      {"time": "16:15", "activity": "크루즈 하선"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"},
    {"condition": "교통사고·생명위급 질병 입원 (영문진단서 제출 필요)", "penalty": "크루즈사 심사 후 환자 본인에 한해 예외 적용 가능 (100% 보장 아님)"},
    {"condition": "환불 처리 기간", "penalty": "취소신청서 작성일부터 통상 2개월 (주말·공휴일·명절 제외). 신용카드 결제 시 카드매출 취소 가능 시점은 카드사 취소, 불가 시 베트남동 기준으로 취소 당일 네이버 환율(하나은행 매매기준율, 환율우대 미적용)로 원화 환산 반환"}
  ]'::jsonb,
  '웰컴드링크, 아침조식, 점심식사(뷔페), 뱀부보트, 승솟동굴 투어, 티톱섬 투어, 해피아워, 자쿠지 이용, 영어가이드',
  '카약킹, 음료 및 주류, 이동차량, 프라이빗 객실, 랍스터',
  5, NULL,
  NULL,
  '["자쿠지 (성인 이용 부적합, 아이들 물놀이 수준)", "프라이빗 객실: 디럭스룸(1층) 욕실+침대(더블/트윈 랜덤)+오션뷰 발코니, 6명 정원, 객실당 150만동", "프라이빗 객실: 프리미엄룸(2층) 욕실+침대(더블/트윈 랜덤)+오션뷰 발코니, 6명 정원, 객실당 175만동", "1층 리셉션 (프라이빗 객실카드 수령)", "하롱국제 크루즈 선착장: 마트·스타벅스·하이랜드 커피 운영", "선착장 공용화장실 (1층·2층)", "선착장 실내 금연 (외부 흡연 가능)"]'::jsonb,
  2
);

-- =====================================================
-- 3. 호안끼엠-선착장 셔틀리무진 (왕복)
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
  'AMB-SHT', '엠바사더 크루즈', 'Ambassador Cruise',
  '하롱베이 5성급 당일크루즈. 한국 관광객에게 가장 유명한 대표 당일크루즈. 승솟동굴·티톱섬·루온동굴 투어코스. 중대형급 크루즈. 한국어 일정표·안내방송 제공. 다양한 뷔페식사. 별도 프라이빗 객실 옵션. 스테이하롱 공식 에이전트. 출항 3일 전부터 예약접수 불가.',
  '당일', '데이크루즈',
  '호안끼엠-선착장 셔틀리무진 (왕복 1인당 750,000동)', NULL,
  '호안끼엠 지역 픽업·드랍 전용 셔틀리무진. 1인당 왕복 750,000동. 대형버스 또는 16인승 합밴 랜덤배정. 호안끼엠 지역에서만 픽업·드랍 가능(기본 픽업위치: 서머셋 그랜드 하노이). 다른 사람들과의 동승이 불편한 경우 VEXERE 등을 통해 단독차량 예약 가능(저희 예약대행 가능, 단 당사 제공 서비스 아님).',
  NULL, 1, 1, false, false, false,
  false, false, false,
  NULL,
  '세계 각국 불특정 다수가 함께 승차하는 차량으로 다소 소란스러울 수 있음. 차량좌석 지정 불가, 남는 자리에 승차. 차량운행·픽업순서·드랍순서는 크루즈사 담당(여행자 개입 불가). 이동 중 진주 상품 또는 공예품 판매 쇼핑몰에 정차할 수 있음. 주말·차없는 거리 픽업·드랍은 차량진입 가능한 가장 가까운 위치로 변경. 차량정보(번호·시간)는 투어 전날 밤 21~22시 전달.',
  '[
    {"day": 1, "title": "셔틀리무진 운행일정", "schedule": [
      {"time": "06:45", "activity": "호안끼엠에서 픽업 - 서머셋 그랜드 하노이 앞 기본 픽업, 차량정보(번호·시간)는 전날 밤 21~22시 전달"},
      {"time": "08:30", "activity": "휴게소 1회 정차"},
      {"time": "08:50", "activity": "선착장 도착 및 하차 - 크루즈 직원 명단 확인 후 승선 안내"},
      {"time": "16:15", "activity": "크루즈 하선 후 크루즈 직원 안내에 따라 하노이 복귀 차량 탑승"},
      {"time": "16:30", "activity": "하노이 이동 - 약 3시간 소요 (도로상황에 따라 상이)"}
    ]}
  ]'::jsonb,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '호안끼엠 지역(서머셋 그랜드 하노이 기본) 왕복 차량 서비스',
  '호안끼엠 외 지역 픽업·드랍, 단독차량 이용',
  NULL, NULL,
  NULL,
  NULL,
  3
);

-- =====================================================
-- 4. 프라이빗 객실 디럭스룸 (1층)
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
  'AMB-DLX', '엠바사더 크루즈', 'Ambassador Cruise',
  '하롱베이 5성급 당일크루즈. 한국 관광객에게 가장 유명한 대표 당일크루즈. 승솟동굴·티톱섬·루온동굴 투어코스. 중대형급 크루즈. 한국어 일정표·안내방송 제공. 다양한 뷔페식사. 별도 프라이빗 객실 옵션. 스테이하롱 공식 에이전트. 출항 3일 전부터 예약접수 불가.',
  '당일', '데이크루즈',
  '프라이빗 디럭스룸 (1층)', NULL,
  '크루즈 1층 프라이빗 객실. 객실당 1,500,000동. 욕실 및 침대(더블/트윈 랜덤) 제공. 완전한 오션뷰 발코니. 6명 정원. 크루즈 승선 후 1층 리셉션에서 객실카드 수령 후 입실. 디럭스(1층)·프리미엄(2층)은 객실 층 차이만 있으며 모든 것이 동일한 구성.',
  NULL, 6, 6, true, false, false,
  false, false, false,
  NULL,
  '침대 타입(더블/트윈)은 랜덤 배정으로 사전 지정 불가. 크루즈 사정에 따라 객실 이용이 불가할 수 있음. 객실카드는 승선 후 1층 리셉션에서 수령.',
  NULL,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '1층 프라이빗 객실 (욕실, 침대, 오션뷰 발코니)',
  '식사, 투어, 이동차량, 음료 및 주류',
  5, NULL,
  NULL,
  NULL,
  4
);

-- =====================================================
-- 5. 프라이빗 객실 프리미엄룸 (2층)
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
  'AMB-PRM', '엠바사더 크루즈', 'Ambassador Cruise',
  '하롱베이 5성급 당일크루즈. 한국 관광객에게 가장 유명한 대표 당일크루즈. 승솟동굴·티톱섬·루온동굴 투어코스. 중대형급 크루즈. 한국어 일정표·안내방송 제공. 다양한 뷔페식사. 별도 프라이빗 객실 옵션. 스테이하롱 공식 에이전트. 출항 3일 전부터 예약접수 불가.',
  '당일', '데이크루즈',
  '프라이빗 프리미엄룸 (2층)', NULL,
  '크루즈 2층 프라이빗 객실. 객실당 1,750,000동. 욕실 및 침대(더블/트윈 랜덤) 제공. 완전한 오션뷰 발코니. 6명 정원. 크루즈 승선 후 1층 리셉션에서 객실카드 수령 후 입실. 디럭스(1층)·프리미엄(2층)은 객실 층 차이만 있으며 모든 것이 동일한 구성.',
  NULL, 6, 6, true, false, false,
  false, false, false,
  NULL,
  '침대 타입(더블/트윈)은 랜덤 배정으로 사전 지정 불가. 크루즈 사정에 따라 객실 이용이 불가할 수 있음. 객실카드는 승선 후 1층 리셉션에서 수령.',
  NULL,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "천재지변, 태풍으로 인한 정부명령, 승선인원 미달, 크루즈사 사정에 따른 결항", "penalty": "전액 환불 보장"}
  ]'::jsonb,
  '2층 프라이빗 객실 (욕실, 침대, 오션뷰 발코니)',
  '식사, 투어, 이동차량, 음료 및 주류',
  5, NULL,
  NULL,
  NULL,
  5
);

-- =====================================================
-- 6. 랍스터 반마리 (옵션)
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
  'AMB-LBT', '엠바사더 크루즈', 'Ambassador Cruise',
  '하롱베이 5성급 당일크루즈. 한국 관광객에게 가장 유명한 대표 당일크루즈. 승솟동굴·티톱섬·루온동굴 투어코스. 중대형급 크루즈. 한국어 일정표·안내방송 제공. 다양한 뷔페식사. 별도 프라이빗 객실 옵션. 스테이하롱 공식 에이전트. 출항 3일 전부터 예약접수 불가.',
  '당일', '데이크루즈',
  '랍스터 반마리 (옵션)', NULL,
  '랍스터 반마리 추가 옵션. 1인당 300,000동. 조리방식: 칠리 또는 갈릭버터 선택. 크루즈 승선 후 주문이 어려울 수 있으므로 사전예약 권장. 랍스터 공급에 어려움이 있는 경우 취소될 수 있으며 이 경우 전액 환불.',
  NULL, 1, 1, false, false, false,
  false, false, false,
  NULL,
  '크루즈 승선 후 주문이 어려울 수 있으므로 사전예약 필수. 랍스터(칠리/갈릭버터) 공급에 어려움이 있는 경우 취소될 수 있음 (전액 환불).',
  NULL,
  '[
    {"condition": "이용일자 31일 전까지", "penalty": "100만동 위약금 발생"},
    {"condition": "이용일자 21~30일 전", "penalty": "10% 위약금"},
    {"condition": "이용일자 11~20일 전", "penalty": "20% 위약금"},
    {"condition": "이용일자 10일 전부터", "penalty": "취소 및 환불, 날짜변경 불가"},
    {"condition": "공급 불가로 인한 취소", "penalty": "전액 환불"}
  ]'::jsonb,
  '랍스터 반마리 (칠리 또는 갈릭버터 선택)',
  '식사, 투어, 이동차량, 음료 및 주류',
  5, NULL,
  NULL,
  NULL,
  6
);
