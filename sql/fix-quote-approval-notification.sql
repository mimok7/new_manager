-- create_quote_approval_notification 함수 수정
-- quote_id 참조를 id로 변경
CREATE OR REPLACE FUNCTION public.create_quote_approval_notification(p_quote_id uuid, p_user_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    quote_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
BEGIN
    -- 견적 정보 조회 (quote_id 컬럼 제거, id만 사용)
    SELECT id, title, total_price, status
    INTO quote_rec
    FROM quote 
    WHERE id = p_quote_id;  -- quote_id 조건 제거
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '견적을 찾을 수 없습니다: %', p_quote_id;
    END IF;
    
    -- 사용자 정보 조회 (phone → phone_number로 수정)
    SELECT name, email, phone_number
    INTO user_rec
    FROM users 
    WHERE id = p_user_id;
    
    -- 제목과 메시지 생성
    title_text := '견적 승인 요청: ' || COALESCE(quote_rec.title, '제목없음');
    message_text := '고객명: ' || COALESCE(user_rec.name, '이름없음') || chr(10) ||
                    '이메일: ' || COALESCE(user_rec.email, '이메일없음') || chr(10) ||
                    '연락처: ' || COALESCE(user_rec.phone_number, '연락처없음') || chr(10) ||
                    '견적명: ' || COALESCE(quote_rec.title, '제목없음') || chr(10) ||
                    '총 금액: ' || COALESCE(quote_rec.total_price::text, '0') || '원' || chr(10) ||
                    '상태: ' || (CASE quote_rec.status 
                                    WHEN 'draft' THEN '작성중'
                                    WHEN 'submitted' THEN '제출됨'
                                    WHEN 'pending' THEN '검토중'
                                    ELSE quote_rec.status
                                END) || chr(10) || chr(10) ||
                    '검토 후 승인 처리 부탁드립니다.';
    
    -- 알림 생성 (quote_id를 id로 변경)
    SELECT create_business_notification(
        '견적',
        title_text,
        message_text,
        '승인요청',
        'high',
        user_rec.name,
        user_rec.email,
        user_rec.phone_number,
        'quote',
        quote_rec.id::text,
        jsonb_build_object(
            'quote_id', quote_rec.id,  -- quote_rec.quote_id → quote_rec.id
            'user_id', p_user_id,
            'total_price', quote_rec.total_price
        )
    ) INTO notification_id;
    
    RETURN notification_id;
END;
$function$;
