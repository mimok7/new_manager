'use client';

import { useState, type FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { createSupabaseBrowserClient } from '@sht/db/browser';
import { PageWrapper, SectionBox } from '@sht/ui';

export default function SignupPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (loading) return;
    setLoading(true);
    setError(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const { data, error: signError } = await supabase.auth.signUp({ email, password });
      if (signError) {
        const msg = signError.message || '';
        if (msg.includes('already registered') || msg.includes('User already registered')) {
          setError('이미 가입된 이메일입니다. 로그인해주세요.');
          return;
        }
        setError('회원가입 실패: ' + msg);
        return;
      }
      if (!data.user) {
        setError('사용자 생성에 실패했습니다.');
        return;
      }
      setDone(true);
      setTimeout(() => router.replace('/mypage' as never), 800);
    } catch (err) {
      setError('회원가입 처리 중 오류가 발생했습니다.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <PageWrapper>
      <div className="mx-auto max-w-md">
        <SectionBox title="📝 회원가입 / 신규 예약">
          {done ? (
            <p className="text-sm text-gray-600">가입 완료. 마이페이지로 이동합니다…</p>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-3">
              <div>
                <label className="mb-1 block text-sm text-gray-600">이메일</label>
                <input type="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} className="w-full rounded border border-gray-200 px-3 py-2 text-sm" />
              </div>
              <div>
                <label className="mb-1 block text-sm text-gray-600">비밀번호</label>
                <input type="password" autoComplete="new-password" required minLength={6} value={password} onChange={(e) => setPassword(e.target.value)} className="w-full rounded border border-gray-200 px-3 py-2 text-sm" />
              </div>
              {error && <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-500">{error}</p>}
              <button type="submit" disabled={loading} className="w-full rounded bg-brand-500 py-2 text-sm font-medium text-white hover:bg-brand-600 disabled:opacity-50">
                {loading ? '처리 중…' : '회원가입'}
              </button>
            </form>
          )}
          <p className="mt-4 text-sm text-gray-600">
            이미 계정이 있나요? <Link href="/login" className="text-brand-500 underline">로그인</Link>
          </p>
          <p className="mt-3 rounded bg-blue-50 px-3 py-2 text-xs text-blue-600">💡 입력하신 이메일과 비밀번호로 향후 예약 내용을 확인할 수 있습니다.</p>
        </SectionBox>
      </div>
    </PageWrapper>
  );
}
