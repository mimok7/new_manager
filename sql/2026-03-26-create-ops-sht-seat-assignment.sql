-- 운영 전용 SHT 좌석 배정 테이블
-- 목적: reservation/re_type=car_sht 도메인에서 분리하여 배차/좌석 체크 전용으로 사용

CREATE TABLE IF NOT EXISTS ops_sht_seat_assignment (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  legacy_car_sht_id uuid UNIQUE,
  reservation_id uuid NULL,
  quote_id uuid NULL,

  usage_date timestamptz NULL,
  pickup_datetime timestamptz NULL,

  vehicle_number text NULL,
  seat_number text NULL,
  sht_category text NULL,
  pickup_location text NULL,
  dropoff_location text NULL,

  passenger_count integer NULL,
  car_count integer NULL,
  car_price_code text NULL,

  dispatch_code text NULL,
  pickup_confirmed_at timestamptz NULL,
  dispatch_memo text NULL,

  request_note text NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ops_sht_seat_usage_date
  ON ops_sht_seat_assignment (usage_date);

CREATE INDEX IF NOT EXISTS idx_ops_sht_seat_reservation_id
  ON ops_sht_seat_assignment (reservation_id);

CREATE INDEX IF NOT EXISTS idx_ops_sht_seat_quote_id
  ON ops_sht_seat_assignment (quote_id);

-- 기존 데이터 이관 (idempotent)
INSERT INTO ops_sht_seat_assignment (
  legacy_car_sht_id,
  reservation_id,
  quote_id,
  usage_date,
  pickup_datetime,
  vehicle_number,
  seat_number,
  sht_category,
  pickup_location,
  dropoff_location,
  passenger_count,
  car_count,
  car_price_code,
  dispatch_code,
  pickup_confirmed_at,
  dispatch_memo,
  request_note,
  created_at,
  updated_at
)
SELECT
  rcs.id AS legacy_car_sht_id,
  rcs.reservation_id,
  r.re_quote_id AS quote_id,
  rcs.usage_date,
  CASE
    WHEN rcs.pickup_datetime IS NULL THEN NULL
    ELSE rcs.pickup_datetime::timestamptz
  END AS pickup_datetime,
  rcs.vehicle_number,
  rcs.seat_number,
  rcs.sht_category,
  rcs.pickup_location,
  rcs.dropoff_location,
  rcs.passenger_count,
  rcs.car_count,
  rcs.car_price_code,
  rcs.dispatch_code,
  rcs.pickup_confirmed_at,
  rcs.dispatch_memo,
  rcs.request_note,
  COALESCE(rcs.created_at, now()) AS created_at,
  COALESCE(rcs.updated_at, now()) AS updated_at
FROM reservation_car_sht rcs
LEFT JOIN reservation r ON r.re_id = rcs.reservation_id
ON CONFLICT (legacy_car_sht_id) DO NOTHING;
