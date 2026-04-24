import { z } from 'zod';

export const ServiceType = z.enum(['room', 'car', 'airport', 'hotel', 'rentcar', 'tour']);
export type ServiceType = z.infer<typeof ServiceType>;

export const QuoteStatus = z.enum([
  'draft',
  'submitted',
  'pending',
  'approved',
  'rejected',
  'cancelled',
]);
export type QuoteStatus = z.infer<typeof QuoteStatus>;

export const QuoteItem = z.object({
  id: z.string().uuid(),
  quote_id: z.string().uuid(),
  service_type: ServiceType,
  service_ref_id: z.string().uuid().nullable(),
  quantity: z.number().int().nonnegative(),
  unit_price: z.number().nonnegative(),
  total_price: z.number().nonnegative(),
});
export type QuoteItem = z.infer<typeof QuoteItem>;

export const Quote = z.object({
  id: z.string().uuid(),
  quote_id: z.string().optional(),
  user_id: z.string().uuid(),
  title: z.string().min(1),
  status: QuoteStatus,
  total_price: z.number().nonnegative().default(0),
  created_at: z.string().optional(),
  updated_at: z.string().optional(),
});
export type Quote = z.infer<typeof Quote>;
