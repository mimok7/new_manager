/**
 * DB 타입 자동 생성 자리표시자.
 * Phase 0 후속 작업: `supabase gen types typescript --project-id <id> > types.ts`
 * 또는 Drizzle introspect 결과를 여기로 머지.
 *
 * 현재는 `any`로 두어 모든 테이블 호출이 untyped 로 동작 (insert/update/upsert payload가
 * `never`로 추론되어 발생하는 빌드 에러 방지). 추후 자동 생성 타입으로 교체 시 strict 가능.
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type Database = any;
