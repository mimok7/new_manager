-- ============================================================================
-- 닌빈 투어 데이터 (간단한 INSERT VALUES 사용)
-- ============================================================================

BEGIN;

-- 1. 투어 기본 정보
INSERT INTO tour (tour_code, tour_name, category, description, overview, duration, guide_language, group_type, location, starting_point, meeting_time, image_url, rating, is_active, contact_info, payment_notes)
VALUES (
  'NINH_BiRV_PRIVATE_001',
  '닌빈 한국어 가이드 투어',
  '닌빈',
  '육지의 하롱베이라 불리는 닌빈의 절경을 한국어 가이드와 함께 둘러보는 프라이빗 투어',
  '베트남 북부 여행자들에게 유명한 닌빈. 강줄기를 따라 멋진 풍경들이 펼쳐집니다.',
  '1일 (당일)',
  ARRAY['한국어'],
  'private',
  '닌빈',
  '호텔 로비',
  '07:50',
  'https://stayhalong.com/images/tours/ninh-binh-private.jpg',
  4.8,
  true,
  '{"kakao_channel": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84)039433 4065", "phone_kr": "070-4554-5185"}',
  '예약금: 50만동 또는 50% (신용카드)'
);

-- 2. 가격 정보
INSERT INTO tour_pricing (tour_id, min_guests, max_guests, price_per_person, vehicle_type, deposit_amount, deposit_rate, deposit_payment_method, balance_payment_method, balance_currency, season_key, valid_from, valid_until) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 1, 4500000, '승용차', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 2, 2, 2650000, '승용차', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 3, 3, 2400000, '7인승 SUV', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 4, 4, 1950000, '7인승 SUV', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 5, 5, 1800000, '9인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 6, 6, 1700000, '9인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 7, 7, 1600000, '9인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 8, 8, 1550000, '11인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 9, 9, 1500000, '11인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE);

-- 3. 포함사항
INSERT INTO tour_inclusions (tour_id, order_seq, description, category, icon) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, '투어 인원에 맞는 단독차량 및 운전기사', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 2, '한국어 가능한 국제가이드 자격소지 베트남인 가이드', 'guide', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 3, '베트남 고대 수도 호아루 입장료 및 사원투어', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 4, '동남아시아 최대사찰 바이딘 사원 입장료 및 사원투어', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 5, '바이딘 사원 내 전기차 이용료', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 6, '짱안 또는 닌빈 나룻배 투어 이용료', 'activity', '✓');

-- 4. 불포함사항
INSERT INTO tour_exclusions (tour_id, order_seq, description, category, estimated_price) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, '점심식사', 'meal', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 2, '항무아 입장료 (옵션)', 'activity', 200000),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 3, '밤 야경투어 (옵션)', 'activity', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 4, '팁 (의무 아님)', 'tip', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 5, '호아루 야시장 투어', 'activity', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 6, '세레네 스파 또는 마사지 (옵션)', 'service', NULL);

-- 5. 추가옵션
INSERT INTO tour_addon_options (tour_id, option_name, option_category, description, price, price_type, duration_minutes, order_seq, is_available) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '점심식사 추가', 'meal'::option_category, '베트남 현지식 또는 한정식', 200000, 'per_person'::price_type, 60, 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '항무아 투어 추가', 'activity'::option_category, '항무아 동굴 탐험 (석회동굴)', 100000, 'per_person'::price_type, 120, 2, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '호이안 야경투어', 'activity'::option_category, '호이안 도시 야경투어 (별도 일정)', 500000, 'per_team'::price_type, 180, 3, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '하노이 야경투어', 'activity'::option_category, '하노이 구시가지 야경투어 및 호수 산책', 800000, 'per_team'::price_type, 180, 4, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '황제마사지/스파', 'service'::option_category, '세레네 스파 프리미엄 마사지', 0, 'per_person'::price_type, 60, 5, true);

-- 6. 일정
INSERT INTO tour_schedule (tour_id, day_number, order_seq, start_time, end_time, activity_name, duration_minutes, optional, notes) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 1, '21:30'::TIME, NULL, '카카오 그룹 채팅 생성 및 정보 안내', 0, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 2, '07:50'::TIME, '08:30'::TIME, '호텔 준비 및 만남', 40, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 3, '08:30'::TIME, '10:30'::TIME, '호아루 관광 (베트남 고대수도)', 120, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 4, '10:30'::TIME, '12:00'::TIME, '점심 전 자유시간', 90, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 5, '12:00'::TIME, '13:00'::TIME, '점심식사 (별도결제)', 60, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 6, '13:00'::TIME, '13:30'::TIME, '이동 및 쉬는 시간', 30, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 7, '13:30'::TIME, '16:00'::TIME, '바이딘 사원 투어 (동남아 최대사찰)', 150, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 8, '16:00'::TIME, '16:30'::TIME, '나룻배 투어 (짱안 또는 닌빈)', 30, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 9, '16:30'::TIME, NULL, '투어 종료 및 귀환', 0, false, NULL);

-- 7. 취소정책
INSERT INTO tour_cancellation_policy (tour_id, policy_name, order_seq, days_before_min, days_before_max, penalty_type, penalty_amount, penalty_rate, description, refundable) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '15일 이상 전 취소', 1, 15, 999, 'fixed', 1000000, NULL, '투어 15일 이상 전 취소 시 100만동 환불불가', false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '6~14일 전 취소', 2, 6, 14, 'rate', NULL, 0.50, '투어 6~14일 전 취소 시 50% 환불', true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '5일 이내 취소', 3, 0, 5, 'rate', NULL, 0.00, '투어 5일 이내 취소 시 환불 불가', false);

-- 8. 중요 정보
INSERT INTO tour_important_info (tour_id, info_type, content, order_seq, is_highlighted) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'caution'::info_type, '점심식사 투어 금액 불포함. 원하는 식당 있으면 사전 요청 필수', 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice'::info_type, '항무아는 포함되지 않음. 원하실 경우 사전 알림 필수', 2, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'caution'::info_type, '나룻배 투어 시 가이드는 함께 탑승하지 않음 (안전상 이유)', 3, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'guide'::info_type, '본 투어는 예약자 팀만을 위한 단독투어 (조인투어 아님)', 4, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'guide'::info_type, '한국어 가능한 국제가이드 자격 소지 베트남인 가이드 동행', 5, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice'::info_type, '호아루 역사와 문화 성실하게 설명 및 안내', 6, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice'::info_type, '바이딘 사원 투어 시 편한 신발 착용 필수 (계단 많음)', 7, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'guide'::info_type, '투어 중 야시장, 쇼핑 등 추가 활동은 고객 선택', 8, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice'::info_type, '예약금은 신용카드로만 결제 가능 (수수료 포함)', 9, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice'::info_type, '잔금은 투어 당일 가이드에게 신용카드 또는 현금 결제 (협의)', 10, false);

COMMIT;

SELECT 'Ninh Binh Tour Data INSERT COMPLETE' AS status;
