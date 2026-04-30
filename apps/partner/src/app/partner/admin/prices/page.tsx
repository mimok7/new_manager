'use client';

import { useEffect, useMemo, useState } from 'react';
import PartnerLayout from '@/components/PartnerLayout';
import SectionBox from '@/components/SectionBox';
import Spinner from '@/components/Spinner';
import { supabase } from '@/lib/supabase';

interface Partner { partner_id: string; partner_code: string; name: string; branch_name?: string | null; category: string; }
interface Service { service_id: string; service_name: string; default_price: number; unit?: string | null; duration_minutes?: number | null; }
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
    is_active: boolean;
}

const emptyForm: Partial<Price> = { price_code: '', price: 0, sht_price: null, duration_minutes: null, tier_label: '', condition_label: '', is_active: true };

export default function AdminPricesPage() {
    const [partners, setPartners] = useState<Partner[]>([]);
    const [services, setServices] = useState<Service[]>([]);
    const [prices, setPrices] = useState<Price[]>([]);
    const [loading, setLoading] = useState(false);
    const [partnerId, setPartnerId] = useState<string>('');
    const [serviceId, setServiceId] = useState<string>('');
    const [showForm, setShowForm] = useState(false);
    const [editCode, setEditCode] = useState<string | null>(null);
    const [form, setForm] = useState<Partial<Price>>(emptyForm);
    const [saving, setSaving] = useState(false);
    const [msg, setMsg] = useState<string | null>(null);

    const loadPartners = async () => {
        const { data } = await supabase.from('partner').select('partner_id, partner_code, name, branch_name, category').eq('is_active', true).order('name');
        setPartners((data as Partner[]) || []);
    };
    const loadServices = async (pid: string) => {
        if (!pid) { setServices([]); return; }
        const { data } = await supabase.from('partner_service').select('service_id, service_name, default_price, unit, duration_minutes').eq('partner_id', pid).order('service_name');
        setServices((data as Service[]) || []);
    };
    const loadPrices = async (sid: string) => {
        if (!sid) { setPrices([]); return; }
        setLoading(true);
        const { data } = await supabase.from('partner_price').select('*').eq('service_id', sid).order('price');
        setPrices((data as Price[]) || []);
        setLoading(false);
    };

    useEffect(() => { loadPartners(); }, []);
    useEffect(() => { setServiceId(''); setPrices([]); loadServices(partnerId); }, [partnerId]);
    useEffect(() => { loadPrices(serviceId); }, [serviceId]);

    const currentService = useMemo(() => services.find(s => s.service_id === serviceId), [services, serviceId]);

    const startCreate = () => {
        setEditCode(null);
        setForm({
            ...emptyForm,
            price_code: `${currentService?.service_name?.slice(0, 6).toUpperCase().replace(/\s/g, '') || 'PRC'}-${Date.now().toString().slice(-5)}`,
            price: currentService?.default_price || 0,
            duration_minutes: currentService?.duration_minutes || null,
        });
        setShowForm(true);
    };
    const startEdit = (p: Price) => { setEditCode(p.price_code); setForm(p); setShowForm(true); };

    const save = async () => {
        setMsg(null);
        if (!serviceId) { setMsg('서비스를 먼저 선택하세요.'); return; }
        if (!form.price_code) { setMsg('가격 코드는 필수입니다.'); return; }
        setSaving(true);
        try {
            const payload: any = {
                price_code: form.price_code,
                service_id: serviceId,
                valid_from: form.valid_from || null,
                valid_to: form.valid_to || null,
                price: Number(form.price) || 0,
                sht_price: form.sht_price != null ? Number(form.sht_price) : null,
                duration_minutes: form.duration_minutes ?? null,
                tier_label: form.tier_label || null,
                condition_label: form.condition_label || null,
                is_active: form.is_active ?? true,
            };
            if (editCode) {
                const { error } = await supabase.from('partner_price').update(payload).eq('price_code', editCode);
                if (error) throw error;
            } else {
                const { error } = await supabase.from('partner_price').insert(payload);
                if (error) throw error;
            }
            setForm(emptyForm); setEditCode(null); setShowForm(false);
            await loadPrices(serviceId);
        } catch (err: any) {
            setMsg(err?.message || '저장 실패');
        } finally { setSaving(false); }
    };

    const remove = async (p: Price) => {
        if (!confirm(`가격 "${p.tier_label || p.price_code}"를 삭제할까요?`)) return;
        await supabase.from('partner_price').delete().eq('price_code', p.price_code);
        await loadPrices(serviceId);
    };

    return (
        <PartnerLayout title="💰 가격 관리" requiredRoles={['manager', 'admin']}>
            <SectionBox title="업체 / 서비스 선택">
                <div className="flex flex-col md:flex-row gap-2">
                    <select value={partnerId} onChange={(e) => setPartnerId(e.target.value)} className="px-2 py-1 rounded border border-gray-200 bg-white text-sm">
                        <option value="">— 업체 선택 —</option>
                        {partners.map(p => (
                            <option key={p.partner_id} value={p.partner_id}>
                                [{p.category}] {p.name}{p.branch_name ? ` (${p.branch_name})` : ''}
                            </option>
                        ))}
                    </select>
                    <select value={serviceId} onChange={(e) => setServiceId(e.target.value)} disabled={!partnerId} className="px-2 py-1 rounded border border-gray-200 bg-white text-sm">
                        <option value="">— 서비스 선택 —</option>
                        {services.map(s => (
                            <option key={s.service_id} value={s.service_id}>
                                {s.service_name} (기본 {Number(s.default_price).toLocaleString()})
                            </option>
                        ))}
                    </select>
                </div>
            </SectionBox>

            {serviceId && (
                <>
                    <div className="flex justify-end mb-2">
                        <button onClick={startCreate} className="text-xs px-3 py-1.5 rounded bg-blue-500 text-white hover:bg-blue-600">+ 가격 추가</button>
                    </div>

                    {showForm && (
                        <SectionBox title={editCode ? '가격 수정' : '신규 가격'}>
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-2 text-sm">
                                <input placeholder="가격 코드 (UNIQUE)" value={form.price_code || ''} onChange={(e) => setForm({ ...form, price_code: e.target.value })} disabled={!!editCode}
                                    className="px-2 py-1 rounded border border-gray-200 bg-white disabled:bg-gray-100" />
                                <input placeholder="티어명 (예: 60분권/2인)" value={form.tier_label || ''} onChange={(e) => setForm({ ...form, tier_label: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input placeholder="조건 라벨" value={form.condition_label || ''} onChange={(e) => setForm({ ...form, condition_label: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="가격" value={form.price ?? 0} onChange={(e) => setForm({ ...form, price: Number(e.target.value) })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="SHT 특가 (선택)" value={form.sht_price ?? ''} onChange={(e) => setForm({ ...form, sht_price: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="소요시간(분)" value={form.duration_minutes ?? ''} onChange={(e) => setForm({ ...form, duration_minutes: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="date" placeholder="시작일" value={form.valid_from || ''} onChange={(e) => setForm({ ...form, valid_from: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="date" placeholder="종료일" value={form.valid_to || ''} onChange={(e) => setForm({ ...form, valid_to: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <label className="flex items-center gap-2 text-xs text-gray-600">
                                    <input type="checkbox" checked={form.is_active ?? true} onChange={(e) => setForm({ ...form, is_active: e.target.checked })} /> 활성화
                                </label>
                            </div>
                            {msg && <div className="text-xs text-red-500 mt-2">{msg}</div>}
                            <div className="flex justify-end gap-2 mt-2">
                                <button onClick={() => { setShowForm(false); setEditCode(null); }} className="text-xs px-3 py-1.5 rounded border border-gray-200 text-gray-600 hover:bg-gray-50">취소</button>
                                <button onClick={save} disabled={saving} className="text-xs px-3 py-1.5 rounded bg-blue-500 text-white hover:bg-blue-600 disabled:opacity-50">
                                    {saving ? '저장 중...' : '저장'}
                                </button>
                            </div>
                        </SectionBox>
                    )}

                    <SectionBox title={`가격 ${prices.length}건`}>
                        {loading ? <Spinner /> : prices.length === 0 ? (
                            <div className="text-sm text-gray-500 text-center py-8">등록된 가격이 없습니다.</div>
                        ) : (
                            <div className="overflow-x-auto">
                                <table className="w-full text-xs">
                                    <thead className="bg-gray-50 text-gray-600">
                                        <tr>
                                            <th className="px-2 py-2 text-left">코드</th>
                                            <th className="px-2 py-2 text-left">티어</th>
                                            <th className="px-2 py-2 text-right">가격</th>
                                            <th className="px-2 py-2 text-right">SHT가</th>
                                            <th className="px-2 py-2 text-right">소요</th>
                                            <th className="px-2 py-2 text-left">유효기간</th>
                                            <th className="px-2 py-2 text-center">상태</th>
                                            <th className="px-2 py-2 text-center">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {prices.map(p => (
                                            <tr key={p.price_code} className="border-t border-gray-100 hover:bg-gray-50">
                                                <td className="px-2 py-2 font-mono">{p.price_code}</td>
                                                <td className="px-2 py-2">{p.tier_label || p.condition_label || '-'}</td>
                                                <td className="px-2 py-2 text-right">{Number(p.price).toLocaleString()}</td>
                                                <td className="px-2 py-2 text-right text-red-600">{p.sht_price ? Number(p.sht_price).toLocaleString() : '-'}</td>
                                                <td className="px-2 py-2 text-right">{p.duration_minutes ? `${p.duration_minutes}분` : '-'}</td>
                                                <td className="px-2 py-2">{p.valid_from || '~'} ~ {p.valid_to || '~'}</td>
                                                <td className="px-2 py-2 text-center">
                                                    <span className={`px-2 py-0.5 rounded ${p.is_active ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'}`}>
                                                        {p.is_active ? '활성' : '비활성'}
                                                    </span>
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
