'use client';

import { useEffect, useState, type FormEvent } from 'react';
import { PageWrapper, SectionBox, Spinner } from '@sht/ui';
import { useAuth } from '@sht/auth';
import { createSupabaseBrowserClient } from '@sht/db/browser';

interface UserProfile {
  id: string;
  email?: string | null;
  name?: string | null;
  phone?: string | null;
  english_name?: string | null;
  passport_number?: string | null;
  birth_date?: string | null;
  role?: string | null;
}

export default function ProfilePage() {
  const { user, loading: authLoading } = useAuth('/login');
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    if (authLoading || !user) return;
    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();
        const { data } = await supabase.from('users').select('*').eq('id', user.id).maybeSingle();
        if (cancelled) return;
        setProfile(
          data
            ? (data as UserProfile)
            : { id: user.id, email: user.email, name: '', phone: '', role: 'guest' },
        );
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void run();
    return () => {
      cancelled = true;
    };
  }, [authLoading, user]);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!user || !profile) return;
    setSaving(true);
    setMessage(null);
    try {
      const supabase = createSupabaseBrowserClient();
      const payload = {
        id: user.id,
        email: user.email,
        name: profile.name,
        phone: profile.phone,
        english_name: profile.english_name,
        passport_number: profile.passport_number,
        birth_date: profile.birth_date,
        role: profile.role || 'member',
      };
      const { error } = await supabase.from('users').upsert(payload);
      if (error) {
        setMessage('저장 실패: ' + error.message);
      } else {
        setMessage('저장되었습니다.');
      }
    } finally {
      setSaving(false);
    }
  };

  if (loading || !profile) return <PageWrapper><Spinner /></PageWrapper>;

  return (
    <PageWrapper>
      <SectionBox title="👤 프로필">
        <form onSubmit={handleSubmit} className="space-y-3">
          <Field label="이메일" value={profile.email ?? ''} readOnly />
          <Field
            label="이름"
            value={profile.name ?? ''}
            onChange={(v) => setProfile({ ...profile, name: v })}
          />
          <Field
            label="전화번호"
            value={profile.phone ?? ''}
            onChange={(v) => setProfile({ ...profile, phone: v })}
          />
          <Field
            label="영문 이름"
            value={profile.english_name ?? ''}
            onChange={(v) => setProfile({ ...profile, english_name: v })}
          />
          <Field
            label="여권 번호"
            value={profile.passport_number ?? ''}
            onChange={(v) => setProfile({ ...profile, passport_number: v })}
          />
          <Field
            label="생년월일"
            value={profile.birth_date ?? ''}
            type="date"
            onChange={(v) => setProfile({ ...profile, birth_date: v })}
          />
          {message && (
            <p
              className={
                message.startsWith('저장되었')
                  ? 'rounded bg-green-50 px-3 py-2 text-sm text-green-600'
                  : 'rounded bg-red-50 px-3 py-2 text-sm text-red-500'
              }
            >
              {message}
            </p>
          )}
          <button
            type="submit"
            disabled={saving}
            className="rounded bg-brand-500 px-4 py-2 text-sm text-white hover:bg-brand-600 disabled:opacity-50"
          >
            {saving ? '저장 중…' : '저장'}
          </button>
        </form>
      </SectionBox>
    </PageWrapper>
  );
}

function Field({
  label,
  value,
  onChange,
  readOnly,
  type = 'text',
}: {
  label: string;
  value: string;
  onChange?: (v: string) => void;
  readOnly?: boolean;
  type?: string;
}) {
  return (
    <div>
      <label className="mb-1 block text-sm text-gray-600">{label}</label>
      <input
        type={type}
        value={value}
        readOnly={readOnly}
        onChange={(e) => onChange?.(e.target.value)}
        className="w-full rounded border border-gray-200 px-3 py-2 text-sm read-only:bg-gray-50"
      />
    </div>
  );
}
