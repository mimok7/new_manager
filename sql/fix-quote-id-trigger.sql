-- 견적 제출 시 발생하는 quote_id 컬럼 오류 및 notifications 테이블 컬럼명 오류 수정
CREATE OR REPLACE FUNCTION create_quote_approval_notification(p_quote_id UUID, p_user_id UUID) RETURNS UUID AS $function$
DECLARE
    quote_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
BEGIN
    -- 1. 견적 정보 조회
    SELECT id, title, total_price, status INTO quote_rec FROM quote WHERE id = p_quote_id;
    IF NOT FOUND THEN RAISE EXCEPTION '견적을 찾을 수 없습니다: %', p_quote_id; END IF;
    
    -- 2. 사용자 정보 조회
    SELECT name, email, phone_number INTO user_rec FROM users WHERE id = p_user_id;
    
    -- 3. 제목과 메시지 생성
    title_text := '견적 승인 요청: ' || COALESCE(quote_rec.title, '제목없음');
    message_text := '고객명: ' || COALESCE(user_rec.name, '이름없음') || chr(10) ||
                    '이메일: ' || COALESCE(user_rec.email, '이메일없음') || chr(10) ||
                    '연락처: ' || COALESCE(user_rec.phone_number, '연락처없음') || chr(10) ||
                    '견적명: ' || COALESCE(quote_rec.title, '제목없음') || chr(10) ||
                    '총 금액: ' || COALESCE(quote_rec.total_price::text, '0') || '원' || chr(10) ||
                    '상태: ' || (CASE quote_rec.status 
                                    WHEN 'draft' THEN '작성중'
                                    WHEN 'submitted' THEN '제출됨'
                                    WHEN 'approved' THEN '승인됨'
                                    WHEN 'rejected' THEN '거절됨'
                                    ELSE quote_rec.status
                                END) || chr(10) || chr(10) ||
                    '검토 후 승인 처리 부탁드립니다.';

    -- 4. 알림 저장
    INSERT INTO notifications (
        type, category, subcategory, title, message, priority,
        customer_name, customer_email, customer_phone,
        target_table, target_id, metadata
    ) VALUES (
        'business', '견적', '승인요청', title_text, message_text, 'high',
        user_rec.name, user_rec.email, user_rec.phone_number,
        'quote', quote_rec.id::text,
        jsonb_build_object(
            'quote_id', quote_rec.id,
            'user_id', p_user_id,
            'total_price', quote_rec.total_price
        )
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$function$ LANGUAGE plpgsql SECURITY DEFINER;
