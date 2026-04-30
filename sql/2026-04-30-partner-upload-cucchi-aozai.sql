-- ============================================================
-- 제휴매장 업로드: Cúc Chi - Coffee Áo Dài & Tour Hạ Long
--                  (꾹찌 — 아오자이 의상대여 & 사진촬영 카페)
-- 작성일: 2026-04-30
-- 지점: 하롱 야시장, MON RESTAURANT 옆 (1점)
-- 전제: 2026-04-30-partner-system.sql (v1) 적용 완료
-- 참고: 2026-04-30-partner-upload-* 파일들의 표준 패턴 준용
-- 특징:
--   - 100% idempotent — 반복 실행 안전
--   - v2 컬럼 미적용 환경에서도 자동 ADD COLUMN (셀프 컨테인드)
--   - 본문에 대여/촬영 가격 미공시 → 서비스는 카테고리 placeholder 4건
--     (아오자이 / 한복 / 기모노 / 소수민족 의상)으로 등록 + 가격 0
--     + 별도 서비스 1건: 포토그래퍼 사전섭외(1주일 전 예약)
--   - 회원 혜택: 아오자이 대여 시 음료 1잔 무료 (혜택 시작일 2026-03-01)
--   - 카테고리: costume (subcategory: aozai_rental_studio)
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
    'CUCCHI-HL-AOZAI',
    'Cúc Chi - Coffee Áo Dài & Tour Hạ Long',
    '하롱 야시장 / MON RESTAURANT 옆',
    'costume',
    'aozai_rental_studio',
    'Halong',
    'X247+5RM, Bãi Cháy, Hạ Long, Vietnam (하롱 야시장, MON RESTAURANT 옆)',
    NULL,
    '베트남 사장님이 운영하는 아오자이 의상대여 & 사진촬영 카페. 한국 여행사 최초 제휴(스테이하롱). 1층 카페 + 2층 의상실(아오자이/한복/기모노/소수민족 의상). 악세서리·신발 풀세트 구비. 명절·할로윈 등 시즌별 포토존 컨셉 변경. 독자 메뉴 ''바나나 커피'' 보유. 1주일 전 사전예약 시 전문 포토그래퍼 섭외 가능 (인근 사원/사찰 출장 촬영 가능).',
    0,        -- 할인율 대신 음료 1잔 무료 사은품
    168,      -- 7일(=168시간) 사전 예약 — 포토그래퍼 섭외 기준
    NULL,
    'https://maps.app.goo.gl/5jRuewiokCdkKqoK8',
    '스테이하롱 회원 혜택: 아오자이 대여 시 음료 1잔 무료. 혜택 시작일 2026-03-01. 포토그래퍼 섭외는 1주일 전 사전 예약 필수 — 스테이하롱 카카오채널로 개별 문의.',
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
-- 2) 서비스(의상 대여 + 포토그래퍼) + 가격 — 본문에 가격 미공시
--    → placeholder 등록 + 가격 0 + condition_label='가격 문의'
--    추후 매장 협의 후 별도 SQL로 보강 예정
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_service_id uuid;
    v_partner_code text := 'CUCCHI-HL-AOZAI';
    v_menu CONSTANT jsonb := jsonb_build_array(
        -- 의상 대여 카테고리
        jsonb_build_object(
            'type','rental','subtype','aozai',
            'name','아오자이 대여',
            'desc','베트남 전통의상 아오자이. 다양한 색상/디자인 + 악세서리·신발 풀세트 포함',
            'unit','set','price',0,'sort',10,'short','AOZAI'
        ),
        jsonb_build_object(
            'type','rental','subtype','hanbok',
            'name','한복 대여',
            'desc','한복 의상 대여 + 악세서리 풀세트',
            'unit','set','price',0,'sort',20,'short','HANBOK'
        ),
        jsonb_build_object(
            'type','rental','subtype','kimono',
            'name','기모노 대여',
            'desc','기모노 의상 대여 + 악세서리 풀세트',
            'unit','set','price',0,'sort',30,'short','KIMONO'
        ),
        jsonb_build_object(
            'type','rental','subtype','ethnic',
            'name','소수민족 의상 대여',
            'desc','사파 등에서 볼 수 있는 베트남 소수민족 전통 의상',
            'unit','set','price',0,'sort',40,'short','ETHNIC'
        ),
        -- 포토그래퍼 섭외 (별도 서비스, 1주일 전 사전예약 필수)
        jsonb_build_object(
            'type','photography','subtype','photographer_booking',
            'name','전문 포토그래퍼 섭외 촬영',
            'desc','1주일 전 사전 예약 필수. 카페 내부 + 인근 사원/사찰 등 출장 촬영 가능',
            'unit','session','price',0,'sort',110,'short','PHOTOG'
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
                v_item->>'type',
                v_item->>'subtype',
                v_item->>'name',
                v_item->>'desc',
                v_item->>'unit',
                (v_item->>'price')::numeric,
                'VND',
                true,
                (v_item->>'sort')::int
            ) RETURNING service_id INTO v_service_id;
        ELSE
            UPDATE partner_service SET
                service_type    = v_item->>'type',
                service_subtype = v_item->>'subtype',
                description     = v_item->>'desc',
                unit            = v_item->>'unit',
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
            '본문에 가격 미공시 — 매장 협의 후 추후 보강 예정',
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
-- 3) 회원 혜택 — 아오자이 대여 시 음료 1잔 무료 (시작일 2026-03-01)
--    (partner_promotion 테이블 — promotion-extension 적용 후에만 동작)
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_has_promo boolean;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public' AND table_name = 'partner_promotion'
    ) INTO v_has_promo;

    IF NOT v_has_promo THEN
        RAISE NOTICE 'partner_promotion table not found — skipping promotion seed (run 2026-04-30-partner-promotion-extension.sql first).';
        RETURN;
    END IF;

    SELECT partner_id INTO v_partner_id
    FROM partner WHERE partner_code = 'CUCCHI-HL-AOZAI';

    IF v_partner_id IS NULL THEN
        RAISE NOTICE 'CUCCHI-HL-AOZAI not found. Promotion seed skipped.';
        RETURN;
    END IF;

    INSERT INTO partner_promotion (
        partner_id, promo_code, promo_name, promo_type,
        free_item_name, benefit_unit, min_people,
        requires_coupon, coupon_label,
        valid_from,
        note, is_active
    ) VALUES (
        v_partner_id,
        'FREE-DRINK-PER-RENTAL',
        '아오자이 대여 시 음료 1잔 무료',
        'free_item',
        '음료 1잔 (바나나 커피 등 매장 메뉴 중 택1)',
        'item',
        1,
        true,
        '스테이하롱 예약 확인',
        '2026-03-01'::date,
        '스테이하롱을 통해 예약한 회원 대상. 혜택 시작일 2026-03-01. 추천 메뉴: 매장 시그니처 ''바나나 커피''.',
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
        valid_from      = EXCLUDED.valid_from,
        note            = EXCLUDED.note,
        is_active       = EXCLUDED.is_active;
END$$;

COMMIT;

-- ============================================================
-- 검증 쿼리(수동)
-- ============================================================
-- 1) 매장 정보
-- SELECT partner_code, name, branch_name, category, subcategory, region, map_url, internal_memo
--   FROM partner WHERE partner_code = 'CUCCHI-HL-AOZAI';
--
-- 2) 서비스 목록
-- SELECT s.service_type, s.service_subtype, s.service_name, s.unit, s.default_price, s.sort_order
--   FROM partner_service s
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'CUCCHI-HL-AOZAI'
--  ORDER BY s.sort_order;
--
-- 3) 가격 전체
-- SELECT pp.price_code, ps.service_name, pp.price, pp.condition_label, pp.note
--   FROM partner_price pp
--   JOIN partner_service ps USING (service_id)
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'CUCCHI-HL-AOZAI'
--  ORDER BY ps.sort_order;
--
-- 4) 혜택
-- SELECT promo_code, promo_name, promo_type, free_item_name, min_people, coupon_label, valid_from
--   FROM partner_promotion
--  WHERE partner_id = (SELECT partner_id FROM partner WHERE partner_code = 'CUCCHI-HL-AOZAI');
