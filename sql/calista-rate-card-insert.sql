-- ============================================
-- 칼리스타 크루즈 2026년 1박 2일 가격 입력
-- (cruise_rate_card 테이블용 - 아동/아동엑스트라 모든 객실 반복)
-- ============================================

-- Step 0: 기존 칼리스타 레이트카드 삭제
DELETE FROM cruise_rate_card 
WHERE cruise_name = '칼리스타'
  AND valid_year = 2026;

-- ============================================
-- 기간 1: 2026/01/01 - 04/30 (정가)
-- ============================================

-- 칼리스타 오션: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 4650000, 4650000, 7900000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2775000, 4650000, 7900000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3825000, 4650000, 7900000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 베이: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5475000, 5000000, 9300000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2775000, 5000000, 9300000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 3825000, 5000000, 9300000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 레거시: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 6000000, 10200000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2775000, 6000000, 10200000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 3825000, 6000000, 10200000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- Horizon Suite (셔틀차량 포함): 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 9100000, 15500000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2775000, 9100000, 15500000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 3825000, 9100000, 15500000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라) (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아 (셔틀차량 포함)');

-- Majesty Suite (셔틀차량 포함): 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 10200000, 17450000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2775000, 10200000, 17450000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 3825000, 10200000, 17450000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라) (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아 (셔틀차량 포함)');

-- President Suite (단독차량 포함): 성인만
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'President Suite', 'President Suite', 22300000, 0, 37900000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인 (단독차량 포함, 아동/유아 불가)');

-- ============================================
-- 기간 2: 2026/05/01 - 09/30 (프로모션 요금)
-- ============================================

-- 칼리스타 오션: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3975000, 3975000, 6800000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2775000, 3975000, 6800000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3825000, 3975000, 6800000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션)');

-- 칼리스타 베이: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 4250000, 7250000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2775000, 7250000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 3825000, 7250000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션)');

-- 칼리스타 레거시: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 4650000, 4650000, 7950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2775000, 4650000, 7950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 3825000, 4650000, 7950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션)');

-- Horizon Suite (프로모션): 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 8300000, 8300000, 14100000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션, 셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2775000, 8300000, 14100000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션, 셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 3825000, 8300000, 14100000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션, 셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션, 셔틀차량 포함)');

-- Majesty Suite (프로모션): 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 9400000, 9400000, 16000000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션, 셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2775000, 9400000, 16000000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션, 셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 3825000, 9400000, 16000000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션, 셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션, 셔틀차량 포함)');

-- President Suite (프로모션): 성인만
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'President Suite', 'President Suite', 20150000, 0, 34300000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션, 단독차량 포함, 아동/유아 불가)');

-- ============================================
-- 기간 3: 2026/10/01 - 12/31 (정가)
-- ============================================

-- 칼리스타 오션: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 4650000, 4650000, 7900000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2775000, 4650000, 7900000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3825000, 4650000, 7900000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 베이: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5475000, 9300000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2775000, 9300000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 3825000, 9300000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 레거시: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 6000000, 10200000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2775000, 6000000, 10200000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 3825000, 6000000, 10200000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- Horizon Suite: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 9100000, 15500000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2775000, 9100000, 15500000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 3825000, 9100000, 15500000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라) (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아 (셔틀차량 포함)');

-- Majesty Suite: 성인, 아동, 아동(엑스트라), 유아
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 10200000, 17450000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2775000, 10200000, 17450000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동 (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 3825000, 10200000, 17450000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라) (셔틀차량 포함)');
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아 (셔틀차량 포함)');

-- President Suite: 성인만
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'President Suite', 'President Suite', 22300000, 0, 37900000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인 (단독차량 포함, 아동/유아 불가)');

-- ============================================
-- Step 1: 시즌별 추가요금 입력
-- ============================================

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '칼리스타'
  AND valid_year = 2026;

INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, valid_year, currency)
VALUES
  ('칼리스타', '1N2D', '2026-04-30', '2026-05-01', '5월 연휴 추가요금', 1200000, 2026, 'VND'),
  ('칼리스타', '1N2D', '2026-12-24', NULL, '크리스마스 이브 추가요금', 1200000, 2026, 'VND'),
  ('칼리스타', '1N2D', '2026-12-31', NULL, '연말 추가요금', 1200000, 2026, 'VND');

-- ============================================
-- Step 2: 최종 확인
-- ============================================

SELECT '✅ 칼리스타 레이트카드 데이터 입력 완료' AS result;

SELECT 
  COUNT(*) as total_rows,
  cruise_name,
  valid_year
FROM cruise_rate_card
WHERE cruise_name = '칼리스타'
  AND valid_year = 2026
GROUP BY cruise_name, valid_year;

SELECT '✅ 칼리스타 추가요금 데이터 입력 완료' AS result;

SELECT 
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = '칼리스타'
  AND valid_year = 2026
ORDER BY holiday_date;

-- ============================================
-- 기간 1: 2026/01/01 - 04/30 (정가)
-- ============================================

-- 칼리스타 오션
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 4650000, 4650000, 7900000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2775000, 4650000, 7900000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3825000, 4650000, 7900000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 베이
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5475000, 5000000, 9300000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5000000, 5000000, 9300000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5475000, 5000000, 9300000, true, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 레거시
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 10200000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 10200000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 10200000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- Horizon Suite (셔틀차량 포함)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 15500000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 15500000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 15500000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라) (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아 (셔틀차량 포함)');

-- Majesty Suite (셔틀차량 포함)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 17450000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 17450000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 17450000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '아동(엑스트라) (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2950000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '유아 (셔틀차량 포함)');

-- President Suite (단독차량 포함)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'President Suite', 'President Suite', 22300000, 37900000, false, 2026, 'VND', true, '2026-01-01', '2026-04-30', '성인 (단독차량 포함, 아동/유아 불가)');

-- ============================================
-- 기간 2: 2026/05/01 - 09/30 (프로모션 요금)
-- ============================================

-- 칼리스타 오션
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3975000, 3975000, 6800000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2775000, 3975000, 6800000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3825000, 3975000, 6800000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션)');

-- 칼리스타 베이
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 4250000, 4250000, 7250000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 4250000, 4250000, 7250000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 4250000, 4250000, 7250000, true, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션)');

-- 칼리스타 레거시
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 4650000, 7950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 4650000, 7950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 4650000, 7950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션)');

-- Horizon Suite (프로모션)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 8300000, 14100000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션, 셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 8300000, 14100000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션, 셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 8300000, 14100000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션, 셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션, 셔틀차량 포함)');

-- Majesty Suite (프로모션)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 9400000, 16000000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션, 셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 9400000, 16000000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동 (프로모션, 셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 9400000, 16000000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '아동(엑스트라) (프로모션, 셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2950000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '유아 (프로모션, 셔틀차량 포함)');

-- President Suite (프로모션)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'President Suite', 'President Suite', 20150000, 34300000, false, 2026, 'VND', true, '2026-05-01', '2026-09-30', '성인 (프로모션, 단독차량 포함, 아동/유아 불가)');

-- ============================================
-- 기간 3: 2026/10/01 - 12/31 (정가)
-- ============================================

-- 칼리스타 오션
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 4650000, 4650000, 7900000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2775000, 4650000, 7900000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 3825000, 4650000, 7900000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 오션', 'Calista Ocean', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 베이
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5475000, 5475000, 9300000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5475000, 5475000, 9300000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_extra_bed, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 5475000, 5475000, 9300000, true, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 베이', 'Calista Bay', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- 칼리스타 레거시
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 10200000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 10200000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 6000000, 10200000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', '칼리스타 레거시', 'Calista Legacy', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아(객실당 1명 무료, 2명 이상 295만동/명)');

-- Horizon Suite (셔틀차량 포함)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 15500000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 15500000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 9100000, 15500000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라) (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Horizon Suite', 'Horizon Suite', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아 (셔틀차량 포함)');

-- Majesty Suite (셔틀차량 포함)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 17450000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 17450000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동 (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 10200000, 17450000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '아동(엑스트라) (셔틀차량 포함)');

INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'Majesty Suite', 'Majesty Suite', 2950000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '유아 (셔틀차량 포함)');

-- President Suite (단독차량 포함)
INSERT INTO cruise_rate_card (cruise_name, schedule_type, room_type, room_type_en, price_adult, price_single, extra_bed_available, valid_year, currency, is_active, valid_from, valid_to, notes)
VALUES ('칼리스타', '1N2D', 'President Suite', 'President Suite', 22300000, 37900000, false, 2026, 'VND', true, '2026-10-01', '2026-12-31', '성인 (단독차량 포함, 아동/유아 불가)');

-- ============================================
-- Step 1: 시즌별 추가요금 입력
-- ============================================

DELETE FROM cruise_holiday_surcharge 
WHERE cruise_name = '칼리스타'
  AND valid_year = 2026;

INSERT INTO cruise_holiday_surcharge 
  (cruise_name, schedule_type, holiday_date, holiday_date_end, holiday_name, surcharge_per_person, valid_year, currency)
VALUES
  ('칼리스타', '1N2D', '2026-04-30', '2026-05-01', '5월 연휴 추가요금', 1200000, 2026, 'VND'),
  ('칼리스타', '1N2D', '2026-12-24', NULL, '크리스마스 이브 추가요금', 1200000, 2026, 'VND'),
  ('칼리스타', '1N2D', '2026-12-31', NULL, '연말 추가요금', 1200000, 2026, 'VND');

-- ============================================
-- Step 2: 최종 확인
-- ============================================

SELECT '✅ 칼리스타 레이트카드 데이터 입력 완료 (72개 행 + 유아 정책)' AS result;

SELECT 
  COUNT(*) as total_rows,
  cruise_name,
  valid_year
FROM cruise_rate_card
WHERE cruise_name = '칼리스타'
  AND valid_year = 2026
GROUP BY cruise_name, valid_year;

SELECT '✅ 칼리스타 추가요금 데이터 입력 완료' AS result;

SELECT 
  holiday_date,
  holiday_date_end,
  holiday_name,
  surcharge_per_person
FROM cruise_holiday_surcharge
WHERE cruise_name = '칼리스타'
  AND valid_year = 2026
ORDER BY holiday_date;
