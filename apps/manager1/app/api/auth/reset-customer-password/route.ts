import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

const RESET_PASSWORD = 'sht123!';

function getClients() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !serviceRoleKey || !anonKey) {
    return {
      adminClient: null,
      anonClient: null,
      error: NextResponse.json(
        { error: 'Missing Supabase server environment variables' },
        { status: 500 }
      )
    };
  }

  const adminClient = createClient(supabaseUrl, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  });

  const anonClient = createClient(supabaseUrl, anonKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  });

  return { adminClient, anonClient, error: null };
}

export async function POST(request: NextRequest) {
  try {
    const { adminClient, anonClient, error } = getClients();
    if (!adminClient || !anonClient) return error!;

    const authHeader = request.headers.get('authorization') || '';
    const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : '';

    if (!token) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { data: requesterAuth, error: requesterAuthError } = await anonClient.auth.getUser(token);

    if (requesterAuthError || !requesterAuth.user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { data: requester, error: requesterError } = await adminClient
      .from('users')
      .select('role')
      .eq('id', requesterAuth.user.id)
      .maybeSingle();

    if (requesterError || !requester) {
      return NextResponse.json({ error: '권한을 확인할 수 없습니다.' }, { status: 403 });
    }

    const requesterRole = String(requester.role || '').trim().toLowerCase();
    if (!['manager', 'admin'].includes(requesterRole)) {
      return NextResponse.json({ error: '권한이 없습니다.' }, { status: 403 });
    }

    const { targetUserId } = await request.json();

    if (!targetUserId || typeof targetUserId !== 'string') {
      return NextResponse.json({ error: 'targetUserId is required' }, { status: 400 });
    }

    const { error: updateError } = await adminClient.auth.admin.updateUserById(targetUserId, {
      password: RESET_PASSWORD
    });

    if (updateError) {
      return NextResponse.json({ error: updateError.message }, { status: 400 });
    }

    return NextResponse.json({ ok: true });
  } catch (error: any) {
    return NextResponse.json({ error: error?.message || '서버 오류' }, { status: 500 });
  }
}
