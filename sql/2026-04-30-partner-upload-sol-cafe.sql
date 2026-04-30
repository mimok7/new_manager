-- ============================================================
-- 제휴매장 업로드: SOL CAFÉ (솔카페 — 솔레일 하롱호텔 1층)
-- 작성일: 2026-04-30
-- 지점: 하롱베이 (1점)
-- 전제: 2026-04-30-partner-system.sql (v1) 적용 완료
-- 참고: 2026-04-30-partner-upload-* 파일들의 표준 패턴 준용
-- 특징:
--   - 100% idempotent — 반복 실행 안전
--   - v2 컬럼 미적용 환경에서도 자동 ADD COLUMN (셀프 컨테인드)
--   - 본문에 메뉴/가격 전체 공시 → 모든 메뉴 정상 등록 (M/L 사이즈는 가격 2건)
--   - 가격 단위: 본문 표기는 천 VND 단위 → DB 저장은 실제 VND (×1000)
--   - 회원 혜택: 전메뉴 10% 할인 (스하 회원 페이지 인증, 아기나옹 등급 이상)
--   - 카테고리: restaurant (subcategory: cafe)
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
    'SOLCAFE-HL-001',
    'SOL CAFÉ',
    '솔레일 하롱호텔 1층',
    'restaurant',
    'cafe',
    'Halong',
    'Soleil Halong Hotel 1F, Halong Bay, Vietnam',
    NULL,
    '5성급 솔레일 하롱호텔이 운영하는 카페. 한국식 커피 + 베트남 커피/Tea/스무디/생과일주스/디저트. 호텔 1층 독립 공간(편안한 소파, 외부 테이블, 청결한 화장실). 썬월드/선착장 가는 길에 위치.',
    10.00,    -- 전메뉴 10% 할인 (스하 회원 인증 시)
    0,
    NULL,
    NULL,
    '스테이하롱 회원 혜택: 전메뉴 10% 할인 (아기나옹 등급 이상). 카운터에서 스하 네이버카페 회원 페이지 제시 필요. 결제 이후 할인 불가. 직원이 혜택을 모를 시 결제 전 스테이하롱 카톡 연락.',
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
-- 2) 메뉴(서비스) + 가격
--    가격 표기: 본문 단위는 천 VND → DB 저장은 실제 VND (×1000)
--    M/L 두 사이즈가 있으면 partner_price 2건(tier_label='M','L'), 단일이면 1건(tier_label='standard')
-- ------------------------------------------------------------
DO $$
DECLARE
    v_partner_id uuid;
    v_service_id uuid;
    v_partner_code text := 'SOLCAFE-HL-001';
    -- 메뉴 정의: type='drink', subtype = milk_tea/machine_coffee/vietnamese_coffee/fresh_fruit/mixed_fruit/tea/smoothie/topping
    -- m,l: 천 VND 단위 (본문 그대로). 단일 사이즈는 m만 입력하고 l=null
    v_menu CONSTANT jsonb := jsonb_build_array(
        -- TRÀ SỮA — Milk Tea
        jsonb_build_object('subtype','milk_tea','name','Trà Sữa Trân Châu Truyền Thống','desc','Traditional Bubble Milk Tea (전통 버블 밀크티)','m',40,'l',50,'sort',110,'short','MT-BUBBLE'),
        jsonb_build_object('subtype','milk_tea','name','Trà Sữa Bạc Hà','desc','Mint Milk Tea (민트 밀크티)','m',40,'l',50,'sort',120,'short','MT-MINT'),
        jsonb_build_object('subtype','milk_tea','name','Trà Sữa Việt Quất','desc','Blueberry Milk Tea (블루베리 밀크티)','m',40,'l',50,'sort',130,'short','MT-BLUEBERRY'),
        jsonb_build_object('subtype','milk_tea','name','Trà Sữa Đào','desc','Peach Milk Tea (피치 밀크티)','m',40,'l',50,'sort',140,'short','MT-PEACH'),
        jsonb_build_object('subtype','milk_tea','name','Trà Sữa Khoai Môn Kem Cheese','desc','Taro Milk Tea with Cheese Cream (타로 치즈크림 밀크티)','m',50,'l',60,'sort',150,'short','MT-TARO-CHEESE'),
        jsonb_build_object('subtype','milk_tea','name','Trà Sữa Matcha Kem Cheese','desc','Green Tea Matcha Milk Tea (말차 치즈크림 밀크티)','m',50,'l',60,'sort',160,'short','MT-MATCHA-CHEESE'),
        jsonb_build_object('subtype','milk_tea','name','Trà Sữa Kem Cheese','desc','Cheese Cream Milk Tea (치즈크림 밀크티)','m',50,'l',60,'sort',170,'short','MT-CHEESE'),

        -- CÀ PHÊ MÁY — Machine Coffee
        jsonb_build_object('subtype','machine_coffee','name','Espresso','desc','에스프레소','m',40,'l',45,'sort',210,'short','MC-ESPRESSO'),
        jsonb_build_object('subtype','machine_coffee','name','Americano','desc','아메리카노','m',45,'l',50,'sort',220,'short','MC-AMERICANO'),
        jsonb_build_object('subtype','machine_coffee','name','Cafe Latte','desc','카페 라떼','m',60,'l',70,'sort',230,'short','MC-LATTE'),
        jsonb_build_object('subtype','machine_coffee','name','Cappuccino','desc','카푸치노','m',60,'l',70,'sort',240,'short','MC-CAPPUCCINO'),

        -- CÀ PHÊ VIỆT — Vietnamese Coffee
        jsonb_build_object('subtype','vietnamese_coffee','name','Cà Phê Đen Đá/Nóng','desc','Black coffee ice/hot (베트남 블랙 커피 / 아이스 또는 핫)','m',30,'l',35,'sort',310,'short','VC-BLACK'),
        jsonb_build_object('subtype','vietnamese_coffee','name','Cà Phê Sữa Đá/Nóng','desc','Coffee with milk ice/hot (연유 커피 / 아이스 또는 핫)','m',35,'l',40,'sort',320,'short','VC-MILK'),
        jsonb_build_object('subtype','vietnamese_coffee','name','Bạc Xỉu Đá','desc','White Coffee (밧시우 / 화이트 커피)','m',35,'l',40,'sort',330,'short','VC-BACXIU'),

        -- NƯỚC ÉP HOA QUẢ — Fresh Fruit Juice
        jsonb_build_object('subtype','fresh_fruit','name','Nước cam','desc','Orange Juice (오렌지 주스)','m',70,'l',80,'sort',410,'short','FJ-ORANGE'),
        jsonb_build_object('subtype','fresh_fruit','name','Nước dưa hấu','desc','Watermelon Juice (수박 주스)','m',60,'l',80,'sort',420,'short','FJ-WATERMELON'),
        jsonb_build_object('subtype','fresh_fruit','name','Nước chanh','desc','Lime Juice (라임 주스)','m',50,'l',60,'sort',430,'short','FJ-LIME'),
        jsonb_build_object('subtype','fresh_fruit','name','Nước chanh leo','desc','Passion Fruit Juice (패션프루트 주스)','m',50,'l',60,'sort',440,'short','FJ-PASSION'),
        jsonb_build_object('subtype','fresh_fruit','name','Nước dứa','desc','Pineapple Juice (파인애플 주스)','m',75,'l',85,'sort',450,'short','FJ-PINEAPPLE'),
        jsonb_build_object('subtype','fresh_fruit','name','Nước cà rốt','desc','Carrot Juice (당근 주스)','m',70,'l',80,'sort',460,'short','FJ-CARROT'),

        -- HOA QUẢ MIX — Mixed Fruit Juice
        jsonb_build_object('subtype','mixed_fruit','name','Nước cam & cà rốt','desc','Orange & Carrot (오렌지+당근 믹스)','m',75,'l',85,'sort',510,'short','MX-OR-CR'),
        jsonb_build_object('subtype','mixed_fruit','name','Nước dứa & cà rốt','desc','Pineapple & Carrot (파인애플+당근 믹스)','m',75,'l',85,'sort',520,'short','MX-PI-CR'),
        jsonb_build_object('subtype','mixed_fruit','name','Nước dứa & cam','desc','Pineapple & Orange (파인애플+오렌지 믹스)','m',75,'l',85,'sort',530,'short','MX-PI-OR'),

        -- TRÀ — Tea
        jsonb_build_object('subtype','tea','name','Trà Quất Sữa Mọng','desc','금귤 우유 베리 차','m',50,'l',60,'sort',610,'short','TEA-QUAT'),
        jsonb_build_object('subtype','tea','name','Trà Thạch Đào','desc','피치 젤리 차','m',50,'l',60,'sort',620,'short','TEA-PEACH'),
        jsonb_build_object('subtype','tea','name','Trà Chanh Việt','desc','베트남식 레몬 차','m',50,'l',60,'sort',630,'short','TEA-LEMON'),
        jsonb_build_object('subtype','tea','name','Trà Xoài Kem Cheese','desc','망고 치즈크림 차','m',50,'l',60,'sort',640,'short','TEA-MANGO-CHEESE'),
        jsonb_build_object('subtype','tea','name','Trà Dâu Kem Cheese','desc','딸기 치즈크림 차','m',50,'l',60,'sort',650,'short','TEA-STRAW-CHEESE'),
        jsonb_build_object('subtype','tea','name','Jasmine Tea','desc','자스민 차','m',30,'l',null,'sort',660,'short','TEA-JASMINE'),
        jsonb_build_object('subtype','tea','name','Peppermint Tea','desc','페퍼민트 차','m',30,'l',null,'sort',670,'short','TEA-PEPPERMINT'),
        jsonb_build_object('subtype','tea','name','Chamomile Tea','desc','캐모마일 차','m',30,'l',null,'sort',680,'short','TEA-CHAMOMILE'),
        jsonb_build_object('subtype','tea','name','Lipton Tea','desc','립톤 차','m',30,'l',null,'sort',690,'short','TEA-LIPTON'),
        jsonb_build_object('subtype','tea','name','Vietnamese Tea','desc','베트남 차','m',30,'l',null,'sort',700,'short','TEA-VN'),

        -- SINH TỐ — Smoothie
        jsonb_build_object('subtype','smoothie','name','Sinh tố xoài','desc','Mango Smoothie (망고 스무디)','m',75,'l',85,'sort',810,'short','SM-MANGO'),
        jsonb_build_object('subtype','smoothie','name','Sinh tố chuối','desc','Banana Smoothie (바나나 스무디)','m',65,'l',75,'sort',820,'short','SM-BANANA'),
        jsonb_build_object('subtype','smoothie','name','Sinh tố chanh leo','desc','Passion Fruit Smoothie (패션프루트 스무디)','m',65,'l',75,'sort',830,'short','SM-PASSION'),
        jsonb_build_object('subtype','smoothie','name','Chanh tuyết','desc','Snow Smoothie (스노우 스무디)','m',65,'l',75,'sort',840,'short','SM-SNOW'),

        -- TOPPING (단일 가격)
        jsonb_build_object('subtype','topping','name','Trân châu đen','desc','블랙 펄 토핑','m',10,'l',null,'sort',910,'short','TP-BLACK'),
        jsonb_build_object('subtype','topping','name','Trân châu trắng','desc','화이트 펄 토핑','m',10,'l',null,'sort',920,'short','TP-WHITE'),
        jsonb_build_object('subtype','topping','name','Nha Đam','desc','알로에 토핑','m',10,'l',null,'sort',930,'short','TP-ALOE'),
        jsonb_build_object('subtype','topping','name','Đậu đỏ','desc','팥 토핑','m',10,'l',null,'sort',940,'short','TP-REDBEAN')
    );
    v_item jsonb;
    v_unit_label text;
    v_price_m numeric;
    v_price_l numeric;
    v_short text;
    v_price_code_m text;
    v_price_code_l text;
BEGIN
    SELECT partner_id INTO v_partner_id FROM partner WHERE partner_code = v_partner_code;
    IF v_partner_id IS NULL THEN
        RAISE EXCEPTION 'partner % not found', v_partner_code;
    END IF;

    FOR v_item IN SELECT * FROM jsonb_array_elements(v_menu)
    LOOP
        v_short := v_item->>'short';
        -- 천 VND → 실제 VND
        v_price_m := (v_item->>'m')::numeric * 1000;
        v_price_l := CASE WHEN v_item->>'l' IS NULL THEN NULL ELSE (v_item->>'l')::numeric * 1000 END;
        -- topping은 'add-on', 그 외는 'cup' 단위
        v_unit_label := CASE WHEN v_item->>'subtype' = 'topping' THEN 'add-on' ELSE 'cup' END;

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
                v_unit_label,
                v_price_m,
                'VND',
                true,
                (v_item->>'sort')::int
            ) RETURNING service_id INTO v_service_id;
        ELSE
            UPDATE partner_service SET
                service_type    = 'menu',
                service_subtype = v_item->>'subtype',
                description     = v_item->>'desc',
                unit            = v_unit_label,
                default_price   = v_price_m,
                currency        = 'VND',
                is_active       = true,
                sort_order      = (v_item->>'sort')::int,
                updated_at      = now()
            WHERE service_id = v_service_id;
        END IF;

        -- M 사이즈 가격
        v_price_code_m := v_partner_code || '-' || v_short || '-M';
        INSERT INTO partner_price (
            price_code, service_id, tier_label, price, sht_price, condition_label, note, is_active
        ) VALUES (
            v_price_code_m,
            v_service_id,
            CASE WHEN v_price_l IS NULL THEN 'standard' ELSE 'M' END,
            v_price_m,
            ROUND(v_price_m * 0.9, 0),  -- 스하 회원 10% 할인 적용가
            CASE WHEN v_price_l IS NULL THEN '단일 사이즈' ELSE 'M 사이즈' END,
            '스하 회원 인증 시 10% 할인 적용 (sht_price 참조)',
            true
        )
        ON CONFLICT (price_code) DO UPDATE SET
            service_id      = EXCLUDED.service_id,
            tier_label      = EXCLUDED.tier_label,
            price           = EXCLUDED.price,
            sht_price       = EXCLUDED.sht_price,
            condition_label = EXCLUDED.condition_label,
            note            = EXCLUDED.note,
            is_active       = EXCLUDED.is_active;

        -- L 사이즈 가격 (있을 때만)
        IF v_price_l IS NOT NULL THEN
            v_price_code_l := v_partner_code || '-' || v_short || '-L';
            INSERT INTO partner_price (
                price_code, service_id, tier_label, price, sht_price, condition_label, note, is_active
            ) VALUES (
                v_price_code_l,
                v_service_id,
                'L',
                v_price_l,
                ROUND(v_price_l * 0.9, 0),
                'L 사이즈',
                '스하 회원 인증 시 10% 할인 적용 (sht_price 참조)',
                true
            )
            ON CONFLICT (price_code) DO UPDATE SET
                service_id      = EXCLUDED.service_id,
                tier_label      = EXCLUDED.tier_label,
                price           = EXCLUDED.price,
                sht_price       = EXCLUDED.sht_price,
                condition_label = EXCLUDED.condition_label,
                note            = EXCLUDED.note,
                is_active       = EXCLUDED.is_active;
        END IF;
    END LOOP;
END$$;

-- ------------------------------------------------------------
-- 3) 회원 혜택 — 전메뉴 10% 할인 (아기나옹 이상)
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
    FROM partner WHERE partner_code = 'SOLCAFE-HL-001';

    IF v_partner_id IS NULL THEN
        RAISE NOTICE 'SOLCAFE-HL-001 not found. Promotion seed skipped.';
        RETURN;
    END IF;

    INSERT INTO partner_promotion (
        partner_id, promo_code, promo_name, promo_type,
        benefit_value, benefit_unit, min_people,
        requires_coupon, coupon_label, member_grade_min,
        note, is_active
    ) VALUES (
        v_partner_id,
        'SOL-MEMBER-10PCT',
        '전메뉴 10% 할인 (스하 회원 인증)',
        'percent_discount',
        10,
        '%',
        1,
        true,
        '스하 네이버카페 회원 페이지',
        '아기나옹',
        '카운터에서 결제 전 회원 페이지 제시 필요. 결제 이후 할인 불가. 직원 미숙지 시 결제 전 스테이하롱 카톡 연락.',
        true
    )
    ON CONFLICT (partner_id, promo_code) DO UPDATE SET
        promo_name       = EXCLUDED.promo_name,
        promo_type       = EXCLUDED.promo_type,
        benefit_value    = EXCLUDED.benefit_value,
        benefit_unit     = EXCLUDED.benefit_unit,
        min_people       = EXCLUDED.min_people,
        requires_coupon  = EXCLUDED.requires_coupon,
        coupon_label     = EXCLUDED.coupon_label,
        member_grade_min = EXCLUDED.member_grade_min,
        note             = EXCLUDED.note,
        is_active        = EXCLUDED.is_active;
END$$;

COMMIT;

-- ============================================================
-- 검증 쿼리(수동)
-- ============================================================
-- 1) 매장 정보
-- SELECT partner_code, name, branch_name, category, subcategory, region, default_discount_rate, internal_memo
--   FROM partner WHERE partner_code = 'SOLCAFE-HL-001';
--
-- 2) 메뉴 카테고리별 개수
-- SELECT s.service_subtype, COUNT(*) AS cnt
--   FROM partner_service s
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'SOLCAFE-HL-001'
--  GROUP BY s.service_subtype
--  ORDER BY MIN(s.sort_order);
--
-- 3) 가격 전체 (M/L 포함)
-- SELECT pp.price_code, ps.service_subtype, ps.service_name, pp.tier_label, pp.price, pp.sht_price
--   FROM partner_price pp
--   JOIN partner_service ps USING (service_id)
--   JOIN partner p USING (partner_id)
--  WHERE p.partner_code = 'SOLCAFE-HL-001'
--  ORDER BY ps.sort_order, pp.tier_label;
--
-- 4) 혜택
-- SELECT promo_code, promo_name, promo_type, benefit_value, benefit_unit, member_grade_min, coupon_label
--   FROM partner_promotion
--  WHERE partner_id = (SELECT partner_id FROM partner WHERE partner_code = 'SOLCAFE-HL-001');
