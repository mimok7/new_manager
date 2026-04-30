'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';

// 로그인 후 역할별 진입 경로
function landingFor(role?: string | null): string {
    switch (role) {
        case 'partner':            return '/partner/dashboard';   // 업체 — 카테고리 적응 대시보드
        case 'manager':
        case 'admin':              return '/partner/admin/partners';
        case 'member':
        default:                   return '/partner/browse';
    }
}

export default function PartnerLoginPage() {
    const router = useRouter();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError(null);
        setLoading(true);
        try {
            const { data, error: signInError } = await supabase.auth.signInWithPassword({ email, password });
            if (signInError) throw signInError;

            // role 조회 → 역할별 페이지로 이동
            let role: string | null = null;
            try {
                const { data: u } = await supabase
                    .from('users')
                    .select('role')
                    .eq('id', data.user?.id)
                    .maybeSingle();
                role = u?.role ?? null;
            } catch { /* ignore */ }

            router.replace(landingFor(role));
        } catch (err: any) {
            setError(err?.message || '로그인 실패');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-white flex flex-col items-center px-4 py-8">
            {/* 가운데 카드 (고객앱 스타일) */}
            <div className="max-w-sm w-full mx-auto p-4 bg-white shadow rounded">
                {/* 상단 로고 — 고객앱과 동일 (logo-full 가로형) */}
                <div className="flex justify-start mb-4">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src="/logo-full.png" alt="스테이하롱 전체 로고" width={320} height={80} />
                </div>

                <h2 className="text-2xl font-bold mb-2 text-left">🤝 제휴업체 로그인</h2>
                <p className="text-sm text-gray-500 mb-6">제휴업체 / 회원 / 매니저 공통 로그인</p>

                {/* 가운데 환영 이미지 */}
                <div className="flex justify-center mb-6">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src="/images/welcome.png" alt="환영합니다" width={200} height={200} className="object-contain" />
                </div>

                <form onSubmit={handleSubmit} className="space-y-4">
                    <input
                        type="email"
                        required
                        placeholder="이메일 (예: partner1@stayhalong.com)"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        className="w-full border p-2 rounded"
                    />
                    <input
                        type="password"
                        required
                        placeholder="비밀번호"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        className="w-full border p-2 rounded"
                    />
                    {error && <div className="text-sm text-red-600">{error}</div>}
                    <button
                        type="submit"
                        disabled={loading}
                        className="bg-blue-700 text-white w-full py-2 rounded hover:bg-blue-800 transition disabled:opacity-50"
                    >
                        {loading ? '처리 중...' : '로그인'}
                    </button>
                </form>

                <p className="mt-4 text-xs text-gray-500 text-center leading-relaxed">
                    제휴업체 계정 초기 비밀번호는 매니저가 별도 안내합니다.<br />
                    로그인 후 비밀번호 변경을 권장합니다.
                </p>
            </div>

            {/* 바닥 감사 이미지 — 고객앱 quote/processing 스타일 */}
            <div className="flex flex-col items-center mt-8">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src="/images/thank-you.png" alt="감사합니다" width={200} height={200} className="object-contain mb-2" />
                <div className="text-xs text-gray-400">© StayHalongTravel</div>
            </div>
        </div>
    );
}
