import { z } from 'zod';

export const ReservationType = z.enum(['cruise', 'airport', 'hotel', 'rentcar', 'tour', 'sht']);
export type ReservationType = z.infer<typeof ReservationType>;

export const ReservationStatus = z.enum([
  'pending',
  'confirmed',
  'in_progress',
  'completed',
  'cancelled',
  'change_requested',
]);
export type ReservationStatus = z.infer<typeof ReservationStatus>;

export const Reservation = z.object({
  re_id: z.string().uuid(),
  re_user_id: z.string().uuid(),
  re_quote_id: z.string().uuid().nullable(),
  re_type: ReservationType,
  re_status: ReservationStatus,
  re_created_at: z.string().optional(),
});
export type Reservation = z.infer<typeof Reservation>;
