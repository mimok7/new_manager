'use client';

import { useEffect, useMemo, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import PartnerLayout from '@/components/PartnerLayout';
import SectionBox from '@/components/SectionBox';
import Spinner from '@/components/Spinner';
import { supabase } from '@/lib/supabase';
import { useAuth } from '@/hooks/useAuth';

interface Service {
    service_id: string;
    service_name: string;
    service_type: string;
    service_subtype?: string | null;
    description?: string | null;
    capacity?: number | null;
    default_price: number;
    unit?: string | null;
    duration_minutes?: number | null;
    min_quantity?: number | null;
    max_quantity?: number | null;
    sht_discount_rate?: number | null;
    thumbnail_url?: string | null;
}
interface Price {
    price_code: string;
    service_id: string;
    valid_from?: string | null;
    valid_to?: string | null;
    price: number;
    sht_price?: number | null;
    duration_minutes?: number | null;
    tier_label?: string | null;
    condition_label?: string | null;
    is_active?: boolean | null;
}
interface Promotion {
    promo_id: string;
    promo_code: string;
    promo_name: string;
    promo_type: string;
    benefit_value?: number | null;
    benefit_unit?: string | null;
    free_item_name?: string | null;
    min_people?: number | null;
    max_people?: number | null;
    requires_coupon?: boolean | null;
    coupon_label?: string | null;
    requires_cruise_booking?: boolean | null;
    min_cruise_people?: number | null;
    note?: string | null;
}
interface Partner {
    partner_id: string; name: string; branch_name?: string | null;
    category: string; subcategory?: string | null;
    region?: string | null; address?: string | null; description?: string | null;
    thumbnail_url?: string | null; open_hours?: string | null; map_url?: string | null;
    booking_lead_hours?: number | null;
}

function modeOf(category: string): 'stay' | 'schedule' | 'order' {
    if (category === 'hotel') return 'stay';
    if (category === 'restaurant') return 'order';
    return 'schedule';
}

const CATEGORY_LABEL: Record<string, string> = {
    hotel: '🏨 호텔', spa: '💆 스파', restaurant: '🍴 식당', costume: '👘 의상대여', tour: '🚌 투어', rentcar: '🚗 렌터카',
};

export default function BookingDetailPage() {
    const params = useParams();
    const router = useRouter();
    const partnerId = String(params?.partnerId || '');
    const { user, loading: authLoading } = useAuth(['member', 'partner', 'manager', 'admin'], '/partner/login');

    const [partner, setPartner] = useState<Partner | null>(null);
    const [services, setServices] = useState<Service[]>([]);
    const [prices, setPrices] = useState<Price[]>([]);
    const [promotions, setPromotions] = useState<Promotion[]>([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [msg, setMsg] = useState<string | null>(null);

    const [selectedService, setSelectedService] = useState<string>('');
    const [selectedPrice, setSelectedPrice] = useState<string>('');
    const [checkin, setCheckin] = useState<string>('');
    const [checkout, setCheckout] = useState<string>('');
    const [roomCount, setRoomCount] = useState<number>(1);
    const [scheduledDate, setScheduledDate] = useState<string>('');
    const [scheduledTime, setScheduledTime] = useState<string>('');
    const [quantity, setQuantity] = useState<number>(1);
    const [guestCount, setGuestCount] = useState<number>(2);
    const [contactName, setContactName] = useState<string>('');
    const [contactPhone, setContactPhone] = useState<string>('');
    const [requestNote, setRequestNote] = useState<string>('');
    const [couponCode, setCouponCode] = useState<string>('');

    const mode = useMemo(() => modeOf(partner?.category || 'hotel'), [partner?.category]);

    useEffect(() => {
        if (!partnerId) return;
        let cancelled = false;
        (async () => {
            try {
                const [pRes, sRes, promRes] = await Promise.all([
                    supabase.from('partner').select('*').eq('partner_id', partnerId).maybeSingle(),
                    supabase.from('partner_service').select('*').eq('partner_id', partnerId).eq('is_active', true).order('sort_order', { ascending: true }).order('service_name'),
                    supabase.from('partner_promotion').select('*').eq('partner_id', partnerId).eq('is_active', true),
                ]);
                if (cancelled) return;
                setPartner((pRes.data as Partner) || null);
                const ss = (sRes.data as Service[]) || [];
                setServices(ss);
                setPromotions((promRes.data as Promotion[]) || []);
                if (ss.length > 0) {
                    const ids = ss.map(s => s.service_id);
                    const { data: prRes } = await supabase
                        .from('partner_price')
                        .select('*')
                        .in('service_id', ids);
                    if (cancelled) return;
                    setPrices(((prRes as Price[]) || []).filter(p => p.is_active !== false));
                }
            } finally {
                if (!cancelled) setLoading(false);
            }
        })();
        return () => { cancelled = true; };
    }, [partnerId]);

    const currentService = useMemo(() => services.find(s => s.service_id === selectedService) || null, [services, selectedService]);
    const currentPrice = useMemo(() => prices.find(p => p.price_code === selectedPrice) || null, [prices, selectedPrice]);
    const servicePrices = useMemo(() => selectedService ? prices.filter(p => p.service_id === selectedService) : [], [selectedService, prices]);

    const nights = useMemo(() => {
        if (mode !== 'stay' || !checkin || !checkout) return 0;
        const d = Math.ceil((new Date(checkout).getTime() - new Date(checkin).getTime()) / 86400000);
        return d > 0 ? d : 0;
    }, [mode, checkin, checkout]);

    const unitPrice = useMemo(() => {
        if (currentPrice) return Number(currentPrice.price) || 0;
        return Number(currentService?.default_price) || 0;
    }, [currentPrice, currentService]);

    const totalPrice = useMemo(() => {
        if (mode === 'stay') return unitPrice * (nights || 1) * roomCount;
        return unitPrice * Math.max(1, quantity);
    }, [mode, unitPrice, nights, roomCount, quantity]);

    const eligiblePromos = useMemo(() => {
        const ppl = mode === 'stay' ? guestCount : Math.max(1, quantity);
        return promotions.filter(p => {
            if (p.min_people && ppl < p.min_people) return false;
            if (p.max_people && ppl > p.max_people) return false;
            return true;
        });
    }, [promotions, guestCount, quantity, mode]);

    const handleSubmit = async () => {
        setMsg(null);
        if (!user) { setMsg('로그인이 필요합니다.'); return; }
        if (!selectedService) { setMsg('서비스를 선택하세요.'); return; }

        if (mode === 'stay') {
            if (!checkin || !checkout) { setMsg('체크인/체크아웃 날짜를 입력하세요.'); return; }
            if (nights <= 0) { setMsg('체크아웃이 체크인보다 이후여야 합니다.'); return; }
        } else if (mode === 'schedule') {
            if (!scheduledDate || !scheduledTime) { setMsg('이용 날짜와 시간을 선택하세요.'); return; }
        } else if (mode === 'order') {
            if (!scheduledDate) { setMsg('방문/배달 날짜를 선택하세요.'); return; }
        }

        if (currentService?.min_quantity && quantity < currentService.min_quantity) {
            setMsg(`최소 ${currentService.min_quantity} 이상 선택해야 합니다.`); return;
        }
        if (currentService?.max_quantity && quantity > currentService.max_quantity) {
            setMsg(`최대 ${currentService.max_quantity}까지 선택 가능합니다.`); return;
        }

        setSubmitting(true);
        try {
            try {
                const { data: existing } = await supabase.from('users').select('id').eq('id', user.id).maybeSingle();
                if (!existing) {
                    await supabase.from('users').insert({
                        id: user.id, email: user.email, role: 'member',
                        name: contactName || user.email, phone: contactPhone,
                    });
                }
            } catch { /* ignore */ }

            const scheduledAt = mode === 'schedule'
                ? `${scheduledDate}T${scheduledTime}:00`
                : (mode === 'order' && scheduledDate ? `${scheduledDate}T${scheduledTime || '12:00'}:00` : null);

            const payload: any = {
                pr_user_id: user.id,
                pr_partner_id: partnerId,
                pr_service_id: selectedService,
                pr_price_code: selectedPrice || null,
                guest_count: guestCount,
                unit_price: unitPrice,
                total_price: totalPrice,
                status: 'pending',
                request_note: couponCode ? `[쿠폰: ${couponCode}]\n${requestNote || ''}`.trim() : (requestNote || null),
                contact_name: contactName || null,
                contact_phone: contactPhone || null,
                service_label: currentService?.service_name || null,
                price_label: currentPrice?.tier_label || currentPrice?.condition_label || null,
                quantity: mode === 'stay' ? roomCount : quantity,
                duration_minutes: currentPrice?.duration_minutes ?? currentService?.duration_minutes ?? null,
                payment_status: 'unpaid',
            };

            if (mode === 'stay') {
                payload.checkin_date = checkin;
                payload.checkout_date = checkout;
                payload.nights = nights;
                payload.room_count = roomCount;
            } else {
                payload.scheduled_at = scheduledAt;
            }

            const { error } = await supabase.from('partner_reservation').insert(payload);
            if (error) throw error;
            router.push('/partner/my-reservations');
        } catch (err: any) {
            setMsg(err?.message || '예약 저장 실패');
        } finally {
            setSubmitting(false);
        }
    };

    if (authLoading || loading) {
        return <PartnerLayout requiredRoles={['member', 'partner', 'manager', 'admin']}><Spinner label="불러오는 중..." /></PartnerLayout>;
    }
    if (!partner) {
        return <PartnerLayout requiredRoles={['member', 'partner', 'manager', 'admin']}><div className="text-sm text-gray-500">업체를 찾을 수 없습니다.</div></PartnerLayout>;
    }

    const unitLabel = currentService?.unit || (mode === 'stay' ? 'night' : mode === 'order' ? 'item' : 'session');
    const unitKo: Record<string, string> = { night: '박', session: '회', hour: '시간', meal: '식', item: '개', day: '일', person: '명' };

    return (
        <PartnerLayout title={`${CATEGORY_LABEL[partner.category] || partner.category} ${partner.name}${partner.branch_name ? ` (${partner.branch_name})` : ''}`} requiredRoles={['member', 'partner', 'manager', 'admin']}>
            <SectionBox title="업체 정보">
                {partner.thumbnail_url && <img src={partner.thumbnail_url} alt={partner.name} className="w-full max-h-48 object-cover rounded mb-3" />}
                <div className="text-sm text-gray-700 space-y-0.5">
                    <div>지역: {partner.region || '-'}</div>
                    <div>주소: {partner.address || '-'}</div>
                    {partner.open_hours && <div>운영 시간: {partner.open_hours}</div>}
                    {partner.booking_lead_hours ? <div className="text-amber-700">최소 예약 시간: {partner.booking_lead_hours}시간 전</div> : null}
                    {partner.description && <div className="text-gray-600 mt-2 whitespace-pre-line">{partner.description}</div>}
                    {partner.map_url && <a href={partner.map_url} target="_blank" rel="noreferrer" className="text-blue-600 hover:underline">지도 보기 →</a>}
                </div>
            </SectionBox>

            {promotions.length > 0 && (
                <SectionBox title="🎁 진행 중 프로모션">
                    <div className="space-y-2">
                        {promotions.map(p => {
                            const eligible = eligiblePromos.find(e => e.promo_id === p.promo_id);
                            return (
                                <div key={p.promo_id} className={`p-3 rounded border ${eligible ? 'border-green-300 bg-green-50' : 'border-gray-200 bg-gray-50 opacity-70'}`}>
                                    <div className="flex justify-between items-start gap-2">
                                        <div className="text-sm font-medium text-gray-800">{p.promo_name}</div>
                                        <span className="text-xs px-2 py-0.5 rounded bg-white border border-gray-200 text-gray-600">{p.promo_code}</span>
                                    </div>
                                    <div className="text-xs text-gray-600 mt-1">
                                        {p.promo_type === 'free_item' && p.free_item_name && <>🎉 무료 제공: <b>{p.free_item_name}</b></>}
                                        {p.promo_type === 'percent_discount' && <>💸 할인: <b>{p.benefit_value}%</b></>}
                                        {p.promo_type === 'amount_discount' && <>💸 할인: <b>{Number(p.benefit_value || 0).toLocaleString()} {p.benefit_unit || 'VND'}</b></>}
                                    </div>
                                    {(p.min_people || p.max_people) && (
                                        <div className="text-xs text-gray-500 mt-0.5">조건: {p.min_people || 1}~{p.max_people || '∞'}명</div>
                                    )}
                                    {p.requires_cruise_booking && (
                                        <div className="text-xs text-blue-600 mt-0.5">크루즈 예약 동반 시 적용 (최소 {p.min_cruise_people || 1}명)</div>
                                    )}
                                    {p.requires_coupon && (
                                        <div className="text-xs text-amber-600 mt-0.5">🎟️ 쿠폰 필수 — 코드 입력란에 기재</div>
                                    )}
                                    {p.note && <div className="text-xs text-gray-500 mt-1 whitespace-pre-line">{p.note}</div>}
                                </div>
                            );
                        })}
                    </div>
                </SectionBox>
            )}

            <SectionBox title="① 서비스/메뉴 선택">
                {services.length === 0 ? (
                    <div className="text-sm text-gray-500">등록된 서비스가 없습니다.</div>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3 max-h-[480px] overflow-y-auto">
                        {services.map(s => {
                            const active = s.service_id === selectedService;
                            return (
                                <div key={s.service_id}
                                    onClick={() => { setSelectedService(s.service_id); setSelectedPrice(''); }}
                                    className={`p-3 rounded border-2 cursor-pointer ${active ? 'border-blue-500 bg-blue-50' : 'border-gray-200 bg-white hover:border-blue-300'}`}>
                                    {s.thumbnail_url && <img src={s.thumbnail_url} alt={s.service_name} className="w-full h-20 object-cover rounded mb-2" />}
                                    <div className="flex justify-between items-start gap-2">
                                        <div className="text-sm font-medium text-gray-800">{s.service_name}</div>
                                        <div className="text-sm font-semibold text-blue-600 whitespace-nowrap">{Number(s.default_price).toLocaleString()}</div>
                                    </div>
                                    <div className="text-xs text-gray-500 mt-1">
                                        {s.service_type}{s.service_subtype ? ` · ${s.service_subtype}` : ''}
                                        {s.duration_minutes ? ` · ${s.duration_minutes}분` : ''}
                                        {s.capacity ? ` · 정원 ${s.capacity}명` : ''}
                                    </div>
                                    {s.sht_discount_rate ? <div className="text-xs text-red-600 mt-0.5">스테이하롱 할인 {s.sht_discount_rate}%</div> : null}
                                    {s.description && <div className="text-xs text-gray-600 mt-1 line-clamp-2">{s.description}</div>}
                                </div>
                            );
                        })}
                    </div>
                )}
            </SectionBox>

            {servicePrices.length > 0 && (
                <SectionBox title="② 가격 옵션">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-2">
                        {servicePrices.map(p => {
                            const active = p.price_code === selectedPrice;
                            return (
                                <div key={p.price_code}
                                    onClick={() => setSelectedPrice(active ? '' : p.price_code)}
                                    className={`p-2 rounded border cursor-pointer text-xs ${active ? 'border-blue-500 bg-blue-50' : 'border-gray-200 bg-white hover:border-blue-300'}`}>
                                    <div className="font-medium text-gray-700">{p.tier_label || p.condition_label || p.price_code}</div>
                                    <div className="text-blue-600 font-semibold">{Number(p.price).toLocaleString()}</div>
                                    {p.sht_price ? <div className="text-red-600">SHT가: {Number(p.sht_price).toLocaleString()}</div> : null}
                                    {p.duration_minutes ? <div className="text-gray-500">{p.duration_minutes}분</div> : null}
                                    {(p.valid_from || p.valid_to) && (
                                        <div className="text-gray-500 mt-1">{p.valid_from || '~'} ~ {p.valid_to || '~'}</div>
                                    )}
                                </div>
                            );
                        })}
                    </div>
                </SectionBox>
            )}

            <SectionBox title="③ 일정 / 수량">
                {mode === 'stay' ? (
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3 text-sm">
                        <label><div className="text-xs text-gray-500 mb-1">체크인</div>
                            <input type="date" value={checkin} onChange={(e) => setCheckin(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                        <label><div className="text-xs text-gray-500 mb-1">체크아웃</div>
                            <input type="date" value={checkout} onChange={(e) => setCheckout(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                        <label><div className="text-xs text-gray-500 mb-1">객실 수</div>
                            <input type="number" min={1} value={roomCount} onChange={(e) => setRoomCount(Math.max(1, Number(e.target.value) || 1))} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                        <label><div className="text-xs text-gray-500 mb-1">총 인원</div>
                            <input type="number" min={1} value={guestCount} onChange={(e) => setGuestCount(Math.max(1, Number(e.target.value) || 1))} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                        <div className="text-xs text-gray-500 col-span-full">박 수: {nights}박</div>
                    </div>
                ) : (
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3 text-sm">
                        <label><div className="text-xs text-gray-500 mb-1">{mode === 'order' ? '방문/배달 날짜' : '이용 날짜'}</div>
                            <input type="date" value={scheduledDate} onChange={(e) => setScheduledDate(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                        <label><div className="text-xs text-gray-500 mb-1">{mode === 'order' ? '시간(선택)' : '시간'}</div>
                            <input type="time" value={scheduledTime} onChange={(e) => setScheduledTime(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                        <label><div className="text-xs text-gray-500 mb-1">수량 ({unitKo[unitLabel] || unitLabel})</div>
                            <input type="number" min={currentService?.min_quantity || 1} max={currentService?.max_quantity || undefined} value={quantity}
                                onChange={(e) => setQuantity(Math.max(1, Number(e.target.value) || 1))} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                        <label><div className="text-xs text-gray-500 mb-1">총 인원</div>
                            <input type="number" min={1} value={guestCount} onChange={(e) => setGuestCount(Math.max(1, Number(e.target.value) || 1))} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" /></label>
                    </div>
                )}
            </SectionBox>

            <SectionBox title="④ 연락처 / 요청사항">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                    <input type="text" placeholder="예약자 이름" value={contactName} onChange={(e) => setContactName(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" />
                    <input type="text" placeholder="연락처" value={contactPhone} onChange={(e) => setContactPhone(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white" />
                    <input type="text" placeholder="쿠폰 코드 (선택)" value={couponCode} onChange={(e) => setCouponCode(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white md:col-span-2" />
                </div>
                <textarea placeholder="요청사항(선택)" rows={3} value={requestNote} onChange={(e) => setRequestNote(e.target.value)} className="w-full px-2 py-1 rounded border border-gray-200 bg-white text-sm mt-2" />
            </SectionBox>

            <div className="bg-yellow-50 border border-yellow-200 rounded p-4 mb-3">
                <div className="text-sm text-yellow-800 mb-1">💰 예상 총 금액</div>
                <div className="text-xl font-bold text-red-600">
                    {totalPrice.toLocaleString()}
                    <span className="text-xs text-gray-500 ml-2 font-normal">
                        ({Number(unitPrice).toLocaleString()} × {mode === 'stay' ? `${nights || 1}박 × ${roomCount}객실` : `${quantity} ${unitKo[unitLabel] || ''}`})
                    </span>
                </div>
            </div>

            {msg && <div className="text-sm text-red-500 mb-2">{msg}</div>}

            <div className="flex justify-end gap-2">
                <button onClick={() => router.back()} className="px-3 py-2 text-sm rounded border border-gray-200 bg-white text-gray-600 hover:bg-gray-50">취소</button>
                <button onClick={handleSubmit} disabled={submitting}
                    className="px-4 py-2 text-sm rounded bg-blue-500 text-white hover:bg-blue-600 disabled:opacity-50">
                    {submitting ? '저장 중...' : '예약하기'}
                </button>
            </div>
        </PartnerLayout>
    );
}
