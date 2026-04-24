import { z } from 'zod';

export const UserRole = z.enum(['guest', 'member', 'manager', 'admin']);
export type UserRole = z.infer<typeof UserRole>;

export const UserProfile = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string().nullable().optional(),
  phone: z.string().nullable().optional(),
  role: UserRole,
  created_at: z.string().optional(),
});
export type UserProfile = z.infer<typeof UserProfile>;
