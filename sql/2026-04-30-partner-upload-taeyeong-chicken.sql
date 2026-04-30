-- ============================================================
-- 제휴매장 업로드: 태영치킨 (TAE YEONG CHICKEN)
-- 작성일: 2026-04-30
-- 지점: 하노이 서호점(매장) + 하롱베이 배달전문점
-- 전제: 2026-04-30-partner-system.sql (v1) 적용 완료
-- 특징:
--   - 100% idempotent — 반복 실행 안전
--   - v2 컬럼 미적용 환경에서도 자동 ADD COLUMN (셀프 컨테인드)
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
-- 1) 두 지점(매장) 마스터 등록
-- ------------------------------------------------------------
-- 하노이 서호점
INSERT INTO partner (
    partner_code, name, branch_name, category, subcategory,
    region, address, contact_phone, description,
    default_discount_rate, booking_lead_hours, open_hours,
    map_url, internal_memo, is_active
) VALUES (
    'TAEYEONG-HN-WESTLAKE',
    '태영치킨',
    '하노이 서호점 (매장)',
    'restaurant',
    'korean_chicken',
    'Hanoi',
    'Tay Ho, Hanoi, Vietnam',
    NULL,
    '한국 1세대 양념치킨 맛 그대로 — 페리카나·이서방 양념의 황금비율 비법소스. 후라이드/양념/간장/반반 + 떡볶이·모둠튀김 사이드. 닭다리살 순살 메뉴 보유.',
    0,        -- 할인율 대신 사은품(음료/감튀) 제공
    0,
    NULL,
    NULL,
    '스테이하롱 회원 혜택: 치킨 1마리 주문 시 음료 1캔 무료. 주문은 카톡(hanoishym1) 또는 매장 직접. 배달앱 주문은 혜택 미제공.',
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
    internal_memo         = EXCLUDED.internal_memo,
    is_active             = EXCLUDED.is_active,
    updated_at            = now();

-- 하롱베이 배달전문점
INSERT INTO partner (
    partner_code, name, branch_name, category, subcategory,
    region, address, contact_phone, description,
    default_discount_rate, booking_lead_hours, open_hours,
    map_url, internal_memo, is_active
) VALUES (
    'TAEYEONG-HL-DELIVERY',
    '태영치킨',
    '하롱베이 배달전문점',
    'restaurant',
    'korean_chicken',
    'Halong',
    'Halong Bay, Vietnam (배달전문)',
    NULL,
    '하롱베이 호텔 1층 픽업/배달 가능 — 한국 스타일 100% 똑같은 맛. 매장 상황에 따라 일부 메뉴 불가.',
    0,
    0,
    NULL,
    NULL,
    '스테이하롱 회원 혜택: 치킨 1마리 주문 시 음료 1캔 또는 감자튀김 중 1택 서비스. 주문은 카톡(hanoishym1)으로. 배달앱(배달K 등) 주문은 혜택 미제공.',
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
    internal_memo         = EXCLUDED.internal_memo,
    is_active             = EXCLUDED.is_active,
    updated_at            = now();

-- ------------------------------------------------------------
-- 2) 메뉴(서비스) + 가격 — 두 지점에 동일 메뉴 업서트
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_service_id uuid;
    v_partner_code text;
    v_partner_codes text[] := ARRAY['TAEYEONG-HN-WESTLAKE','TAEYEONG-HL-DELIVERY'];
    v_short text;
    -- 메뉴 정의: (subtype, name, description, price_VND, sort)
    v_menu CONSTANT jsonb := jsonb_build_array(
        -- 콤보 (가격 미공시 → 0, 가격 문의 표시)
        jsonb_build_object('subtype','combo','name','콤보 A — 태영 클래식 세트','desc','후라이드 + 떡볶이','price',0,'sort',10,'short','COMBO-A'),
        jsonb_build_object('subtype','combo','name','콤보 B — 태영 바삭 세트','desc','후라이드 + 모둠튀김','price',0,'sort',20,'short','COMBO-B'),
        jsonb_build_object('subtype','combo','name','콤보 C — 태영 시그니처 세트','desc','후라이드 + 떡볶이 + 모둠튀김','price',0,'sort',30,'short','COMBO-C'),
        -- 메인 치킨
        jsonb_build_object('subtype','chicken','name','후라이드 치킨','desc','脆炸炸鸡','price',350000,'sort',110,'short','FRIED'),
        jsonb_build_object('subtype','chicken','name','양념 치킨','desc','甜辣炸鸡','price',370000,'sort',120,'short','SAUCE'),
        jsonb_build_object('subtype','chicken','name','간장 치킨','desc','酱油炸鸡','price',370000,'sort',130,'short','SOY'),
        jsonb_build_object('subtype','chicken','name','반반 치킨','desc','双拼炸鸡 (후라이드+양념 반반)','price',370000,'sort',140,'short','HALF'),
        -- 사이드
        jsonb_build_object('subtype','side','name','떡볶이','desc','매콤한 떡볶이','price',120000,'sort',210,'short','TTEOK'),
        jsonb_build_object('subtype','side','name','모둠튀김','desc','모둠튀김','price',80000,'sort',220,'short','MIXFRY'),
        jsonb_build_object('subtype','side','name','김말이 튀김 x3','desc','김말이 튀김 3개','price',30000,'sort',230,'short','GIMMARI'),
        jsonb_build_object('subtype','side','name','고구마 튀김 x2','desc','고구마 튀김 2개','price',30000,'sort',240,'short','SWEETPOTATO'),
        jsonb_build_object('subtype','side','name','고추 튀김 x2','desc','고추 튀김 2개','price',30000,'sort',250,'short','PEPPER'),
        -- 음료
        jsonb_build_object('subtype','drink','name','맥주','desc','베트남 맥주','price',40000,'sort',310,'short','BEER'),
        jsonb_build_object('subtype','drink','name','소주','desc','한국 소주','price',150000,'sort',320,'short','SOJU'),
        jsonb_build_object('subtype','drink','name','음료수','desc','음료수 1캔','price',20000,'sort',330,'short','SOFT'),
        jsonb_build_object('subtype','drink','name','생수','desc','생수 1병','price',30000,'sort',340,'short','WATER')
    );
    v_item jsonb;
    v_price_code text;
BEGIN
    FOREACH v_partner_code IN ARRAY v_partner_codes
    LOOP
        SELECT partner_id INTO v_partner_id FROM partner WHERE partner_code = v_partner_code;
        IF v_partner_id IS NULL THEN
            RAISE EXCEPTION 'partner % not found', v_partner_code;
        END IF;

        FOR v_item IN SELECT * FROM jsonb_array_elements(v_menu)
        LOOP
            v_short := v_item->>'short';

            -- 서비스 업서트 (partner_id + service_name 기준)
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

            -- 가격 행 1건 (콤보=0이어도 행 등록, 추후 가격 확정 시 UPDATE)
            v_price_code := v_partner_code || '-' || v_short;

            INSERT INTO partner_price (
                price_code, service_id, tier_label, price, condition_label, note, is_active
            ) VALUES (
                v_price_code,
                v_service_id,
                'standard',
                (v_item->>'price')::numeric,
                CASE WHEN (v_item->>'price')::numeric = 0 THEN '가격 문의' ELSE '정가' END,
                CASE WHEN (v_item->>'price')::numeric = 0
                     THEN '가격 미공시 — 매장에 문의'
                     ELSE '스테이하롱 회원 혜택: 치킨 1마리 주문 시 음료/감튀 서비스 (지점 정책)'
                END,
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
    END LOOP;
END$$;

COMMIT;

-- ============================================================
-- 검증 쿼리(수동)
-- ============================================================
-- 1) 지점 정보
-- SELECT partner_code, name, branch_name, region, internal_memo
--   FROM partner WHERE partner_code LIKE 'TAEYEONG-%';
--
-- 2) 메뉴 목록 (지점별)
-- SELECT p.branch_name, s.service_subtype, s.service_name, s.default_price
--   FROM partner_service s
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code LIKE 'TAEYEONG-%'
--  ORDER BY p.partner_code, s.sort_order;
--
-- 3) 가격 전체
-- SELECT pp.price_code, ps.service_name, pp.price, pp.condition_label
--   FROM partner_price pp
--   JOIN partner_service ps USING (service_id)
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code LIKE 'TAEYEONG-%'
--  ORDER BY p.partner_code, ps.sort_order;
