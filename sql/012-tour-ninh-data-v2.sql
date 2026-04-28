-- ============================================================================
-- 닌빈 투어 데이터 (수정된 구문)
-- ============================================================================

BEGIN;

-- 1. 투어 기본 정보
INSERT INTO tour (tour_code, tour_name, category, description, overview, duration, guide_language, group_type, location, starting_point, meeting_time, image_url, rating, is_active, contact_info, payment_notes)
VALUES (
  'NINH_BiRV_PRIVATE_001',
  '닌빈 한국어 가이드 투어',
  '닌빈',
  '육지의 하롱베이라 불리는 닌빈의 절경을 한국어 가이드와 함께 둘러보는 프라이빗 투어',
  '베트남 북부 여행자들에게 유명한 대표적 관광지 닌빈. 마치 하롱베이를 육지로 그대로 옮겨놓듯, 강줄기를 따라 멋진 풍경들이 반겨줍니다.',
  '1일 (당일)',
  ARRAY['한국어'],
  'private',
  '닌빈',
  '호텔 로비',
  '07:50',
  'https://stayhalong.com/images/tours/ninh-binh-private.jpg',
  4.8,
  true,
  '{"kakao_channel": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84)039 433 4065", "phone_kr": "070-4554-5185"}',
  '예약금: 50만동 또는 50% (신용카드)'
);

-- 2. 가격 정보 (INSERT ... VALUES 직접 사용)
INSERT INTO tour_pricing (tour_id, min_guests, max_guests, price_per_person, vehicle_type, deposit_amount, deposit_rate, deposit_payment_method, balance_payment_method, balance_currency, season_key, valid_from, valid_until)
SELECT tour_id, 1, 1, 4500000, '승용차', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 2, 2, 2650000, '승용차', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 3, 3, 2400000, '7인승 SUV', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 4, 4, 1950000, '7인승 SUV', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 5, 5, 1800000, '9인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 6, 6, 1700000, '9인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 7, 7, 1600000, '9인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 8, 8, 1550000, '11인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE
UNION ALL SELECT (SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 9, 9, 1500000, '11인승 리무진', 500000, 0.50, 'card', 'card', 'KRW', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE;

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
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 2, '항무아 입장료', 'activity', 200000),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 3, '밤 야경투어', 'activity', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 4, '팁', 'tip', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 5, '호아루 야시장 투어', 'activity', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 6, '스파/마사지', 'service', NULL);

-- 5. 추가옵션
INSERT INTO tour_addon_options (tour_id, option_name, option_category, description, price, price_type, duration_minutes, order_seq, is_available) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '점심식사 추가', 'meal'::option_category, '베트남 현지식 또는 한정식', 200000, 'per_person'::price_type, 60, 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '항무아 투어 추가', 'activity', '항무아 동굴 탐험', 100000, 'per_person', 120, 2, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '호이안 야경투어', 'activity', '호이안 도시 야경투어', 500000, 'per_team'::price_type, 180, 3, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '하노이 야경투어', 'activity', '하노이 구시가지 야경투어', 800000, 'per_team', 180, 4, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '황제마사지/스파', 'service', '세레네 스파 프리미엄 마사지', 0, 'per_person'::price_type, 60, 5, true);

-- 6. 일정
INSERT INTO tour_schedule (tour_id, day_number, order_seq, start_time, end_time, activity_name, duration_minutes, optional, notes) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 1, '21:30'::TIME, NULL, '카카오 그룹 채팅 생성 및 정보 안내', 0, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 2, '07:50'::TIME, '08:30'::TIME, '호텔 준비 및 만남', 40, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 3, '08:30'::TIME, '10:30'::TIME, '호아루 관광', 120, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 4, '10:30'::TIME, '12:00'::TIME, '점심 전 자유시간', 90, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 5, '12:00'::TIME, '13:00'::TIME, '점심식사 (별도결제)', 60, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 6, '13:00'::TIME, '13:30'::TIME, '이동 및 쉬는 시간', 30, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 7, '13:30'::TIME, '16:00'::TIME, '바이딘 사원 투어', 150, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 8, '16:00'::TIME, '16:30'::TIME, '나룻배 투어', 30, false, NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 1, 9, '16:30'::TIME, NULL, '투어 종료 및 귀환', 0, false, NULL);

-- 7. 취소정책
INSERT INTO tour_cancellation_policy (tour_id, policy_name, order_seq, days_before_min, days_before_max, penalty_type, penalty_amount, penalty_rate, description, refundable) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '15일 이상 전 취소', 1, 15, 999, 'fixed', 1000000, NULL, '투어 15일 이상 전 취소 시 100만동 환불불가', false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '6~14일 전 취소', 2, 6, 14, 'rate', NULL, 0.50, '투어 6~14일 전 취소 시 50% 환불', true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), '5일 이내 취소', 3, 0, 5, 'rate', NULL, 0.00, '투어 5일 이내 취소 시 환불 불가', false);

-- 8. 중요 정보
INSERT INTO tour_important_info (tour_id, info_type, content, order_seq, is_highlighted) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'caution'::info_type, '점심식사는 투어 금액에 불포함', 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice', '항무아는 포함 안 됨', 2, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'caution', '나룻배 투어 시 가이드는 함께 탑승하지 않음', 3, true),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'guide', '본 투어는 예약자 팀만을 위한 단독투어', 4, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'guide', '한국어 가능한 국제가이드 자격 소지 베트남인 가이드', 5, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice', '호아루의 역사와 문화 설명', 6, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice', '바이딘 사원 투어 시 편한 신발 착용 필수', 7, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'guide', '투어 중 야시장, 쇼핑 등 추가 활동은 고객 선택', 8, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice', '예약금은 신용카드로만 결제 (수수료 포함)', 9, false),
((SELECT tour_id FROM tour WHERE tour_code = 'NINH_BiRV_PRIVATE_001'), 'notice', '잔금은 투어 당일 가이드에게 현금/신용카드 결제', 10, false);

COMMIT;
