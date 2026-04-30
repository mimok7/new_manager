-- ============================================================
-- 제휴매장 업로드: 냠냠 (Nhâm Nhâm)
-- 작성일: 2026-04-30
-- 지점: 하롱베이 본점
-- 전제: 2026-04-30-partner-system.sql (v1) 적용 완료
-- 특징:
--   - 100% idempotent (반복 실행 안전)
--   - v2 컬럼 미적용 환경에서도 자동 ADD COLUMN (셀프 컨테인드)
-- 주의: 사용자 제공 데이터만 반영 (임의 메뉴/가격 추가 없음)
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 0) 스키마 자동 보강 (v2 컬럼)
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
-- 1) partner 등록/갱신
-- ------------------------------------------------------------
INSERT INTO partner (
    partner_code, name, branch_name, category, subcategory,
    region, address, contact_phone, description,
    default_discount_rate, booking_lead_hours, open_hours,
    map_url, internal_memo, is_active
) VALUES (
    'NHAMNHAM-HL-001',
    'Nhâm Nhâm',
    '하롱베이 본점',
    'restaurant',
    'korean_buffet_bunsik',
    'Halong',
    'Bai Chay, Halong, Vietnam',
    NULL,
    '한국식 고기뷔페 + 분식 매장. 한국인 사장 직접 운영, 셀프바(잡채/떡볶이/김치볶음밥/불고기 등) 및 샤브샤브 마무리 가능.',
    0,
    0,
    NULL,
    NULL,
    '스테이하롱 혜택: ① 2인당 소프트드링크 1잔 무료 ② 스테이하롱 통해 크루즈 예약 고객 2인당 5만동 할인(4인 이상 시 총 10만동 가능). 방문 전 카톡 안내 권장. 쿠폰 제시 필요.',
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
-- 2) 메뉴 + 가격 업서트 (사용자 제공 10개 메뉴만)
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_service_id uuid;
    v_item jsonb;
    v_price_code text;
    v_menu CONSTANT jsonb := jsonb_build_array(
        jsonb_build_object('subtype','kimbap','name','냠냠김밥','desc','한국산 김과 한국산 재료로 채워진 기본김밥','price',60000,'sort',10,'short','KIMBAP'),
        jsonb_build_object('subtype','kimbap','name','냠냠 치즈 김밥','desc','한국산 김과 한국산 재료, 그리고 치즈가 만난 고소한 김밥','price',70000,'sort',20,'short','CHEESE-KIMBAP'),
        jsonb_build_object('subtype','kimbap','name','냠냠 소고기 김밥','desc','호불호 없는 맛있는 소고기가 가득한 든든한 김밥','price',80000,'sort',30,'short','BEEF-KIMBAP'),
        jsonb_build_object('subtype','kimbap','name','냠냠 돈까스 김밥','desc','냠냠소스 누구나 좋아하는 바삭한 돈까스와 함께','price',80000,'sort',40,'short','PORKCUTLET-KIMBAP'),
        jsonb_build_object('subtype','bunsik','name','냠냠 떡볶이','desc','매콤하면서도 달콤한 마성의 간식! 냠냠떡볶이','price',70000,'sort',50,'short','TTEOKBOKKI'),
        jsonb_build_object('subtype','meal','name','냠냠 돈까스 정식','desc','바삭한 돈까스가 땡기는 날엔 냠냠돈까스','price',120000,'sort',60,'short','PORKCUTLET-MEAL'),
        jsonb_build_object('subtype','meal','name','냠냠 제육볶음 정식','desc','매콤한 제육과 함께 하는 맛있는 한끼','price',120000,'sort',70,'short','JAEYUK-MEAL'),
        jsonb_build_object('subtype','meal','name','냠냠 소불고기 정식','desc','누구나 좋아하는 바로 그 맛! 소불고기 정식','price',140000,'sort',80,'short','BULGOGI-MEAL'),
        jsonb_build_object('subtype','fried_rice','name','냠냠 김치 볶음밥','desc','한국인이라면 역시 김치 볶음밥!','price',80000,'sort',90,'short','KIMCHI-RICE'),
        jsonb_build_object('subtype','fried_rice','name','냠냠 새우 볶음밥','desc','쌀국수에 질린 아이들을 위한 새우볶음밥','price',90000,'sort',100,'short','SHRIMP-RICE')
    );
BEGIN
    SELECT partner_id INTO v_partner_id
    FROM partner
    WHERE partner_code = 'NHAMNHAM-HL-001';

    IF v_partner_id IS NULL THEN
        RAISE EXCEPTION 'partner NHAMNHAM-HL-001 not found';
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

        v_price_code := 'NHAMNHAM-HL-001-' || (v_item->>'short');

        INSERT INTO partner_price (
            price_code, service_id, tier_label, price, condition_label, note, is_active
        ) VALUES (
            v_price_code,
            v_service_id,
            'standard',
            (v_item->>'price')::numeric,
            '정가',
            '스테이하롱 제휴 혜택 별도 적용(쿠폰 제시): 2인당 소프트드링크 1잔 무료 + 조건부 금액 할인',
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

COMMIT;

-- ============================================================
-- 검증 쿼리(수동)
-- ============================================================
-- SELECT partner_code, name, branch_name, category, subcategory
-- FROM partner
-- WHERE partner_code = 'NHAMNHAM-HL-001';
--
-- SELECT s.service_name, s.default_price
-- FROM partner_service s
-- JOIN partner p USING (partner_id)
-- WHERE p.partner_code = 'NHAMNHAM-HL-001'
-- ORDER BY s.sort_order;
--
-- SELECT price_code, price, condition_label
-- FROM partner_price
-- WHERE price_code LIKE 'NHAMNHAM-HL-001-%'
-- ORDER BY price_code;
