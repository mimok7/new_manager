'use client';

import { useEffect, useRef } from 'react';
import { supabase } from '@/lib/supabase';

const TAB_SESSION_KEY = 'sht:tab:id';
const ACTIVE_TAB_KEY = 'sht:active:tab';

function getOrCreateTabId() {
    if (typeof window === 'undefined') return '';
    let tabId = sessionStorage.getItem(TAB_SESSION_KEY);
    if (!tabId) {
        tabId = `tab_${Date.now()}_${Math.random().toString(36).slice(2, 10)}`;
        sessionStorage.setItem(TAB_SESSION_KEY, tabId);
    }
    return tabId;
}

function readTabId(raw: string | null) {
    if (!raw) return null;
    try {
        const parsed = JSON.parse(raw);
        return typeof parsed?.tabId === 'string' ? parsed.tabId : null;
    } catch {
        return null;
    }
}

export default function TabSessionGuard({ loginPath }: { loginPath: string }) {
    const currentTabIdRef = useRef('');

    useEffect(() => {
        currentTabIdRef.current = getOrCreateTabId();

        const logoutLocal = async () => {
            try {
                await supabase.auth.signOut({ scope: 'local' });
            } catch {
                // noop
            }
            window.location.replace(loginPath);
        };

        const syncWithActiveTab = () => {
            const activeTabId = readTabId(localStorage.getItem(ACTIVE_TAB_KEY));
            if (!activeTabId || activeTabId === currentTabIdRef.current) return;
            void logoutLocal();
        };

        const handleStorage = (e: StorageEvent) => {
            if (e.key !== ACTIVE_TAB_KEY) return;
            const incomingTabId = readTabId(e.newValue);
            if (!incomingTabId || incomingTabId === currentTabIdRef.current) return;
            void logoutLocal();
        };

        syncWithActiveTab();
        window.addEventListener('storage', handleStorage);
        return () => window.removeEventListener('storage', handleStorage);
    }, [loginPath]);

    return null;
}