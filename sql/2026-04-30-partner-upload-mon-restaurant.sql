-- ============================================================
-- 제휴매장 업로드: MON RESTAURANT (몬 레스토랑)
-- 작성일: 2026-04-30
-- 지점: 하롱 야시장 인근 본점 (1점)
-- 전제: 2026-04-30-partner-system.sql (v1) 적용 완료
-- 참고: 2026-04-30-partner-upload-* 파일들의 표준 패턴 준용
-- 특징:
--   - 100% idempotent — 반복 실행 안전
--   - v2 컬럼 미적용 환경에서도 자동 ADD COLUMN (셀프 컨테인드)
--   - 본문에 메뉴 가격 미공시 → 메뉴는 카테고리 placeholder 2건(한식/베트남식)
--     으로 등록하고 가격 0 + condition_label='가격 문의' 처리
--   - 회원 혜택(2인당 소프트드링크 1캔 무료)은 partner_promotion에 등록
-- 적용 위치: Supabase SQL Editor
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 0) 스키마 자동 보강 — v2 마이그레이션 미적용 환경 대응
-- ------------------------------------------------------------
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

ALTER TABLE partner_service
    ADD COLUMN IF NOT EXISTS service_subtype       text,
    ADD COLUMN IF NOT EXISTS unit                  text NOT NULL DEFAULT 'session',
    ADD COLUMN IF NOT EXISTS duration_minutes      int,
    ADD COLUMN IF NOT EXISTS min_quantity          int  NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS max_quantity          int,
    ADD COLUMN IF NOT EXISTS sht_discount_rate     numeric(5,2),
    ADD COLUMN IF NOT EXISTS thumbnail_url         text,
    ADD COLUMN IF NOT EXISTS sort_order            int  NOT NULL DEFAULT 0;

ALTER TABLE partner_price
    ADD COLUMN IF NOT EXISTS duration_minutes      int,
    ADD COLUMN IF NOT EXISTS tier_label            text,
    ADD COLUMN IF NOT EXISTS sht_price             numeric(14,2),
    ADD COLUMN IF NOT EXISTS is_active             boolean NOT NULL DEFAULT true;

-- ------------------------------------------------------------
-- 1) 매장 마스터 등록
-- ------------------------------------------------------------
INSERT INTO partner (
    partner_code, name, branch_name, category, subcategory,
    region, address, contact_phone, description,
    default_discount_rate, booking_lead_hours, open_hours,
    map_url, internal_memo, is_active
) VALUES (
    'MON-HL-NIGHTMKT',
    'MON RESTAURANT',
    '하롱 야시장 인근 본점',
    'restaurant',
    'vietnamese_korean',
    'Halong',
    'City, Cho Dem Marine, Ha Long, Vietnam (시타딘 호텔쪽 야시장 도보 1~2분)',
    NULL,
    '한국인 사장 2분이 운영하는 베트남/한식 레스토랑. 1층 갤러리 분위기 + 2층 호수뷰 테라스/실내 단체석. 하롱 야시장 도보 2분 거리. 베트남 전통 식사 + 한식 메뉴를 한 매장에서 즐길 수 있는 스테이하롱 제휴 맛집.',
    0,
    0,
    NULL,
    'https://maps.app.goo.gl/RWVvojaJmMXE5QQE9',
    '스테이하롱 회원 혜택: 예약 후 방문 시 2인당 소프트 드링크 1캔 무료. 예약은 스테이하롱 카카오채널로 문의.',
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
    map_url               = EXCLUDED.map_url,
    internal_memo         = EXCLUDED.internal_memo,
    is_active             = EXCLUDED.is_active,
    updated_at            = now();

-- ------------------------------------------------------------
-- 2) 메뉴(서비스) + 가격 — 본문에 가격 미공시 → placeholder 2건
--    추후 매장 협의 후 별도 SQL로 메뉴별 상세 가격 보강 예정
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_service_id uuid;
    v_partner_code text := 'MON-HL-NIGHTMKT';
    v_menu CONSTANT jsonb := jsonb_build_array(
        jsonb_build_object(
            'subtype','vietnamese',
            'name','베트남식 식사메뉴',
            'desc','한국인 입맛에도 잘 맞는 베트남 전통 식사 (사장님 추천 가능)',
            'price',0,
            'sort',10,
            'short','VN-MEAL'
        ),
        jsonb_build_object(
            'subtype','korean',
            'name','한식 메뉴',
            'desc','한국인 사장님이 직접 운영하는 한식 메뉴',
            'price',0,
            'sort',20,
            'short','KR-MEAL'
        )
    );
    v_item jsonb;
    v_price_code text;
BEGIN
    SELECT partner_id INTO v_partner_id FROM partner WHERE partner_code = v_partner_code;
    IF v_partner_id IS NULL THEN
        RAISE EXCEPTION 'partner % not found', v_partner_code;
    END IF;

    FOR v_item IN SELECT * FROM jsonb_array_elements(v_menu)
    LOOP
        SELECT service_id INTO v_service_id
        FROM partner_service
        WHERE partner_id = v_partner_id
          AND service_name = v_item->>'name';

        IF v_service_id IS NULL THEN
            INSERT INTO partner_service (
                partner_id, service_type, service_subtype, service_name, description,
                unit, default_price, currency, is_active, sort_order
            ) VALUES (
                v_partner_id,
                'menu',
                v_item->>'subtype',
                v_item->>'name',
                v_item->>'desc',
                'item',
                (v_item->>'price')::numeric,
                'VND',
                true,
                (v_item->>'sort')::int
            ) RETURNING service_id INTO v_service_id;
        ELSE
            UPDATE partner_service SET
                service_type    = 'menu',
                service_subtype = v_item->>'subtype',
                description     = v_item->>'desc',
                unit            = 'item',
                default_price   = (v_item->>'price')::numeric,
                currency        = 'VND',
                is_active       = true,
                sort_order      = (v_item->>'sort')::int,
                updated_at      = now()
            WHERE service_id = v_service_id;
        END IF;

        v_price_code := v_partner_code || '-' || (v_item->>'short');

        INSERT INTO partner_price (
            price_code, service_id, tier_label, price, condition_label, note, is_active
        ) VALUES (
            v_price_code,
            v_service_id,
            'standard',
            (v_item->>'price')::numeric,
            '가격 문의',
            '본문에 메뉴별 가격 미공시 — 매장 협의 후 추후 보강 예정',
            true
        )
        ON CONFLICT (price_code) DO UPDATE SET
            service_id      = EXCLUDED.service_id,
            tier_label      = EXCLUDED.tier_label,
            price           = EXCLUDED.price,
            condition_label = EXCLUDED.condition_label,
            note            = EXCLUDED.note,
            is_active       = EXCLUDED.is_active;
    END LOOP;
END$$;

-- ------------------------------------------------------------
-- 3) 회원 혜택 — 2인당 소프트 드링크 1캔 무료
--    (partner_promotion 테이블 — promotion-extension 적용 후에만 동작)
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_has_promo boolean;
BEGIN
    -- partner_promotion 테이블 존재 여부 확인 (extension 미적용 환경 안전 처리)
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public' AND table_name = 'partner_promotion'
    ) INTO v_has_promo;

    IF NOT v_has_promo THEN
        RAISE NOTICE 'partner_promotion table not found — skipping promotion seed (run 2026-04-30-partner-promotion-extension.sql first).';
        RETURN;
    END IF;

    SELECT partner_id INTO v_partner_id
    FROM partner WHERE partner_code = 'MON-HL-NIGHTMKT';

    IF v_partner_id IS NULL THEN
        RAISE NOTICE 'MON-HL-NIGHTMKT not found. Promotion seed skipped.';
        RETURN;
    END IF;

    INSERT INTO partner_promotion (
        partner_id, promo_code, promo_name, promo_type,
        free_item_name, benefit_unit, min_people,
        requires_coupon, coupon_label,
        note, is_active
    ) VALUES (
        v_partner_id,
        'FREE-SOFTDRINK-PER2',
        '2인당 소프트 드링크 1캔 무료',
        'free_item',
        '소프트 드링크 1캔',
        'item',
        2,
        true,
        '스테이하롱 예약 확인',
        '스테이하롱을 통해 MON RESTAURANT를 예약하고 방문하는 회원 대상',
        true
    )
    ON CONFLICT (partner_id, promo_code) DO UPDATE SET
        promo_name      = EXCLUDED.promo_name,
        promo_type      = EXCLUDED.promo_type,
        free_item_name  = EXCLUDED.free_item_name,
        benefit_unit    = EXCLUDED.benefit_unit,
        min_people      = EXCLUDED.min_people,
        requires_coupon = EXCLUDED.requires_coupon,
        coupon_label    = EXCLUDED.coupon_label,
        note            = EXCLUDED.note,
        is_active       = EXCLUDED.is_active;
END$$;

COMMIT;

-- ============================================================
-- 검증 쿼리(수동)
-- ============================================================
-- 1) 매장 정보
-- SELECT partner_code, name, branch_name, region, map_url, internal_memo
--   FROM partner WHERE partner_code = 'MON-HL-NIGHTMKT';
--
-- 2) 메뉴 목록
-- SELECT s.service_subtype, s.service_name, s.default_price, s.sort_order
--   FROM partner_service s
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'MON-HL-NIGHTMKT'
--  ORDER BY s.sort_order;
--
-- 3) 가격 전체
-- SELECT pp.price_code, ps.service_name, pp.price, pp.condition_label, pp.note
--   FROM partner_price pp
--   JOIN partner_service ps USING (service_id)
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'MON-HL-NIGHTMKT'
--  ORDER BY ps.sort_order;
--
-- 4) 혜택
-- SELECT promo_code, promo_name, promo_type, free_item_name, min_people, coupon_label
--   FROM partner_promotion
--  WHERE partner_id = (SELECT partner_id FROM partner WHERE partner_code = 'MON-HL-NIGHTMKT');
