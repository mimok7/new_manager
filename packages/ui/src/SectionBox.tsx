import type { ReactNode } from 'react';
import { cn } from './cn';

export interface SectionBoxProps {
  title?: ReactNode;
  right?: ReactNode;
  children: ReactNode;
  className?: string;
}

export function SectionBox({ title, right, children, className }: SectionBoxProps) {
  return (
    <section className={cn('rounded-lg bg-white p-6 shadow-sm', className)}>
      {(title || right) && (
        <header className="mb-4 flex items-center justify-between">
          {title ? (
            <h2 className="text-lg font-semibold text-gray-700">{title}</h2>
          ) : (
            <span />
          )}
          {right}
        </header>
      )}
      {children}
    </section>
  );
}
