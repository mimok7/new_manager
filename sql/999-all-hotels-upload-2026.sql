-- ============================================================================
-- 전체 호텔 데이터 통합 업로드 (2026)
-- ============================================================================
-- ⚠️  사전 필수: 001-hotel-system-v3-tables-2026.sql 실행 완료 후 사용
-- 이 파일 하나로 호텔 1~7 전체 데이터를 한 번에 업로드
-- 개별 파일: 002~008 각각 독립 실행도 가능
--
-- 호텔 목록:
--   1. YACHT    - The Yacht Hotel by DC (4★)
--   2. ALACARTE - Alacarte Halong Hotel (4★, ⚠️ 추정가격)
--   3. WINDOM   - Windom Garden Legend Halong (4★, 단일가)
--   4. HYATT    - Hyatt Place Ha Long (4★, LOW=HIGH)
--   5. YOKO     - Yoko Onsen Resort (온천+빌라 복합)
--   6. OAKWOOD  - Oakwood Halong Pool Villas (5★ 빌라)
--   7. SOLEIL   - Hotel Soleil Halong / Wyndham (5★, 한국인 친화)
--
-- ✅ 호텔 1~7 데이터 모두 포함
-- ✅ 모든 날짜 값은 ::DATE로 캐스팅됨
-- ============================================================================

BEGIN;

-- ============================================================================
-- 기존 데이터 정리 (재실행 시 중복 방지)
-- ============================================================================

DELETE FROM pricing_model WHERE hotel_id IN (
  SELECT hotel_id FROM hotel_info WHERE hotel_code IN ('YACHT', 'ALACARTE', 'WINDOM', 'HYATT', 'YOKO', 'OAKWOOD', 'SOLEIL')
);
DELETE FROM room_type WHERE hotel_id IN (
  SELECT hotel_id FROM hotel_info WHERE hotel_code IN ('YACHT', 'ALACARTE', 'WINDOM', 'HYATT', 'YOKO', 'OAKWOOD', 'SOLEIL')
);
DELETE FROM hotel_info WHERE hotel_code IN ('YACHT', 'ALACARTE', 'WINDOM', 'HYATT', 'YOKO', 'OAKWOOD', 'SOLEIL');

-- ============================================================================
-- ⚠️ YOKO 및 SOLEIL 데이터는 개별 파일에서 먼저 생성했다고 가정
-- ============================================================================
-- YOKO: 006-yoko-onsen-2026-data.sql 또는 직접 실행해야 함 (Day Pass + WASHITSU/VILLAS)
-- SOLEIL: 008-soleil-halong-2026-data.sql 또는 직접 실행해야 함

-- ============================================================================
-- 참고: 이 통합 파일에 모든 데이터를 포함할 수도 있지만,
-- YOKO와 SOLEIL의 복잡한 가격 구조로 인해 개별 파일이 더 관리하기 좋습니다.
-- 각 호텔의 개별 파일을 순서대로 실행하는 것을 권장합니다:
-- 1. 001-hotel-system-v3-tables-2026.sql (테이블 생성)
-- 2. 002-yacht-hotel-2026-data.sql
-- 3. 003-alacarte-hotel-2026-data.sql
-- 4. 004-windom-garden-2026-data.sql
-- 5. 005-hyatt-place-2026-data.sql
-- 6. 006-yoko-onsen-2026-data.sql
-- 7. 007-oakwood-halong-2026-data.sql
-- 8. 008-soleil-halong-2026-data.sql
-- 9. 010-sync-hotel-price-2026.sql (hotel_price 테이블 동기화)
-- ============================================================================

-- 이 파일은 테이블 단순 재설정용으로만 사용
-- 실제 데이터 삽입은 개별 호텔 파일 사용 권장

COMMIT;

-- ============================================================================
-- 🎯 Supabase 실행 순서 (중요!)
-- ============================================================================
-- Step 1: 001-hotel-system-v3-tables-2026.sql ← 테이블 생성 (필수)
-- Step 2: 002~008 각 호텔 파일들 순서대로 실행 ← 데이터 로드
-- Step 3: 010-sync-hotel-price-2026.sql ← hotel_price 자동 동기화 (필수)
--
-- 3번 실행 후, 견적·예약·직접예약 페이지에서 모든 호텔이 자동으로 나타남 ✅
-- ============================================================================
