-- ============================================================================
-- 투어 상품 관리 시스템 테이블 생성 (2026)
-- ============================================================================
-- 이 스크립트는 Supabase SQL Editor에서 한 번만 실행
-- 투어 상품 데이터는 투어별 개별 스크립트에서 INSERT

-- ============================================================================
-- 1. ENUM 타입 정의 (간단한 생성 방식)
-- ============================================================================

-- 투어 그룹 타입
DROP TYPE IF EXISTS tour_group_type CASCADE;
CREATE TYPE tour_group_type AS ENUM (
  'private',      -- 단독투어
  'group',        -- 공동투어
  'hybrid'        -- 혼합
);

-- 투어 상태
DROP TYPE IF EXISTS tour_status CASCADE;
CREATE TYPE tour_status AS ENUM (
  'active',
  'inactive',
  'discontinued',
  'seasonal'
);

-- 예약 상태
DROP TYPE IF EXISTS booking_status CASCADE;
CREATE TYPE booking_status AS ENUM (
  'pending',           -- 대기중
  'deposit_paid',      -- 예약금 지불
  'confirmed',         -- 확정
  'completed',         -- 완료
  'cancelled'          -- 취소
);

-- 결제 상태
DROP TYPE IF EXISTS payment_status CASCADE;
CREATE TYPE payment_status AS ENUM (
  'unpaid',           -- 미결제
  'deposit_paid',     -- 예약금 결제
  'fully_paid',       -- 완전 결제
  'refunded'          -- 환불
);

-- 결제 방식
DROP TYPE IF EXISTS payment_method CASCADE;
CREATE TYPE payment_method AS ENUM (
  'card',            -- 신용카드
  'bank_transfer',   -- 은행이체
  'cash',            -- 현금
  'paypal'           -- PayPal
);

-- 시즌 타입
DROP TYPE IF EXISTS season_type CASCADE;
CREATE TYPE season_type AS ENUM (
  'PEAK',           -- 성수기
  'OFF_SEASON',     -- 비수기
  'YEAR'            -- 연중
);

-- 가격 타입 (인원별, 인원 비례, 일일 패스)
DROP TYPE IF EXISTS price_type CASCADE;
CREATE TYPE price_type AS ENUM (
  'per_person',
  'per_team',
  'day_pass'
);

-- 옵션 카테고리
DROP TYPE IF EXISTS option_category CASCADE;
CREATE TYPE option_category AS ENUM (
  'meal',       -- 식사
  'activity',   -- 액티비티
  'transport',  -- 교통
  'service',    -- 서비스
  'other'       -- 기타
);

-- 정보 타입
DROP TYPE IF EXISTS info_type CASCADE;
CREATE TYPE info_type AS ENUM (
  'notice',    -- 공지사항
  'warning',   -- 경고
  'caution',   -- 주의
  'guide'      -- 가이드
);

-- ============================================================================
-- 2. 기본 테이블 (DROP IF EXISTS로 정리)
-- ============================================================================

-- 기존 테이블 정리 (순서 중요: 자식 테이블부터 삭제)
DROP TABLE IF EXISTS tour_review CASCADE;
DROP TABLE IF EXISTS tour_booking CASCADE;
DROP TABLE IF EXISTS tour_cancellation_policy CASCADE;
DROP TABLE IF EXISTS tour_important_info CASCADE;
DROP TABLE IF EXISTS tour_schedule CASCADE;
DROP TABLE IF EXISTS tour_addon_options CASCADE;
DROP TABLE IF EXISTS tour_exclusions CASCADE;
DROP TABLE IF EXISTS tour_inclusions CASCADE;
DROP TABLE IF EXISTS tour_pricing CASCADE;
DROP TABLE IF EXISTS tour CASCADE;

-- 투어 기본 정보
CREATE TABLE tour (
  tour_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_code TEXT NOT NULL UNIQUE,
  tour_name TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  overview TEXT,
  duration TEXT,
  guide_language TEXT[] DEFAULT ARRAY['한국어'],
  group_type tour_group_type NOT NULL DEFAULT 'private',
  location TEXT,
  starting_point TEXT,
  meeting_time TIME,
  image_url TEXT,
  thumbnail_url TEXT,
  rating DECIMAL(3,2) DEFAULT 0,
  review_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  status tour_status DEFAULT 'active',
  min_age_free_applicable INTEGER,          -- 요금 미적용 최소 나이 (예: 3세)
  special_age_policy_description TEXT,      -- 특수 나이정책 설명 (예: 5세 미만 인원미포함)
  contact_info JSONB,                       -- {"kakao_channel": "...", "phone_vn": "...", "phone_kr": "..."}
  payment_notes TEXT,                       -- 결제 특수 사항 (예약금 비율, 통화 정보)
  cancellation_policy_url TEXT,             -- 취소 정책 상세 URL
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- 투어별 가격 (인원수 기준)
CREATE TABLE tour_pricing (
  pricing_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL REFERENCES tour(tour_id) ON DELETE CASCADE,
  min_guests INTEGER NOT NULL,
  max_guests INTEGER NOT NULL,
  price_per_person DECIMAL(15,0) NOT NULL,
  vehicle_type TEXT,
  deposit_amount DECIMAL(15,0),
  deposit_rate DECIMAL(3,2),
  deposit_payment_method TEXT DEFAULT 'card',     -- 예약금 결제 방식 (card, bank_transfer, cash)
  balance_payment_method TEXT,                    -- 잔금 결제 방식 (cash, bank_transfer, card)
  balance_currency TEXT DEFAULT 'VND',            -- 잔금 통화 (VND, KRW 등)
  season_key season_type DEFAULT 'YEAR',
  valid_from DATE,
  valid_until DATE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  
  CONSTRAINT valid_guest_range CHECK (min_guests <= max_guests)
);

-- 포함사항
CREATE TABLE tour_inclusions (
  inclusion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL REFERENCES tour(tour_id) ON DELETE CASCADE,
  order_seq INTEGER,
  description TEXT NOT NULL,
  icon TEXT,
  category TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- 불포함사항
CREATE TABLE tour_exclusions (
  exclusion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL REFERENCES tour(tour_id) ON DELETE CASCADE,
  order_seq INTEGER,
  description TEXT NOT NULL,
  category TEXT,
  estimated_price DECIMAL(15,0),
  price_currency TEXT DEFAULT 'VND',
  notes TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- 추가옵션
CREATE TABLE tour_addon_options (
  option_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL REFERENCES tour(tour_id) ON DELETE CASCADE,
  option_name TEXT NOT NULL,
  option_category option_category,
  description TEXT,
  detailed_description JSONB,
  price DECIMAL(15,0),
  price_type price_type DEFAULT 'per_person',
  price_currency TEXT DEFAULT 'VND',
  is_guide_escort_fee BOOLEAN DEFAULT false,          -- 가이드 동행료 여부
  is_post_tour_optional BOOLEAN DEFAULT false,        -- 투어 후 선택 옵션 여부
  duration_minutes INTEGER,
  is_required BOOLEAN DEFAULT false,
  is_available BOOLEAN DEFAULT true,
  max_capacity INTEGER,
  order_seq INTEGER,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- 일정/스케줄
CREATE TABLE tour_schedule (
  schedule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL REFERENCES tour(tour_id) ON DELETE CASCADE,
  day_number INTEGER NOT NULL,
  order_seq INTEGER NOT NULL,
  start_time TIME,
  end_time TIME,
  activity_name TEXT NOT NULL,
  activity_description TEXT,
  location TEXT,
  duration_minutes INTEGER,
  notes JSONB,
  optional BOOLEAN DEFAULT false,
  order_changeable BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now(),
  
  CONSTRAINT valid_day_number CHECK (day_number >= 1)
);

-- 취소정책
CREATE TABLE tour_cancellation_policy (
  policy_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL REFERENCES tour(tour_id) ON DELETE CASCADE,
  policy_name TEXT,
  order_seq INTEGER,
  days_before_min INTEGER,
  days_before_max INTEGER,
  penalty_type TEXT,            -- 'fixed' 또는 'rate'
  penalty_amount DECIMAL(15,0),
  penalty_rate DECIMAL(3,2),
  description TEXT,
  refundable BOOLEAN DEFAULT true,
  notes TEXT,
  created_at TIMESTAMP DEFAULT now(),
  
  CONSTRAINT valid_days CHECK (days_before_min <= days_before_max)
);

-- 중요 정보/주의사항
CREATE TABLE tour_important_info (
  info_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_id UUID NOT NULL REFERENCES tour(tour_id) ON DELETE CASCADE,
  info_type info_type,
  title TEXT,
  content TEXT NOT NULL,
  order_seq INTEGER,
  is_highlighted BOOLEAN DEFAULT false,
  icon TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- ============================================================================
-- 3. 예약 관련 테이블
-- ============================================================================

-- 투어 예약
CREATE TABLE tour_booking (
  booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  tour_id UUID NOT NULL REFERENCES tour(tour_id),
  tour_date DATE NOT NULL,
  guest_count INTEGER NOT NULL,
  adult_count INTEGER,                      -- 성인 수
  child_count INTEGER DEFAULT 0,            -- 아동 수 (3세 이상 또는 5세 이상)
  infant_count INTEGER DEFAULT 0,           -- 유아 수 (3세 미만, 요금 미적용)
  special_age_children_count INTEGER DEFAULT 0,  -- 특수정책 아동 (예: 5세 미만, 비용 미포함)
  selected_vehicle_type TEXT,               -- 선택된 차량 유형
  selected_spa_menu TEXT,                   -- 선택된 스파 메뉴 (기본/성장판/발마사지)
  total_price DECIMAL(15,0),
  deposit_paid DECIMAL(15,0),
  remaining_balance DECIMAL(15,0),
  deposit_paid_at TIMESTAMP,
  payment_due_date TIMESTAMP,
  booking_status booking_status DEFAULT 'pending',
  payment_status payment_status DEFAULT 'unpaid',
  payment_method payment_method,
  special_requests TEXT,                    -- 추가 요청사항
  selected_options JSONB,                   -- [{"option_id": "...", "quantity": 1}]
  guide_info JSONB,
  booking_source TEXT DEFAULT 'kakao',
  notes TEXT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  cancelled_at TIMESTAMP,
  
  CONSTRAINT valid_guest_count CHECK (guest_count > 0)
);

-- 리뷰/평점
CREATE TABLE tour_review (
  review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID REFERENCES tour_booking(booking_id),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  tour_id UUID NOT NULL REFERENCES tour(tour_id),
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  comment TEXT,
  verified_purchase BOOLEAN DEFAULT true,
  helpful_count INTEGER DEFAULT 0,
  images JSONB,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- ============================================================================
-- 4. 인덱스 생성 (성능 최적화)
-- ============================================================================

-- 투어 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_tour_code ON tour(tour_code);
CREATE INDEX IF NOT EXISTS idx_tour_category ON tour(category);
CREATE INDEX IF NOT EXISTS idx_tour_location ON tour(location);
CREATE INDEX IF NOT EXISTS idx_tour_active ON tour(is_active, status);

-- 가격 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_tour_pricing_tour_id ON tour_pricing(tour_id);
CREATE INDEX IF NOT EXISTS idx_tour_pricing_guest_range ON tour_pricing(tour_id, min_guests, max_guests);
CREATE INDEX IF NOT EXISTS idx_tour_pricing_dates ON tour_pricing(valid_from, valid_until);

-- 옵션 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_tour_addon_options_tour_id ON tour_addon_options(tour_id);
CREATE INDEX IF NOT EXISTS idx_tour_addon_options_category ON tour_addon_options(option_category);

-- 예약 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_tour_booking_user_id ON tour_booking(user_id);
CREATE INDEX IF NOT EXISTS idx_tour_booking_tour_id ON tour_booking(tour_id);
CREATE INDEX IF NOT EXISTS idx_tour_booking_tour_date ON tour_booking(tour_date);
CREATE INDEX IF NOT EXISTS idx_tour_booking_status ON tour_booking(booking_status, payment_status);
CREATE INDEX IF NOT EXISTS idx_tour_booking_dates ON tour_booking(tour_date, booking_status);

-- 리뷰 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_tour_review_tour_id ON tour_review(tour_id);
CREATE INDEX IF NOT EXISTS idx_tour_review_user_id ON tour_review(user_id);
CREATE INDEX IF NOT EXISTS idx_tour_review_rating ON tour_review(tour_id, rating);

-- ============================================================================
-- 5. RLS 정책 (Row Level Security)
-- ============================================================================

-- 투어 정보는 모두 조회 가능 (public read)
ALTER TABLE tour ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_public_read" ON tour;
CREATE POLICY "tour_public_read" ON tour
  FOR SELECT USING (true);

-- 투어 가격 정보는 모두 조회 가능
ALTER TABLE tour_pricing ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_pricing_public_read" ON tour_pricing;
CREATE POLICY "tour_pricing_public_read" ON tour_pricing
  FOR SELECT USING (true);

-- 투어 포함/불포함 정보는 모두 조회 가능
ALTER TABLE tour_inclusions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_inclusions_public_read" ON tour_inclusions;
CREATE POLICY "tour_inclusions_public_read" ON tour_inclusions
  FOR SELECT USING (true);

ALTER TABLE tour_exclusions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_exclusions_public_read" ON tour_exclusions;
CREATE POLICY "tour_exclusions_public_read" ON tour_exclusions
  FOR SELECT USING (true);

-- 투어 옵션은 모두 조회 가능
ALTER TABLE tour_addon_options ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_addon_options_public_read" ON tour_addon_options;
CREATE POLICY "tour_addon_options_public_read" ON tour_addon_options
  FOR SELECT USING (true);

-- 투어 일정은 모두 조회 가능
ALTER TABLE tour_schedule ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_schedule_public_read" ON tour_schedule;
CREATE POLICY "tour_schedule_public_read" ON tour_schedule
  FOR SELECT USING (true);

-- 예약은 본인만 조회 가능
ALTER TABLE tour_booking ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_booking_user_read" ON tour_booking;
CREATE POLICY "tour_booking_user_read" ON tour_booking
  FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "tour_booking_user_insert" ON tour_booking;
CREATE POLICY "tour_booking_user_insert" ON tour_booking
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 리뷰는 모두 조회 가능, 본인만 작성 가능
ALTER TABLE tour_review ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tour_review_public_read" ON tour_review;
CREATE POLICY "tour_review_public_read" ON tour_review
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "tour_review_user_insert" ON tour_review;
CREATE POLICY "tour_review_user_insert" ON tour_review
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- 6. VIEW 생성
-- ============================================================================

-- 투어별 평균 평점 및 리뷰 수
CREATE OR REPLACE VIEW tour_stats AS
SELECT
  t.tour_id,
  t.tour_name,
  COUNT(DISTINCT r.review_id) AS total_reviews,
  ROUND(AVG(r.rating)::NUMERIC, 2) AS avg_rating,
  COUNT(DISTINCT tb.booking_id) AS total_bookings,
  SUM(tb.total_price) AS total_revenue
FROM tour t
LEFT JOIN tour_review r ON t.tour_id = r.tour_id
LEFT JOIN tour_booking tb ON t.tour_id = tb.tour_id AND tb.booking_status IN ('completed', 'confirmed')
GROUP BY t.tour_id, t.tour_name;

-- 특정 날짜의 가용 투어
CREATE OR REPLACE VIEW available_tours_by_date AS
SELECT
  t.tour_id,
  t.tour_code,
  t.tour_name,
  t.location,
  tp.min_guests,
  tp.max_guests,
  tp.price_per_person,
  tp.vehicle_type,
  CURRENT_DATE::DATE AS available_date
FROM tour t
JOIN tour_pricing tp ON t.tour_id = tp.tour_id
WHERE t.is_active = true
  AND t.status = 'active'
  AND tp.is_active = true
  AND (tp.valid_from IS NULL OR tp.valid_from <= CURRENT_DATE)
  AND (tp.valid_until IS NULL OR tp.valid_until >= CURRENT_DATE);

-- ============================================================================
-- 테이블 생성 완료
-- ============================================================================
-- 다음 단계: 투어 상품 데이터 입력 (012-tour-ninh-data.sql 등)
