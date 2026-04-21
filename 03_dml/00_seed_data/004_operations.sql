-- 004_operations.sql
-- Airport, aircraft and flight operations dataset.

-- Additional location to satisfy origin/destination checks.
INSERT INTO state_province (country_id, state_code, state_name)
SELECT c.country_id, 'ANT', 'Antioquia'
FROM country c
WHERE c.iso_alpha2 = 'CO'
ON CONFLICT (country_id, state_name) DO UPDATE
SET
    state_code = EXCLUDED.state_code,
    updated_at = now();

INSERT INTO city (state_province_id, time_zone_id, city_name)
SELECT sp.state_province_id, tz.time_zone_id, 'Medellin'
FROM state_province sp
JOIN country c ON c.country_id = sp.country_id
JOIN time_zone tz ON tz.time_zone_name = 'America/Bogota'
WHERE c.iso_alpha2 = 'CO'
  AND sp.state_name = 'Antioquia'
ON CONFLICT (state_province_id, city_name) DO UPDATE
SET
    time_zone_id = EXCLUDED.time_zone_id,
    updated_at = now();

INSERT INTO district (city_id, district_name)
SELECT ci.city_id, 'El Poblado'
FROM city ci
WHERE ci.city_name = 'Medellin'
ON CONFLICT (city_id, district_name) DO NOTHING;

INSERT INTO address (district_id, address_line_1, address_line_2, postal_code, latitude, longitude)
SELECT d.district_id, 'Carrera 43A # 1 - 50', 'Zona Aeropuerto', '050021', 6.2088000, -75.5676000
FROM district d
JOIN city ci ON ci.city_id = d.city_id
WHERE ci.city_name = 'Medellin'
  AND d.district_name = 'El Poblado'
  AND NOT EXISTS (
      SELECT 1
      FROM address a
      WHERE a.district_id = d.district_id
        AND a.address_line_1 = 'Carrera 43A # 1 - 50'
  );

INSERT INTO airport (address_id, airport_name, iata_code, icao_code, is_active)
SELECT a.address_id, 'El Dorado International Airport', 'BOG', 'SKBO', true
FROM address a
WHERE a.address_line_1 = 'Calle 100 # 8A - 49'
ON CONFLICT (iata_code) DO UPDATE
SET
    address_id = EXCLUDED.address_id,
    airport_name = EXCLUDED.airport_name,
    icao_code = EXCLUDED.icao_code,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO airport (address_id, airport_name, iata_code, icao_code, is_active)
SELECT a.address_id, 'Jose Maria Cordova International Airport', 'MDE', 'SKRG', true
FROM address a
WHERE a.address_line_1 = 'Carrera 43A # 1 - 50'
ON CONFLICT (iata_code) DO UPDATE
SET
    address_id = EXCLUDED.address_id,
    airport_name = EXCLUDED.airport_name,
    icao_code = EXCLUDED.icao_code,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO terminal (airport_id, terminal_code, terminal_name)
SELECT ap.airport_id, 'T1', 'Main Terminal'
FROM airport ap
WHERE ap.iata_code = 'BOG'
ON CONFLICT (airport_id, terminal_code) DO UPDATE
SET
    terminal_name = EXCLUDED.terminal_name,
    updated_at = now();

INSERT INTO boarding_gate (terminal_id, gate_code, is_active)
SELECT t.terminal_id, 'A1', true
FROM terminal t
JOIN airport ap ON ap.airport_id = t.airport_id
WHERE ap.iata_code = 'BOG'
  AND t.terminal_code = 'T1'
ON CONFLICT (terminal_id, gate_code) DO UPDATE
SET
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO runway (airport_id, runway_code, length_meters, surface_type)
SELECT ap.airport_id, 'RWY-01', 3800, 'ASPHALT'
FROM airport ap
WHERE ap.iata_code = 'BOG'
ON CONFLICT (airport_id, runway_code) DO UPDATE
SET
    length_meters = EXCLUDED.length_meters,
    surface_type = EXCLUDED.surface_type,
    updated_at = now();

INSERT INTO airport_regulation (
    airport_id,
    regulation_code,
    regulation_title,
    issuing_authority,
    effective_from,
    effective_to
)
SELECT ap.airport_id, 'OPS-001', 'Standard Ground Ops', 'Aerocivil', date '2024-01-01', NULL
FROM airport ap
WHERE ap.iata_code = 'BOG'
ON CONFLICT (airport_id, regulation_code) DO UPDATE
SET
    regulation_title = EXCLUDED.regulation_title,
    issuing_authority = EXCLUDED.issuing_authority,
    effective_from = EXCLUDED.effective_from,
    effective_to = EXCLUDED.effective_to,
    updated_at = now();

INSERT INTO aircraft_manufacturer (manufacturer_name)
VALUES ('Airbus')
ON CONFLICT (manufacturer_name) DO UPDATE
SET
    updated_at = now();

INSERT INTO aircraft_model (aircraft_manufacturer_id, model_code, model_name, max_range_km)
SELECT am.aircraft_manufacturer_id, 'A320-200', 'Airbus A320-200', 6100
FROM aircraft_manufacturer am
WHERE am.manufacturer_name = 'Airbus'
ON CONFLICT (aircraft_manufacturer_id, model_code) DO UPDATE
SET
    model_name = EXCLUDED.model_name,
    max_range_km = EXCLUDED.max_range_km,
    updated_at = now();

INSERT INTO cabin_class (class_code, class_name)
VALUES
    ('ECON', 'Economy'),
    ('BUS', 'Business')
ON CONFLICT (class_code) DO UPDATE
SET
    class_name = EXCLUDED.class_name,
    updated_at = now();

INSERT INTO aircraft (
    airline_id,
    aircraft_model_id,
    registration_number,
    serial_number,
    in_service_on,
    retired_on
)
SELECT al.airline_id, am.aircraft_model_id, 'HK-1234', 'SN-ATD-0001', date '2020-01-01', NULL
FROM airline al
JOIN aircraft_model am ON am.model_code = 'A320-200'
WHERE al.airline_code = 'ATD'
ON CONFLICT (registration_number) DO UPDATE
SET
    airline_id = EXCLUDED.airline_id,
    aircraft_model_id = EXCLUDED.aircraft_model_id,
    serial_number = EXCLUDED.serial_number,
    in_service_on = EXCLUDED.in_service_on,
    retired_on = EXCLUDED.retired_on,
    updated_at = now();

INSERT INTO aircraft_cabin (aircraft_id, cabin_class_id, cabin_code, deck_number)
SELECT ac.aircraft_id, cc.cabin_class_id, 'Y', 1
FROM aircraft ac
JOIN cabin_class cc ON cc.class_code = 'ECON'
WHERE ac.registration_number = 'HK-1234'
ON CONFLICT (aircraft_id, cabin_code) DO UPDATE
SET
    cabin_class_id = EXCLUDED.cabin_class_id,
    deck_number = EXCLUDED.deck_number,
    updated_at = now();

INSERT INTO aircraft_seat (aircraft_cabin_id, seat_row_number, seat_column_code, is_window, is_aisle, is_exit_row)
SELECT cab.aircraft_cabin_id, 1, 'A', true, false, false
FROM aircraft_cabin cab
JOIN aircraft ac ON ac.aircraft_id = cab.aircraft_id
WHERE ac.registration_number = 'HK-1234'
  AND cab.cabin_code = 'Y'
ON CONFLICT (aircraft_cabin_id, seat_row_number, seat_column_code) DO UPDATE
SET
    is_window = EXCLUDED.is_window,
    is_aisle = EXCLUDED.is_aisle,
    is_exit_row = EXCLUDED.is_exit_row,
    updated_at = now();

INSERT INTO maintenance_provider (address_id, provider_name, contact_name)
SELECT a.address_id, 'TechMRO Colombia', 'Carlos Ruiz'
FROM address a
WHERE a.address_line_1 = 'Calle 100 # 8A - 49'
ON CONFLICT (provider_name) DO UPDATE
SET
    address_id = EXCLUDED.address_id,
    contact_name = EXCLUDED.contact_name,
    updated_at = now();

INSERT INTO maintenance_type (type_code, type_name)
VALUES ('LINE', 'Line Maintenance')
ON CONFLICT (type_code) DO UPDATE
SET
    type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO maintenance_event (
    aircraft_id,
    maintenance_type_id,
    maintenance_provider_id,
    status_code,
    started_at,
    completed_at,
    notes
)
SELECT ac.aircraft_id, mt.maintenance_type_id, mp.maintenance_provider_id,
       'COMPLETED', timestamptz '2024-03-01 08:00:00+00', timestamptz '2024-03-01 12:00:00+00',
       'Routine check'
FROM aircraft ac
JOIN maintenance_type mt ON mt.type_code = 'LINE'
JOIN maintenance_provider mp ON mp.provider_name = 'TechMRO Colombia'
WHERE ac.registration_number = 'HK-1234'
  AND NOT EXISTS (
      SELECT 1
      FROM maintenance_event me
      WHERE me.aircraft_id = ac.aircraft_id
        AND me.started_at = timestamptz '2024-03-01 08:00:00+00'
  );

INSERT INTO flight_status (status_code, status_name)
VALUES ('SCHEDULED', 'Scheduled')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO delay_reason_type (reason_code, reason_name)
VALUES ('WX', 'Weather')
ON CONFLICT (reason_code) DO UPDATE
SET
    reason_name = EXCLUDED.reason_name,
    updated_at = now();

INSERT INTO flight (airline_id, aircraft_id, flight_status_id, flight_number, service_date)
SELECT al.airline_id, ac.aircraft_id, fs.flight_status_id, 'ATD101', date '2024-04-10'
FROM airline al
JOIN aircraft ac ON ac.airline_id = al.airline_id
JOIN flight_status fs ON fs.status_code = 'SCHEDULED'
WHERE al.airline_code = 'ATD'
  AND ac.registration_number = 'HK-1234'
ON CONFLICT (airline_id, flight_number, service_date) DO UPDATE
SET
    aircraft_id = EXCLUDED.aircraft_id,
    flight_status_id = EXCLUDED.flight_status_id,
    updated_at = now();

INSERT INTO flight_segment (
    flight_id,
    origin_airport_id,
    destination_airport_id,
    segment_number,
    scheduled_departure_at,
    scheduled_arrival_at,
    actual_departure_at,
    actual_arrival_at
)
SELECT f.flight_id, ap_o.airport_id, ap_d.airport_id, 1,
       timestamptz '2024-04-10 13:00:00+00', timestamptz '2024-04-10 14:00:00+00',
       timestamptz '2024-04-10 13:10:00+00', timestamptz '2024-04-10 14:05:00+00'
FROM flight f
JOIN airport ap_o ON ap_o.iata_code = 'BOG'
JOIN airport ap_d ON ap_d.iata_code = 'MDE'
WHERE f.flight_number = 'ATD101'
  AND f.service_date = date '2024-04-10'
ON CONFLICT (flight_id, segment_number) DO UPDATE
SET
    origin_airport_id = EXCLUDED.origin_airport_id,
    destination_airport_id = EXCLUDED.destination_airport_id,
    scheduled_departure_at = EXCLUDED.scheduled_departure_at,
    scheduled_arrival_at = EXCLUDED.scheduled_arrival_at,
    actual_departure_at = EXCLUDED.actual_departure_at,
    actual_arrival_at = EXCLUDED.actual_arrival_at,
    updated_at = now();

INSERT INTO flight_delay (flight_segment_id, delay_reason_type_id, reported_at, delay_minutes, notes)
SELECT fs.flight_segment_id, dr.delay_reason_type_id, timestamptz '2024-04-10 13:05:00+00', 10, 'Minor weather delay'
FROM flight_segment fs
JOIN flight f ON f.flight_id = fs.flight_id
JOIN delay_reason_type dr ON dr.reason_code = 'WX'
WHERE f.flight_number = 'ATD101'
  AND f.service_date = date '2024-04-10'
  AND fs.segment_number = 1
  AND NOT EXISTS (
      SELECT 1
      FROM flight_delay fd
      WHERE fd.flight_segment_id = fs.flight_segment_id
        AND fd.reported_at = timestamptz '2024-04-10 13:05:00+00'
  );
