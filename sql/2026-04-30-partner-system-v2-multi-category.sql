-- ============================================================
-- 제휴업체(Partner) 시스템 v2 — 다업종 대응 확장
-- 작성일: 2026-04-30
-- 전제: 2026-04-30-partner-system.sql (v1) 적용 완료
-- 범위:
--   1) partner.category 자유화 (체크 제약 제거 + 권장 카탈로그 코멘트)
--   2) 시간 기반 서비스(스파/마사지) 지원 — duration_minutes, unit
--   3) 수량 기반 서비스(식당/의상대여) 지원 — quantity, scheduled_at
--   4) 호텔 전용 컬럼(checkin/checkout/nights)을 nullable로 완화
--   5) 가격 옵션(시간/등급) 분리 — partner_price.duration_minutes, tier_label
--   6) SERENE Spa(하노이 본점) 샘플 시드
-- 정책: 모든 변경은 idempotent (IF NOT EXISTS / ADD COLUMN IF NOT EXISTS)
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1) partner 확장
-- ------------------------------------------------------------
-- category: 'hotel','spa','restaurant','costume_rental','tour','rentcar','massage','shopping','activity', ...
ALTER TABLE partner
    ADD COLUMN IF NOT EXISTS subcategory          text,                       -- 예: 'foot_spa','korean_food','ao_dai_rental'
    ADD COLUMN IF NOT EXISTS timezone             text NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
    ADD COLUMN IF NOT EXISTS default_discount_rate numeric(5,2) NOT NULL DEFAULT 0,  -- 스테이하롱 회원 기본 할인율(%)
    ADD COLUMN IF NOT EXISTS website_url          text,
    ADD COLUMN IF NOT EXISTS map_url              text,
    ADD COLUMN IF NOT EXISTS thumbnail_url        text,
    ADD COLUMN IF NOT EXISTS branch_name          text,                       -- 본점/지점 구분 (예: '하노이 본점')
    ADD COLUMN IF NOT EXISTS open_hours           text,                       -- 자유 텍스트 (예: '10:00-23:00')
    ADD COLUMN IF NOT EXISTS booking_lead_hours   int  NOT NULL DEFAULT 0,    -- 최소 예약 리드타임(시간). 당일 예약 차단용
    ADD COLUMN IF NOT EXISTS internal_memo        text;

COMMENT ON COLUMN partner.category IS '권장값: hotel, spa, restaurant, costume_rental, massage, tour, rentcar, shopping, activity, etc.';
COMMENT ON COLUMN partner.default_discount_rate IS '스테이하롱 고객 기본 할인율(%). 서비스별 override는 partner_service.sht_discount_rate.';
COMMENT ON COLUMN partner.booking_lead_hours IS '최소 예약 리드타임(시간). 0이면 당일 예약 가능.';

-- ------------------------------------------------------------
-- 2) partner_service 확장 (시간/수량 기반 서비스 지원)
-- ------------------------------------------------------------
ALTER TABLE partner_service
    ADD COLUMN IF NOT EXISTS service_subtype     text,                        -- 'foot_treatment','body_massage','main_dish','set_menu','daily_rental' ...
    ADD COLUMN IF NOT EXISTS unit                text NOT NULL DEFAULT 'session', -- 'night','session','hour','meal','item','day','person'
    ADD COLUMN IF NOT EXISTS duration_minutes    int,                          -- 시간 기반 서비스 기본 소요시간(스파 75분 등)
    ADD COLUMN IF NOT EXISTS min_quantity        int  NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS max_quantity        int,                          -- NULL=무제한
    ADD COLUMN IF NOT EXISTS sht_discount_rate   numeric(5,2),                 -- 서비스별 할인율 override(NULL이면 partner.default_discount_rate 사용)
    ADD COLUMN IF NOT EXISTS thumbnail_url       text,
    ADD COLUMN IF NOT EXISTS sort_order          int  NOT NULL DEFAULT 0;

COMMENT ON COLUMN partner_service.unit IS '가격 단위. night=박, session=회, hour=시간, meal=식, item=벌/개, day=일, person=인';
COMMENT ON COLUMN partner_service.duration_minutes IS '시간 기반 서비스의 기본 소요시간(분). 스파/마사지 메뉴.';
COMMENT ON COLUMN partner_service.sht_discount_rate IS '스테이하롱 할인율(%). NULL이면 partner.default_discount_rate.';

-- service_type 기본값을 더 일반화 (room → service)
ALTER TABLE partner_service ALTER COLUMN service_type SET DEFAULT 'service';

-- ------------------------------------------------------------
-- 3) partner_price 확장 (시간옵션·등급별 다단가)
-- ------------------------------------------------------------
ALTER TABLE partner_price
    ADD COLUMN IF NOT EXISTS duration_minutes    int,                          -- 75/90 분 같은 시간 옵션
    ADD COLUMN IF NOT EXISTS tier_label          text,                         -- 'standard','vip','peak' 등
    ADD COLUMN IF NOT EXISTS sht_price           numeric(14,2),                -- 스테이하롱 회원가(미리 계산된 가격, 옵션)
    ADD COLUMN IF NOT EXISTS is_active           boolean NOT NULL DEFAULT true;

CREATE INDEX IF NOT EXISTS idx_partner_price_active ON partner_price(service_id, is_active);

-- ------------------------------------------------------------
-- 4) partner_reservation 확장 (시간/수량 기반 예약 지원)
-- ------------------------------------------------------------
-- 호텔 외 업종(스파/식당/의상)은 checkin/checkout/nights 가 의미 없을 수 있음 → nullable
ALTER TABLE partner_reservation
    ALTER COLUMN checkin_date  DROP NOT NULL,
    ALTER COLUMN checkout_date DROP NOT NULL,
    ALTER COLUMN nights        DROP NOT NULL;

ALTER TABLE partner_reservation
    ADD COLUMN IF NOT EXISTS scheduled_at       timestamptz,                  -- 예약 시작 시각(스파/식당 등)
    ADD COLUMN IF NOT EXISTS duration_minutes   int,                          -- 실제 예약된 소요시간
    ADD COLUMN IF NOT EXISTS quantity           int  NOT NULL DEFAULT 1,      -- 수량 (의상 벌수, 식사 인분 등). 호텔은 room_count와 별개로 1.
    ADD COLUMN IF NOT EXISTS service_label      text,                         -- 예약 시점 서비스명/메뉴 스냅샷
    ADD COLUMN IF NOT EXISTS price_label        text,                         -- 예약 시점 가격옵션 스냅샷 (예: '75분')
    ADD COLUMN IF NOT EXISTS discount_rate      numeric(5,2) NOT NULL DEFAULT 0, -- 적용된 할인율(%)
    ADD COLUMN IF NOT EXISTS discount_amount    numeric(14,2) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS payment_status     text NOT NULL DEFAULT 'unpaid', -- unpaid|partial|paid|refunded
    ADD COLUMN IF NOT EXISTS confirmation_code  text;

CREATE INDEX IF NOT EXISTS idx_partner_res_scheduled ON partner_reservation(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_partner_res_service   ON partner_reservation(pr_service_id);

-- 무결성 체크: 시간 기반(scheduled_at) 또는 숙박 기반(checkin_date) 중 하나 이상 존재
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'partner_reservation_time_or_date_chk'
    ) THEN
        ALTER TABLE partner_reservation
            ADD CONSTRAINT partner_reservation_time_or_date_chk
            CHECK (scheduled_at IS NOT NULL OR checkin_date IS NOT NULL);
    END IF;
END$$;

-- ------------------------------------------------------------
-- 5) updated_at 자동 갱신 트리거 (공용)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION partner_set_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY['partner','partner_service','partner_reservation']
    LOOP
        EXECUTE format(
            'DROP TRIGGER IF EXISTS trg_%1$s_updated_at ON %1$s; '
            'CREATE TRIGGER trg_%1$s_updated_at BEFORE UPDATE ON %1$s '
            'FOR EACH ROW EXECUTE FUNCTION partner_set_updated_at();',
            t
        );
    END LOOP;
END$$;

COMMIT;

-- ============================================================
-- 6) SERENE Spa 시드 데이터 (하노이 본점)
--    스테이하롱 크루즈 회원 10% 할인 / 당일 예약 불가
-- ============================================================
BEGIN;

-- 6-1) partner
INSERT INTO partner (
    partner_code, name, branch_name, category, subcategory,
    region, address, contact_phone, description,
    default_discount_rate, booking_lead_hours, open_hours,
    map_url, is_active
) VALUES (
    'SERENE-HN-001',
    'SERENE Spa',
    '하노이 본점',
    'spa',
    'foot_and_body_spa',
    'Hanoi',
    'Hanoi Old Quarter, Vietnam',
    NULL,
    'SERENE — 연꽃잎과 학에서 영감을 얻은 평온한 스파. 스테이하롱 대표 MEO가 즐겨 이용하는 단골 제휴 스파. 하노이 3개·호이안 2개 지점 운영.',
    10.00,   -- 스테이하롱 10% 할인
    24,      -- 당일 예약 불가 → 24시간 리드타임
    '10:00-23:00',
    'https://maps.google.com/?q=Serene+Spa+Hanoi',
    true
)
ON CONFLICT (partner_code) DO UPDATE SET
    name = EXCLUDED.name,
    branch_name = EXCLUDED.branch_name,
    category = EXCLUDED.category,
    subcategory = EXCLUDED.subcategory,
    region = EXCLUDED.region,
    address = EXCLUDED.address,
    description = EXCLUDED.description,
    default_discount_rate = EXCLUDED.default_discount_rate,
    booking_lead_hours = EXCLUDED.booking_lead_hours,
    open_hours = EXCLUDED.open_hours,
    map_url = EXCLUDED.map_url,
    is_active = EXCLUDED.is_active,
    updated_at = now();

-- 6-2) partner_service + partner_price
DO $$
DECLARE
    v_partner_id uuid;
    v_service_id uuid;
BEGIN
    SELECT partner_id INTO v_partner_id FROM partner WHERE partner_code = 'SERENE-HN-001';

    -- (A) 발 토탈 트리트먼트
    INSERT INTO partner_service (
        partner_id, service_type, service_subtype, service_name, description,
        unit, duration_minutes, default_price, currency, is_active, sort_order
    ) VALUES (
        v_partner_id, 'spa_menu', 'foot_treatment',
        '발 토탈 트리트먼트',
        '따뜻한 허브 족욕 + 발마사지로 깊은 휴식과 숙면을 돕는 트리트먼트',
        'session', 75, 734400, 'VND', true, 10
    )
    RETURNING service_id INTO v_service_id;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note)
    VALUES
        ('SERENE-HN-001-FOOT-TOTAL-75', v_service_id, 75, 'standard', 734400, '75분', '세금 포함 / 스테이하롱 10% 할인 별도 적용'),
        ('SERENE-HN-001-FOOT-TOTAL-90', v_service_id, 90, 'standard', 896400, '90분', '세금 포함 / 스테이하롱 10% 할인 별도 적용')
    ON CONFLICT (price_code) DO UPDATE SET
        price = EXCLUDED.price,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label = EXCLUDED.tier_label,
        condition_label = EXCLUDED.condition_label,
        note = EXCLUDED.note;

    -- (B) 발 릴렉싱 마사지
    INSERT INTO partner_service (
        partner_id, service_type, service_subtype, service_name, description,
        unit, duration_minutes, default_price, currency, is_active, sort_order
    ) VALUES (
        v_partner_id, 'spa_menu', 'foot_massage',
        '발 릴렉싱 마사지',
        '발 반사요법 기반의 혈액 순환 개선·면역 균형·에너지 재생 마사지',
        'session', 45, 518400, 'VND', true, 20
    )
    RETURNING service_id INTO v_service_id;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note)
    VALUES
        ('SERENE-HN-001-FOOT-RELAX-45', v_service_id, 45, 'standard', 518400, '45분', '세금 포함 / 스테이하롱 10% 할인 별도 적용'),
        ('SERENE-HN-001-FOOT-RELAX-60', v_service_id, 60, 'standard', 626400, '60분', '세금 포함 / 스테이하롱 10% 할인 별도 적용')
    ON CONFLICT (price_code) DO UPDATE SET
        price = EXCLUDED.price,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label = EXCLUDED.tier_label,
        condition_label = EXCLUDED.condition_label,
        note = EXCLUDED.note;

    -- (C) 릴렉싱 테라피 (오일)
    INSERT INTO partner_service (
        partner_id, service_type, service_subtype, service_name, description,
        unit, duration_minutes, default_price, currency, is_active, sort_order
    ) VALUES (
        v_partner_id, 'spa_menu', 'body_massage_oil',
        '릴렉싱 테라피',
        '100% 천연 오일 — 피부 관리·근육 이완·체내 독소 배출',
        'session', 60, 680400, 'VND', true, 30
    )
    RETURNING service_id INTO v_service_id;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note)
    VALUES
        ('SERENE-HN-001-RELAX-OIL-60', v_service_id, 60, 'standard', 680400, '60분', '세금 포함 / 스테이하롱 10% 할인 별도 적용'),
        ('SERENE-HN-001-RELAX-OIL-90', v_service_id, 90, 'standard', 950400, '90분', '세금 포함 / 스테이하롱 10% 할인 별도 적용')
    ON CONFLICT (price_code) DO UPDATE SET
        price = EXCLUDED.price,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label = EXCLUDED.tier_label,
        condition_label = EXCLUDED.condition_label,
        note = EXCLUDED.note;

    -- (D) 태국 로얄 마사지
    INSERT INTO partner_service (
        partner_id, service_type, service_subtype, service_name, description,
        unit, duration_minutes, default_price, currency, is_active, sort_order
    ) VALUES (
        v_partner_id, 'spa_menu', 'body_massage_thai',
        '태국 로얄 마사지',
        '수동 스트레칭 + 호흡 기반 지압 — 근육·관절 통증 완화 및 부상 예방',
        'session', 60, 680400, 'VND', true, 40
    )
    RETURNING service_id INTO v_service_id;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note)
    VALUES
        ('SERENE-HN-001-THAI-ROYAL-60', v_service_id, 60, 'standard', 680400, '60분', '세금 포함 / 스테이하롱 10% 할인 별도 적용'),
        ('SERENE-HN-001-THAI-ROYAL-90', v_service_id, 90, 'standard', 950400, '90분', '세금 포함 / 스테이하롱 10% 할인 별도 적용')
    ON CONFLICT (price_code) DO UPDATE SET
        price = EXCLUDED.price,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label = EXCLUDED.tier_label,
        condition_label = EXCLUDED.condition_label,
        note = EXCLUDED.note;
END$$;

COMMIT;

-- ============================================================
-- 검증 쿼리(수동)
-- ============================================================
-- SELECT partner_code, name, branch_name, category, default_discount_rate, booking_lead_hours
-- FROM partner WHERE partner_code = 'SERENE-HN-001';
--
-- SELECT s.service_name, s.unit, s.duration_minutes, s.default_price
-- FROM partner_service s
-- JOIN partner p USING (partner_id)
-- WHERE p.partner_code = 'SERENE-HN-001'
-- ORDER BY s.sort_order;
--
-- SELECT pp.price_code, pp.duration_minutes, pp.price, pp.condition_label
-- FROM partner_price pp
-- JOIN partner_service ps USING (service_id)
-- JOIN partner p USING (partner_id)
-- WHERE p.partner_code = 'SERENE-HN-001'
-- ORDER BY ps.sort_order, pp.duration_minutes;
--
-- 새 컬럼 확인:
-- SELECT column_name, data_type, is_nullable, column_default
-- FROM information_schema.columns
-- WHERE table_name IN ('partner','partner_service','partner_price','partner_reservation')
-- ORDER BY table_name, ordinal_position;
