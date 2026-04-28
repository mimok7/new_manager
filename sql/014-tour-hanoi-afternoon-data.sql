-- ============================================================================
-- 하노이 오후 투어 데이터 INSERT
-- ============================================================================
-- 실행 전 011-tour-system-tables-2026.sql 먼저 실행 필요
-- 하노이 오후 투어 상품 전체 정보 입력

BEGIN;

-- ============================================================================
-- 1. 투어 기본 정보 INSERT
-- ============================================================================

INSERT INTO tour (
  tour_code, tour_name, category, description, overview,
  duration, guide_language, group_type, location, starting_point, meeting_time,
  image_url, rating, is_active,
  min_age_free_applicable, special_age_policy_description, contact_info, payment_notes, cancellation_policy_url
) VALUES (
  'HANOI_AFT_PRIVATE_001',
  '하노이 오후 투어',
  '하노이',
  '크루즈 투어 후 시간이 남을 때 즐기는 하노이 오후 투어. 기찻길카페, 문묘 또는 쩐꾸옥 사원, 전기차 시티투어, 세레네 스파를 포함한 알찬 5시간 프로그램. 늦은 비행기나 새벽 비행기로 출국하는 고객을 위해 마사지 후 샤워 가능.',
  '베트남의 수도 하노이는 관광도시로 유명하지는 않지만, 구도시 호안끼엠 외에도 신도시, 서호 등 다양한 볼거리를 가지고 있습니다. 스테이하롱의 하노이 오후 투어는 하노이를 보다 안전하고 즐겁게 즐길 수 있도록 역사, 문화, 현대 발전상을 모두 담아 구성한 프로그램입니다. 크루즈 투어 후 애매한 시간을 의미있게 보낼 수 있습니다.',
  '약 5시간 (14:30-19:30)',
  ARRAY['한국어'],
  'private',
  '하노이',
  '하노이 힐튼호텔 라인',
  '14:30',
  'https://stayhalong.com/images/tours/hanoi-afternoon.jpg',
  4.7,
  true,
  NULL,
  '5세 미만 아동은 요금 적용 안 함 (인원 미포함). 다만 차량 변경이 필요할 경우 차액은 부담해야 함.',
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
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, 1, 5000000, '승용차', 1000000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 2, 2, 2950000, '승용차', 590000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 3, 3, 2250000, 'SUV', 450000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 4, 4, 2175000, '기아 카니발', 435000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 5, 5, 1980000, '9인승 리무진', 396000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 6, 6, 1780000, '9인승 리무진', 356000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 7, 7, 1700000, '9인승 리무진', 340000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 8, 8, 1725000, '11인승 리무진', 345000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 9, 9, 1630000, '11인승 리무진', 326000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE);

-- ============================================================================
-- 3. 포함사항 INSERT
-- ============================================================================

INSERT INTO tour_inclusions (tour_id, order_seq, description, category, icon) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, '투어 중 이동 단독차량', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 2, '국제가이드 자격소지 한국어 현지 가이드', 'guide', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 3, '투어코스 입장료 / 티켓 / 커피', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 4, '하노이 힐튼 라인에서 제공하는 반미 1개', 'meal', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 5, '세레네 스파 60분 아로마 마사지 (아동 성장판, 임산부 발마사지 가능)', 'service', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 6, '하노이 시내 호텔 또는 목적지까지 드랍', 'transportation', '✓');

-- ============================================================================
-- 4. 불포함사항 INSERT
-- ============================================================================

INSERT INTO tour_exclusions (tour_id, order_seq, description, category, estimated_price) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, '점심식사', 'meal', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 2, '공항드롭 (늦은 시간 선택가능)', 'transportation', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 3, '가이드 팁 (투어만족 시 자율)', 'tip', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 4, '개인경비 (음료 등)', 'other', NULL);

-- ============================================================================
-- 5. 추가옵션 INSERT
-- ============================================================================

INSERT INTO tour_addon_options (
  tour_id, option_name, option_category, description, price, price_type, duration_minutes, order_seq, is_available
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '문묘 → 쩐꾸옥 사원 변경', 'activity', '하노이 문묘(1076년 개교 베트남 최초 교육기관) 대신 쩐꾸옥 사원(1500년 역사, 소호)으로 변경. 할인 적용.', -50000, 'per_person', 90, 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '마사지 프로그램 제외', 'service', '세레네 스파 60분 아로마 마사지 프로그램 제외. 1인당 50만동 할인 적용.', -500000, 'per_person', 0, 2, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '공항드롭 추가 (늦은 시간)', 'transport', '마사지 후 공항으로 직접 이동. 늦은 비행기나 새벽 비행기 고객용. 추가요금 확인 필요.', 0, 'per_team', 0, 3, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '투어코스 순서 변경', 'other', '제공된 일정 (기찻길카페 → 문묘/쩐꾸옥 → 전기차투어 → 스파)을 가이드와 협의하여 변경 가능', 0, 'per_team', 0, 4, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '추가 임산부 발마사지', 'service', '임산부를 위한 발마사지로 기본 마사지 대체 (무료)', 0, 'per_person', 60, 5, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '추가 아동 성장판 마사지', 'service', '아동을 위한 성장판 마사지로 기본 마사지 대체 (무료)', 0, 'per_person', 60, 6, true);

-- ============================================================================
-- 6. 일정/스케줄 INSERT
-- ============================================================================

INSERT INTO tour_schedule (tour_id, day_number, order_seq, start_time, end_time, activity_name, duration_minutes, optional, notes) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, 1, '14:30', '15:00', '가이드 미팅 및 오리엔테이션', 30, false, '{"location": "하노이 힐튼호텔 라인", "welcome": "음료 제공 (반미 포함)"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, 2, '15:00', '16:00', '기찻길 카페 투어', 60, false, '{"location": "하노이 올드쿼터 기찻길", "description": "하노이의 매력적인 철길 카페거리", "duration_changeable": true}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, 3, '16:00', '17:20', '하노이 문묘 또는 쩐꾸옥 사원', 80, false, '{"activities": ["문묘 선택: 베트남 최초 교육기관 (1076년)", "쩐꾸옥 선택: 1500년 역사 사찰 + 서호 경관"], "changeable": true, "discount_for_temple": -50000}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, 4, '17:20', '18:20', '전기차 시티투어', 60, false, '{"location": "하노이 올드쿼터 구도시", "description": "하노이 역사와 문화 설명, 오토바이 흐름 관찰"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, 5, '18:30', '19:30', '세레네 스파 아로마 마사지', 60, false, '{"location": "SERENE SPA", "service": "60분 전신마사지", "notes": "아동 성장판 또는 임산부 발마사지 가능", "shower_available": "마사지 후 샤워 및 캐리어 보관 가능", "spa_discount": -500000}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 1, 6, '19:30', NULL, '투어 종료 및 목적지까지 이동', 0, false, '{"note": "호텔 드롭 또는 공항 드롭 (선택)"}');

-- ============================================================================
-- 7. 취소정책 INSERT
-- ============================================================================

INSERT INTO tour_cancellation_policy (
  tour_id, policy_name, order_seq, days_before_min, days_before_max,
  penalty_type, penalty_amount, penalty_rate, description, refundable
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '일반 취소 정책', 1, 0, 999, 'rate', NULL, NULL, '자세한 취소 규정은 카페 게시판 참고 (링크: https://cafe.naver.com/stayhalong/784)', false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '불가항력 취소', 2, 0, 999, 'rate', NULL, NULL, '기상악화, 천재지변 등 불가항력적 이유로 투어 취소 시 전액 환불', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), '당사 사정 취소', 3, 0, 999, 'rate', NULL, NULL, '당사의 사정으로 투어 취소 시 전액 환불 또는 날짜 변경', true);

-- ============================================================================
-- 8. 중요 정보/주의사항 INSERT
-- ============================================================================

INSERT INTO tour_important_info (tour_id, info_type, content, order_seq, is_highlighted) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'notice', '5세 미만 아동은 요금 미적용 (인원에 미포함)하나, 차량 변경 필요 시 차액 부담 필수', 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'guide', '5세 이상 아동은 성인과 동일 요금 적용', 2, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'caution', '투어코스 순서는 가이드와 협의하여 변경 가능', 3, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'notice', '문묘 대신 쩐꾸옥 사원 선택 시 1인당 50,000동 할인', 4, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'notice', '마사지 이용을 안 할 경우 1인당 500,000동 할인', 5, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'guide', '국제가이드 자격소지 한국어 가이드가 하노이의 역사, 유학문화, 현대발전상에 대해 설명', 6, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'notice', '기찻길 카페에서 음료와 반미 제공 (호안끼엠 지역 웰컴 서비스)', 7, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'caution', '투어코스 입장료 변경이 있는 경우 요금 변경 가능', 8, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'notice', '예약금: 신용카드 20% (원화송금) | 잔금: 투어당일 가이드에게 베트남동 현금 지불', 9, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'guide', '마사지 후 늦은 비행기 또는 새벽 비행기로 출국 고객을 위해 샤워 및 캐리어 보관 가능', 10, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'notice', '본 투어는 예약자 팀만을 위한 단독투어 (조인투어 아님)', 11, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001'), 'guide', '예약 및 상담: 스테이하롱 카카오채널 (http://pf.kakao.com/_zvsxaG/chat)', 12, false);

SELECT 'INSERT COMPLETE' AS status;

COMMIT;

-- ============================================================================
-- 검증 쿼리
-- ============================================================================

-- 투어 정보 확인
-- SELECT 
--   tour_code, tour_name, category, duration, group_type, meeting_time,
--   min_age_free_applicable, special_age_policy_description
-- FROM tour 
-- WHERE tour_code = 'HANOI_AFT_PRIVATE_001';

-- 가격 정보 확인
-- SELECT 
--   min_guests, max_guests, price_per_person, vehicle_type, deposit_amount, balance_payment_method
-- FROM tour_pricing 
-- WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001')
-- ORDER BY min_guests;

-- 전체 데이터 수 확인
-- SELECT
--   'Inclusions' AS type, COUNT(*) FROM tour_inclusions WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001')
-- UNION ALL
-- SELECT 'Exclusions' AS type, COUNT(*) FROM tour_exclusions WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001')
-- UNION ALL
-- SELECT 'Options' AS type, COUNT(*) FROM tour_addon_options WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001')
-- UNION ALL
-- SELECT 'Schedules' AS type, COUNT(*) FROM tour_schedule WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001')
-- UNION ALL
-- SELECT 'Policies' AS type, COUNT(*) FROM tour_cancellation_policy WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001')
-- UNION ALL
-- SELECT 'Info' AS type, COUNT(*) FROM tour_important_info WHERE tour_id = (SELECT tour_id FROM tour WHERE tour_code = 'HANOI_AFT_PRIVATE_001');
