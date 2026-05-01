import { createClient } from '@supabase/supabase-js';

// Server-only Supabase client using the service role key.
// Ensure SUPABASE_SERVICE_ROLE_KEY is set in the environment (.env.local) and never expose this key to the browser.
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const serviceSupabase = supabaseUrl && serviceRoleKey
    ? createClient(supabaseUrl, serviceRoleKey)
    : null;

export default serviceSupabase;
