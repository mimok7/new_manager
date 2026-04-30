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
        <div className="min-h-screen flex flex-col items-center justify-between bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 px-4 py-6 relative overflow-hidden">
            {/* 배경 장식 */}
            <div className="absolute inset-0 pointer-events-none opacity-30">
                <div className="absolute -top-20 -left-20 w-80 h-80 bg-blue-200 rounded-full blur-3xl" />
                <div className="absolute -bottom-20 -right-20 w-96 h-96 bg-indigo-200 rounded-full blur-3xl" />
            </div>

            {/* 상단 로고 */}
            <div className="relative z-10 flex flex-col items-center mt-2">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src="/logo-160.png" alt="스테이하롱" className="w-20 h-20 object-contain drop-shadow-md" />
                <div className="mt-2 text-sm font-bold text-gray-700 tracking-wide">STAY HALONG</div>
            </div>

            {/* 가운데 카드 + 환영 이미지 */}
            <div className="relative z-10 w-full max-w-sm bg-white/90 backdrop-blur border border-gray-200 rounded-2xl shadow-xl overflow-hidden">
                {/* 가운데 환영 이미지 */}
                <div className="relative bg-gradient-to-br from-blue-500 to-indigo-600 px-6 py-5 flex items-center justify-center">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src="/images/welcome.png" alt="환영합니다" className="max-h-24 object-contain drop-shadow-lg" />
                </div>
                <div className="p-6">
                    <h1 className="text-base font-semibold text-gray-800 mb-1 text-center">제휴업체 시스템</h1>
                    <p className="text-xs text-gray-500 mb-4 text-center">제휴업체 / 회원 / 매니저 공통 로그인</p>
                    <form onSubmit={handleSubmit} className="space-y-3">
                        <input
                            type="email"
                            required
                            placeholder="이메일 (예: partner1@stayhalong.com)"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 bg-gray-50 focus:bg-white focus:outline-none focus:border-blue-300"
                        />
                        <input
                            type="password"
                            required
                            placeholder="비밀번호"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-200 bg-gray-50 focus:bg-white focus:outline-none focus:border-blue-300"
                        />
                        {error && <div className="text-xs text-red-500">{error}</div>}
                        <button
                            type="submit"
                            disabled={loading}
                            className="w-full px-3 py-2 text-sm rounded-lg bg-gradient-to-r from-blue-500 to-indigo-500 text-white hover:opacity-90 disabled:opacity-50 shadow"
                        >
                            {loading ? '로그인 중...' : '로그인'}
                        </button>
                    </form>
                    <p className="mt-4 text-[11px] text-gray-400 leading-relaxed text-center">
                        제휴업체 계정 초기 비밀번호는 매니저가 별도 안내합니다.<br />
                        로그인 후 비밀번호 변경을 권장합니다.
                    </p>
                </div>
            </div>

            {/* 바닥 이미지 */}
            <div className="relative z-10 flex flex-col items-center mt-4">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src="/images/thank-you.png" alt="감사합니다" className="max-h-16 object-contain opacity-90" />
                <div className="mt-1 text-[10px] text-gray-400">© Stay Halong Partner Platform</div>
            </div>
        </div>
    );
}
