-- ============================================================================
-- 하노이 원데이 당일투어 데이터 INSERT
-- ============================================================================
-- 실행 전 011-tour-system-tables-2026.sql 먼저 실행 필요
-- 하노이 원데이 투어 상품 전체 정보 입력

BEGIN;

-- ============================================================================
-- 1. 투어 기본 정보 INSERT
-- ============================================================================

INSERT INTO tour (
  tour_code, tour_name, category, description, overview,
  duration, guide_language, group_type, location, starting_point, meeting_time,
  image_url, rating, is_active,
  min_age_free_applicable, contact_info, payment_notes, cancellation_policy_url
) VALUES (
  'HANOI_FULLDAY_PRIVATE_001',
  '하노이 원데이 당일투어',
  '하노이',
  '아침부터 저녁까지 풀타임으로 즐기는 하노이 최고의 원데이 투어. 호치민 관저, 문묘, 쩐꾸옥 사원, 기찻길카페, 시티투어 버스를 모두 포함하는 알찬 일정. 한국어 국제가이드의 안전한 동행으로 하노이의 풍성한 역사와 문화를 체험.',
  '아침부터 저녁까지 시끄럽고 복잡한 하노이 오토바이 사이에서 안전한 여행을 할 수 있도록 스테이하롱이 준비한 풀타임 당일투어. 호치민 주석의 검소한 삶의 흔적, 베트남 최초 교육기관의 유학문화, 1500년 역사의 사원, 하노이의 현대 발전상까지 한 날에 모두 경험할 수 있는 완벽한 프로그램입니다.',
  '당일 (08:00-17:00, 약 9시간)',
  ARRAY['한국어'],
  'private',
  '하노이',
  '호텔 또는 지정 위치',
  '08:00',
  'https://stayhalong.com/images/tours/hanoi-fullday.jpg',
  4.8,
  true,
  3,
  '{"kakao_channel": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84)039 433 4065", "phone_kr": "070-4554-5185", "kakao_talk_id": "stayhalong"}',
  '예약금: 신용카드 20% (원화송금) | 잔금: 투어당일 가이드에게 현금지불 (베트남동)',
  'https://cafe.naver.com/stayhalong/784'
);

-- ============================================================================
-- 2. 인원별 가격 정보 INSERT
-- ============================================================================

INSERT INTO tour_pricing (
  tour_id, min_guests, max_guests, price_per_person, vehicle_type, deposit_amount, deposit_rate,
  deposit_payment_method, balance_payment_method, balance_currency,
  season_key, valid_from, valid_until
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 1, 4300000, '승용차', 860000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 2, 2, 2450000, '승용차', 490000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 3, 3, 1900000, 'SUV', 380000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 4, 4, 1750000, '기아 카니발', 350000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 5, 5, 1600000, '9인승 리무진', 320000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 6, 6, 1450000, '9인승 리무진', 290000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 7, 7, 1320000, '9인승 리무진', 264000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 8, 8, 1340000, '11인승 리무진', 268000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 9, 9, 1250000, '11인승 리무진', 250000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE);

-- ============================================================================
-- 3. 포함사항 INSERT
-- ============================================================================

INSERT INTO tour_inclusions (tour_id, order_seq, description, category, icon) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, '투어 중 이동 단독차량', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 2, '국제가이드 자격소지 한국어 현지 가이드', 'guide', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 3, '투어코스 입장료 / 티켓 / 커피 / 반미', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 4, '시티투어 버스 티켓', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 5, '하노이 시내 호텔 또는 목적지까지 드랍', 'transportation', '✓');

-- ============================================================================
-- 4. 불포함사항 INSERT
-- ============================================================================

INSERT INTO tour_exclusions (tour_id, order_seq, description, category, estimated_price) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, '점심식사', 'meal', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 2, '가이드 팁 (투어만족 시 자유)', 'tip', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 3, '개인경비 (음료 등)', 'other', NULL);

-- ============================================================================
-- 5. 추가옵션 INSERT
-- ============================================================================

INSERT INTO tour_addon_options (
  tour_id, option_name, option_category, description, price, price_type, duration_minutes, order_seq,
  is_guide_escort_fee, is_post_tour_optional, is_available
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '문묘 → 쩐꾸옥 사원 변경', 'activity', '베트남 최초 교육기관 문묘(1076년) 대신 1500년 역사 쩐꾸옥 사원(서호) 선택. 할인 적용.', -50000, 'per_person', 90, 1, false, false, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '세레네 스파 60분 마사지 추가', 'service', '투어 종료 후 세레네 스파에서 60분 아로마 마사지 추가 (별도 예약, 별도 결제)', 0, 'per_person', 60, 2, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '가이드 쇼핑동행 (20:00까지)', 'other', '투어 종료 후 기념품 쇼핑 등 동행. 20:00까지 추가 동행 가능.', 300000, 'per_team', 120, 3, true, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '투어코스 순서 변경', 'other', '제공된 일정을 가이드와 협의하여 변경 가능', 0, 'per_team', 0, 4, false, false, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '아동 성장판 마사지 (스파 옵션)', 'service', '스파 추가 시 아동을 위한 성장판 마사지로 대체 가능', 0, 'per_person', 60, 5, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '임산부 발마사지 (스파 옵션)', 'service', '스파 추가 시 임산부를 위한 발마사지로 대체 가능', 0, 'per_person', 60, 6, false, true, true);

-- ============================================================================
-- 6. 일정/스케줄 INSERT
-- ============================================================================

INSERT INTO tour_schedule (tour_id, day_number, order_seq, start_time, end_time, activity_name, duration_minutes, optional, notes) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 1, '08:00', '08:30', '가이드 미팅 및 오리엔테이션', 30, false, '{"location": "호텔 또는 지정 위치"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 2, '08:30', '10:00', '호치민 관저 투어', 90, false, '{"location": "호치민 관저", "description": "베트남 초대주석 호치민의 검소한 삶과 11년간의 국정운영 흔적"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 3, '10:00', '11:30', '하노이 문묘 또는 쩐꾸옥 사원', 90, false, '{"activities": ["문묘: 1076년 개교, 베트남 최초 교육기관, 유학문화 중심", "쩐꾸옥: 1500년 역사 사찰, 서호 경관"], "changeable": true}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 4, '11:30', '12:30', '점심식사 (자유식사)', 60, false, '{"meal": true, "payment": "on-site", "note": "원하는 식당 선택 가능"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 5, '12:30', '13:30', '카페지앙 에그커피', 60, false, '{"location": "카페지앙", "specialty": "하노이 명물 에그커피", "included": true}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 6, '13:30', '15:00', '쩐꾸옥 사원 또는 기찻길 카페', 90, false, '{"note": "문묘 선택 시 쩐꾸옥, 쩐꾸옥 선택 시 기찻길 카페"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 7, '15:00', '16:00', '기찻길 카페 (기차가 달리는 카페)', 60, false, '{"location": "하노이 올드쿼터 기찻길", "featured": true, "note": "인생사진 촬영"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 8, '16:00', '17:00', '시티투어 버스 (2층 버스)', 60, false, '{"location": "하노이 시내", "description": "높은 곳에서 보는 하노이의 색다른 경관, 역사와 문화 설명"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 1, 9, '17:00', NULL, '투어 종료 및 호텔 드랍', 0, false, '{"end": true, "options": "스파 추가 예약 또는 가이드 쇼핑동행(20:00까지) 선택 가능"}');

-- ============================================================================
-- 7. 취소정책 INSERT
-- ============================================================================

INSERT INTO tour_cancellation_policy (
  tour_id, policy_name, order_seq, days_before_min, days_before_max,
  penalty_type, penalty_amount, penalty_rate, description, refundable
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '일반 취소 정책', 1, 0, 999, 'rate', NULL, NULL, '자세한 취소 규정은 카페 게시판 참고 (링크: https://cafe.naver.com/stayhalong/784)', false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '불가항력 취소', 2, 0, 999, 'rate', NULL, NULL, '기상악화, 천재지변 등 불가항력적 이유로 투어 취소 시 전액 환불', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), '당사 사정 취소', 3, 0, 999, 'rate', NULL, NULL, '당사의 사정으로 투어 취소 시 전액 환불 또는 날짜 변경', true);

-- ============================================================================
-- 8. 중요 정보/주의사항 INSERT
-- ============================================================================

INSERT INTO tour_important_info (tour_id, info_type, content, order_seq, is_highlighted) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'notice', '3세 미만 유아는 요금 미적용하나, 아동으로 인해 차량변경이 필요할 경우 차량요금 변경', 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'guide', '5세 이상 아동은 성인과 동일 요금 적용', 2, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'caution', '투어코스 순서는 가이드와 협의하여 변경 가능', 3, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'notice', '문묘 대신 쩐꾸옥 사원 선택 시 1인당 50,000동 할인', 4, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'guide', '점심시간 12:30, 자유로이 원하는 식당에서 식사 (개별결제)', 5, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'notice', '세레네 스파는 투어 종료 후 별도 예약 및 결제 (선택옵션)', 6, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'guide', '가이드 쇼핑동행: 20:00까지 추가 동행 가능 (1인당 300,000동)', 7, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'guide', '국제가이드 자격소지 한국어 가이드가 하노이의 역사, 문화, 현대발전상에 대해 성실하게 설명', 8, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'notice', '예약금: 신용카드 20% (원화송금) | 잔금: 투어당일 가이드에게 베트남동 현금 지불', 9, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'notice', '본 투어는 예약자 팀만을 위한 단독투어 (조인투어 아님)', 10, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'guide', '투어코스 입장료 변경이 있는 경우 요금 변경 가능', 11, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001'), 'guide', '예약 및 상담: 스테이하롱 카카오채널 (http://pf.kakao.com/_zvsxaG/chat)', 12, false);

SELECT 'INSERT COMPLETE' AS status;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================

-- 투어 정보 확인
-- SELECT 
--   tour_code, tour_name, category, duration, group_type, meeting_time
-- FROM tour 
-- WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001';

-- 가격 정보 확인
-- SELECT 
--   min_guests, max_guests, price_per_person, vehicle_type, deposit_amount
-- FROM tour_pricing 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001')
-- ORDER BY min_guests;

-- 추가옵션에서 가이드동행료 확인
-- SELECT 
--   option_name, price, is_guide_escort_fee, is_post_tour_optional
-- FROM tour_addon_options 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001')
-- ORDER BY order_seq;

-- 전체 데이터 수 확인
-- SELECT
--   'Inclusions' AS type, COUNT(*) FROM tour_inclusions WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001')
-- UNION ALL
-- SELECT 'Exclusions' AS type, COUNT(*) FROM tour_exclusions WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001')
-- UNION ALL
-- SELECT 'Options' AS type, COUNT(*) FROM tour_addon_options WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001')
-- UNION ALL
-- SELECT 'Schedules' AS type, COUNT(*) FROM tour_schedule WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001')
-- UNION ALL
-- SELECT 'Policies' AS type, COUNT(*) FROM tour_cancellation_policy WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001')
-- UNION ALL
-- SELECT 'Info' AS type, COUNT(*) FROM tour_important_info WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_FULLDAY_PRIVATE_001');
