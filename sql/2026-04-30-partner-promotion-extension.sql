-- ============================================================
-- 선택 확장: 조건형 제휴혜택 구조화 테이블
-- 작성일: 2026-04-30
-- 목적: '2인당 음료 1잔', '크루즈 예약 고객 2인당 5만동 할인' 같은
--       룰 기반 혜택을 정형 데이터로 관리
-- ============================================================

BEGIN;

CREATE TABLE IF NOT EXISTS partner_promotion (
    promo_id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    partner_id          uuid NOT NULL REFERENCES partner(partner_id) ON DELETE CASCADE,
    promo_code          text NOT NULL,
    promo_name          text NOT NULL,
    promo_type          text NOT NULL,     -- free_item | amount_discount | percent_discount
    benefit_value       numeric(14,2),     -- 금액/퍼센트 값
    benefit_unit        text,              -- VND | % | item
    free_item_name      text,
    min_people          int,
    max_people          int,
    requires_coupon     boolean NOT NULL DEFAULT false,
    coupon_label        text,
    requires_cruise_booking boolean NOT NULL DEFAULT false,
    min_cruise_people   int,
    member_grade_min    text,              -- 예: 아기나옹
    is_active           boolean NOT NULL DEFAULT true,
    valid_from          date,
    valid_to            date,
    note                text,
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_partner_promo_code UNIQUE (partner_id, promo_code)
);

CREATE INDEX IF NOT EXISTS idx_partner_promotion_partner_active
    ON partner_promotion(partner_id, is_active);

CREATE OR REPLACE FUNCTION partner_promotion_set_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_partner_promotion_updated_at ON partner_promotion;
CREATE TRIGGER trg_partner_promotion_updated_at
BEFORE UPDATE ON partner_promotion
FOR EACH ROW EXECUTE FUNCTION partner_promotion_set_updated_at();

COMMIT;

-- ------------------------------------------------------------
-- Nhâm Nhâm 혜택 샘플 시드 (선택)
-- ------------------------------------------------------------
BEGIN;

DO $$
DECLARE
    v_partner_id uuid;
BEGIN
    SELECT partner_id INTO v_partner_id
    FROM partner
    WHERE partner_code = 'NHAMNHAM-HL-001';

    IF v_partner_id IS NULL THEN
        RAISE NOTICE 'NHAMNHAM-HL-001 not found. Seed skipped.';
        RETURN;
    END IF;

    -- 2인당 소프트드링크 1잔 무료 (아기나옹 이상)
    INSERT INTO partner_promotion (
        partner_id, promo_code, promo_name, promo_type,
        free_item_name, benefit_unit, min_people,
        requires_coupon, coupon_label, member_grade_min,
        note, is_active
    ) VALUES (
        v_partner_id,
        'FREE-SOFTDRINK-PER2',
        '2인당 소프트드링크 1잔 무료',
        'free_item',
        '소프트드링크 1잔',
        'item',
        2,
        true,
        '냠냠쿠폰',
        '아기나옹',
        '주문 전 쿠폰 제시 필요',
        true
    )
    ON CONFLICT (partner_id, promo_code) DO UPDATE SET
        promo_name = EXCLUDED.promo_name,
        promo_type = EXCLUDED.promo_type,
        free_item_name = EXCLUDED.free_item_name,
        benefit_unit = EXCLUDED.benefit_unit,
        min_people = EXCLUDED.min_people,
        requires_coupon = EXCLUDED.requires_coupon,
        coupon_label = EXCLUDED.coupon_label,
        member_grade_min = EXCLUDED.member_grade_min,
        note = EXCLUDED.note,
        is_active = EXCLUDED.is_active;

    -- 스테이하롱 크루즈 예약 고객: 2인당 50,000 VND 할인
    INSERT INTO partner_promotion (
        partner_id, promo_code, promo_name, promo_type,
        benefit_value, benefit_unit, min_people,
        requires_coupon, coupon_label,
        requires_cruise_booking, min_cruise_people,
        note, is_active
    ) VALUES (
        v_partner_id,
        'CRUISE-BOOKING-50K-PER2',
        '크루즈 예약 고객 2인당 50,000동 할인',
        'amount_discount',
        50000,
        'VND',
        2,
        true,
        '냠냠할인쿠폰',
        true,
        4,
        '4인 이상 예약 고객 기준 총 100,000동 할인 가능 문구 반영',
        true
    )
    ON CONFLICT (partner_id, promo_code) DO UPDATE SET
        promo_name = EXCLUDED.promo_name,
        promo_type = EXCLUDED.promo_type,
        benefit_value = EXCLUDED.benefit_value,
        benefit_unit = EXCLUDED.benefit_unit,
        min_people = EXCLUDED.min_people,
        requires_coupon = EXCLUDED.requires_coupon,
        coupon_label = EXCLUDED.coupon_label,
        requires_cruise_booking = EXCLUDED.requires_cruise_booking,
        min_cruise_people = EXCLUDED.min_cruise_people,
        note = EXCLUDED.note,
        is_active = EXCLUDED.is_active;
END$$;

COMMIT;
