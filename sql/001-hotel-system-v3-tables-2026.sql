-- ============================================================================
-- 하롱베이 호텔 통합 관리 시스템 - 테이블 생성 (2026)
-- ============================================================================
-- 이 스크립트는 Supabase SQL Editor에서 한 번만 실행
-- 호텔 데이터는 호텔별 개별 스크립트에서 INSERT

-- ============================================================================
-- 1. ENUM 타입 정의
-- ============================================================================

-- 호텔 상품 타입
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'hotel_product_type') THEN
    CREATE TYPE hotel_product_type AS ENUM (
      'HOTEL',
      'RESORT_ONSEN',
      'VILLA_POOL',
      'VILLA_RESORT'
    );
  END IF;
END
$$;

-- 객실 카테고리
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'room_category_type') THEN
    CREATE TYPE room_category_type AS ENUM (
      'STANDARD_ROOM',
      'SUITE',
      'FAMILY_ROOM',
      'VILLA'
    );
  END IF;
END
$$;

-- 가격 책정 모델
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'pricing_model_type') THEN
    CREATE TYPE pricing_model_type AS ENUM (
      'FIXED_OCCUPANCY',
      'SCALED_OCCUPANCY',
      'DAY_PASS'
    );
  END IF;
END
$$;

-- 요일 필터
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'day_of_week_type') THEN
    CREATE TYPE day_of_week_type AS ENUM (
      'WEEKDAY',
      'WEEKEND',
      'ANY'
    );
  END IF;
END
$$;

-- 예약 상태
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'reservation_status_type') THEN
    CREATE TYPE reservation_status_type AS ENUM (
      'PENDING',
      'CONFIRMED',
      'PAID',
      'CANCELLED'
    );
  END IF;
END
$$;

-- ============================================================================
-- 2. 호텔 기본 정보 테이블
-- ============================================================================

CREATE TABLE IF NOT EXISTS hotel_info (
  hotel_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_name TEXT NOT NULL,
  hotel_code VARCHAR(10) UNIQUE NOT NULL,
  product_type hotel_product_type NOT NULL,
  location TEXT,
  star_rating INTEGER CHECK (star_rating >= 1 AND star_rating <= 5),
  check_in_time TIME DEFAULT '14:00:00',
  check_out_time TIME DEFAULT '11:00:00',
  special_features JSONB,
  active_year INTEGER[] DEFAULT ARRAY[2026],
  currency VARCHAR(3) DEFAULT 'VND',
  contact_info JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hotel_code ON hotel_info(hotel_code);
CREATE INDEX IF NOT EXISTS idx_product_type ON hotel_info(product_type);

-- ============================================================================
-- 3. 객실/빌라 타입 정의 테이블
-- ============================================================================

CREATE TABLE IF NOT EXISTS room_type (
  room_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_id UUID NOT NULL REFERENCES hotel_info(hotel_id) ON DELETE CASCADE,
  room_code VARCHAR(30) NOT NULL,
  room_name TEXT NOT NULL,
  room_category room_category_type NOT NULL,
  area_sqm INTEGER,
  bed_config TEXT,
  occupancy_base INTEGER NOT NULL,
  occupancy_max INTEGER,
  amenities JSONB,
  view_options TEXT[],
  extra_bed_allowed INTEGER DEFAULT 0,
  max_children INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  CONSTRAINT room_code_per_hotel UNIQUE(hotel_id, room_code)
);

CREATE INDEX IF NOT EXISTS idx_room_hotel_id ON room_type(hotel_id);
CREATE INDEX IF NOT EXISTS idx_room_category ON room_type(room_category);

-- ============================================================================
-- 4. 가격 책정 모델 테이블
-- ============================================================================

CREATE TABLE IF NOT EXISTS pricing_model (
  pricing_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_id UUID NOT NULL REFERENCES hotel_info(hotel_id) ON DELETE CASCADE,
  room_id UUID REFERENCES room_type(room_id) ON DELETE CASCADE,
  model_type pricing_model_type NOT NULL,
  season_key VARCHAR(100) NOT NULL,
  season_name TEXT,
  date_range_start DATE NOT NULL,
  date_range_end DATE NOT NULL,
  day_of_week day_of_week_type NOT NULL DEFAULT 'ANY',
  base_price DECIMAL(12,2) NOT NULL,
  extra_person_price DECIMAL(12,2),
  child_policy TEXT,
  surcharge_holiday DECIMAL(12,2),
  include_breakfast BOOLEAN DEFAULT TRUE,
  include_facilities TEXT,
  notes TEXT,
  calendar_year INTEGER DEFAULT 2026,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pricing_hotel_id ON pricing_model(hotel_id);
CREATE INDEX IF NOT EXISTS idx_pricing_room_id ON pricing_model(room_id);
CREATE INDEX IF NOT EXISTS idx_pricing_date_range ON pricing_model(date_range_start, date_range_end);
CREATE INDEX IF NOT EXISTS idx_pricing_year ON pricing_model(calendar_year);

-- ============================================================================
-- 5. 예약 기록 테이블 (기존 reservation_hotel 유지)
-- ============================================================================
-- ⚠️ reservation_hotel 테이블은 이미 Supabase에 존재하며 
--    기존 예약 시스템에서 사용 중이므로 여기서 생성하지 않음.
--    기존 스키마: reservation_id, schedule, room_count, checkin_date,
--    breakfast_service, hotel_category, guest_count, total_price, 
--    hotel_price_code, request_note, id, created_at, unit_price,
--    assignment_code, updated_at, adult_count, child_count, infant_count,
--    accommodation_info
-- ============================================================================

-- ============================================================================
-- 6. View: 호텔별 현재 요금 조회 (2026년 기준)
-- ============================================================================

CREATE OR REPLACE VIEW current_pricing_2026 AS
SELECT
  h.hotel_id,
  h.hotel_name,
  h.hotel_code,
  rt.room_id,
  rt.room_code,
  rt.room_name,
  pm.season_name,
  pm.date_range_start,
  pm.date_range_end,
  pm.day_of_week,
  pm.base_price,
  pm.extra_person_price,
  pm.child_policy,
  pm.surcharge_holiday,
  pm.include_breakfast,
  pm.include_facilities,
  pm.calendar_year
FROM hotel_info h
LEFT JOIN room_type rt ON h.hotel_id = rt.hotel_id
LEFT JOIN pricing_model pm ON (
  pm.hotel_id = h.hotel_id
  AND pm.calendar_year = 2026
)
ORDER BY h.hotel_name, COALESCE(rt.room_name, ''), COALESCE(pm.date_range_start, CURRENT_DATE);

-- ============================================================================
-- 7. RLS 정책 (Supabase 역할 기반 접근 제어)
-- ============================================================================

-- 호텔 정보는 모두 조회 가능 (public read)
ALTER TABLE hotel_info ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "hotel_info_public_read" ON hotel_info;
CREATE POLICY "hotel_info_public_read" ON hotel_info
  FOR SELECT USING (true);

-- 객실 정보는 모두 조회 가능
ALTER TABLE room_type ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "room_type_public_read" ON room_type;
CREATE POLICY "room_type_public_read" ON room_type
  FOR SELECT USING (true);

-- 가격 정보는 모두 조회 가능
ALTER TABLE pricing_model ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "pricing_model_public_read" ON pricing_model;
CREATE POLICY "pricing_model_public_read" ON pricing_model
  FOR SELECT USING (true);

-- ============================================================================
-- 8. 트리거: updated_at 자동 업데이트
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_hotel_info_timestamp ON hotel_info;
CREATE TRIGGER update_hotel_info_timestamp
  BEFORE UPDATE ON hotel_info
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_room_type_timestamp ON room_type;
CREATE TRIGGER update_room_type_timestamp
  BEFORE UPDATE ON room_type
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_pricing_model_timestamp ON pricing_model;
CREATE TRIGGER update_pricing_model_timestamp
  BEFORE UPDATE ON pricing_model
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 검증 완료
-- ============================================================================

-- SELECT COUNT(*) FROM hotel_info;
-- SELECT COUNT(*) FROM room_type;
-- SELECT COUNT(*) FROM pricing_model;
-- SELECT * FROM current_pricing_2026 LIMIT 10;
