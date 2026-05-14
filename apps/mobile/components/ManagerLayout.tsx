'use client';

import React from 'react';
import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';

export default function ManagerLayout({
    title,
    children,
    activeTab,
}: {
    title?: string;
    children: React.ReactNode;
    activeTab?: string;
}) {
    return (
        <div className="min-h-screen bg-slate-50 pb-16">
            <header className="sticky top-0 z-30 bg-white/95 backdrop-blur border-b border-slate-200">
                <div className="mx-auto flex items-center justify-between px-3 py-2.5">
                    <Link href="/" className="flex items-center gap-1 text-slate-600 active:text-slate-900">
                        <ArrowLeft className="w-5 h-5" />
                        <span className="text-sm">이전</span>
                    </Link>
                    <h1 className="text-sm font-semibold text-slate-800 truncate max-w-[60%] text-center">
                        {title || '매니저'}
                    </h1>
                    <Link href="/" className="text-sm text-blue-600 active:text-blue-800 font-medium">홈</Link>
                </div>
            </header>
            <main className="w-full px-2 py-2 overflow-x-hidden">{children}</main>
        </div>
    );
}
