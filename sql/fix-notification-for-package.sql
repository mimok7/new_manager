-- 🔔 알림 생성 함수에 'package' 타입 지원 추가

-- 1. 예약 신청 알림 생성 함수 수정
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
    -- 예약 정보 조회
    SELECT re_id, re_user_id, re_quote_id, re_type, re_status, total_amount
    FROM reservation 
    WHERE re_id = p_reservation_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '예약을 찾을 수 없습니다: %', p_reservation_id;
    END IF;
    
    -- 사용자 정보 조회
    SELECT name, email, phone
    INTO user_rec
    FROM users 
    WHERE id = COALESCE(p_user_id, reservation_rec.re_user_id);
    
    -- 견적 정보 조회 (있는 경우)
    IF reservation_rec.re_quote_id IS NOT NULL THEN
        SELECT title INTO quote_rec
        FROM quote 
        WHERE id = reservation_rec.re_quote_id;
    END IF;
    
    -- 서비스 이름 변환
    service_name := CASE reservation_rec.re_type
        WHEN 'cruise' THEN '크루즈'
        WHEN 'airport' THEN '공항 서비스'
        WHEN 'hotel' THEN '호텔'
        WHEN 'tour' THEN '투어'
        WHEN 'rentcar' THEN '렌터카'
        WHEN 'package' THEN '패키지'
        WHEN 'sht' THEN '스테이하롱 차량'
        WHEN 'car' THEN '크루즈 차량'
        ELSE reservation_rec.re_type
    END;
    
    -- 제목과 메시지 생성
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
        COALESCE(user_rec.phone, '연락처없음'),
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
    
    -- 알림 생성
    SELECT create_business_notification(
        '예약',
        '신규신청',
        title_text,
        message_text,
        'high',
        user_rec.name,
        user_rec.email,
        user_rec.phone,
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

-- 2. 결제 신청 알림 생성 함수 수정
CREATE OR REPLACE FUNCTION create_payment_notification(
    p_reservation_id UUID,
    p_user_id UUID,
    p_amount NUMERIC,
    p_payment_method TEXT
) RETURNS UUID AS $$
DECLARE
    payment_rec RECORD;
    reservation_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
    priority_level TEXT;
BEGIN
    -- 사용자 정보 조회
    SELECT name, email, phone
    INTO user_rec
    FROM users 
    WHERE id = p_user_id;
    
    -- 예약 정보 조회
    SELECT re_type, re_quote_id
    INTO reservation_rec
    FROM reservation 
    WHERE re_id = p_reservation_id;
    
    -- 우선순위 결정 (금액 기준)
    priority_level := CASE 
        WHEN p_amount >= 1000000 THEN 'urgent'
        WHEN p_amount >= 500000 THEN 'high'
        ELSE 'normal'
    END;
    
    -- 제목과 메시지 생성
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
        COALESCE(user_rec.phone, '연락처없음'),
        p_amount::text,
        COALESCE(p_payment_method, '방법없음'),
        CASE reservation_rec.re_type
            WHEN 'cruise' THEN '크루즈'
            WHEN 'airport' THEN '공항 서비스'
            WHEN 'hotel' THEN '호텔'
            WHEN 'tour' THEN '투어'
            WHEN 'rentcar' THEN '렌터카'
            WHEN 'package' THEN '패키지'
            WHEN 'sht' THEN '스테이하롱 차량'
            WHEN 'car' THEN '크루즈 차량'
            ELSE reservation_rec.re_type
        END
    );
    
    -- 알림 생성
    SELECT create_business_notification(
        '결제',
        '결제확인',
        title_text,
        message_text,
        priority_level,
        user_rec.name,
        user_rec.email,
        user_rec.phone,
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
