-- 2026-04-06-seed-usd-exchange-rate.sql
-- exchange_rates 테이블에 USD 관리 행을 보장합니다.

BEGIN;

-- upsert 충돌 기준 보장을 위해 unique 인덱스 생성
CREATE UNIQUE INDEX IF NOT EXISTS ux_exchange_rates_currency_code
  ON public.exchange_rates(currency_code);

-- USD 기본 행 생성/갱신 (1달러 = 1,400원 기본값)
INSERT INTO public.exchange_rates (currency_code, rate_to_krw, source, last_updated)
VALUES ('USD', 1400, 'manual', now())
ON CONFLICT (currency_code)
DO UPDATE SET
  rate_to_krw = EXCLUDED.rate_to_krw,
  source = EXCLUDED.source,
  last_updated = now();

COMMIT;
