import type { SupabaseClient as TypedSupabaseClient } from '@supabase/supabase-js';

// 다양한 Database 제너릭 클라이언트를 모두 받기 위해 any로 완화.
export type SupabaseLike = TypedSupabaseClient<any, any, any>;

export interface QuoteRow {
  id: string;
  quote_id?: string | null;
  user_id: string;
  title: string;
  status: string | null;
  created_at: string;
}

export interface QuoteItemRow {
  id: string;
  quote_id: string;
  service_type: 'room' | 'car' | 'airport' | 'hotel' | 'rentcar' | 'tour';
  service_ref_id: string;
  quantity: number;
  unit_price: number;
  total_price: number;
}

/** 사용자의 모든 견적 (최신순). */
export async function listQuotes(supabase: SupabaseLike, userId: string): Promise<QuoteRow[]> {
  const { data, error } = await supabase
    .from('quote')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false });
  if (error) throw error;
  return (data || []) as QuoteRow[];
}

/** 단일 견적 + quote_item */
export async function getQuoteWithItems(
  supabase: SupabaseLike,
  idOrQuoteId: string,
): Promise<{ quote: QuoteRow; items: QuoteItemRow[] } | null> {
  let { data: quote } = await supabase.from('quote').select('*').eq('id', idOrQuoteId).maybeSingle();
  if (!quote) {
    const { data } = await supabase
      .from('quote')
      .select('*')
      .eq('quote_id', idOrQuoteId)
      .maybeSingle();
    quote = data;
  }
  if (!quote) return null;
  const { data: items } = await supabase
    .from('quote_item')
    .select('*')
    .eq('quote_id', (quote as QuoteRow).id);
  return { quote: quote as QuoteRow, items: (items || []) as QuoteItemRow[] };
}

/** 새 견적 생성 (기존 draft 있으면 재사용) */
export async function createOrReuseDraft(
  supabase: SupabaseLike,
  userId: string,
  title?: string,
): Promise<QuoteRow> {
  const { data: existing } = await supabase
    .from('quote')
    .select('*')
    .eq('user_id', userId)
    .eq('status', 'draft')
    .order('created_at', { ascending: false })
    .maybeSingle();
  if (existing) return existing as QuoteRow;
  const { data, error } = await supabase
    .from('quote')
    .insert({ user_id: userId, title: title || '새 견적', status: 'draft' })
    .select()
    .single();
  if (error) throw error;
  return data as QuoteRow;
}
