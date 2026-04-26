import { NextResponse } from 'next/server';
import serviceSupabase from '../../../../../lib/serviceSupabase';

type UpsertBody = {
    id?: string | null;
    cruise_code?: string | null;
    cruise_name?: string | null;
    name?: string | null;
    category?: string | null;
    duration?: string | null;
    description?: string | null;
    star_rating?: string | null;
    capacity?: string | null;
    awards?: string | null;
    cruise_image?: string | null;
    facilities?: any;
    inclusions?: string | null;
    exclusions?: string | null;
    itinerary?: any;
    cancellation_policy?: any;
    images?: string[] | string | null;
    features?: any;
    base_price?: number | null;

    // 객실 정보
    room_name?: string | null;
    room_description?: string | null;
    room_image?: string | null;
    room_area?: string | null;
    room_url?: string | null;
    bed_type?: string | null;
    max_adults?: number | null;
    max_guests?: number | null;
    has_balcony?: boolean | null;
    is_vip?: boolean | null;
    has_butler?: boolean | null;
    is_recommended?: boolean | null;
    connecting_available?: boolean | null;
    extra_bed_available?: boolean | null;
    special_amenities?: string | null;
    warnings?: string | null;
    display_order?: number | null;
};

function toNullableText(value: unknown): string | null {
    if (value === null || value === undefined) return null;
    const text = String(value).trim();
    return text ? text : null;
}

function toNullableNumber(value: unknown): number | null {
    if (value === null || value === undefined || value === '') return null;
    const n = Number(value);
    return Number.isFinite(n) ? n : null;
}

function toNullableBool(value: unknown): boolean | null {
    if (value === null || value === undefined) return null;
    if (typeof value === 'boolean') return value;
    const text = String(value).trim().toLowerCase();
    if (['true', '1', 'yes', 'y'].includes(text)) return true;
    if (['false', '0', 'no', 'n'].includes(text)) return false;
    return null;
}

function normalizeImages(images: UpsertBody['images']): string[] {
    if (Array.isArray(images)) {
        return Array.from(new Set(images.map((v) => String(v || '').trim()).filter(Boolean)));
    }
    if (typeof images === 'string') {
        return Array.from(
            new Set(
                images
                    .split(/\r?\n|,/)
                    .map((v) => v.trim())
                    .filter(Boolean)
            )
        );
    }
    return [];
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

function buildPayload(body: UpsertBody): Record<string, any> {
    const payload: Record<string, any> = {};

    const textFields: (keyof UpsertBody)[] = [
        'cruise_code', 'cruise_name', 'name', 'category', 'duration', 'description',
        'star_rating', 'capacity', 'awards', 'cruise_image', 'inclusions', 'exclusions',
        'room_name', 'room_description', 'room_image', 'room_area', 'room_url', 'bed_type',
        'special_amenities', 'warnings'
    ];
    for (const f of textFields) {
        if (f in body) payload[f] = toNullableText(body[f]);
    }

    const numberFields: (keyof UpsertBody)[] = ['max_adults', 'max_guests', 'display_order', 'base_price'];
    for (const f of numberFields) {
        if (f in body) payload[f] = toNullableNumber(body[f]);
    }

    const boolFields: (keyof UpsertBody)[] = [
        'has_balcony', 'is_vip', 'has_butler', 'is_recommended',
        'connecting_available', 'extra_bed_available'
    ];
    for (const f of boolFields) {
        if (f in body) {
            const v = toNullableBool(body[f]);
            if (v !== null) payload[f] = v;
        }
    }

    if ('images' in body) payload.images = normalizeImages(body.images);
    if ('facilities' in body) payload.facilities = parseJsonField(body.facilities);
    if ('itinerary' in body) payload.itinerary = parseJsonField(body.itinerary);
    if ('cancellation_policy' in body) payload.cancellation_policy = parseJsonField(body.cancellation_policy);
    if ('features' in body) payload.features = parseJsonField(body.features);

    payload.updated_at = new Date().toISOString();
    return payload;
}

export async function POST(request: Request) {
    try {
        if (!serviceSupabase) {
            return NextResponse.json(
                { success: false, error: 'SUPABASE_SERVICE_ROLE_KEY 환경변수를 확인하세요.' },
                { status: 500 }
            );
        }

        const body = (await request.json()) as UpsertBody;
        const payload = buildPayload(body);
        const targetId = toNullableText(body.id);

        if (targetId) {
            const { data, error } = await serviceSupabase
                .from('cruise_info')
                .update(payload)
                .eq('id', targetId)
                .select('id')
                .single();

            if (error) {
                return NextResponse.json({ success: false, error: error.message }, { status: 500 });
            }

            return NextResponse.json({ success: true, mode: 'update', id: data?.id || targetId });
        }

        const cruiseName = payload.cruise_name;
        const roomName = payload.room_name;

        if (cruiseName && roomName) {
            const { data: existing, error: lookupError } = await serviceSupabase
                .from('cruise_info')
                .select('id')
                .eq('cruise_name', cruiseName)
                .eq('room_name', roomName)
                .order('updated_at', { ascending: false })
                .limit(1)
                .maybeSingle();

            if (lookupError) {
                return NextResponse.json({ success: false, error: lookupError.message }, { status: 500 });
            }

            if (existing?.id) {
                const { data, error } = await serviceSupabase
                    .from('cruise_info')
                    .update(payload)
                    .eq('id', existing.id)
                    .select('id')
                    .single();

                if (error) {
                    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
                }

                return NextResponse.json({ success: true, mode: 'matched-update', id: data?.id || existing.id });
            }
        }

        // INSERT 시 필수 컬럼 보강
        if (!payload.cruise_code) payload.cruise_code = `CR-${Date.now()}`;
        if (!payload.name) payload.name = payload.cruise_name || 'Cruise';
        if (!payload.cruise_name) {
            return NextResponse.json({ success: false, error: 'cruise_name이 필요합니다.' }, { status: 400 });
        }
        if (!payload.room_name) {
            return NextResponse.json({ success: false, error: 'room_name이 필요합니다.' }, { status: 400 });
        }

        const { data: inserted, error: insertError } = await serviceSupabase
            .from('cruise_info')
            .insert(payload)
            .select('id')
            .single();

        if (insertError) {
            return NextResponse.json({ success: false, error: insertError.message }, { status: 500 });
        }

        return NextResponse.json({ success: true, mode: 'insert', id: inserted?.id });
    } catch (error: any) {
        return NextResponse.json(
            { success: false, error: error?.message || 'Internal server error' },
            { status: 500 }
        );
    }
}
