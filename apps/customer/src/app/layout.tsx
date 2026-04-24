import '@sht/ui/styles.css';
import './globals.css';
import type { ReactNode } from 'react';
import { QueryProvider } from '@sht/ui';

export const metadata = {
  title: 'StayHalong Customer',
  description: '스테이하롱 크루즈 예약 — 고객용',
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="ko">
      <body className="min-h-screen bg-gray-50 text-gray-700 antialiased">
        <QueryProvider>{children}</QueryProvider>
      </body>
    </html>
  );
}
