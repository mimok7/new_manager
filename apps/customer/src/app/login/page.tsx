'use client';

import { useState, type FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
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
        const msg = signError.message || '';
        if (msg.includes('Invalid login credentials')) setError('이메일 또는 비밀번호가 올바르지 않습니다.');
        else if (msg.includes('Email not confirmed')) setError('이메일 인증이 완료되지 않았습니다.');
        else setError('로그인 실패: ' + msg);
        return;
      }
      if (!data.user) {
        setError('로그인에 실패했습니다.');
        return;
      }
      writeSessionCache(data.user);
      router.replace('/mypage' as never);
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
        <SectionBox title="🔐 로그인 / 예약 확인">
          <form onSubmit={handleSubmit} className="space-y-3">
            <div>
              <label className="mb-1 block text-sm text-gray-600">이메일</label>
              <input type="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} className="w-full rounded border border-gray-200 px-3 py-2 text-sm" />
            </div>
            <div>
              <label className="mb-1 block text-sm text-gray-600">비밀번호</label>
              <input type="password" autoComplete="current-password" required minLength={6} value={password} onChange={(e) => setPassword(e.target.value)} className="w-full rounded border border-gray-200 px-3 py-2 text-sm" />
              <p className="mt-1 text-xs text-gray-500">6자 이상 입력해주세요.</p>
            </div>
            {error && <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>}
            <button type="submit" disabled={loading} className="w-full rounded bg-brand-500 py-2 text-sm font-medium text-white hover:bg-brand-600 disabled:opacity-50">
              {loading ? '처리 중…' : '로그인'}
            </button>
          </form>
          <p className="mt-4 text-sm text-gray-600">
            계정이 없으신가요? <Link href="/signup" className="text-brand-500 underline">회원가입</Link>
          </p>
        </SectionBox>
      </div>
    </PageWrapper>
  );
}
