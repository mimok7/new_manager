import { cn } from './cn';

export interface SpinnerProps {
  className?: string;
  label?: string;
}

export function Spinner({ className, label }: SpinnerProps) {
  return (
    <div className={cn('flex h-72 items-center justify-center', className)}>
      <div className="flex flex-col items-center gap-3">
        <div className="h-12 w-12 animate-spin rounded-full border-b-2 border-brand-500" />
        {label && <p className="text-sm text-gray-500">{label}</p>}
      </div>
    </div>
  );
}
