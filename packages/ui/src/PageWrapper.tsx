import type { ReactNode } from 'react';
import { cn } from './cn';

export interface PageWrapperProps {
  children: ReactNode;
  className?: string;
}

export function PageWrapper({ children, className }: PageWrapperProps) {
  return (
    <div className={cn('mx-auto w-full max-w-5xl px-4 py-6', className)}>
      {children}
    </div>
  );
}
