'use client';

import { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';
import PartnerLayout from '@/components/PartnerLayout';
import SectionBox from '@/components/SectionBox';
import Spinner from '@/components/Spinner';
import { supabase } from '@/lib/supabase';

interface Partner {
    partner_id: string;
    partner_code: string;
    name: string;
    branch_name?: string | null;
    category: string;
    subcategory?: string | null;
    region?: string | null;
    address?: string | null;
    description?: string | null;
    thumbnail_url?: string | null;
    open_hours?: string | null;
    default_discount_rate?: number | null;
}

const CATEGORY_LABEL: Record<string, string> = {
    hotel: '🏨 호텔',
    spa: '💆 스파',
    restaurant: '🍴 식당',
    costume: '👘 의상대여',
    tour: '🚌 투어',
    rentcar: '🚗 렌터카',
};

export default function BrowseAllPage() {
    const [partners, setPartners] = useState<Partner[]>([]);
    const [loading, setLoading] = useState(true);
    const [category, setCategory] = useState<string>('');
    const [region, setRegion] = useState<string>('');
    const [keyword, setKeyword] = useState<string>('');

    useEffect(() => {
        let cancelled = false;
        (async () => {
            try {
                const { data } = await supabase
                    .from('partner')
                    .select('partner_id, partner_code, name, branch_name, category, subcategory, region, address, description, thumbnail_url, open_hours, default_discount_rate')
                    .eq('is_active', true)
                    .order('category')
                    .order('name');
                if (cancelled) return;
                setPartners((data as Partner[]) || []);
            } finally {
                if (!cancelled) setLoading(false);
            }
        })();
        return () => { cancelled = true; };
    }, []);

    const categories = useMemo(() => Array.from(new Set(partners.map(p => p.category))).sort(), [partners]);
    const regions = useMemo(() => Array.from(new Set(partners.map(p => p.region).filter(Boolean))) as string[], [partners]);

    const filtered = useMemo(() => {
        return partners.filter(p => {
            if (category && p.category !== category) return false;
            if (region && (p.region || '') !== region) return false;
            if (keyword) {
                const k = keyword.toLowerCase();
                if (!(p.name?.toLowerCase().includes(k) || p.branch_name?.toLowerCase().includes(k) || p.description?.toLowerCase().includes(k))) return false;
            }
            return true;
        });
    }, [partners, category, region, keyword]);

    return (
        <PartnerLayout title="🛍️ 제휴업체 둘러보기" requiredRoles={['member', 'partner', 'manager', 'admin']}>
            <SectionBox title="필터">
                <div className="flex flex-col gap-2">
                    <div className="flex gap-2 flex-wrap text-xs">
                        <span className="text-gray-500 self-center">카테고리:</span>
                        <button onClick={() => setCategory('')}
                            className={`px-3 py-1 rounded border ${category === '' ? 'bg-blue-50 border-blue-300 text-blue-600' : 'bg-white border-gray-200 text-gray-600'}`}>전체</button>
                        {categories.map(c => (
                            <button key={c} onClick={() => setCategory(c)}
                                className={`px-3 py-1 rounded border ${category === c ? 'bg-blue-50 border-blue-300 text-blue-600' : 'bg-white border-gray-200 text-gray-600'}`}>
                                {CATEGORY_LABEL[c] || c}
                            </button>
                        ))}
                    </div>
                    {regions.length > 0 && (
                        <div className="flex gap-2 flex-wrap text-xs">
                            <span className="text-gray-500 self-center">지역:</span>
                            <button onClick={() => setRegion('')}
                                className={`px-3 py-1 rounded border ${region === '' ? 'bg-blue-50 border-blue-300 text-blue-600' : 'bg-white border-gray-200 text-gray-600'}`}>전체</button>
                            {regions.map(r => (
                                <button key={r} onClick={() => setRegion(r)}
                                    className={`px-3 py-1 rounded border ${region === r ? 'bg-blue-50 border-blue-300 text-blue-600' : 'bg-white border-gray-200 text-gray-600'}`}>{r}</button>
                            ))}
                        </div>
                    )}
                    <input type="text" placeholder="업체명/지점/설명 검색" value={keyword} onChange={(e) => setKeyword(e.target.value)}
                        className="px-2 py-1 rounded border border-gray-200 bg-white text-sm" />
                </div>
            </SectionBox>

            <SectionBox title={`업체 ${filtered.length}개`}>
                {loading ? (
                    <Spinner label="불러오는 중..." />
                ) : filtered.length === 0 ? (
                    <div className="text-sm text-gray-500 text-center py-8">조건에 맞는 업체가 없습니다.</div>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                        {filtered.map(p => (
                            <Link
                                key={p.partner_id}
                                href={`/partner/booking/${p.partner_id}`}
                                className="block p-4 bg-white border border-gray-200 rounded hover:border-blue-300 hover:shadow-sm transition"
                            >
                                {p.thumbnail_url && (
                                    <img src={p.thumbnail_url} alt={p.name} className="w-full h-32 object-cover rounded mb-2" />
                                )}
                                <div className="flex items-start justify-between gap-2">
                                    <div className="text-sm font-medium text-gray-800">
                                        {p.name}
                                        {p.branch_name && <span className="text-xs text-gray-500 ml-1">({p.branch_name})</span>}
                                    </div>
                                    {p.default_discount_rate ? (
                                        <span className="text-xs px-2 py-0.5 rounded bg-red-50 text-red-600 whitespace-nowrap">
                                            {Number(p.default_discount_rate)}% 할인
                                        </span>
                                    ) : null}
                                </div>
                                <div className="text-xs text-gray-500 mt-1">
                                    <span className="px-1.5 py-0.5 rounded bg-gray-100 text-gray-600 mr-1">
                                        {CATEGORY_LABEL[p.category] || p.category}
                                    </span>
                                    {p.subcategory && <span className="text-gray-500">{p.subcategory}</span>}
                                </div>
                                <div className="text-xs text-gray-500 mt-1">
                                    {p.region || '-'}{p.address ? ` · ${p.address}` : ''}
                                </div>
                                {p.open_hours && <div className="text-xs text-gray-500 mt-0.5">⏰ {p.open_hours}</div>}
                                {p.description && (
                                    <div className="text-xs text-gray-600 mt-2 line-clamp-2">{p.description}</div>
                                )}
                            </Link>
                        ))}
                    </div>
                )}
            </SectionBox>
        </PartnerLayout>
    );
}
