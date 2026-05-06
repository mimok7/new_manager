import supabase from './supabase';

/**
 * Get current authenticated user with server verification.
 */
export async function getSessionUser(): Promise<{ user: any; error: any }> {
  try {
    const { data: { user }, error } = await supabase.auth.getUser();
    if (error) return { user: null, error };
    if (user) return { user, error: null };
    return { user: null, error: new Error('No active session') };
  } catch (err) {
    return { user: null, error: err };
  }
}

/**
 * Verify auth session is still valid before a critical operation (form submit).
 * Returns the current user or null + error.
 */
export async function refreshAuthBeforeSubmit(): Promise<{ user: any; error?: any }> {
  try {
    const { data: { user }, error } = await supabase.auth.getUser();
    if (error || !user) {
      return { user: null, error: error || new Error('No active session') };
    }
    return { user, error: null };
  } catch (err) {
    return { user: null, error: err };
  }
}
