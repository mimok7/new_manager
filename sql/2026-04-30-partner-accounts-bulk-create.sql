-- ============================================================
-- 제휴업체 담당자 계정 일괄 생성
-- 작성일: 2026-04-30
-- 목적: 현재 등록된 모든 활성 제휴업체(호텔 제외)에 대해
--       partner1@stayhalong.com 부터 순차로 로그인 계정 생성
-- 전제:
--   - pgcrypto 확장 활성화 (Supabase 기본 활성)
--   - 2026-04-30-partner-system.sql 적용 완료 (partner / partner_user 테이블)
--   - supabase-auth-integration.sql의 handle_new_user 트리거 정상 동작
-- 동작:
--   1) partner 테이블의 활성 업체를 created_at 순으로 정렬
--   2) 각 업체에 대해 partner{N}@stayhalong.com 이메일로
--      auth.users + auth.identities 생성 (이미 있으면 스킵)
--   3) public.users 의 role을 'partner'로 설정
--   4) partner_user 매핑(역할='manager') 생성/갱신
-- 적용 위치: Supabase SQL Editor (service_role 권한 필요)
-- ⚠️ 보안: 운영 적용 후 각 업체에 비밀번호 변경 안내 필수
-- ============================================================

BEGIN;

-- pgcrypto 확장 보장
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    rec RECORD;
    v_idx        int := 0;
    v_total      int := 0;
    v_skipped    int := 0;
    v_email      text;
    v_uid        uuid;
    v_existing   boolean;
    -- ⚠️ 초기 비밀번호 — 배포 후 각 매장에 안내하고 변경 유도
    v_pwd CONSTANT text := 'partner1234!';
BEGIN
    FOR rec IN
        SELECT partner_id, partner_code, name, category, region, branch_name
          FROM partner
         WHERE is_active = true
           AND COALESCE(category, '') <> 'hotel'
         ORDER BY created_at NULLS LAST, partner_code
    LOOP
        v_idx := v_idx + 1;
        v_email := 'partner' || v_idx::text || '@stayhalong.com';

        -- 이미 존재하는 이메일이면 uid 재사용
        SELECT id INTO v_uid FROM auth.users WHERE email = v_email LIMIT 1;
        v_existing := v_uid IS NOT NULL;

        IF NOT v_existing THEN
            v_uid := gen_random_uuid();

            -- 1) auth.users 생성
            INSERT INTO auth.users (
                instance_id, id, aud, role,
                email, encrypted_password, email_confirmed_at,
                raw_app_meta_data, raw_user_meta_data,
                created_at, updated_at,
                confirmation_token, email_change, email_change_token_new, recovery_token
            ) VALUES (
                '00000000-0000-0000-0000-000000000000',
                v_uid,
                'authenticated', 'authenticated',
                v_email,
                crypt(v_pwd, gen_salt('bf')),
                now(),
                jsonb_build_object(
                    'provider','email',
                    'providers', jsonb_build_array('email')
                ),
                jsonb_build_object(
                    'partner_code', rec.partner_code,
                    'partner_name', rec.name,
                    'category',     rec.category
                ),
                now(), now(),
                '', '', '', ''
            );

            -- 2) auth.identities (이메일 로그인 활성화에 필요)
            INSERT INTO auth.identities (
                id, user_id, provider_id, identity_data, provider,
                last_sign_in_at, created_at, updated_at
            ) VALUES (
                gen_random_uuid(),
                v_uid,
                v_uid::text,
                jsonb_build_object(
                    'sub',            v_uid::text,
                    'email',          v_email,
                    'email_verified', true,
                    'phone_verified', false
                ),
                'email',
                now(), now(), now()
            );
            v_total := v_total + 1;
        ELSE
            v_skipped := v_skipped + 1;
        END IF;

        -- 3) public.users 업서트 (role='partner'로 강제)
        --    handle_new_user 트리거가 미리 'guest'로 만들었을 수 있어 ON CONFLICT 갱신
        INSERT INTO public.users (id, email, name, role, created_at)
        VALUES (v_uid, v_email, rec.name, 'partner', now())
        ON CONFLICT (id) DO UPDATE SET
            email = EXCLUDED.email,
            name  = EXCLUDED.name,
            role  = 'partner';

        -- 4) partner_user 매핑 (UNIQUE: pu_user_id)
        INSERT INTO partner_user (pu_user_id, pu_partner_id, role)
        VALUES (v_uid, rec.partner_id, 'manager')
        ON CONFLICT (pu_user_id) DO UPDATE SET
            pu_partner_id = EXCLUDED.pu_partner_id,
            role          = 'manager';

        RAISE NOTICE '[%] % => %  (%, %)',
            v_idx, v_email, rec.partner_code, rec.name, COALESCE(rec.branch_name, '-');
    END LOOP;

    RAISE NOTICE '======================================';
    RAISE NOTICE '처리 완료 — 전체 %건 / 신규 % / 기존 재사용 %', v_idx, v_total, v_skipped;
    RAISE NOTICE '초기 비밀번호: %', v_pwd;
    RAISE NOTICE '⚠️ 각 업체에 계정 안내 후 비밀번호 변경 유도 필요';
    RAISE NOTICE '======================================';
END$$;

COMMIT;

-- ============================================================
-- 검증 쿼리 (수동)
-- ============================================================
-- 1) 생성된 계정 매핑
-- SELECT
--     u.email,
--     u.role,
--     p.partner_code,
--     p.name AS partner_name,
--     p.category,
--     p.region,
--     pu.role AS partner_role
--   FROM public.users u
--   JOIN partner_user pu ON pu.pu_user_id = u.id
--   JOIN partner p       ON p.partner_id  = pu.pu_partner_id
--  WHERE u.email LIKE 'partner%@stayhalong.com'
--  ORDER BY u.email;
--
-- 2) auth 측 확인
-- SELECT email, email_confirmed_at, raw_user_meta_data
--   FROM auth.users
--  WHERE email LIKE 'partner%@stayhalong.com'
--  ORDER BY email;
--
-- 3) 비밀번호 강제 재설정 예시 (특정 업체)
-- UPDATE auth.users SET encrypted_password = crypt('새비번', gen_salt('bf'))
--  WHERE email = 'partner1@stayhalong.com';
--
-- 4) 계정 일괄 삭제(롤백)
-- DELETE FROM partner_user WHERE pu_user_id IN (
--     SELECT id FROM auth.users WHERE email LIKE 'partner%@stayhalong.com'
-- );
-- DELETE FROM public.users WHERE email LIKE 'partner%@stayhalong.com';
-- DELETE FROM auth.identities WHERE user_id IN (
--     SELECT id FROM auth.users WHERE email LIKE 'partner%@stayhalong.com'
-- );
-- DELETE FROM auth.users WHERE email LIKE 'partner%@stayhalong.com';
