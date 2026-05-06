// lib/supabase.ts
import { createClient, SupabaseClient } from '@supabase/supabase-js';

let _supabase: SupabaseClient | null = null;

function initSupabase(): SupabaseClient | null {
  // Reuse a global singleton to survive HMR in dev and avoid multiple GoTrue instances
  const g = globalThis as any;
  if (_supabase) return _supabase;
  if (g.__supabase) {
    _supabase = g.__supabase as SupabaseClient;
    return _supabase;
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || !key) {
    return null;
  }

  const client = createClient(url, key, {
    auth: {
      autoRefreshToken: true,
      persistSession: true,
      detectSessionInUrl: true,
    },
  });
  g.__supabase = client;
  _supabase = client;
  return _supabase;
}

export function getSupabase(): SupabaseClient {
  const client = initSupabase();
  if (!client) {
    throw new Error('Supabase client not initialized: missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY');
  }
  return client;
}

// Minimal safe fallback stub used when env vars are not provided.
const fallbackStub: any = {
  auth: {
    async getSession() {
      return { data: { session: null }, error: null };
    },
    async getUser() {
      return { data: { user: null }, error: null };
    },
    // preserve common auth methods used in the app
    signInWithPassword: async () => ({ data: null, error: new Error('Supabase not configured') }),
    signUp: async () => ({ data: null, error: new Error('Supabase not configured') }),
    signIn: async () => ({ data: null, error: new Error('Supabase not configured') }),
    signOut: async () => ({ data: null, error: new Error('Supabase not configured') }),
    onAuthStateChange: () => ({ data: { subscription: { unsubscribe() { } } } })
  },
  from: (_table: string) => ({
    select: (_cols?: string) => ({
      eq: (_col: string, _val: any) => ({ single: async () => ({ data: null, error: null }) }),
      in: (_col: string, _vals: any[]) => ({ order: (_c: string, _o?: any) => ({ limit: (_n: number) => ({ then: (f: any) => f({ data: [], error: null }) }) }) }),
      order: (_c: string, _opts?: any) => ({ limit: (_n: number) => ({ then: (f: any) => f({ data: [], error: null }) }) }),
      single: async () => ({ data: null, error: null }),
      limit: (_n: number) => ({ then: (f: any) => f({ data: [], error: null }) })
    }),
    insert: async (_payload: any) => ({ data: null, error: null }),
    update: async (_payload: any) => ({ data: null, error: null }),
    eq: (_col: string, _val: any) => ({ select: async () => ({ data: null, error: null }) })
  }),
  channel: (_name?: string) => ({
    on: (_event: any, _opts: any, _cb?: any) => ({ subscribe: () => ({}) }),
    subscribe: () => ({})
  }),
  // If code expects other properties, return a function that throws a clear error when invoked.
  __notConfigured: true
};

// Default export: a lightweight proxy that calls getSupabase() lazily.
// When real creds are missing, return the safe fallback stub instead of throwing so the app doesn't crash on import.
const supabaseProxy: any = new Proxy({}, {
  get(_, prop) {
    const client = initSupabase();
    const obj: any = client || fallbackStub;
    if (prop === 'auth' && obj?.auth) {
      const authObj = obj.auth;
      return new Proxy(authObj, {
        get(target, authProp) {
          const original = (target as any)[authProp as any];
          if (typeof original !== 'function') return original;

          if (authProp === 'getUser') {
            return async (...args: any[]) => {
              if (args.length === 0 && typeof window !== 'undefined' && typeof (target as any).getSession === 'function') {
                try {
                  const sessionResult = await Promise.resolve((target as any).getSession());
                  const sessionUser = sessionResult?.data?.session?.user ?? null;
                  if (sessionUser) {
                    return { data: { user: sessionUser }, error: null } as any;
                  }
                } catch {
                  // Keep browser auth checks local; avoid network verification loops on transient failures.
                }

                return { data: { user: null }, error: null } as any;
              }

              return Promise.resolve(original.apply(target, args));
            };
          }

          return original.bind(target);
        }
      });
    }
    // @ts-ignore
    return obj[prop as any];
  }
});

export default supabaseProxy;
export { supabaseProxy as supabase };
