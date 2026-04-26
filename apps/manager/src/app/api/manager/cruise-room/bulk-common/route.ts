import { NextResponse } from 'next/server';
import serviceSupabase from '../../../../../lib/serviceSupabase';

/**
 * 같은 cruise_name을 가진 모든 cruise_info 행에 공통 정보를 일괄 적용한다.
 * 객실별로 다른 필드(room_name, room_description 등)는 변경하지 않음.
 */

const COMMON_TEXT_FIELDS = [
    'name', 'category', 'duration', 'description',
    'star_rating', 'capacity', 'awards', 'cruise_image',
    'inclusions', 'exclusions',
] as const;

const COMMON_JSON_FIELDS = ['facilities', 'itinerary', 'cancellation_policy'] as const;

function toNullableText(value: unknown): string | null {
    if (value === null || value === undefined) return null;
    const text = String(value).trim();
    return text ? text : null;
}

function parseJsonField(value: any): any {
    if (value === null || value === undefined) return null;
    if (typeof value === 'object') return value;
    if (typeof value === 'string') {
        const trimmed = value.trim();
        if (!trimmed) return null;
        try {
            return JSON.parse(trimmed);
        } catch {
            return null;
        }
    }
    return null;
}

export async function POST(request: Request) {
    try {
        if (!serviceSupabase) {
            return NextResponse.json(
                { success: false, error: 'SUPABASE_SERVICE_ROLE_KEY 환경변수를 확인하세요.' },
                { status: 500 }
            );
        }

        const body = await request.json();
        const cruiseName = toNullableText(body?.cruise_name);
        if (!cruiseName) {
            return NextResponse.json({ success: false, error: 'cruise_name이 필요합니다.' }, { status: 400 });
        }

        const payload: Record<string, any> = {};
        for (const f of COMMON_TEXT_FIELDS) {
            if (f in body) payload[f] = toNullableText(body[f]);
        }
        for (const f of COMMON_JSON_FIELDS) {
            if (f in body) payload[f] = parseJsonField(body[f]);
        }
        if (Object.keys(payload).length === 0) {
            return NextResponse.json({ success: false, error: '업데이트할 필드가 없습니다.' }, { status: 400 });
        }
        payload.updated_at = new Date().toISOString();

        // cruise_name 변경(기존명 -> 신규명)도 지원
        const newCruiseName = toNullableText(body?.new_cruise_name);
        if (newCruiseName && newCruiseName !== cruiseName) {
            payload.cruise_name = newCruiseName;
        }

        const { data, error } = await serviceSupabase
            .from('cruise_info')
            .update(payload)
            .eq('cruise_name', cruiseName)
            .select('id');

        if (error) {
            return NextResponse.json({ success: false, error: error.message }, { status: 500 });
        }

        return NextResponse.json({
            success: true,
            mode: 'bulk-common',
            updated_count: (data || []).length,
            cruise_name: payload.cruise_name || cruiseName,
        });
    } catch (error: any) {
        return NextResponse.json(
            { success: false, error: error?.message || 'Internal server error' },
            { status: 500 }
        );
    }
}
