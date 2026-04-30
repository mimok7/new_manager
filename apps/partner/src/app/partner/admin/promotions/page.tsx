'use client';

import { useEffect, useState } from 'react';
import PartnerLayout from '@/components/PartnerLayout';
import SectionBox from '@/components/SectionBox';
import Spinner from '@/components/Spinner';
import { supabase } from '@/lib/supabase';

interface Partner { partner_id: string; partner_code: string; name: string; branch_name?: string | null; category: string; }
interface Promotion {
    promo_id: string;
    partner_id: string;
    promo_code: string;
    promo_name: string;
    promo_type: 'free_item' | 'amount_discount' | 'percent_discount';
    benefit_value?: number | null;
    benefit_unit?: string | null;
    free_item_name?: string | null;
    min_people?: number | null;
    max_people?: number | null;
    requires_coupon?: boolean | null;
    coupon_label?: string | null;
    requires_cruise_booking?: boolean | null;
    min_cruise_people?: number | null;
    member_grade_min?: string | null;
    is_active: boolean;
    valid_from?: string | null;
    valid_to?: string | null;
    note?: string | null;
}

const emptyForm: Partial<Promotion> = {
    promo_code: '', promo_name: '', promo_type: 'free_item',
    benefit_value: null, benefit_unit: 'VND',
    is_active: true, requires_coupon: false, requires_cruise_booking: false,
};

export default function AdminPromotionsPage() {
    const [partners, setPartners] = useState<Partner[]>([]);
    const [promos, setPromos] = useState<Promotion[]>([]);
    const [loading, setLoading] = useState(false);
    const [partnerId, setPartnerId] = useState<string>('');
    const [showForm, setShowForm] = useState(false);
    const [editId, setEditId] = useState<string | null>(null);
    const [form, setForm] = useState<Partial<Promotion>>(emptyForm);
    const [saving, setSaving] = useState(false);
    const [msg, setMsg] = useState<string | null>(null);

    const loadPartners = async () => {
        const { data } = await supabase.from('partner').select('partner_id, partner_code, name, branch_name, category').eq('is_active', true).order('name');
        setPartners((data as Partner[]) || []);
    };
    const loadPromos = async (pid: string) => {
        if (!pid) { setPromos([]); return; }
        setLoading(true);
        const { data } = await supabase.from('partner_promotion').select('*').eq('partner_id', pid).order('promo_code');
        setPromos((data as Promotion[]) || []);
        setLoading(false);
    };

    useEffect(() => { loadPartners(); }, []);
    useEffect(() => { loadPromos(partnerId); }, [partnerId]);

    const startCreate = () => { setEditId(null); setForm({ ...emptyForm }); setShowForm(true); };
    const startEdit = (p: Promotion) => { setEditId(p.promo_id); setForm(p); setShowForm(true); };

    const save = async () => {
        setMsg(null);
        if (!partnerId) { setMsg('업체를 먼저 선택하세요.'); return; }
        if (!form.promo_code || !form.promo_name || !form.promo_type) { setMsg('코드/이름/유형은 필수입니다.'); return; }
        setSaving(true);
        try {
            const payload: any = {
                partner_id: partnerId,
                promo_code: form.promo_code,
                promo_name: form.promo_name,
                promo_type: form.promo_type,
                benefit_value: form.benefit_value != null ? Number(form.benefit_value) : null,
                benefit_unit: form.benefit_unit || null,
                free_item_name: form.free_item_name || null,
                min_people: form.min_people ?? null,
                max_people: form.max_people ?? null,
                requires_coupon: !!form.requires_coupon,
                coupon_label: form.coupon_label || null,
                requires_cruise_booking: !!form.requires_cruise_booking,
                min_cruise_people: form.min_cruise_people ?? null,
                member_grade_min: form.member_grade_min || null,
                is_active: form.is_active ?? true,
                valid_from: form.valid_from || null,
                valid_to: form.valid_to || null,
                note: form.note || null,
            };
            if (editId) {
                const { error } = await supabase.from('partner_promotion').update(payload).eq('promo_id', editId);
                if (error) throw error;
            } else {
                const { error } = await supabase.from('partner_promotion').insert(payload);
                if (error) throw error;
            }
            setForm(emptyForm); setEditId(null); setShowForm(false);
            await loadPromos(partnerId);
        } catch (err: any) {
            setMsg(err?.message || '저장 실패');
        } finally { setSaving(false); }
    };

    const toggleActive = async (p: Promotion) => {
        await supabase.from('partner_promotion').update({ is_active: !p.is_active }).eq('promo_id', p.promo_id);
        await loadPromos(partnerId);
    };
    const remove = async (p: Promotion) => {
        if (!confirm(`프로모션 "${p.promo_name}"을 삭제할까요?`)) return;
        await supabase.from('partner_promotion').delete().eq('promo_id', p.promo_id);
        await loadPromos(partnerId);
    };

    return (
        <PartnerLayout title="🎁 프로모션 / 혜택 관리" requiredRoles={['manager', 'admin']}>
            <SectionBox title="업체 선택">
                <select value={partnerId} onChange={(e) => setPartnerId(e.target.value)} className="px-2 py-1 rounded border border-gray-200 bg-white text-sm w-full md:w-auto">
                    <option value="">— 업체 선택 —</option>
                    {partners.map(p => (
                        <option key={p.partner_id} value={p.partner_id}>
                            [{p.category}] {p.name}{p.branch_name ? ` (${p.branch_name})` : ''}
                        </option>
                    ))}
                </select>
            </SectionBox>

            {partnerId && (
                <>
                    <div className="flex justify-end mb-2">
                        <button onClick={startCreate} className="text-xs px-3 py-1.5 rounded bg-blue-500 text-white hover:bg-blue-600">+ 신규 프로모션</button>
                    </div>

                    {showForm && (
                        <SectionBox title={editId ? '프로모션 수정' : '신규 프로모션'}>
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-2 text-sm">
                                <input placeholder="프로모션 코드" value={form.promo_code || ''} onChange={(e) => setForm({ ...form, promo_code: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input placeholder="프로모션 이름" value={form.promo_name || ''} onChange={(e) => setForm({ ...form, promo_name: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <select value={form.promo_type || 'free_item'} onChange={(e) => setForm({ ...form, promo_type: e.target.value as any })} className="px-2 py-1 rounded border border-gray-200 bg-white">
                                    <option value="free_item">🎉 무료 제공</option>
                                    <option value="percent_discount">💸 % 할인</option>
                                    <option value="amount_discount">💰 금액 할인</option>
                                </select>

                                {form.promo_type === 'free_item' ? (
                                    <input placeholder="무료 제공 품목" value={form.free_item_name || ''} onChange={(e) => setForm({ ...form, free_item_name: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white md:col-span-2" />
                                ) : (
                                    <>
                                        <input type="number" placeholder={form.promo_type === 'percent_discount' ? '할인율 %' : '할인 금액'} value={form.benefit_value ?? ''} onChange={(e) => setForm({ ...form, benefit_value: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                        <input placeholder="단위 (VND/KRW/%)" value={form.benefit_unit || ''} onChange={(e) => setForm({ ...form, benefit_unit: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                    </>
                                )}

                                <input type="number" placeholder="최소 인원" value={form.min_people ?? ''} onChange={(e) => setForm({ ...form, min_people: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="최대 인원" value={form.max_people ?? ''} onChange={(e) => setForm({ ...form, max_people: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input placeholder="회원 등급 최소" value={form.member_grade_min || ''} onChange={(e) => setForm({ ...form, member_grade_min: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />

                                <input type="date" value={form.valid_from || ''} onChange={(e) => setForm({ ...form, valid_from: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="date" value={form.valid_to || ''} onChange={(e) => setForm({ ...form, valid_to: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />

                                <label className="flex items-center gap-2 text-xs text-gray-600">
                                    <input type="checkbox" checked={!!form.requires_coupon} onChange={(e) => setForm({ ...form, requires_coupon: e.target.checked })} /> 쿠폰 필수
                                </label>
                                {form.requires_coupon && (
                                    <input placeholder="쿠폰 라벨" value={form.coupon_label || ''} onChange={(e) => setForm({ ...form, coupon_label: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white md:col-span-2" />
                                )}
                                <label className="flex items-center gap-2 text-xs text-gray-600">
                                    <input type="checkbox" checked={!!form.requires_cruise_booking} onChange={(e) => setForm({ ...form, requires_cruise_booking: e.target.checked })} /> 크루즈 예약 동반 필수
                                </label>
                                {form.requires_cruise_booking && (
                                    <input type="number" placeholder="최소 크루즈 인원" value={form.min_cruise_people ?? ''} onChange={(e) => setForm({ ...form, min_cruise_people: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white md:col-span-2" />
                                )}
                                <label className="flex items-center gap-2 text-xs text-gray-600">
                                    <input type="checkbox" checked={form.is_active ?? true} onChange={(e) => setForm({ ...form, is_active: e.target.checked })} /> 활성화
                                </label>
                            </div>
                            <textarea placeholder="비고/안내문" rows={2} value={form.note || ''} onChange={(e) => setForm({ ...form, note: e.target.value })} className="w-full px-2 py-1 mt-2 rounded border border-gray-200 bg-white text-sm" />
                            {msg && <div className="text-xs text-red-500 mt-2">{msg}</div>}
                            <div className="flex justify-end gap-2 mt-2">
                                <button onClick={() => { setShowForm(false); setEditId(null); }} className="text-xs px-3 py-1.5 rounded border border-gray-200 text-gray-600 hover:bg-gray-50">취소</button>
                                <button onClick={save} disabled={saving} className="text-xs px-3 py-1.5 rounded bg-blue-500 text-white hover:bg-blue-600 disabled:opacity-50">
                                    {saving ? '저장 중...' : '저장'}
                                </button>
                            </div>
                        </SectionBox>
                    )}

                    <SectionBox title={`프로모션 ${promos.length}건`}>
                        {loading ? <Spinner /> : promos.length === 0 ? (
                            <div className="text-sm text-gray-500 text-center py-8">등록된 프로모션이 없습니다.</div>
                        ) : (
                            <div className="overflow-x-auto">
                                <table className="w-full text-xs">
                                    <thead className="bg-gray-50 text-gray-600">
                                        <tr>
                                            <th className="px-2 py-2 text-left">코드</th>
                                            <th className="px-2 py-2 text-left">이름</th>
                                            <th className="px-2 py-2 text-left">유형</th>
                                            <th className="px-2 py-2 text-left">혜택</th>
                                            <th className="px-2 py-2 text-left">조건</th>
                                            <th className="px-2 py-2 text-left">기간</th>
                                            <th className="px-2 py-2 text-center">상태</th>
                                            <th className="px-2 py-2 text-center">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {promos.map(p => (
                                            <tr key={p.promo_id} className="border-t border-gray-100 hover:bg-gray-50 align-top">
                                                <td className="px-2 py-2 font-mono">{p.promo_code}</td>
                                                <td className="px-2 py-2">{p.promo_name}</td>
                                                <td className="px-2 py-2">
                                                    {p.promo_type === 'free_item' && '🎉 무료'}
                                                    {p.promo_type === 'percent_discount' && '💸 %할인'}
                                                    {p.promo_type === 'amount_discount' && '💰 금액할인'}
                                                </td>
                                                <td className="px-2 py-2">
                                                    {p.promo_type === 'free_item' && p.free_item_name}
                                                    {p.promo_type === 'percent_discount' && `${p.benefit_value}%`}
                                                    {p.promo_type === 'amount_discount' && `${Number(p.benefit_value || 0).toLocaleString()} ${p.benefit_unit}`}
                                                </td>
                                                <td className="px-2 py-2 text-xs text-gray-600">
                                                    {p.min_people || p.max_people ? <div>{p.min_people || 1}~{p.max_people || '∞'}명</div> : null}
                                                    {p.requires_coupon && <div>🎟️ {p.coupon_label || '쿠폰 필수'}</div>}
                                                    {p.requires_cruise_booking && <div>🚢 크루즈 {p.min_cruise_people || 1}명+</div>}
                                                </td>
                                                <td className="px-2 py-2 text-xs">{p.valid_from || '~'} ~ {p.valid_to || '~'}</td>
                                                <td className="px-2 py-2 text-center">
                                                    <button onClick={() => toggleActive(p)} className={`px-2 py-0.5 rounded ${p.is_active ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'}`}>
                                                        {p.is_active ? '활성' : '비활성'}
                                                    </button>
                                                </td>
                                                <td className="px-2 py-2 text-center whitespace-nowrap">
                                                    <button onClick={() => startEdit(p)} className="text-blue-600 hover:underline mr-2">수정</button>
                                                    <button onClick={() => remove(p)} className="text-red-500 hover:underline">삭제</button>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </SectionBox>
                </>
            )}
        </PartnerLayout>
    );
}
