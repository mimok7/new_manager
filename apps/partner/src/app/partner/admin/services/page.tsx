'use client';

import { useEffect, useMemo, useState } from 'react';
import PartnerLayout from '@/components/PartnerLayout';
import SectionBox from '@/components/SectionBox';
import Spinner from '@/components/Spinner';
import { supabase } from '@/lib/supabase';

interface Partner { partner_id: string; partner_code: string; name: string; branch_name?: string | null; category: string; }
interface Service {
    service_id: string;
    partner_id: string;
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
    sort_order?: number | null;
    is_active: boolean;
}

const UNIT_OPTIONS = ['night', 'session', 'hour', 'meal', 'item', 'day', 'person'];
const emptyForm: Partial<Service> = {
    service_name: '', service_type: '', service_subtype: '', description: '',
    default_price: 0, unit: 'session', duration_minutes: 60, min_quantity: 1, sort_order: 0, is_active: true,
};

export default function AdminServicesPage() {
    const [partners, setPartners] = useState<Partner[]>([]);
    const [services, setServices] = useState<Service[]>([]);
    const [loading, setLoading] = useState(true);
    const [partnerId, setPartnerId] = useState<string>('');
    const [showForm, setShowForm] = useState(false);
    const [editId, setEditId] = useState<string | null>(null);
    const [form, setForm] = useState<Partial<Service>>(emptyForm);
    const [saving, setSaving] = useState(false);
    const [msg, setMsg] = useState<string | null>(null);

    const loadPartners = async () => {
        const { data } = await supabase.from('partner').select('partner_id, partner_code, name, branch_name, category').eq('is_active', true).order('name');
        setPartners((data as Partner[]) || []);
    };
    const loadServices = async (pid: string) => {
        if (!pid) { setServices([]); return; }
        setLoading(true);
        const { data } = await supabase.from('partner_service').select('*').eq('partner_id', pid).order('sort_order').order('service_name');
        setServices((data as Service[]) || []);
        setLoading(false);
    };

    useEffect(() => { loadPartners(); }, []);
    useEffect(() => { loadServices(partnerId); }, [partnerId]);

    const startEdit = (s: Service) => { setEditId(s.service_id); setForm(s); setShowForm(true); };
    const startCreate = () => { setEditId(null); setForm({ ...emptyForm, partner_id: partnerId }); setShowForm(true); };

    const save = async () => {
        setMsg(null);
        if (!partnerId) { setMsg('업체를 먼저 선택하세요.'); return; }
        if (!form.service_name || !form.service_type) { setMsg('서비스명과 타입은 필수입니다.'); return; }
        setSaving(true);
        try {
            const payload: any = {
                partner_id: partnerId,
                service_name: form.service_name,
                service_type: form.service_type,
                service_subtype: form.service_subtype || null,
                description: form.description || null,
                capacity: form.capacity ?? null,
                default_price: Number(form.default_price) || 0,
                unit: form.unit || null,
                duration_minutes: form.duration_minutes ?? null,
                min_quantity: form.min_quantity ?? null,
                max_quantity: form.max_quantity ?? null,
                sht_discount_rate: form.sht_discount_rate ?? null,
                sort_order: form.sort_order ?? 0,
                is_active: form.is_active ?? true,
            };
            if (editId) {
                const { error } = await supabase.from('partner_service').update(payload).eq('service_id', editId);
                if (error) throw error;
            } else {
                const { error } = await supabase.from('partner_service').insert(payload);
                if (error) throw error;
            }
            setForm(emptyForm); setEditId(null); setShowForm(false);
            await loadServices(partnerId);
        } catch (err: any) {
            setMsg(err?.message || '저장 실패');
        } finally { setSaving(false); }
    };

    const toggleActive = async (s: Service) => {
        await supabase.from('partner_service').update({ is_active: !s.is_active }).eq('service_id', s.service_id);
        await loadServices(partnerId);
    };
    const remove = async (s: Service) => {
        if (!confirm(`"${s.service_name}" 서비스를 삭제할까요? (가격도 함께 삭제됩니다)`)) return;
        await supabase.from('partner_price').delete().eq('service_id', s.service_id);
        await supabase.from('partner_service').delete().eq('service_id', s.service_id);
        await loadServices(partnerId);
    };

    return (
        <PartnerLayout title="🍴 서비스 / 메뉴 관리" requiredRoles={['manager', 'admin']}>
            <SectionBox title="업체 선택">
                <select value={partnerId} onChange={(e) => setPartnerId(e.target.value)}
                    className="px-2 py-1 rounded border border-gray-200 bg-white text-sm w-full md:w-auto">
                    <option value="">— 업체를 선택하세요 —</option>
                    {partners.map(p => (
                        <option key={p.partner_id} value={p.partner_id}>
                            [{p.category}] {p.name}{p.branch_name ? ` (${p.branch_name})` : ''} · {p.partner_code}
                        </option>
                    ))}
                </select>
            </SectionBox>

            {partnerId && (
                <>
                    <div className="flex justify-end mb-2">
                        <button onClick={startCreate} className="text-xs px-3 py-1.5 rounded bg-blue-500 text-white hover:bg-blue-600">+ 신규 서비스/메뉴</button>
                    </div>

                    {showForm && (
                        <SectionBox title={editId ? '서비스 수정' : '신규 서비스/메뉴'}>
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-2 text-sm">
                                <input placeholder="서비스명/메뉴명" value={form.service_name || ''} onChange={(e) => setForm({ ...form, service_name: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input placeholder="타입 (예: room/spa/menu/costume)" value={form.service_type || ''} onChange={(e) => setForm({ ...form, service_type: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input placeholder="서브타입 (예: deluxe/aroma)" value={form.service_subtype || ''} onChange={(e) => setForm({ ...form, service_subtype: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="기본가" value={form.default_price ?? 0} onChange={(e) => setForm({ ...form, default_price: Number(e.target.value) })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <select value={form.unit || ''} onChange={(e) => setForm({ ...form, unit: e.target.value })} className="px-2 py-1 rounded border border-gray-200 bg-white">
                                    {UNIT_OPTIONS.map(u => <option key={u} value={u}>{u}</option>)}
                                </select>
                                <input type="number" placeholder="소요(분)" value={form.duration_minutes ?? ''} onChange={(e) => setForm({ ...form, duration_minutes: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="정원" value={form.capacity ?? ''} onChange={(e) => setForm({ ...form, capacity: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="최소수량" value={form.min_quantity ?? ''} onChange={(e) => setForm({ ...form, min_quantity: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="최대수량" value={form.max_quantity ?? ''} onChange={(e) => setForm({ ...form, max_quantity: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="SHT 할인율(%)" value={form.sht_discount_rate ?? ''} onChange={(e) => setForm({ ...form, sht_discount_rate: e.target.value ? Number(e.target.value) : null })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <input type="number" placeholder="정렬 순서" value={form.sort_order ?? 0} onChange={(e) => setForm({ ...form, sort_order: Number(e.target.value) })} className="px-2 py-1 rounded border border-gray-200 bg-white" />
                                <label className="flex items-center gap-2 text-xs text-gray-600">
                                    <input type="checkbox" checked={form.is_active ?? true} onChange={(e) => setForm({ ...form, is_active: e.target.checked })} /> 활성화
                                </label>
                            </div>
                            <textarea placeholder="설명(선택)" rows={2} value={form.description || ''} onChange={(e) => setForm({ ...form, description: e.target.value })} className="w-full px-2 py-1 mt-2 rounded border border-gray-200 bg-white text-sm" />
                            {msg && <div className="text-xs text-red-500 mt-2">{msg}</div>}
                            <div className="flex justify-end gap-2 mt-2">
                                <button onClick={() => { setShowForm(false); setEditId(null); }} className="text-xs px-3 py-1.5 rounded border border-gray-200 text-gray-600 hover:bg-gray-50">취소</button>
                                <button onClick={save} disabled={saving} className="text-xs px-3 py-1.5 rounded bg-blue-500 text-white hover:bg-blue-600 disabled:opacity-50">
                                    {saving ? '저장 중...' : '저장'}
                                </button>
                            </div>
                        </SectionBox>
                    )}

                    <SectionBox title={`서비스/메뉴 ${services.length}개`}>
                        {loading ? <Spinner label="불러오는 중..." /> : services.length === 0 ? (
                            <div className="text-sm text-gray-500 text-center py-8">등록된 서비스가 없습니다.</div>
                        ) : (
                            <div className="overflow-x-auto">
                                <table className="w-full text-xs">
                                    <thead className="bg-gray-50 text-gray-600">
                                        <tr>
                                            <th className="px-2 py-2 text-left">정렬</th>
                                            <th className="px-2 py-2 text-left">이름</th>
                                            <th className="px-2 py-2 text-left">타입</th>
                                            <th className="px-2 py-2 text-right">기본가</th>
                                            <th className="px-2 py-2 text-left">단위</th>
                                            <th className="px-2 py-2 text-right">소요</th>
                                            <th className="px-2 py-2 text-right">정원</th>
                                            <th className="px-2 py-2 text-right">SHT%</th>
                                            <th className="px-2 py-2 text-center">상태</th>
                                            <th className="px-2 py-2 text-center">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {services.map(s => (
                                            <tr key={s.service_id} className="border-t border-gray-100 hover:bg-gray-50">
                                                <td className="px-2 py-2">{s.sort_order ?? 0}</td>
                                                <td className="px-2 py-2 font-medium">{s.service_name}</td>
                                                <td className="px-2 py-2">{s.service_type}{s.service_subtype ? `/${s.service_subtype}` : ''}</td>
                                                <td className="px-2 py-2 text-right">{Number(s.default_price).toLocaleString()}</td>
                                                <td className="px-2 py-2">{s.unit || '-'}</td>
                                                <td className="px-2 py-2 text-right">{s.duration_minutes ? `${s.duration_minutes}분` : '-'}</td>
                                                <td className="px-2 py-2 text-right">{s.capacity || '-'}</td>
                                                <td className="px-2 py-2 text-right">{s.sht_discount_rate ?? '-'}</td>
                                                <td className="px-2 py-2 text-center">
                                                    <button onClick={() => toggleActive(s)} className={`px-2 py-0.5 rounded ${s.is_active ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'}`}>
                                                        {s.is_active ? '활성' : '비활성'}
                                                    </button>
                                                </td>
                                                <td className="px-2 py-2 text-center whitespace-nowrap">
                                                    <button onClick={() => startEdit(s)} className="text-blue-600 hover:underline mr-2">수정</button>
                                                    <button onClick={() => remove(s)} className="text-red-500 hover:underline">삭제</button>
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
