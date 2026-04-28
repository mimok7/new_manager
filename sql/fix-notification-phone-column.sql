-- 알림 함수 수정: users 테이블의 phone 컬럼을 phone_number로 변경
-- 에러: column "phone" does not exist (42703)

BEGIN;

-- 1. create_business_notification 함수 수정
DROP FUNCTION IF EXISTS create_business_notification(text, text, text, text, text, text, text, text, text, text, jsonb);

CREATE OR REPLACE FUNCTION create_business_notification(
    p_category TEXT,
    p_subcategory TEXT DEFAULT '일반',
    p_title TEXT DEFAULT NULL,
    p_message TEXT DEFAULT NULL,
    p_priority TEXT DEFAULT '보통',
    p_customer_name TEXT DEFAULT NULL,
    p_customer_email TEXT DEFAULT NULL,
    p_customer_phone TEXT DEFAULT NULL,
    p_target_table TEXT DEFAULT NULL,
    p_target_id TEXT DEFAULT NULL,
    p_metadata JSONB DEFAULT '{}'
) RETURNS UUID AS $$
DECLARE
    notification_id UUID;
    v_priority TEXT;
BEGIN
    v_priority := CASE 
        WHEN p_priority IN ('urgent', '긴급') THEN '긴급'
        WHEN p_priority IN ('high', '높음') THEN '높음'
        WHEN p_priority IN ('low', '낮음') THEN '낮음'
        ELSE '보통'
    END;

    INSERT INTO notifications (
        notification_type, category, subcategory, title, message, priority,
        customer_name, customer_email, customer_phone,
        target_table, target_id, metadata, created_at, updated_at
    ) VALUES (
        '업무알림', p_category, p_subcategory, p_title, p_message, v_priority,
        p_customer_name, p_customer_email, p_customer_phone,
        p_target_table, p_target_id, p_metadata, NOW(), NOW()
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
EXCEPTION 
    WHEN OTHERS THEN
        BEGIN
            INSERT INTO notifications (
                type, category, subcategory, title, message, priority,
                customer_name, customer_email, customer_phone,
                target_table, target_id, metadata, created_at, updated_at
            ) VALUES (
                'business', p_category, p_subcategory, p_title, p_message, v_priority,
                p_customer_name, p_customer_email, p_customer_phone,
                p_target_table, p_target_id, p_metadata, NOW(), NOW()
            ) RETURNING id INTO notification_id;
            RETURN notification_id;
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE '알림 생성 실패: %', SQLERRM;
            RETURN NULL;
        END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 2. create_reservation_notification 함수 수정 (phone -> phone_number)
DROP FUNCTION IF EXISTS create_reservation_notification(uuid, uuid);

CREATE OR REPLACE FUNCTION create_reservation_notification(
    p_reservation_id UUID,
    p_user_id UUID
) RETURNS UUID AS $$
DECLARE
    reservation_rec RECORD;
    user_rec RECORD;
    quote_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
    service_name TEXT;
BEGIN
    SELECT re_id, re_user_id, re_quote_id, re_type, re_status, total_amount
    INTO reservation_rec
    FROM reservation 
    WHERE re_id = p_reservation_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '예약을 찾을 수 없습니다: %', p_reservation_id;
    END IF;
    
    -- ✅ phone_number 사용 (phone이 아님)
    SELECT name, email, phone_number
    INTO user_rec
    FROM users 
    WHERE id = COALESCE(p_user_id, reservation_rec.re_user_id);
    
    IF reservation_rec.re_quote_id IS NOT NULL THEN
        SELECT title INTO quote_rec
        FROM quote 
        WHERE id = reservation_rec.re_quote_id;
    END IF;
    
    service_name := CASE reservation_rec.re_type
        WHEN 'cruise' THEN '크루즈'
        WHEN 'airport' THEN '공항 서비스'
        WHEN 'hotel' THEN '호텔'
        WHEN 'tour' THEN '투어'
        WHEN 'rentcar' THEN '렌터카'
        WHEN 'golf' THEN '골프'
        WHEN 'car' THEN '차량'
        WHEN 'car_sht' THEN '스하차량'
        WHEN 'vehicle' THEN '차량'
        ELSE reservation_rec.re_type
    END;
    
    title_text := '신규 ' || service_name || ' 예약: ' || COALESCE(user_rec.name, '고객명없음');
    message_text := format(
        '고객명: %s
이메일: %s
연락처: %s
서비스: %s
견적명: %s
예약 금액: %s원
예약 상태: %s

확인 및 처리 부탁드립니다.',
        COALESCE(user_rec.name, '이름없음'),
        COALESCE(user_rec.email, '이메일없음'),
        COALESCE(user_rec.phone_number, '연락처없음'),  -- ✅ phone_number
        service_name,
        COALESCE(quote_rec.title, '연결된 견적 없음'),
        COALESCE(reservation_rec.total_amount::text, '0'),
        CASE reservation_rec.re_status
            WHEN 'pending' THEN '대기중'
            WHEN 'confirmed' THEN '확정됨'
            WHEN 'processing' THEN '처리중'
            ELSE reservation_rec.re_status
        END
    );
    
    SELECT create_business_notification(
        '예약',
        '신규신청',
        title_text,
        message_text,
        '높음',
        user_rec.name,
        user_rec.email,
        user_rec.phone_number,  -- ✅ phone_number
        'reservation',
        reservation_rec.re_id::text,
        jsonb_build_object(
            'reservation_id', reservation_rec.re_id,
            'user_id', reservation_rec.re_user_id,
            'service_type', reservation_rec.re_type,
            'total_amount', reservation_rec.total_amount
        )
    ) INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 3. create_payment_notification 함수 수정 (phone -> phone_number)
DROP FUNCTION IF EXISTS create_payment_notification(uuid, uuid, numeric, text);

CREATE OR REPLACE FUNCTION create_payment_notification(
    p_reservation_id UUID,
    p_user_id UUID,
    p_amount NUMERIC,
    p_payment_method TEXT
) RETURNS UUID AS $$
DECLARE
    reservation_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
    priority_level TEXT;
BEGIN
    -- ✅ phone_number 사용
    SELECT name, email, phone_number
    INTO user_rec
    FROM users 
    WHERE id = p_user_id;
    
    SELECT re_type, re_quote_id
    INTO reservation_rec
    FROM reservation 
    WHERE re_id = p_reservation_id;
    
    priority_level := CASE 
        WHEN p_amount >= 1000000 THEN '긴급'
        WHEN p_amount >= 500000 THEN '높음'
        ELSE '보통'
    END;
    
    title_text := '결제 확인 필요: ' || COALESCE(user_rec.name, '고객명없음') || ' (' || p_amount::text || '원)';
    message_text := format(
        '고객명: %s
이메일: %s
연락처: %s
결제 금액: %s원
결제 방법: %s
서비스: %s

결제 확인 후 예약 승인 처리 부탁드립니다.',
        COALESCE(user_rec.name, '이름없음'),
        COALESCE(user_rec.email, '이메일없음'),
        COALESCE(user_rec.phone_number, '연락처없음'),  -- ✅ phone_number
        p_amount::text,
        COALESCE(p_payment_method, '방법없음'),
        CASE reservation_rec.re_type
            WHEN 'cruise' THEN '크루즈'
            WHEN 'airport' THEN '공항 서비스'
            WHEN 'hotel' THEN '호텔'
            WHEN 'tour' THEN '투어'
            WHEN 'rentcar' THEN '렌터카'
            WHEN 'golf' THEN '골프'
            WHEN 'car' THEN '차량'
            WHEN 'car_sht' THEN '스하차량'
            WHEN 'vehicle' THEN '차량'
            ELSE reservation_rec.re_type
        END
    );
    
    SELECT create_business_notification(
        '결제',
        '결제확인',
        title_text,
        message_text,
        priority_level,
        user_rec.name,
        user_rec.email,
        user_rec.phone_number,  -- ✅ phone_number
        'reservation_payment',
        p_reservation_id::text,
        jsonb_build_object(
            'reservation_id', p_reservation_id,
            'user_id', p_user_id,
            'amount', p_amount,
            'payment_method', p_payment_method
        )
    ) INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 4. create_quote_approval_notification 함수 수정 (phone -> phone_number)
DROP FUNCTION IF EXISTS create_quote_approval_notification(uuid, uuid);

CREATE OR REPLACE FUNCTION create_quote_approval_notification(
    p_quote_id UUID,
    p_user_id UUID
) RETURNS UUID AS $$
DECLARE
    quote_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
BEGIN
    SELECT id, quote_id, title, total_price, status
    INTO quote_rec
    FROM quote 
    WHERE id = p_quote_id OR quote_id = p_quote_id::text;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '견적을 찾을 수 없습니다: %', p_quote_id;
    END IF;
    
    -- ✅ phone_number 사용
    SELECT name, email, phone_number
    INTO user_rec
    FROM users 
    WHERE id = p_user_id;
    
    title_text := '견적 승인 요청: ' || COALESCE(quote_rec.title, '제목없음');
    message_text := format(
        '고객명: %s
이메일: %s
연락처: %s
견적명: %s
총 금액: %s원
상태: %s

검토 후 승인 처리 부탁드립니다.',
        COALESCE(user_rec.name, '이름없음'),
        COALESCE(user_rec.email, '이메일없음'),
        COALESCE(user_rec.phone_number, '연락처없음'),  -- ✅ phone_number
        COALESCE(quote_rec.title, '제목없음'),
        COALESCE(quote_rec.total_price::text, '0'),
        CASE quote_rec.status 
            WHEN 'draft' THEN '작성중'
            WHEN 'submitted' THEN '제출됨'
            WHEN 'pending' THEN '검토중'
            ELSE quote_rec.status
        END
    );
    
    SELECT create_business_notification(
        '견적',
        '승인요청',
        title_text,
        message_text,
        '높음',
        user_rec.name,
        user_rec.email,
        user_rec.phone_number,  -- ✅ phone_number
        'quote',
        quote_rec.id::text,
        jsonb_build_object(
            'quote_id', quote_rec.quote_id,
            'user_id', p_user_id,
            'total_price', quote_rec.total_price
        )
    ) INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMIT;

-- 완료 메시지
SELECT '알림 함수 수정 완료: phone -> phone_number' as result;
