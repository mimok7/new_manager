-- customer와 동일 SQL 유지
BEGIN;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS rentcar_price_code TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS way_type TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS route TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS vehicle_type TEXT;

ALTER TABLE IF EXISTS reservation_cruise_car
  ADD COLUMN IF NOT EXISTS rental_type TEXT;

UPDATE reservation_cruise_car
SET rentcar_price_code = car_price_code
WHERE (rentcar_price_code IS NULL OR rentcar_price_code = '')
  AND car_price_code IS NOT NULL;

UPDATE reservation_cruise_car rcc
SET
  way_type = COALESCE(rcc.way_type, rp.way_type),
  route = COALESCE(rcc.route, rp.route),
  vehicle_type = COALESCE(rcc.vehicle_type, rp.vehicle_type),
  rental_type = COALESCE(rcc.rental_type, rp.rental_type)
FROM rentcar_price rp
WHERE rp.rent_code = rcc.rentcar_price_code;

CREATE INDEX IF NOT EXISTS idx_reservation_cruise_car_rentcar_price_code
  ON reservation_cruise_car(rentcar_price_code);

CREATE INDEX IF NOT EXISTS idx_reservation_cruise_car_way_type
  ON reservation_cruise_car(way_type);

COMMIT;

SELECT
  COUNT(*) AS total_rows,
  COUNT(rentcar_price_code) AS with_rentcar_price_code,
  COUNT(way_type) AS with_way_type,
  COUNT(route) AS with_route,
  COUNT(vehicle_type) AS with_vehicle_type
FROM reservation_cruise_car;
