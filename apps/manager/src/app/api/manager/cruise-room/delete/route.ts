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
        const cruiseName = String(body?.cruise_name || '').trim();

        if (!id && !cruiseName) {
            return NextResponse.json({ success: false, error: 'id 또는 cruise_name이 필요합니다.' }, { status: 400 });
        }

        if (cruiseName) {
            const { data, error } = await serviceSupabase
                .from('cruise_info')
                .delete()
                .eq('cruise_name', cruiseName)
                .select('id');

            if (error) {
                return NextResponse.json({ success: false, error: error.message }, { status: 500 });
            }

            return NextResponse.json({ success: true, cruise_name: cruiseName, deleted_count: data?.length || 0 });
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
