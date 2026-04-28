-- 1. 테이블 컬럼 추가 (매니저 처리 결과 기록용) - 반드시 Supabase SQL Editor에서 실행 필요
-- notifications 테이블
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS processing_note TEXT;
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS processed_at TIMESTAMPTZ;
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS processed_by_name TEXT;

-- customer_notifications 테이블 (누락된 컬럼 추가)
ALTER TABLE customer_notifications ADD COLUMN IF NOT EXISTS processed_at TIMESTAMPTZ;
ALTER TABLE customer_notifications ADD COLUMN IF NOT EXISTS status VARCHAR(50);
ALTER TABLE customer_notifications ADD COLUMN IF NOT EXISTS manager_name VARCHAR(255);

-- reservation 테이블
ALTER TABLE reservation ADD COLUMN IF NOT EXISTS manager_note TEXT;

-- customer_requests 테이블
ALTER TABLE customer_requests ADD COLUMN IF NOT EXISTS manager_note TEXT;
ALTER TABLE customer_requests ADD COLUMN IF NOT EXISTS processed_at TIMESTAMPTZ;
ALTER TABLE customer_requests ADD COLUMN IF NOT EXISTS processed_by UUID;


-- 2. 알림 처리 함수 개선 (상태 동기화 및 처리 결과 저장)
CREATE OR REPLACE FUNCTION complete_notification(
  p_notification_id uuid,
  p_manager_id text DEFAULT NULL,
  p_manager_name text DEFAULT '매니저',
  p_processing_note text DEFAULT '',
  p_status text DEFAULT 'completed', -- 상태 파라미터 추가
  p_customer_satisfaction integer DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_target_table text;
  v_target_id text;
  v_notification_type text;
BEGIN
  -- 1) 알림 정보 조회
  SELECT target_table, target_id, type 
  INTO v_target_table, v_target_id, v_notification_type
  FROM notifications 
  WHERE id = p_notification_id;

  -- 2) notifications 테이블 업데이트
  UPDATE notifications
  SET 
    status = p_status, -- 파라미터로 받은 상태 적용
    processed_at = CASE WHEN p_status = 'completed' THEN now() ELSE processed_at END,
    updated_at = now(),
    processing_note = p_processing_note,
    processed_by_name = p_manager_name,
    metadata = COALESCE(metadata, '{}'::jsonb) || 
      jsonb_build_object(
        'processed_by', p_manager_id,
        'processed_by_id', p_manager_id,
        'processed_by_name', p_manager_name,
        'processing_note', p_processing_note,
        'updated_at', now()
      )
  WHERE id = p_notification_id;

  -- 3) customer_notifications 상세 정보 업데이트 (연결된 경우)
  UPDATE customer_notifications
  SET 
    resolution_notes = p_processing_note,
    manager_name = p_manager_name,
    customer_satisfaction = COALESCE(p_customer_satisfaction, customer_satisfaction),
    updated_at = now(),
    status = p_status, -- 상태 동기화
    processed_at = CASE WHEN p_status = 'completed' THEN now() ELSE processed_at END
  WHERE notification_id = p_notification_id OR id = p_notification_id;

  -- 4) 원본 데이터 동기화 (가장 중요)
  IF v_target_table IS NOT NULL AND v_target_id IS NOT NULL THEN
    
    -- UUID 포맷 검사 (정규식)
    IF v_target_id ~ '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' THEN

      -- [예약] 상태 'confirmed'로 변경 및 매니저 노트 기록
      IF v_target_table = 'reservation' THEN
        UPDATE reservation 
        SET 
          re_status = 'confirmed',
          manager_note = COALESCE(manager_note || E'\n', '') || p_processing_note,
          re_update_at = now()
        WHERE re_id = v_target_id::uuid;
        
        -- 관련 customer_requests가 있으면 그것도 완료 처리
        UPDATE customer_requests
        SET 
          status = CASE 
            WHEN p_status = 'processing' THEN 'in_progress'
            WHEN p_status = 'completed' THEN 'completed'
            ELSE status 
          END,
          response_message = p_processing_note,
          updated_at = now()
        WHERE related_reservation_id = v_target_id 
          AND status IN ('pending', 'in_progress');

      -- [견적] 상태 'approved'로 변경 및 매니저 노트 기록
      ELSIF v_target_table = 'quote' THEN
        UPDATE quote 
        SET 
          status = 'approved',
          manager_note = COALESCE(manager_note || E'\n', '') || p_processing_note,
          updated_at = now()
        WHERE id = v_target_id::uuid;

      -- [고객요청] 상태 변경 및 응답 기록
      ELSIF v_target_table = 'customer_requests' THEN
        UPDATE customer_requests
        SET
          status = CASE 
            WHEN p_status = 'processing' THEN 'in_progress'
            WHEN p_status = 'completed' THEN 'completed'
            ELSE status 
          END,
          processed_at = CASE WHEN p_status = 'completed' THEN now() ELSE processed_at END,
          response_message = p_processing_note,
          updated_at = now()
        WHERE id = v_target_id::uuid;
        
        -- 연결된 예약이 있다면 예약 상태도 확정으로 변경 시도
        UPDATE reservation r
        SET re_status = 'confirmed', re_update_at = now()
        FROM customer_requests cr
        WHERE cr.id = v_target_id::uuid 
          AND cr.related_reservation_id IS NOT NULL 
          AND r.re_id = cr.related_reservation_id::uuid
          AND r.re_status = 'pending';
      END IF;

    ELSE
      -- UUID가 아닌 경우 (예: payment_notifications의 숫자 ID 등)
      -- 로그만 남기고 에러 발생시키지 않음 (알림 상태 변경은 성공해야 함)
      RAISE NOTICE 'Target ID is not a UUID: %, Table: %', v_target_id, v_target_table;
    END IF;
  END IF;

  RETURN json_build_object(
    'success', true, 
    'message', '알림 처리 및 원본 데이터 동기화가 완료되었습니다.', 
    'notification_id', p_notification_id,
    'target_table', v_target_table,
    'target_id', v_target_id
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false, 
      'message', '동기화 중 오류 발생: ' || SQLERRM
    );
END;
$$;
