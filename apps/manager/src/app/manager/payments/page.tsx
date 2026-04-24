'use client';

import { useEffect, useState } from 'react';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface PaymentRow {
  id: string;
  reservation_id: string | null;
  amount: number | null;
  status: string | null;
  method?: string | null;
  created_at: string;
}

export default function ManagerPaymentsPage() {
  const [items, setItems] = useState<PaymentRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState({ reservation_id: '', amount: 0, method: 'cash', status: 'paid' });
  const [saving, setSaving] = useState(false);
  const [msg, setMsg] = useState<string | null>(null);

  const refresh = async () => {
    const supabase = createSupabaseBrowserClient();
    const { data } = await supabase
      .from('payment')
      .select('id, reservation_id, amount, status, method, created_at')
      .order('created_at', { ascending: false })
      .limit(200);
    setItems((data || []) as PaymentRow[]);
  };

  useEffect(() => {
    let cancelled = false;
    const run = async () => {
      try {
        await refresh();
      } catch {
        if (!cancelled) setItems([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, []);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setMsg(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const { error } = await supabase
        .from('payment')
        .insert({
          reservation_id: form.reservation_id || null,
          amount: form.amount,
          method: form.method,
          status: form.status,
        } as never);
      if (error) throw error;
      setMsg('등록 완료');
      setForm({ reservation_id: '', amount: 0, method: 'cash', status: 'paid' });
      await refresh();
    } catch (e) {
      setMsg('실패: ' + (e as Error).message);
    } finally {
      setSaving(false);
    }
  };

  const total = items.reduce((s, p) => s + (p.amount || 0), 0);

  return (
    <PageWrapper>
      <SectionBox title="➕ 결제 등록">
        <form onSubmit={submit} className="grid gap-2 md:grid-cols-5">
          <input
            type="text"
            value={form.reservation_id}
            onChange={(e) => setForm({ ...form, reservation_id: e.target.value })}
            placeholder="예약 ID"
            className="rounded border border-gray-200 px-2 py-1 text-sm"
          />
          <input
            type="number"
            value={form.amount}
            onChange={(e) => setForm({ ...form, amount: Number(e.target.value) || 0 })}
            placeholder="금액"
            className="rounded border border-gray-200 px-2 py-1 text-sm"
          />
          <select
            value={form.method}
            onChange={(e) => setForm({ ...form, method: e.target.value })}
            className="rounded border border-gray-200 px-2 py-1 text-sm"
          >
            <option value="cash">현금</option>
            <option value="card">카드</option>
            <option value="transfer">계좌이체</option>
            <option value="onepay">OnePay</option>
          </select>
          <select
            value={form.status}
            onChange={(e) => setForm({ ...form, status: e.target.value })}
            className="rounded border border-gray-200 px-2 py-1 text-sm"
          >
            <option value="paid">결제완료</option>
            <option value="pending">대기</option>
            <option value="refunded">환불</option>
          </select>
          <button
            type="submit"
            disabled={saving}
            className="rounded bg-brand-500 px-3 py-1 text-sm text-white hover:bg-brand-600 disabled:opacity-50"
          >
            {saving ? '저장…' : '등록'}
          </button>
        </form>
        {msg && <p className="mt-2 text-xs text-gray-600">{msg}</p>}
      </SectionBox>

      <SectionBox
        title="💳 결제 관리"
        right={<span className="text-sm text-gray-600">합계 {total.toLocaleString()}동</span>}
      >
        {loading ? (
          <Spinner />
        ) : items.length === 0 ? (
          <p className="text-sm text-gray-500">결제 없음</p>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-100 text-left text-xs text-gray-500">
                <th className="py-2">예약</th>
                <th className="py-2">금액</th>
                <th className="py-2">방법</th>
                <th className="py-2">상태</th>
                <th className="py-2">생성</th>
              </tr>
            </thead>
            <tbody>
              {items.map((p) => (
                <tr key={p.id} className="border-b border-gray-50">
                  <td className="py-2 font-mono text-xs">{p.reservation_id?.slice(0, 8) || '-'}…</td>
                  <td className="py-2 text-gray-700">{p.amount?.toLocaleString() || 0}동</td>
                  <td className="py-2 text-gray-500">{p.method || '-'}</td>
                  <td className="py-2 text-gray-500">{p.status || '-'}</td>
                  <td className="py-2 text-xs text-gray-500">
                    {new Date(p.created_at).toLocaleString('ko-KR')}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
