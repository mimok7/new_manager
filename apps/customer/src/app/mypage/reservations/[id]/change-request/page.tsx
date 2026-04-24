'use client';

import { useEffect, useState, type FormEvent } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';

export default function ChangeRequestPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const id = params?.id;
  const { user, loading: authLoading } = useAuth('/login');
  const [message, setMessage] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!user || !id || submitting) return;
    setSubmitting(true);
    setError(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const { error: insErr } = await supabase.from('reservation_change_request').insert({
        reservation_id: id,
        user_id: user.id,
        message,
        status: 'pending',
      });
      if (insErr) throw insErr;
      setDone(true);
      setTimeout(() => router.replace(`/mypage/reservations/${id}` as never), 800);
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setSubmitting(false);
    }
  };

  if (authLoading) return <PageWrapper><Spinner /></PageWrapper>;

  return (
    <PageWrapper>
      <SectionBox title="✏️ 변경 요청">
        {done ? (
          <p className="text-sm text-green-600">변경 요청이 접수되었습니다.</p>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-3">
            <div>
              <label className="mb-1 block text-sm text-gray-600">요청 내용</label>
              <textarea
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                required
                minLength={5}
                rows={6}
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
                placeholder="변경하실 내용을 자세히 적어주세요."
              />
            </div>
            {error && (
              <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>
            )}
            <button
              type="submit"
              disabled={submitting}
              className="rounded bg-brand-500 px-4 py-2 text-sm text-white hover:bg-brand-600 disabled:opacity-50"
            >
              {submitting ? '제출 중…' : '요청 보내기'}
            </button>
          </form>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
