import type { User } from '@supabase/supabase-js';
import supabase from '@/lib/supabase';

const MANAGER_ROLE_CANDIDATES = ['manager'];

const normalizeRole = (value: unknown): string => {
  if (typeof value !== 'string') return '';
  return value.trim().toLowerCase();
};

const extractRoles = (user: User): string[] => {
  const candidates: unknown[] = [];

  candidates.push(user.user_metadata?.role);
  candidates.push(user.app_metadata?.role);

  if (Array.isArray(user.user_metadata?.roles)) {
    candidates.push(...user.user_metadata.roles);
  }

  if (Array.isArray(user.app_metadata?.roles)) {
    candidates.push(...user.app_metadata.roles);
  }

  return candidates
    .map(normalizeRole)
    .filter((role): role is string => role.length > 0);
};

export const isManagerUser = (user: User | null | undefined): boolean => {
  if (!user) return false;
  const roles = extractRoles(user);
  return roles.some((role) => MANAGER_ROLE_CANDIDATES.includes(role));
};

export const canAccessManagerApp = async (user: User | null | undefined): Promise<boolean> => {
  if (!user) return false;

  // 1) 메타데이터에 role이 세팅된 경우 즉시 허용
  if (isManagerUser(user)) return true;

  // 2) 매니저 프로젝트와 동일하게 users.role을 기준으로 권한 확인
  const { data, error } = await supabase
    .from('users')
    .select('role')
    .eq('id', user.id)
    .single();

  if (error || !data) return false;
  return normalizeRole(data.role) === 'manager';
};

export const isPublicPath = (pathname: string): boolean => {
  return pathname === '/login';
};
