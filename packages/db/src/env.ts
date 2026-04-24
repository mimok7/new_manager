function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing env: ${name}`);
  return value;
}

export const SUPABASE_URL = (): string => requireEnv('NEXT_PUBLIC_SUPABASE_URL');
export const SUPABASE_ANON_KEY = (): string => requireEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY');
export const SUPABASE_SERVICE_ROLE_KEY = (): string => requireEnv('SUPABASE_SERVICE_ROLE_KEY');
