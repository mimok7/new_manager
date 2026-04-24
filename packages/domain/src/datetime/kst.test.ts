import { describe, expect, it } from 'vitest';
import { formatKst, toDbDateTimeKst, toInputDateTime } from './kst';

describe('kst datetime', () => {
  it('toDbDateTimeKst appends +09:00 when missing', () => {
    expect(toDbDateTimeKst('2026-04-25T10:30')).toBe('2026-04-25T10:30:00+09:00');
  });

  it('toDbDateTimeKst handles null/empty', () => {
    expect(toDbDateTimeKst(null)).toBeNull();
    expect(toDbDateTimeKst('')).toBeNull();
  });

  it('toInputDateTime returns naive value as-is when no tz', () => {
    expect(toInputDateTime('2026-04-25T10:30')).toBe('2026-04-25T10:30');
  });

  it('formatKst handles null', () => {
    expect(formatKst(null)).toBe('-');
  });
});
