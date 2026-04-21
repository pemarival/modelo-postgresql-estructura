-- 002_identity_security.sql
-- Identity and security baseline data.

INSERT INTO airline (home_country_id, airline_code, airline_name, iata_code, icao_code, is_active)
SELECT c.country_id, 'ATD', 'Aero Test Demo', 'AT', 'ATD', true
FROM country c
WHERE c.iso_alpha2 = 'CO'
ON CONFLICT (airline_code) DO UPDATE
SET
    home_country_id = EXCLUDED.home_country_id,
    airline_name = EXCLUDED.airline_name,
    iata_code = EXCLUDED.iata_code,
    icao_code = EXCLUDED.icao_code,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO person_type (type_code, type_name)
VALUES
    ('PASSENGER', 'Passenger'),
    ('EMPLOYEE', 'Employee')
ON CONFLICT (type_code) DO UPDATE
SET
    type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO document_type (type_code, type_name)
VALUES
    ('CC', 'Citizenship ID'),
    ('PP', 'Passport')
ON CONFLICT (type_code) DO UPDATE
SET
    type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO contact_type (type_code, type_name)
VALUES
    ('EMAIL', 'Email'),
    ('PHONE', 'Phone')
ON CONFLICT (type_code) DO UPDATE
SET
    type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO person (
    person_type_id,
    nationality_country_id,
    first_name,
    middle_name,
    last_name,
    second_last_name,
    birth_date,
    gender_code
)
SELECT pt.person_type_id, c.country_id, 'Maria', 'Elena', 'Lopez', 'Diaz', date '1994-06-15', 'F'
FROM person_type pt
JOIN country c ON c.iso_alpha2 = 'CO'
WHERE pt.type_code = 'PASSENGER'
  AND NOT EXISTS (
      SELECT 1
      FROM person p
      WHERE p.first_name = 'Maria'
        AND p.last_name = 'Lopez'
        AND p.birth_date = date '1994-06-15'
  );

INSERT INTO person_document (
    person_id,
    document_type_id,
    issuing_country_id,
    document_number,
    issued_on,
    expires_on
)
SELECT p.person_id, dt.document_type_id, c.country_id, '1012345678', date '2018-01-01', date '2030-01-01'
FROM person p
JOIN document_type dt ON dt.type_code = 'CC'
JOIN country c ON c.iso_alpha2 = 'CO'
WHERE p.first_name = 'Maria'
  AND p.last_name = 'Lopez'
ON CONFLICT (document_type_id, issuing_country_id, document_number) DO UPDATE
SET
    person_id = EXCLUDED.person_id,
    issued_on = EXCLUDED.issued_on,
    expires_on = EXCLUDED.expires_on,
    updated_at = now();

INSERT INTO person_contact (person_id, contact_type_id, contact_value, is_primary)
SELECT p.person_id, ct.contact_type_id, 'maria.lopez@test-airline.com', true
FROM person p
JOIN contact_type ct ON ct.type_code = 'EMAIL'
WHERE p.first_name = 'Maria'
  AND p.last_name = 'Lopez'
ON CONFLICT (person_id, contact_type_id, contact_value) DO UPDATE
SET
    is_primary = EXCLUDED.is_primary,
    updated_at = now();

INSERT INTO user_status (status_code, status_name)
VALUES ('ACTIVE', 'Active')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO user_account (person_id, user_status_id, username, password_hash)
SELECT p.person_id, us.user_status_id, 'maria.lopez', 'hash_demo_01'
FROM person p
JOIN user_status us ON us.status_code = 'ACTIVE'
WHERE p.first_name = 'Maria'
  AND p.last_name = 'Lopez'
ON CONFLICT (username) DO UPDATE
SET
    person_id = EXCLUDED.person_id,
    user_status_id = EXCLUDED.user_status_id,
    password_hash = EXCLUDED.password_hash,
    updated_at = now();

INSERT INTO user_role (user_account_id, security_role_id, assigned_by_user_id)
SELECT ua.user_account_id, sr.security_role_id, ua.user_account_id
FROM user_account ua
JOIN security_role sr ON sr.role_code = 'SUPPORT_AGENT'
WHERE ua.username = 'maria.lopez'
ON CONFLICT (user_account_id, security_role_id) DO NOTHING;
