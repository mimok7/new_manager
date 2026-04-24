/**
 * KST(Asia/Seoul) 표준 시간 변환 함수.
 * 수동 +8/+9 보정 절대 금지 — 반드시 이 함수만 사용할 것.
 */

const KST_TIMEZONE = 'Asia/Seoul';

/** DB timestamptz → input[type=datetime-local] 표시용 (KST) */
export function toInputDateTime(value?: string | null): string {
  if (!value) return '';
  const raw = String(value).trim();
  if (!raw) return '';

  const hasTz = /[zZ]$|[+-]\d{2}:?\d{2}$/.test(raw);
  if (!hasTz) return raw.replace(' ', 'T').slice(0, 16);

  const d = new Date(raw);
  if (Number.isNaN(d.getTime())) return raw.replace(' ', 'T').slice(0, 16);

  const parts = new Intl.DateTimeFormat('sv-SE', {
    timeZone: KST_TIMEZONE,
    hour12: false,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  }).formatToParts(d);

  const pick = (type: string) => parts.find((p) => p.type === type)?.value ?? '';
  return `${pick('year')}-${pick('month')}-${pick('day')}T${pick('hour')}:${pick('minute')}`;
}

/** input[type=datetime-local] → DB timestamptz (KST 오프셋 명시) */
export function toDbDateTimeKst(value?: string | null): string | null {
  if (!value) return null;
  const v = String(value).trim();
  if (!v) return null;

  const normalized = v.replace(' ', 'T');
  if (/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(normalized)) {
    return `${normalized}:00+09:00`;
  }
  return normalized;
}

/** 표시용 KST 한글 포맷 */
export function formatKst(value?: string | null): string {
  if (!value) return '-';
  const raw = String(value).trim();
  const hasTz = /[zZ]$|[+-]\d{2}:?\d{2}$/.test(raw);

  if (!hasTz) return raw.replace('T', ' ').slice(0, 16);

  const d = new Date(raw);
  if (Number.isNaN(d.getTime())) return raw;

  return d.toLocaleString('ko-KR', {
    timeZone: KST_TIMEZONE,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    hour12: true,
  });
}
