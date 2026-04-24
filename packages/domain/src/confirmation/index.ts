/**
 * 확정서(UnifiedQuoteData) 빌더
 * Phase 4: customer/manager 양측에서 동일 데이터 모양으로 UnifiedConfirmation에 주입.
 */
import type { SupabaseClient as TypedSupabaseClient } from '@supabase/supabase-js';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type SupabaseLike = TypedSupabaseClient<any, any, any>;

const SERVICE_DETAIL_TABLE: Record<string, string> = {
  cruise: 'reservation_cruise',
  airport: 'reservation_airport',
  hotel: 'reservation_hotel',
  rentcar: 'reservation_rentcar',
  tour: 'reservation_tour',
  sht: 'reservation_car_sht',
};

export interface UnifiedReservationDetail {
  reservation_id: string;
  service_type: string;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  service_details: Record<string, any> | null;
  amount: number;
  status: string;
}

export interface UnifiedQuoteData {
  id?: string;
  quote_id?: string;
  title: string;
  user_name: string;
  user_phone: string;
  user_email?: string;
  total_price: number;
  created_at?: string;
  reservations: UnifiedReservationDetail[];
}

/**
 * 단일 quote 기준 확정서 데이터 빌드.
 * - quote.title / users.name|phone|email / 해당 quote의 모든 reservation + 서비스 디테일을 모은다.
 */
export async function buildConfirmationData(
  supabase: SupabaseLike,
  quoteId: string,
): Promise<UnifiedQuoteData | null> {
  const { data: q } = await supabase
    .from('quote')
    .select('id, quote_id, title, user_id, total_price, created_at')
    .or(`id.eq.${quoteId},quote_id.eq.${quoteId}`)
    .limit(1)
    .maybeSingle();
  if (!q) return null;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const quoteRow = q as Record<string, any>;

  const { data: u } = quoteRow.user_id
    ? await supabase
        .from('users')
        .select('name, phone, email')
        .eq('id', quoteRow.user_id)
        .maybeSingle()
    : { data: null };

  const { data: reservations } = await supabase
    .from('reservation')
    .select('re_id, re_type, re_status, re_created_at')
    .eq('re_quote_id', quoteRow.id);

  const items: UnifiedReservationDetail[] = [];
  for (const r of (reservations || []) as Array<{
    re_id: string;
    re_type: string;
    re_status: string;
    re_created_at: string;
  }>) {
    const tbl = SERVICE_DETAIL_TABLE[r.re_type];
    let detail: Record<string, unknown> | null = null;
    let amount = 0;
    if (tbl) {
      const { data: d } = await supabase
        .from(tbl)
        .select('*')
        .eq('reservation_id', r.re_id)
        .maybeSingle();
      detail = (d as Record<string, unknown> | null) ?? null;
      const total = (detail?.['total_price'] ?? detail?.['room_total_price'] ?? 0) as number;
      amount = typeof total === 'number' ? total : 0;
    }
    items.push({
      reservation_id: r.re_id,
      service_type: r.re_type,
      service_details: detail,
      amount,
      status: r.re_status,
    });
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const userRow = (u || {}) as Record<string, any>;

  return {
    id: quoteRow.id as string,
    quote_id: quoteRow.quote_id as string | undefined,
    title: (quoteRow.title as string) || '여행',
    user_name: (userRow.name as string) || '-',
    user_phone: (userRow.phone as string) || '-',
    user_email: (userRow.email as string) || undefined,
    total_price:
      (quoteRow.total_price as number) || items.reduce((sum, it) => sum + it.amount, 0),
    created_at: quoteRow.created_at as string | undefined,
    reservations: items,
  };
}
