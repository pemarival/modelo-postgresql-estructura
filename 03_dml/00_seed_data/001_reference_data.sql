-- 001_reference_data.sql
-- Base reference dataset. This block must run first.

INSERT INTO time_zone (time_zone_name, utc_offset_minutes)
VALUES ('America/Bogota', -300)
ON CONFLICT (time_zone_name) DO UPDATE
SET
    utc_offset_minutes = EXCLUDED.utc_offset_minutes,
    updated_at = now();

INSERT INTO continent (continent_code, continent_name)
VALUES ('SAM', 'South America')
ON CONFLICT (continent_code) DO UPDATE
SET
    continent_name = EXCLUDED.continent_name,
    updated_at = now();

INSERT INTO country (continent_id, iso_alpha2, iso_alpha3, country_name)
SELECT c.continent_id, 'CO', 'COL', 'Colombia'
FROM continent c
WHERE c.continent_code = 'SAM'
ON CONFLICT (iso_alpha2) DO UPDATE
SET
    continent_id = EXCLUDED.continent_id,
    iso_alpha3 = EXCLUDED.iso_alpha3,
    country_name = EXCLUDED.country_name,
    updated_at = now();

INSERT INTO state_province (country_id, state_code, state_name)
SELECT c.country_id, 'DC', 'Bogota'
FROM country c
WHERE c.iso_alpha2 = 'CO'
ON CONFLICT (country_id, state_name) DO UPDATE
SET
    state_code = EXCLUDED.state_code,
    updated_at = now();

INSERT INTO city (state_province_id, time_zone_id, city_name)
SELECT sp.state_province_id, tz.time_zone_id, 'Bogota'
FROM state_province sp
JOIN country c ON c.country_id = sp.country_id
JOIN time_zone tz ON tz.time_zone_name = 'America/Bogota'
WHERE c.iso_alpha2 = 'CO'
  AND sp.state_name = 'Bogota'
ON CONFLICT (state_province_id, city_name) DO UPDATE
SET
    time_zone_id = EXCLUDED.time_zone_id,
    updated_at = now();

INSERT INTO district (city_id, district_name)
SELECT ci.city_id, 'Chapinero'
FROM city ci
JOIN state_province sp ON sp.state_province_id = ci.state_province_id
JOIN country c ON c.country_id = sp.country_id
WHERE c.iso_alpha2 = 'CO'
  AND ci.city_name = 'Bogota'
ON CONFLICT (city_id, district_name) DO NOTHING;

INSERT INTO address (district_id, address_line_1, address_line_2, postal_code, latitude, longitude)
SELECT d.district_id, 'Calle 100 # 8A - 49', 'Torre Test', '110111', 4.6872000, -74.0621000
FROM district d
JOIN city ci ON ci.city_id = d.city_id
WHERE ci.city_name = 'Bogota'
  AND d.district_name = 'Chapinero'
  AND NOT EXISTS (
      SELECT 1
      FROM address a
      WHERE a.district_id = d.district_id
        AND a.address_line_1 = 'Calle 100 # 8A - 49'
  );

INSERT INTO currency (iso_currency_code, currency_name, currency_symbol, minor_units)
VALUES ('COP', 'Colombian Peso', '$', 2)
ON CONFLICT (iso_currency_code) DO UPDATE
SET
    currency_name = EXCLUDED.currency_name,
    currency_symbol = EXCLUDED.currency_symbol,
    minor_units = EXCLUDED.minor_units,
    updated_at = now();

  INSERT INTO currency (iso_currency_code, currency_name, currency_symbol, minor_units)
  VALUES ('USD', 'US Dollar', '$', 2)
  ON CONFLICT (iso_currency_code) DO UPDATE
  SET
    currency_name = EXCLUDED.currency_name,
    currency_symbol = EXCLUDED.currency_symbol,
    minor_units = EXCLUDED.minor_units,
    updated_at = now();
