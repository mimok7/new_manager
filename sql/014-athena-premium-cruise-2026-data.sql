-- ============================================================================
-- 014-athena-premium-cruise-2026-data.sql
-- 아테나 프리미엄 크루즈 (Athena Premium Cruise) 요금표 INSERT (2026)
-- ============================================================================
-- 크루즈명: 아테나 프리미엄 (6성급)
-- 운항시작: 2026년 6월 20일부터
-- 프로모션 단계: 선착순 20팀 사전예약 프로모션 요금
-- 참고: 프로모션 종료 후 요금 조정 가능
-- 테이블: cruise_rate_card (크루즈 가격 카드 - room_price는 호텔 전용)

BEGIN;

-- ============================================================================
-- 기존 아테나 프리미엄 데이터 삭제 (재실행을 위해 먼저 정리)
-- ============================================================================
DELETE FROM cruise_rate_card 
WHERE cruise_name = '아테나 프리미엄';

-- ============================================================================
-- 아테나 프리미엄 크루즈: 8개 객실 타입별 요금 데이터
-- ============================================================================
-- 일정: 1박 2일
-- 운항 시작: 2026-06-20
-- 프로모션 종료: 2026-12-31

-- 1. 아테나 오션뷰
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, price_extra_bed, price_single, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Athena Ocean View', 5175000, 3900000, 5175000, 8900000, 2026, '2026-06-20', '2026-12-31', 'VND', true, '아테나 오션뷰');

-- 2. 이그제큐티브 발코니
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, price_extra_bed, price_single, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Executive Balcony', 5700000, 4300000, 5700000, 9800000, 2026, '2026-06-20', '2026-12-31', 'VND', true, '이그제큐티브 발코니');

-- 3. 트리플 발코니 (엑스트라, 싱글차지 불가)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, extra_bed_available, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Triple Balcony', 5700000, 4300000, false, 2026, '2026-06-20', '2026-12-31', 'VND', true, '트리플 발코니 (엑스트라/싱글차지 불가)');

-- 4. 커넥팅 발코니 (싱글차지 불가)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, price_extra_bed, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Connecting Balcony', 5450000, 4100000, 5450000, 2026, '2026-06-20', '2026-12-31', 'VND', true, '커넥팅 발코니 (싱글차지 불가)');

-- 5. 프리미엄 발코니
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, price_extra_bed, price_single, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Premium Balcony', 6750000, 5075000, 6750000, 11600000, 2026, '2026-06-20', '2026-12-31', 'VND', true, '프리미엄 발코니');

-- 6. 캡틴 뷰 스위트 (VIP)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, price_extra_bed, price_single, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Captain View Suite (VIP)', 12000000, 9000000, 12000000, 20500000, 2026, '2026-06-20', '2026-12-31', 'VND', true, '캡틴 뷰 스위트 (VIP)');

-- 7. 엘리트 스위트 (VIP)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, price_extra_bed, price_single, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Elite Suite (VIP)', 14500000, 10900000, 14500000, 24750000, 2026, '2026-06-20', '2026-12-31', 'VND', true, '엘리트 스위트 (VIP)');

-- 8. 임페리얼 아테나 (VIP)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, price_adult, price_child, price_extra_bed, price_single, valid_year, valid_from, valid_to, currency, is_active, notes)
VALUES 
  ('아테나 프리미엄', '1N2D', 'Imperial Athena (VIP)', 47000000, 35200000, 47000000, 73000000, 2026, '2026-06-20', '2026-12-31', 'VND', true, '임페리얼 아테나 (VIP)');

COMMIT;

-- ============================================================================
-- 검증 쿼리 (SELECT하여 입력 데이터 확인)
-- ============================================================================
-- 아테나 프리미엄 크루즈 데이터 확인 (총 8개 객실 타입)
-- SELECT COUNT(*) FROM cruise_rate_card WHERE cruise_name = '아테나 프리미엄';
-- SELECT cruise_name, room_type, price_adult, price_child, price_extra_bed, price_single FROM cruise_rate_card WHERE cruise_name = '아테나 프리미엄' ORDER BY room_type;
