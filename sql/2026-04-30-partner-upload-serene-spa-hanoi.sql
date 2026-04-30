-- ============================================================
-- 제휴업체 업로드: SERENE Spa (하노이 본점)
-- 작성일: 2026-04-30
-- 전제: 2026-04-30-partner-system.sql (v1) 적용 완료
-- 특징:
--   - 100% idempotent — 반복 실행해도 중복/오류 없음
--   - v2 컬럼이 없으면 본 스크립트에서 자동 ADD COLUMN (셀프 컨테인드)
-- 적용 위치: Supabase SQL Editor 또는 psql
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 0) 스키마 자동 보강 — v2 마이그레이션 미적용 환경 대응
--    (이미 적용된 환경에서는 NO-OP, 안전)
-- ------------------------------------------------------------
-- partner 확장 컬럼
ALTER TABLE partner
    ADD COLUMN IF NOT EXISTS subcategory           text,
    ADD COLUMN IF NOT EXISTS timezone              text NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
    ADD COLUMN IF NOT EXISTS default_discount_rate numeric(5,2) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS website_url           text,
    ADD COLUMN IF NOT EXISTS map_url               text,
    ADD COLUMN IF NOT EXISTS thumbnail_url         text,
    ADD COLUMN IF NOT EXISTS branch_name           text,
    ADD COLUMN IF NOT EXISTS open_hours            text,
    ADD COLUMN IF NOT EXISTS booking_lead_hours    int  NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS internal_memo         text;

-- partner_service 확장 컬럼
ALTER TABLE partner_service
    ADD COLUMN IF NOT EXISTS service_subtype       text,
    ADD COLUMN IF NOT EXISTS unit                  text NOT NULL DEFAULT 'session',
    ADD COLUMN IF NOT EXISTS duration_minutes      int,
    ADD COLUMN IF NOT EXISTS min_quantity          int  NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS max_quantity          int,
    ADD COLUMN IF NOT EXISTS sht_discount_rate     numeric(5,2),
    ADD COLUMN IF NOT EXISTS thumbnail_url         text,
    ADD COLUMN IF NOT EXISTS sort_order            int  NOT NULL DEFAULT 0;

-- partner_price 확장 컬럼
ALTER TABLE partner_price
    ADD COLUMN IF NOT EXISTS duration_minutes      int,
    ADD COLUMN IF NOT EXISTS tier_label            text,
    ADD COLUMN IF NOT EXISTS sht_price             numeric(14,2),
    ADD COLUMN IF NOT EXISTS is_active             boolean NOT NULL DEFAULT true;

-- ------------------------------------------------------------
-- 1) partner 마스터 등록/갱신
-- ------------------------------------------------------------
INSERT INTO partner (
    partner_code,
    name,
    branch_name,
    category,
    subcategory,
    region,
    address,
    contact_phone,
    description,
    default_discount_rate,
    booking_lead_hours,
    open_hours,
    map_url,
    is_active
) VALUES (
    'SERENE-HN-001',
    'SERENE Spa',
    '하노이 본점 (Serene Spa Hanoi)',
    'spa',
    'foot_and_body_spa',
    'Hanoi',
    'Hanoi Old Quarter, Vietnam',
    NULL,
    'SERENE — 연꽃잎과 학에서 영감을 얻은 평온한 스파. 스테이하롱 대표 MEO가 즐겨 이용하는 단골 제휴 스파. 하노이 3개·호이안 2개 지점 운영. 움직임·호흡·치유 3대 핵심에 기반한 트리트먼트 제공.',
    10.00,    -- 스테이하롱 회원 10% 할인
    24,       -- 당일 예약 불가 → 24시간 리드타임
    '10:00-23:00',
    'https://maps.google.com/?q=Serene+Spa+Hanoi',
    true
)
ON CONFLICT (partner_code) DO UPDATE SET
    name                  = EXCLUDED.name,
    branch_name           = EXCLUDED.branch_name,
    category              = EXCLUDED.category,
    subcategory           = EXCLUDED.subcategory,
    region                = EXCLUDED.region,
    address               = EXCLUDED.address,
    description           = EXCLUDED.description,
    default_discount_rate = EXCLUDED.default_discount_rate,
    booking_lead_hours    = EXCLUDED.booking_lead_hours,
    open_hours            = EXCLUDED.open_hours,
    map_url               = EXCLUDED.map_url,
    is_active             = EXCLUDED.is_active,
    updated_at            = now();

-- ------------------------------------------------------------
-- 2) 서비스(메뉴) + 가격 옵션 — 업서트 패턴
--    service_name + partner_id로 중복 판단 (UNIQUE 키 없으면 SELECT 후 분기)
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_service_id uuid;

    -- (서비스, 단축코드, 기본가, 기본분, 설명, 정렬)
    -- 가격은 기본가(75/45/60/60분)를 default_price로 저장
    rec RECORD;
BEGIN
    SELECT partner_id INTO v_partner_id FROM partner WHERE partner_code = 'SERENE-HN-001';
    IF v_partner_id IS NULL THEN
        RAISE EXCEPTION 'partner SERENE-HN-001 not found';
    END IF;

    -- ============= (A) 발 토탈 트리트먼트 =============
    SELECT service_id INTO v_service_id
    FROM partner_service
    WHERE partner_id = v_partner_id AND service_name = '발 토탈 트리트먼트';

    IF v_service_id IS NULL THEN
        INSERT INTO partner_service (
            partner_id, service_type, service_subtype, service_name, description,
            unit, duration_minutes, default_price, currency, is_active, sort_order
        ) VALUES (
            v_partner_id, 'spa_menu', 'foot_treatment',
            '발 토탈 트리트먼트',
            '따뜻한 허브 족욕으로 몸을 이완시킨 후 부드러운 발마사지로 깊은 휴식과 숙면을 돕는 트리트먼트',
            'session', 75, 734400, 'VND', true, 10
        ) RETURNING service_id INTO v_service_id;
    ELSE
        UPDATE partner_service SET
            service_type = 'spa_menu',
            service_subtype = 'foot_treatment',
            description = '따뜻한 허브 족욕으로 몸을 이완시킨 후 부드러운 발마사지로 깊은 휴식과 숙면을 돕는 트리트먼트',
            unit = 'session',
            duration_minutes = 75,
            default_price = 734400,
            currency = 'VND',
            is_active = true,
            sort_order = 10,
            updated_at = now()
        WHERE service_id = v_service_id;
    END IF;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note, is_active)
    VALUES
        ('SERENE-HN-001-FOOT-TOTAL-75', v_service_id, 75, 'standard', 734400, '75분', '세금 포함 / 스테이하롱 10% 할인 별도', true),
        ('SERENE-HN-001-FOOT-TOTAL-90', v_service_id, 90, 'standard', 896400, '90분', '세금 포함 / 스테이하롱 10% 할인 별도', true)
    ON CONFLICT (price_code) DO UPDATE SET
        service_id       = EXCLUDED.service_id,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label       = EXCLUDED.tier_label,
        price            = EXCLUDED.price,
        condition_label  = EXCLUDED.condition_label,
        note             = EXCLUDED.note,
        is_active        = EXCLUDED.is_active;

    -- ============= (B) 발 릴렉싱 마사지 =============
    SELECT service_id INTO v_service_id
    FROM partner_service
    WHERE partner_id = v_partner_id AND service_name = '발 릴렉싱 마사지';

    IF v_service_id IS NULL THEN
        INSERT INTO partner_service (
            partner_id, service_type, service_subtype, service_name, description,
            unit, duration_minutes, default_price, currency, is_active, sort_order
        ) VALUES (
            v_partner_id, 'spa_menu', 'foot_massage',
            '발 릴렉싱 마사지',
            '발 반사요법 기반 — 혈액 순환 개선·면역 균형·에너지 재생',
            'session', 45, 518400, 'VND', true, 20
        ) RETURNING service_id INTO v_service_id;
    ELSE
        UPDATE partner_service SET
            service_type = 'spa_menu',
            service_subtype = 'foot_massage',
            description = '발 반사요법 기반 — 혈액 순환 개선·면역 균형·에너지 재생',
            unit = 'session',
            duration_minutes = 45,
            default_price = 518400,
            currency = 'VND',
            is_active = true,
            sort_order = 20,
            updated_at = now()
        WHERE service_id = v_service_id;
    END IF;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note, is_active)
    VALUES
        ('SERENE-HN-001-FOOT-RELAX-45', v_service_id, 45, 'standard', 518400, '45분', '세금 포함 / 스테이하롱 10% 할인 별도', true),
        ('SERENE-HN-001-FOOT-RELAX-60', v_service_id, 60, 'standard', 626400, '60분', '세금 포함 / 스테이하롱 10% 할인 별도', true)
    ON CONFLICT (price_code) DO UPDATE SET
        service_id       = EXCLUDED.service_id,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label       = EXCLUDED.tier_label,
        price            = EXCLUDED.price,
        condition_label  = EXCLUDED.condition_label,
        note             = EXCLUDED.note,
        is_active        = EXCLUDED.is_active;

    -- ============= (C) 릴렉싱 테라피 (오일) =============
    SELECT service_id INTO v_service_id
    FROM partner_service
    WHERE partner_id = v_partner_id AND service_name = '릴렉싱 테라피';

    IF v_service_id IS NULL THEN
        INSERT INTO partner_service (
            partner_id, service_type, service_subtype, service_name, description,
            unit, duration_minutes, default_price, currency, is_active, sort_order
        ) VALUES (
            v_partner_id, 'spa_menu', 'body_massage_oil',
            '릴렉싱 테라피',
            '100% 천연 오일 — 피부 관리·근육 이완·체내 독소 배출',
            'session', 60, 680400, 'VND', true, 30
        ) RETURNING service_id INTO v_service_id;
    ELSE
        UPDATE partner_service SET
            service_type = 'spa_menu',
            service_subtype = 'body_massage_oil',
            description = '100% 천연 오일 — 피부 관리·근육 이완·체내 독소 배출',
            unit = 'session',
            duration_minutes = 60,
            default_price = 680400,
            currency = 'VND',
            is_active = true,
            sort_order = 30,
            updated_at = now()
        WHERE service_id = v_service_id;
    END IF;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note, is_active)
    VALUES
        ('SERENE-HN-001-RELAX-OIL-60', v_service_id, 60, 'standard', 680400, '60분', '세금 포함 / 스테이하롱 10% 할인 별도', true),
        ('SERENE-HN-001-RELAX-OIL-90', v_service_id, 90, 'standard', 950400, '90분', '세금 포함 / 스테이하롱 10% 할인 별도', true)
    ON CONFLICT (price_code) DO UPDATE SET
        service_id       = EXCLUDED.service_id,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label       = EXCLUDED.tier_label,
        price            = EXCLUDED.price,
        condition_label  = EXCLUDED.condition_label,
        note             = EXCLUDED.note,
        is_active        = EXCLUDED.is_active;

    -- ============= (D) 태국 로얄 마사지 =============
    SELECT service_id INTO v_service_id
    FROM partner_service
    WHERE partner_id = v_partner_id AND service_name = '태국 로얄 마사지';

    IF v_service_id IS NULL THEN
        INSERT INTO partner_service (
            partner_id, service_type, service_subtype, service_name, description,
            unit, duration_minutes, default_price, currency, is_active, sort_order
        ) VALUES (
            v_partner_id, 'spa_menu', 'body_massage_thai',
            '태국 로얄 마사지',
            '수동 스트레칭 + 호흡 기반 지압 — 근육·관절 통증 완화 및 부상 예방',
            'session', 60, 680400, 'VND', true, 40
        ) RETURNING service_id INTO v_service_id;
    ELSE
        UPDATE partner_service SET
            service_type = 'spa_menu',
            service_subtype = 'body_massage_thai',
            description = '수동 스트레칭 + 호흡 기반 지압 — 근육·관절 통증 완화 및 부상 예방',
            unit = 'session',
            duration_minutes = 60,
            default_price = 680400,
            currency = 'VND',
            is_active = true,
            sort_order = 40,
            updated_at = now()
        WHERE service_id = v_service_id;
    END IF;

    INSERT INTO partner_price (price_code, service_id, duration_minutes, tier_label, price, condition_label, note, is_active)
    VALUES
        ('SERENE-HN-001-THAI-ROYAL-60', v_service_id, 60, 'standard', 680400, '60분', '세금 포함 / 스테이하롱 10% 할인 별도', true),
        ('SERENE-HN-001-THAI-ROYAL-90', v_service_id, 90, 'standard', 950400, '90분', '세금 포함 / 스테이하롱 10% 할인 별도', true)
    ON CONFLICT (price_code) DO UPDATE SET
        service_id       = EXCLUDED.service_id,
        duration_minutes = EXCLUDED.duration_minutes,
        tier_label       = EXCLUDED.tier_label,
        price            = EXCLUDED.price,
        condition_label  = EXCLUDED.condition_label,
        note             = EXCLUDED.note,
        is_active        = EXCLUDED.is_active;
END$$;

COMMIT;

-- ============================================================
-- 검증 쿼리(수동 실행 권장)
-- ============================================================
-- 1) 업체 정보
-- SELECT partner_code, name, branch_name, category, default_discount_rate, booking_lead_hours, is_active
--   FROM partner WHERE partner_code = 'SERENE-HN-001';
--
-- 2) 메뉴 목록
-- SELECT s.service_name, s.service_subtype, s.unit, s.duration_minutes, s.default_price
--   FROM partner_service s
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'SERENE-HN-001'
--  ORDER BY s.sort_order;
--
-- 3) 가격 옵션 전체
-- SELECT pp.price_code, ps.service_name, pp.duration_minutes, pp.price, pp.condition_label
--   FROM partner_price pp
--   JOIN partner_service ps USING (service_id)
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'SERENE-HN-001'
--  ORDER BY ps.sort_order, pp.duration_minutes;
