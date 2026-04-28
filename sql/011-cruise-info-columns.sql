-- =====================================================
-- 011-cruise-info-columns.sql
-- cruise_info 테이블에 크루즈/객실 상세 설명 컬럼 추가
-- =====================================================

-- ── 객실 상세 정보 컬럼 ──
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS bed_type text;                    -- 침대 타입 (더블/트윈/킹 등)
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS max_adults integer DEFAULT 2;     -- 최대 성인 수
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS max_guests integer DEFAULT 3;     -- 최대 수용 인원
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS has_balcony boolean DEFAULT false; -- 발코니/베란다 유무
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS is_vip boolean DEFAULT false;     -- VIP 등급 여부
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS has_butler boolean DEFAULT false;  -- 버틀러 서비스
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS is_recommended boolean DEFAULT false; -- 추천 객실
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS connecting_available boolean DEFAULT false; -- 커넥팅룸 가능
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS extra_bed_available boolean DEFAULT true;   -- 엑스트라베드 가능
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS special_amenities text;            -- 특별 어메니티 (줄바꿈 구분)
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS warnings text;                     -- 주의사항/안내

-- ── 크루즈 상세 정보 컬럼 (크루즈별 공통, 각 행에 반복 저장) ──
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS itinerary jsonb;                   -- 일정표 (일차별 배열)
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS cancellation_policy jsonb;         -- 취소 규정 (조건별 배열)
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS inclusions text;                   -- 포함 사항
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS exclusions text;                   -- 불포함 사항
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS star_rating text;                  -- 등급 (6성급 등)
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS capacity text;                     -- 수용 인원 (예: 160명)
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS awards text;                       -- 수상 이력
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS facilities jsonb;                  -- 편의시설 목록

-- ── display_order 추가 (객실 정렬용) ──
ALTER TABLE cruise_info ADD COLUMN IF NOT EXISTS display_order integer DEFAULT 0;

SELECT 'cruise_info 컬럼 추가 완료' AS result;
