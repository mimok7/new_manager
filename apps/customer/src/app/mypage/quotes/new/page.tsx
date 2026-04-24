'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { PageWrapper, SectionBox } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { quote as quoteDomain } from '@sht/domain';

export default function NewQuotePage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth('/login');
  const [title, setTitle] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;
    setSaving(true);
    setError(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const q = await quoteDomain.createOrReuseDraft(supabase, user.id, title.trim() || '새 견적');
      router.push(`/mypage/quotes/${q.id}`);
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <PageWrapper>
      <SectionBox title="📝 새 견적 만들기">
        {authLoading ? (
          <p className="text-sm text-gray-500">로그인 확인 중…</p>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-3">
            <div>
              <label className="mb-1 block text-xs text-gray-500">행복여행 이름</label>
              <input
                type="text"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="예: 가족 하롱베이 여행"
                className="w-full rounded border border-gray-200 px-3 py-2 text-sm"
              />
            </div>
            {error && (
              <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>
            )}
            <button
              type="submit"
              disabled={saving}
              className="rounded bg-brand-500 px-4 py-2 text-sm text-white hover:bg-brand-600 disabled:opacity-50"
            >
              {saving ? '생성 중…' : '견적 만들기'}
            </button>
          </form>
        )}
      </SectionBox>
    </PageWrapper>
  );
}
