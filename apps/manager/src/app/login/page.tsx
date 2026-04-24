'use client';

import { useState, type FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { writeSessionCache } from '@sht/auth';
import { PageWrapper, SectionBox } from '@sht/ui';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (loading) return;
    setLoading(true);
    setError(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const { data, error: signError } = await supabase.auth.signInWithPassword({ email, password });
      if (signError) {
        setError('로그인 실패: ' + signError.message);
        return;
      }
      if (!data.user) {
        setError('로그인에 실패했습니다.');
        return;
      }
      // 매니저/관리자 권한 검증
      const { data: row, error: roleError } = await supabase
        .from('users')
        .select('role')
        .eq('id', data.user.id)
        .maybeSingle();
      if (roleError) {
        setError('권한 조회 실패: ' + roleError.message);
        return;
      }
      const role = (row as { role?: string } | null)?.role;
      if (!role || !['manager', 'admin'].includes(role)) {
        await supabase.auth.signOut();
        setError('매니저/관리자 권한이 없는 계정입니다.');
        return;
      }
      writeSessionCache(data.user);
      router.replace((role === 'admin' ? '/admin' : '/manager') as never);
    } catch (err) {
      setError('로그인 처리 중 오류가 발생했습니다.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <PageWrapper>
      <div className="mx-auto max-w-md">
        <SectionBox title="🔐 매니저 / 관리자 로그인">
          <form onSubmit={handleSubmit} className="space-y-3">
            <div>
              <label className="mb-1 block text-sm text-gray-600">이메일</label>
              <input type="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} className="w-full rounded border border-gray-200 px-3 py-2 text-sm" />
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">비밀번호</label>
              <input type="password" autoComplete="current-password" required minLength={6} value={password} onChange={(e) => setPassword(e.target.value)} className="w-full rounded border border-gray-200 px-3 py-2 text-sm" />
            </div>
            {error && <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>}
            <button type="submit" disabled={loading} className="w-full rounded bg-brand-500 py-2 text-sm font-medium text-white hover:bg-brand-600 disabled:opacity-50">
              {loading ? '처리 중…' : '로그인'}
            </button>
          </form>
        </SectionBox>
      </div>
    </PageWrapper>
  );
}
