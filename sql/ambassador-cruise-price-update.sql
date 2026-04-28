-- ============================================
-- 엠바사더 시그니쳐 크루즈 2026년 1박 2일 가격 입력
-- (room_type별로 room_code 구분)
-- ============================================

-- Step 0: 기존 엠바사더 크루즈 데이터 삭제 (재입력 위해)
DELETE FROM room_price 
WHERE cruise = 'Ambassador Signature Cruise';

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = 'Ambassador Signature Cruise' 
  AND valid_year = 2026;

-- Step 1: 발코니 객실 (성인, 아동, 유아, 엑스트라베드, 싱글차지)
INSERT INTO room_price (room_code, room_category, cruise, room_type, price, schedule, payment)
VALUES
  ('R-AMB-BALCONY-ADULT', '발코니', 'Ambassador Signature Cruise', '성인', 3750000, '1박 2일', '성인 1인당'),
  ('R-AMB-BALCONY-CHILD', '발코니', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-BALCONY-INFANT', '발코니', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)'),
  ('R-AMB-BALCONY-EXTRA', '발코니', 'Ambassador Signature Cruise', '엑스트라베드', 3750000, '1박 2일', '엑스트라베드 1인'),
  ('R-AMB-BALCONY-SINGLE', '발코니', 'Ambassador Signature Cruise', '싱글차지', 6800000, '1박 2일', '싱글차지 추가비용');

-- Step 2: 이그제큐티브 객실 (성인, 아동, 유아, 엑스트라베드, 싱글차지)
INSERT INTO room_price (room_code, room_category, cruise, room_type, price, schedule, payment)
VALUES
  ('R-AMB-EXECUTIVE-ADULT', '이그제큐티브', 'Ambassador Signature Cruise', '성인', 4000000, '1박 2일', '성인 1인당'),
  ('R-AMB-EXECUTIVE-CHILD', '이그제큐티브', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-EXECUTIVE-INFANT', '이그제큐티브', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)'),
  ('R-AMB-EXECUTIVE-EXTRA', '이그제큐티브', 'Ambassador Signature Cruise', '엑스트라베드', 4000000, '1박 2일', '엑스트라베드 1인'),
  ('R-AMB-EXECUTIVE-SINGLE', '이그제큐티브', 'Ambassador Signature Cruise', '싱글차지', 7300000, '1박 2일', '싱글차지 추가비용');

-- Step 3: 발코니 스위트 객실 (성인, 아동, 유아, 엑스트라베드, 싱글차지)
INSERT INTO room_price (room_code, room_category, cruise, room_type, price, schedule, payment)
VALUES
  ('R-AMB-SUITE-ADULT', '발코니 스위트', 'Ambassador Signature Cruise', '성인', 4700000, '1박 2일', '성인 1인당'),
  ('R-AMB-SUITE-CHILD', '발코니 스위트', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-SUITE-INFANT', '발코니 스위트', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)'),
  ('R-AMB-SUITE-EXTRA', '발코니 스위트', 'Ambassador Signature Cruise', '엑스트라베드', 4700000, '1박 2일', '엑스트라베드 1인'),
  ('R-AMB-SUITE-SINGLE', '발코니 스위트', 'Ambassador Signature Cruise', '싱글차지', 8800000, '1박 2일', '싱글차지 추가비용');

-- Step 4: 캡틴 뷰 엠바사더 스위트 객실 (성인, 아동, 유아, 엑스트라베드, 싱글차지)
INSERT INTO room_price (room_code, room_category, cruise, room_type, price, schedule, payment)
VALUES
  ('R-AMB-CAPTAIN-ADULT', '캡틴 뷰 스위트', 'Ambassador Signature Cruise', '성인', 5050000, '1박 2일', '성인 1인당'),
  ('R-AMB-CAPTAIN-CHILD', '캡틴 뷰 스위트', 'Ambassador Signature Cruise', '아동', 2750000, '1박 2일', '아동 1인당 (5~11세)'),
  ('R-AMB-CAPTAIN-INFANT', '캡틴 뷰 스위트', 'Ambassador Signature Cruise', '유아', 950000, '1박 2일', '유아 1인당 (0~4세)'),
  ('R-AMB-CAPTAIN-EXTRA', '캡틴 뷰 스위트', 'Ambassador Signature Cruise', '엑스트라베드', 5050000, '1박 2일', '엑스트라베드 1인'),
  ('R-AMB-CAPTAIN-SINGLE', '캡틴 뷰 스위트', 'Ambassador Signature Cruise', '싱글차지', 9450000, '1박 2일', '싱글차지 추가비용');

-- Step 5: 시즌별 추가요금 (cruise_holiday_surcharge 테이블)
INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, valid_year, currency)
VALUES
  -- 일별 추가요금: 12월 24일만
  ('Ambassador Signature Cruise', '1N2D', '2026-12-24', NULL, '크리스마스 이브 추가요금', 1350000, 2026, 'VND'),
  
  -- 일별 추가요금: 12월 31일만
  ('Ambassador Signature Cruise', '1N2D', '2026-12-31', NULL, '연말 특수요금', 1350000, 2026, 'VND'),
  
  -- 일별 추가요금: 9월 2일만 (베트남 국경일)
  ('Ambassador Signature Cruise', '1N2D', '2026-09-02', NULL, '베트남 국경일 추가요금', 800000, 2026, 'VND'),
  
  -- 기간 추가요금: 4월 30일 ~ 5월 1일 (미정)
  ('Ambassador Signature Cruise', '1N2D', '2026-04-30', '2026-05-01', '5월 연휴 추가요금', 0, 2026, 'VND');
