-- ============================================================================
-- 밧짱 도자기 마을 단독투어 데이터 INSERT
-- ============================================================================
-- 실행 전 011-tour-system-tables-2026.sql 먼저 실행 필요
-- 밧짱 도자기 마을 투어 상품 전체 정보 입력

BEGIN;

-- ============================================================================
-- 1. 투어 기본 정보 INSERT
-- ============================================================================

INSERT INTO tour (
  tour_code, tour_name, category, description, overview,
  duration, guide_language, group_type, location, starting_point, meeting_time,
  image_url, rating, is_active,
  contact_info, payment_notes, cancellation_policy_url
) VALUES (
  'HANOI_BATTRANG_PRIVATE_001',
  '밧짱 도자기 마을 단독투어',
  '밧짱',
  '700년 이상의 역사를 자랑하는 전통 도자기 마을 밧짱에서 즐기는 프라이빗 투어. 도자기 공예관, 박물관, 직접 만들기 체험을 통해 베트남의 전통 수공예 문화를 체험. 강요 없는 자유로운 도자기 구입 선택권.',
  '700년 이상의 깊은 역사를 지닌 전통 도자기 마을 밧짱은 리왕조 시대부터 형성된 베트남의 대표적 수공예 문화 중심지입니다. 9개의 도자기 공예관과 23개의 박물관에서 베트남의 전통 문화를 체험할 수 있으며, 직접 도자기를 만들어보는 체험 프로그램으로 더욱 의미있는 여행이 됩니다.',
  '당일 (08:00-16:30, 약 8.5시간)',
  ARRAY['한국어'],
  'private',
  '밧짱',
  '호텔 로비',
  '08:00',
  'https://stayhalong.com/images/tours/bat-trang.jpg',
  4.7,
  true,
  '{"kakao_channel": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84)039 433 4065", "phone_kr": "070-4554-5185", "kakao_talk_id": "stayhalong"}',
  '예약금: 1인당 50만동 현금 또는 신용카드 | 잔금: 투어당일 가이드에게 베트남동 현금 지불 (환전수수료 +3% 원화송금시)',
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
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 1, 4200000, '승용차', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 2, 2, 2300000, '승용차', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 3, 3, 1770000, 'SUV', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 4, 4, 1625000, '기아 카니발', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 5, 5, 1460000, '9인승 리무진', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 6, 6, 1300000, '9인승 리무진', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 7, 7, 1185000, '9인승 리무진', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 8, 8, 1225000, '11인승 리무진', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 9, 9, 1150000, '11인승 리무진', 500000, NULL, 'both', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE);

-- ============================================================================
-- 3. 포함사항 INSERT
-- ============================================================================

INSERT INTO tour_inclusions (tour_id, order_seq, description, category, icon) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, '투어 인원에 맞춰 배차된 차량 (기사님 팁 포함)', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 2, '외국인 국제가이드 자격소지 한국어 가능한 현지 가이드', 'guide', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 3, '도자기 공예관, 도자기전시장, 박물관 입장료', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 4, '도자기 만들기 체험비용', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 5, '베트남 최초 대학교 하노이 문묘 투어', 'activity', '✓');

-- ============================================================================
-- 4. 불포함사항 INSERT
-- ============================================================================

INSERT INTO tour_exclusions (tour_id, order_seq, description, category, estimated_price) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, '점심식사 및 음료', 'meal', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 2, '도자기 구입 (강요 없음, 자유 선택)', 'shopping', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 3, '가이드 팁 (의무 아님, 약 10만동 권장)', 'tip', 100000),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 4, '투어 후 공항으로의 이동 (별도 비용)', 'transportation', 600000),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 5, '마사지 서비스 (연계 가능, 별도 결제)', 'service', NULL);

-- ============================================================================
-- 5. 추가옵션 INSERT
-- ============================================================================

INSERT INTO tour_addon_options (
  tour_id, option_name, option_category, description, price, price_type, duration_minutes, order_seq,
  is_guide_escort_fee, is_post_tour_optional, is_available
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '공항드롭 (일반차량)', 'transport', '투어 종료 후 공항으로의 이동 (20분 소요, 팀당). 투어 가격에 포함된 차량 기준.', 600000, 'per_team', 20, 1, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '공항드롭 (리무진)', 'transport', '투어 종료 후 리무진으로 공항 이동 (팀당). 일반차량 기준 + 추가 60만동.', 600000, 'per_team', 20, 2, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '마사지샵 연계', 'service', '투어 종료 후 세레네 스파 등 마사지샵 연계 (별도 예약/결제)', 0, 'per_person', 60, 3, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '마사지 후 공항드롭', 'service', '마사지 후 공항으로 이동. 투어 이동시간(20분) + 공항드롭비용 별도 발생.', 0, 'per_team', 80, 4, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '도자기 구입 및 배송', 'other', '도자기마을에서 구입한 도자기 배송 서비스 (협의 후 별도 비용)', 0, 'per_person', 0, 5, false, true, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '투어 코스 순서 변경', 'other', '제공된 일정을 가이드와 협의하여 변경 가능 (날씨, 상황에 따라 조정)', 0, 'per_team', 0, 6, false, false, true);

-- ============================================================================
-- 6. 일정/스케줄 INSERT
-- ============================================================================

INSERT INTO tour_schedule (tour_id, day_number, order_seq, start_time, end_time, activity_name, duration_minutes, optional, notes) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 1, '21:00', '21:30', '투어 전날 준비안내', 30, false, '{"day": -1, "note": "차량번호, 가이드 미팅시간, 준비물 전달"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 2, '08:00', '08:30', '가이드 미팅 및 차량 탑승', 30, false, '{"location": "숙박 호텔 로비"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 3, '08:30', '10:00', '밧짱 도자기 마을 투어 (1차)', 90, false, '{"location": "밧짱", "activities": ["도자기 공예관", "도자기전시장 방문"]}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 4, '10:00', '11:30', '하노이 문묘 투어', 90, false, '{"location": "하노이 문묘", "description": "베트남 최초 대학교, 유학문화 가이드 설명"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 5, '11:30', '12:30', '이동 및 점심준비', 60, false, '{"meal": false, "note": "식당 안내 및 예약 도움"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 6, '12:30', '13:30', '점심식사 (자유)', 60, false, '{"meal": true, "payment": "on-site", "note": "도자기마을 내 현지식당 추천"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 7, '13:30', '15:30', '밧짱 도자기 마을 투어 (2차)', 120, false, '{"location": "밧짱", "activities": ["아트스페이스 방문", "박물관 투어", "도자기 만들기 체험"], "experience": true, "note": "기념 도자기 제품 구입 가능 (강요 없음)"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 8, '15:30', '16:30', '이동 및 정리', 60, false, '{"transition": true}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 1, 9, '16:30', NULL, '투어 종료 및 드랍', 0, false, '{"end": true, "options": "공항드롭 또는 호텔 드랍 (선택)"}');

-- ============================================================================
-- 7. 취소정책 INSERT
-- ============================================================================

INSERT INTO tour_cancellation_policy (
  tour_id, policy_name, order_seq, days_before_min, days_before_max,
  penalty_type, penalty_amount, penalty_rate, description, refundable
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '16일 이상 전 취소', 1, 16, 999, 'rate', NULL, NULL, '투어 예정일 16일 전까지는 무료 취소 가능', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '6~15일 전 취소', 2, 6, 15, 'rate', NULL, 0.50, '투어 6~15일 전 취소 시 수령한 예약금의 50% 환불', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '5일 이내 취소', 3, 0, 5, 'rate', NULL, 0.00, '투어일자까지 5일 이내가 남은 경우 취소 불가 (예약금 전액 반환 불가)', false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), '기상악화 등 불가항력', 4, 0, 999, 'rate', NULL, NULL, '기상악화 등으로 투어 안전에 위험이 있을 시 투어 취소, 전액 환불 또는 날짜 변경', true);

-- ============================================================================
-- 8. 중요 정보/주의사항 INSERT
-- ============================================================================

INSERT INTO tour_important_info (tour_id, info_type, content, order_seq, is_highlighted) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '본상품은 "예약자 팀"만을 위한 단독투어 상품입니다. (조인투어 아님)', 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'guide', '투어 프로그램의 순서는 투어 당일 가이드와 협의하여 변경 가능', 2, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '도자기 구입이나 쇼핑은 강요 없으며, 원하실 경우 구입 가능', 3, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'caution', '비가 와도 투어는 정상 진행 (다만 폭우 등의 경우 일정 조정)', 4, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'guide', '가이드는 국제 가이드 자격소지, 한국어 소통 능숙한 경험 풍부한 현지 가이드', 5, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '예약금: 1인당 50만동 (현금 또는 신용카드) | 잔금: 투어당일 현금 (베트남동)', 6, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '잔금을 원화 송금 시 환전수수료 3% 추가 발생', 7, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'guide', '투어 후 지불(후불결제)은 어떠한 경우에도 불가능', 8, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '차량요금에는 기사님 팁이 포함, 가이드 팁(약 10만동)은 의무 아님', 9, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '투어 후 공항드롭 시 팀당 60만동 (리무진은 +60만동)', 10, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'guide', '마사지샵 연계 가능, 마사지 후 공항드롭도 가능 (별도 비용)', 11, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '투어 일자 변경은 투어일 10일 전까지만 가능', 12, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'guide', '투어 전날 21:00~21:30에 차량번호, 가이드 정보, 준비물 안내', 13, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001'), 'notice', '예약 및 상담은 카카오채널을 통해 진행 (http://pf.kakao.com/_zvsxaG/chat)', 14, false);

SELECT 'INSERT COMPLETE' AS status;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================

-- 투어 정보 확인
-- SELECT 
--   tour_code, tour_name, category, duration, group_type, meeting_time
-- FROM tour 
-- WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001';

-- 가격 정보 확인 (1인당 50만동 예약금 고정)
-- SELECT 
--   min_guests, max_guests, price_per_person, vehicle_type, deposit_amount
-- FROM tour_pricing 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- ORDER BY min_guests;

-- 공항드롭 옵션 확인
-- SELECT 
--   option_name, price, price_type, is_post_tour_optional
-- FROM tour_addon_options 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- AND option_name LIKE '%공항%'
-- ORDER BY order_seq;

-- 취소정책 확인 (16일, 6-15일, 5일 이내)
-- SELECT 
--   policy_name, days_before_min, days_before_max, penalty_rate, refundable
-- FROM tour_cancellation_policy 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- ORDER BY order_seq;

-- 전체 데이터 수 확인
-- SELECT
--   'Inclusions' AS type, COUNT(*) FROM tour_inclusions WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- UNION ALL
-- SELECT 'Exclusions' AS type, COUNT(*) FROM tour_exclusions WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- UNION ALL
-- SELECT 'Options' AS type, COUNT(*) FROM tour_addon_options WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- UNION ALL
-- SELECT 'Schedules' AS type, COUNT(*) FROM tour_schedule WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- UNION ALL
-- SELECT 'Policies' AS type, COUNT(*) FROM tour_cancellation_policy WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001')
-- UNION ALL
-- SELECT 'Info' AS type, COUNT(*) FROM tour_important_info WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_BATTRANG_PRIVATE_001');
