-- ============================================================================
-- 하노이 역사투어 데이터 INSERT (직접 INSERT VALUES 패턴)
-- ============================================================================
-- 실행 전 011-tour-system-tables-2026.sql 먼저 실행 필요

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
  'HANOI_HIST_PRIVATE_001',
  '하노이 역사투어',
  '하노이',
  '베트남의 깊은 역사와 그들의 삶을 엿볼 수 있는 특별한 투어. 호치민 관저, 호아로 수용소, 탕롱황성 등 역사적 유산을 한국어 가이드와 함께 둘러보고, 세레네 스파에서 마사지로 마무리하는 완벽한 역사 문화 투어',
  '베트남의 오랜 역사를 고스란히 담고 있는 하노이의 역사적 기록들과 당시의 모습들을 한국어 전공, 국제가이드와 함께 둘러보며 베트남에 대한 새로운 사실들을 하나씩 알아가는 뜻 깊고 의미있는 시간입니다. 프랑스 식민지 시절의 아픔, 독립운동의 역사, 전쟁의 상흔 등을 통해 우리의 역사와 닮아있는 베트남의 진정한 모습을 만날 수 있습니다.',
  '당일 (약 10시간)',
  ARRAY['한국어'],
  'private',
  '하노이',
  '호텔 로비 (올드쿼터 중심)',
  '08:30',
  'https://stayhalong.com/images/tours/hanoi-history.jpg',
  4.9,
  true,
  3,
  '{"kakao_channel": "http://pf.kakao.com/_zvsxaG/chat", "phone_vn": "(+84)039 433 4065", "phone_kr": "070-4554-5185", "kakao_talk_id": "stayhalong"}',
  '예약금: 신용카드 20% (원화송금) | 잔금: 투어당일 가이드에게 현금지불 (베트남동)',
  'https://cafe.naver.com/stayhalong/784?tc=shared_link'
);

-- ============================================================================
-- 2. 인원별 가격 정보 INSERT
-- ============================================================================

INSERT INTO tour_pricing (
  tour_id, min_guests, max_guests, price_per_person, vehicle_type, deposit_amount, deposit_rate,
  deposit_payment_method, balance_payment_method, balance_currency,
  season_key, valid_from, valid_until
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 1, 4900000, '승용차', 980000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 2, 2, 3050000, '승용차', 610000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 3, 3, 2500000, 'SUV', 500000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 4, 4, 2350000, '기아 카니발', 470000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 5, 5, 2200000, '9인승 리무진', 440000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 6, 6, 2000000, '9인승 리무진', 400000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 7, 7, 1850000, '9인승 리무진', 370000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 8, 8, 1880000, '11인승 리무진', 376000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 9, 9, 1750000, '11인승 리무진', 350000, 0.20, 'card', 'cash', 'VND', 'YEAR', '2026-01-01'::DATE, '2026-12-31'::DATE);

-- ============================================================================
-- 3. 포함사항 INSERT
-- ============================================================================

INSERT INTO tour_inclusions (tour_id, order_seq, description, category, icon) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, '투어 시 이동차량 (올드쿼터 호텔 픽업 및 드랍 일체)', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 2, '관광지 입장료 (호치민 관저, 호아로 수용소, 탕롱황성 또는 문묘)', 'activity', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 3, '한국어 전공, 현지 국제 가이드', 'guide', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 4, '세레네 스파 60분 전신마사지 (아동은 성장판 마사지, 임산부 발마사지)', 'service', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 5, '하노이 시티투어 버스 티켓', 'transportation', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 6, '카페지앙 에그커피 1잔 (ICE or HOT)', 'meal', '✓'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 7, '1인당 생수 1병 제공', 'meal', '✓');

-- ============================================================================
-- 4. 불포함사항 INSERT
-- ============================================================================

INSERT INTO tour_exclusions (tour_id, order_seq, description, category, estimated_price) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, '점심식사 및 식사 시 음료', 'meal', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 2, '여행자 보험', 'service', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 3, '개인경비', 'other', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 4, '가이드 팁', 'tip', NULL),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 5, '아로마 마사지 제외 시 1인당 50만동 할인', 'service', 500000);

-- ============================================================================
-- 5. 추가옵션 INSERT
-- ============================================================================

INSERT INTO tour_addon_options (
  tour_id, option_name, option_category, description, price, price_type, duration_minutes, order_seq, is_available
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '탕롱황성 → 하노이 문묘 변경', 'activity', '세번째 코스에서 탕롱황성(세계문화유산) 대신 하노이 문묘(베트남 최초 대학교)로 변경 가능. 무료 변경.', 0, 'per_person', 120, 1, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '아로마 마사지 제외', 'service', '세레네 스파 60분 전신마사지 프로그램 제외. 1인당 50만동 할인 적용.', -500000, 'per_person', 0, 2, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '스테이하롱 11인승 리무진 업그레이드', 'transport', '일반 9인승 리무진에서 스테이하롱 소유의 고급 11인승 리무진으로 업그레이드. 시트 컨디션이 우수한 차량.', 1800000, 'per_team', 0, 3, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '스테이하롱 리무진 - SUV에서 업그레이드', 'transport', 'SUV에서 스테이하롱 11인승 리무진으로 업그레이드.', 2800000, 'per_team', 0, 4, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '스테이하롱 리무진 - 승용차에서 업그레이드', 'transport', '승용차에서 스테이하롱 11인승 리무진으로 업그레이드.', 3000000, 'per_team', 0, 5, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '스테이하롱 리무진 - 카니발에서 업그레이드', 'transport', '기아 카니발에서 스테이하롱 11인승 리무진으로 업그레이드.', 2100000, 'per_team', 0, 6, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '가이드 동행 점심식사', 'meal', '점심식사 시 가이드가 함께 식사. 미포함 시 고객님끼리만 식사 후 가이드 합류.', 0, 'per_person', 0, 7, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '지정 식당 예약', 'meal', '원하시는 특정 식당에서 점심식사. 사전 요청 시 가이드가 예약 및 이동 담당.', 0, 'per_person', 0, 8, true);

-- ============================================================================
-- 6. 일정/스케줄 INSERT
-- ============================================================================

INSERT INTO tour_schedule (tour_id, day_number, order_seq, start_time, end_time, activity_name, duration_minutes, optional, notes) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 1, '08:30', '09:00', '가이드 미팅, 차량픽업', 30, false, '{"location": "호텔 로비", "important": true}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 2, '09:00', '10:30', '호치민 관저 투어', 90, false, '{"included": true, "description": "호치민 주석의 마지막 거주지, 검소한 삶과 국정운영 흔적"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 3, '10:30', '12:00', '호아로 수용소 박물관', 90, false, '{"included": true, "description": "프랑스 식민지 독립운동가 수감소, 전쟁 포로 수용소"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 4, '12:00', '13:00', '점심식사 (자유선택)', 60, false, '{"payment": "on-site", "meal": true, "optional": "가이드 동행 선택"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 5, '13:00', '13:50', '카페지앙 에그커피', 50, false, '{"included": true, "activity": "카페", "description": "베트남 명물 에그커피 시음"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 6, '13:50', '15:30', '탕롱황성 또는 하노이 문묘', 100, false, '{"included": true, "optional_change": true, "description": "세계문화유산 또는 베트남 최초 대학교"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 7, '15:30', '17:30', '하노이 시티투어 버스', 120, false, '{"included": true, "description": "하노이 주요 관광지 둘러보기, 역사 설명 동행"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 8, '17:30', '18:30', '세레네 스파 아로마 마사지', 60, false, '{"included": true, "optional": "제외 선택 가능", "description": "60분 전신마사지, 아동 성장판, 임산부 발마사지"}'),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 1, 9, '18:30', NULL, '투어종료', 0, false, '{"note": "공항 이동 전 샤워 및 캐리어 보관 가능"}');

-- ============================================================================
-- 7. 취소정책 INSERT
-- ============================================================================

INSERT INTO tour_cancellation_policy (
  tour_id, policy_name, order_seq, days_before_min, days_before_max,
  penalty_type, penalty_amount, penalty_rate, description, refundable
) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '기상악화 등 불가항력', 1, 0, 999, 'rate', NULL, NULL, '기상악화, 천재지변, 정부명령 등 불가항력적 이유로 투어 취소 시 전액 환불', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '당사 사정 취소', 2, 0, 999, 'rate', NULL, NULL, '당사의 사정으로 투어 취소 시 전액 환불 또는 날짜 변경', true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), '일반 취소 규정', 3, 0, 7, 'rate', NULL, NULL, '자세한 취소 규정은 카페 게시판 참고 (환불 정책에 따름)', false);

-- ============================================================================
-- 8. 중요 정보/주의사항 INSERT
-- ============================================================================

INSERT INTO tour_important_info (tour_id, info_type, content, order_seq, is_highlighted) VALUES
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'guide', '투어 금액에 포함된 차량: 승용차/SUV/카니발/9인승 리무진/11인승 리무진 중 인원별 배정', 1, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'notice', '스테이하롱 소유 11인승 리무진으로 업그레이드 가능 (추가요금: 1.8M~3.0M동)', 2, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'notice', '일반 리무진 차량은 의자 좌석 컨디션이 다를 수 있으며, 스테이하롱 리무진은 고급 차량입니다.', 3, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'caution', '점심식사는 투어 금액에 불포함. 원하시는 식당 있으시면 사전 요청 시 예약 및 이동 담당', 4, true),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'caution', '아로마 마사지 제외 시 1인당 50만동 할인. 아동은 성장판 마사지, 임산부는 발마사지로 대체', 5, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'guide', '탕롱황성은 원하시는 경우 하노이 문묘로 변경하여 진행 가능 (무료)', 6, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'notice', '역사투어는 걷는 코스가 많으므로 편한 신발 착용 권장', 7, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'guide', '본 투어는 "예약자 팀" 만을 위한 단독투어입니다. (조인투어 아님)', 8, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'notice', '예약금은 신용카드로만 결제 가능. 신용카드 수수료 및 환율 수수료 추가', 9, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'notice', '잔금은 투어 당일 가이드에게 현금(베트남동)으로 지불', 10, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'guide', '마사지 후 공항으로 이동하시는 경우 샤워 및 캐리어 보관 가능', 11, false),
((SELECT tour_id FROM tour WHERE tour_code = 'HANOI_HIST_PRIVATE_001'), 'guide', '한국어 전공, 국제가이드 자격 소지 가이드가 베트남 역사 및 문화에 대해 성실하게 설명', 12, false);

SELECT 'HANOI_HIST_PRIVATE_001 INSERT COMPLETE' AS status;

COMMIT;
