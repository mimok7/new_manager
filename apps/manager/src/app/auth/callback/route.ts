import { NextRequest, NextResponse } from 'next/server';
import { createSupabaseServerClient } from '@/lib/supabaseServer';

export async function GET(request: NextRequest) {
    const requestUrl = new URL(request.url);
    const code = requestUrl.searchParams.get('code');
    const error = requestUrl.searchParams.get('error');
    const error_description = requestUrl.searchParams.get('error_description');

    // 에러가 있는 경우
    if (error) {
        console.error('OAuth 에러:', error, error_description);
        return NextResponse.redirect(new URL(`/login?error=${encodeURIComponent(error_description || error)}`, requestUrl.origin));
    }

    if (code) {
        let response = NextResponse.redirect(new URL('/', requestUrl.origin));

        try {
            const supabase = await createSupabaseServerClient(response);
            // 인증 코드를 세션으로 교환
            const { data: { user }, error: authError } = await supabase.auth.exchangeCodeForSession(code);

            if (authError) {
                console.error('세션 교환 실패:', authError);
                return NextResponse.redirect(new URL('/login?error=auth_failed', requestUrl.origin));
            }

            if (!user) {
                console.error('사용자 정보 없음');
                return NextResponse.redirect(new URL('/login?error=no_user', requestUrl.origin));
            }

            console.log('✅ OAuth 로그인 성공:', user.id, user.email);

            // users 테이블에 사용자 프로필 확인 (매니저 앱이므로 신규 자동 생성 금지)
            const { data: existingUser, error: fetchError } = await supabase
                .from('users')
                .select('id, role, status')
                .eq('id', user.id)
                .single();

            const ALLOWED_ROLES = ['manager', 'admin', 'dispatcher'];

            if (fetchError && fetchError.code === 'PGRST116') {
                // 신규 사용자 → 매니저 앱에서는 차단
                console.warn('⛔ OAuth 매니저 권한 없음 (신규):', user.email);
                await supabase.auth.signOut();
                return NextResponse.redirect(new URL('/login?error=' + encodeURIComponent('매니저 권한이 없는 계정입니다.'), requestUrl.origin));
            }

            const userRole = existingUser?.role || null;
            if (!userRole || !ALLOWED_ROLES.includes(userRole)) {
                console.warn('⛔ OAuth 매니저 권한 없음:', user.email, 'role=', userRole);
                await supabase.auth.signOut();
                return NextResponse.redirect(new URL('/login?error=' + encodeURIComponent(`매니저 권한이 없는 계정입니다. (현재 권한: ${userRole || '없음'})`), requestUrl.origin));
            }

            console.log('✅ 기존 프로필 확인:', userRole);

            // 로그인 성공, 홈으로 리다이렉트
            return response;

        } catch (error) {
            console.error('OAuth 콜백 처리 오류:', error);
            return NextResponse.redirect(new URL('/login?error=callback_failed', requestUrl.origin));
        }
    }

    // code가 없으면 로그인 페이지로
    return NextResponse.redirect(new URL('/login', requestUrl.origin));
}
