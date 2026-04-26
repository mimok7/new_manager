import { NextResponse } from 'next/server';
import serviceSupabase from '../../../../../lib/serviceSupabase';

export async function POST(request: Request) {
    try {
        if (!serviceSupabase) {
            return NextResponse.json(
                { success: false, error: 'SUPABASE_SERVICE_ROLE_KEY 환경변수를 확인하세요.' },
                { status: 500 }
            );
        }

        const body = await request.json();
        const id = String(body?.id || '').trim();
        if (!id) {
            return NextResponse.json({ success: false, error: 'id가 필요합니다.' }, { status: 400 });
        }

        const { error } = await serviceSupabase.from('cruise_info').delete().eq('id', id);
        if (error) {
            return NextResponse.json({ success: false, error: error.message }, { status: 500 });
        }

        return NextResponse.json({ success: true, id });
    } catch (error: any) {
        return NextResponse.json(
            { success: false, error: error?.message || 'Internal server error' },
            { status: 500 }
        );
    }
}
