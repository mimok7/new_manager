'use client';

import { useEffect, useMemo, useState } from 'react';
import PartnerLayout from '@/components/PartnerLayout';
import SectionBox from '@/components/SectionBox';
import Spinner from '@/components/Spinner';
import { supabase } from '@/lib/supabase';
import { useAuth } from '@/hooks/useAuth';

interface Row {
    pr_id: string;
    pr_user_id: string;
    pr_partner_id: string;
    checkin_date: string | null;
    checkout_date: string | null;
    scheduled_at: string | null;
    nights: number | null;
    guest_count: number;
    room_count: number | null;
    quantity: number | null;
    duration_minutes: number | null;
    service_label?: string | null;
    price_label?: string | null;
    total_price: number;
    status: string;
    payment_status?: string | null;
    confirmation_code?: string | null;
    contact_name?: string | null;
    contact_phone?: string | null;
    request_note?: string | null;
    created_at: string;
    service?: { service_name: string } | null;
}

const STATUS_LABEL: Record<string, string> = {
    pending: '대기', confirmed: '확정', cancelled: '취소', completed: '완료',
};
const STATUS_COLOR: Record<string, string> = {
    pending: 'bg-yellow-50 text-yellow-700',
    confirmed: 'bg-green-50 text-green-700',
    cancelled: 'bg-gray-50 text-gray-500',
    completed: 'bg-blue-50 text-blue-700',
};

export default function PartnerDashboardPage() {
    const { profile, loading: authLoading } = useAuth(['partner', 'manager', 'admin'], '/partner/login');
    const [rows, setRows] = useState<Row[]>([]);
    const [loading, setLoading] = useState(true);
    const [statusFilter, setStatusFilter] = useState<string>('');
    const [period, setPeriod] = useState<'all' | 'week' | 'month'>('month');

    useEffect(() => {
        if (authLoading) return;
        if (!profile?.partner_id && profile?.role === 'partner') { setLoading(false); return; }
        let cancelled = false;
        (async () => {
            try {
                let q = supabase
                    .from('partner_reservation')
                    .select(`
                        pr_id, pr_user_id, pr_partner_id, checkin_date, checkout_date, scheduled_at,
                        nights, guest_count, room_count, quantity, duration_minutes,
                        service_label, price_label, total_price, status, payment_status, confirmation_code,
                        contact_name, contact_phone, request_note, created_at,
                        service:pr_service_id(service_name)
                    `)
                    .order('created_at', { ascending: false });
                // partner role: RLS가 자기 업체로 자동 필터. 명시적 필터도 추가
                if (profile?.role === 'partner' && profile?.partner_id) {
                    q = q.eq('pr_partner_id', profile.partner_id);
                }
                const { data } = await q;
                if (cancelled) return;
                setRows((data as any) || []);
            } finally {
                if (!cancelled) setLoading(false);
            }
        })();
        return () => { cancelled = true; };
    }, [authLoading, profile?.partner_id, profile?.role]);

    const updateStatus = async (pr_id: string, next: string) => {
        if (!confirm(`상태를 "${STATUS_LABEL[next] || next}"로 변경할까요?`)) return;
        const patch: any = { status: next };
        if (next === 'confirmed' && !rows.find(r => r.pr_id === pr_id)?.confirmation_code) {
            patch.confirmation_code = `C${Date.now().toString().slice(-8)}`;
        }
        const { error } = await supabase.from('partner_reservation').update(patch).eq('pr_id', pr_id);
        if (error) { alert('변경 실패: ' + error.message); return; }
        setRows(prev => prev.map(r => r.pr_id === pr_id ? { ...r, status: next, ...(patch.confirmation_code ? { confirmation_code: patch.confirmation_code } : {}) } : r));
    };

    const filtered = useMemo(() => {
        let r = rows;
        if (statusFilter) r = r.filter(x => x.status === statusFilter);
        if (period !== 'all') {
            const now = new Date();
            const limit = new Date();
            if (period === 'week') limit.setDate(now.getDate() + 7);
            else if (period === 'month') limit.setMonth(now.getMonth() + 1);
            r = r.filter(x => {
                const dateStr = x.checkin_date || (x.scheduled_at ? x.scheduled_at.slice(0, 10) : null);
                if (!dateStr) return true;
                const d = new Date(dateStr);
                return d >= new Date(now.toISOString().slice(0, 10)) && d <= limit;
            });
        }
        return r;
    }, [rows, statusFilter, period]);

    if (authLoading) return <PartnerLayout><Spinner /></PartnerLayout>;

    return (
        <PartnerLayout title="📊 우리 업체 예약" requiredRoles={['partner', 'manager', 'admin']}>
            <SectionBox title="필터">
                <div className="flex gap-2 flex-wrap text-xs">
                    {(['all', 'week', 'month'] as const).map(p => (
                        <button key={p} onClick={() => setPeriod(p)}
                            className={`px-3 py-1 rounded border ${period === p ? 'bg-blue-50 border-blue-300 text-blue-600' : 'bg-white border-gray-200 text-gray-600'}`}>
                            {p === 'all' ? '전체' : p === 'week' ? '향후 7일' : '향후 30일'}
                        </button>
                    ))}
                    <span className="border-l border-gray-200 mx-2" />
                    {['', 'pending', 'confirmed', 'completed', 'cancelled'].map(s => (
                        <button key={s} onClick={() => setStatusFilter(s)}
                            className={`px-3 py-1 rounded border ${statusFilter === s ? 'bg-blue-50 border-blue-300 text-blue-600' : 'bg-white border-gray-200 text-gray-600'}`}>
                            {s === '' ? '상태 전체' : STATUS_LABEL[s]}
                        </button>
                    ))}
                </div>
            </SectionBox>

            <SectionBox title={`예약 ${filtered.length}건`}>
                {loading ? <Spinner label="불러오는 중..." /> : filtered.length === 0 ? (
                    <div className="text-sm text-gray-500 text-center py-8">조건에 맞는 예약이 없습니다.</div>
                ) : (
                    <div className="overflow-x-auto">
                        <table className="w-full text-xs">
                            <thead className="bg-gray-50 text-gray-600">
                                <tr>
                                    <th className="px-2 py-2 text-left">일시</th>
                                    <th className="px-2 py-2 text-left">서비스</th>
                                    <th className="px-2 py-2 text-right">수량/명</th>
                                    <th className="px-2 py-2 text-left">예약자</th>
                                    <th className="px-2 py-2 text-left">연락처</th>
                                    <th className="px-2 py-2 text-left">요청사항</th>
                                    <th className="px-2 py-2 text-right">금액</th>
                                    <th className="px-2 py-2 text-center">상태</th>
                                    <th className="px-2 py-2 text-center">액션</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filtered.map(r => (
                                    <tr key={r.pr_id} className="border-t border-gray-100 hover:bg-gray-50 align-top">
                                        <td className="px-2 py-2 whitespace-nowrap">
                                            {r.checkin_date ? (
                                                <>{r.checkin_date}<br /><span className="text-gray-400">~ {r.checkout_date}</span></>
                                            ) : r.scheduled_at ? (
                                                <>{r.scheduled_at.slice(0, 10)}<br /><span className="text-gray-500">{r.scheduled_at.slice(11, 16)}{r.duration_minutes ? ` (${r.duration_minutes}분)` : ''}</span></>
                                            ) : '-'}
                                        </td>
                                        <td className="px-2 py-2">
                                            <div>{r.service_label || r.service?.service_name || '-'}</div>
                                            {r.price_label && <div className="text-xs text-gray-500">{r.price_label}</div>}
                                            {r.confirmation_code && <div className="text-xs text-blue-600 font-mono">#{r.confirmation_code}</div>}
                                        </td>
                                        <td className="px-2 py-2 text-right whitespace-nowrap">
                                            {r.nights ? `${r.nights}박/${r.room_count}실/${r.guest_count}명` : `${r.quantity || 1}/${r.guest_count}명`}
                                        </td>
                                        <td className="px-2 py-2">{r.contact_name || '-'}</td>
                                        <td className="px-2 py-2">{r.contact_phone || '-'}</td>
                                        <td className="px-2 py-2 max-w-[200px] truncate" title={r.request_note || ''}>{r.request_note || '-'}</td>
                                        <td className="px-2 py-2 text-right text-red-600 font-semibold whitespace-nowrap">
                                            {Number(r.total_price).toLocaleString()}
                                            {r.payment_status && <div className="text-xs text-gray-500">{r.payment_status}</div>}
                                        </td>
                                        <td className="px-2 py-2 text-center">
                                            <span className={`px-2 py-0.5 rounded ${STATUS_COLOR[r.status] || 'bg-gray-50 text-gray-600'}`}>
                                                {STATUS_LABEL[r.status] || r.status}
                                            </span>
                                        </td>
                                        <td className="px-2 py-2 text-center whitespace-nowrap">
                                            <div className="flex gap-1 justify-center">
                                                {r.status === 'pending' && (
                                                    <>
                                                        <button onClick={() => updateStatus(r.pr_id, 'confirmed')} className="px-2 py-0.5 text-xs rounded bg-green-500 text-white hover:bg-green-600">승인</button>
                                                        <button onClick={() => updateStatus(r.pr_id, 'cancelled')} className="px-2 py-0.5 text-xs rounded bg-gray-200 text-gray-700 hover:bg-gray-300">취소</button>
                                                    </>
                                                )}
                                                {r.status === 'confirmed' && (
                                                    <>
                                                        <button onClick={() => updateStatus(r.pr_id, 'completed')} className="px-2 py-0.5 text-xs rounded bg-blue-500 text-white hover:bg-blue-600">완료</button>
                                                        <button onClick={() => updateStatus(r.pr_id, 'cancelled')} className="px-2 py-0.5 text-xs rounded bg-gray-200 text-gray-700 hover:bg-gray-300">취소</button>
                                                    </>
                                                )}
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                )}
            </SectionBox>
        </PartnerLayout>
    );
}
