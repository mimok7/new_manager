import type { SupabaseClient as TypedSupabaseClient } from '@supabase/supabase-js';

export type SupabaseLike = TypedSupabaseClient<any, any, any>;

export type ReservationType = 'cruise' | 'airport' | 'hotel' | 'rentcar' | 'tour' | 'sht';

export interface ReservationRow {
  re_id: string;
  re_user_id: string;
  re_quote_id: string | null;
  re_type: ReservationType;
  re_status: string | null;
  re_created_at: string;
}

export async function listReservations(
  supabase: SupabaseLike,
  userId: string,
): Promise<ReservationRow[]> {
  const { data, error } = await supabase
    .from('reservation')
    .select('*')
    .eq('re_user_id', userId)
    .order('re_created_at', { ascending: false });
  if (error) throw error;
  return (data || []) as ReservationRow[];
}

export async function findReservationByQuote(
  supabase: SupabaseLike,
  userId: string,
  quoteId: string,
  type: ReservationType,
): Promise<ReservationRow | null> {
  const { data } = await supabase
    .from('reservation')
    .select('*')
    .eq('re_user_id', userId)
    .eq('re_quote_id', quoteId)
    .eq('re_type', type)
    .maybeSingle();
  return (data as ReservationRow | null) ?? null;
}

export async function ensureReservation(
  supabase: SupabaseLike,
  userId: string,
  quoteId: string,
  type: ReservationType,
): Promise<ReservationRow> {
  const existing = await findReservationByQuote(supabase, userId, quoteId, type);
  if (existing) return existing;
  const { data, error } = await supabase
    .from('reservation')
    .insert({
      re_user_id: userId,
      re_quote_id: quoteId,
      re_type: type,
      re_status: 'pending',
    })
    .select()
    .single();
  if (error) throw error;
  return data as ReservationRow;
}
