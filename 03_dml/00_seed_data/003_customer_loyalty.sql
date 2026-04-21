-- 003_customer_loyalty.sql
-- Customer and loyalty dataset dependent on airline, identity and currency.

INSERT INTO customer_category (category_code, category_name)
VALUES ('REGULAR', 'Regular Customer')
ON CONFLICT (category_code) DO UPDATE
SET
    category_name = EXCLUDED.category_name,
    updated_at = now();

INSERT INTO benefit_type (benefit_code, benefit_name, benefit_description)
VALUES ('PRIORITY_BOARDING', 'Priority Boarding', 'Allows passenger to board first.')
ON CONFLICT (benefit_code) DO UPDATE
SET
    benefit_name = EXCLUDED.benefit_name,
    benefit_description = EXCLUDED.benefit_description,
    updated_at = now();

INSERT INTO loyalty_program (
    airline_id,
    default_currency_id,
    program_code,
    program_name,
    expiration_months
)
SELECT a.airline_id, c.currency_id, 'ATDPLUS', 'Aero Test Plus', 24
FROM airline a
JOIN currency c ON c.iso_currency_code = 'COP'
WHERE a.airline_code = 'ATD'
ON CONFLICT (airline_id, program_code) DO UPDATE
SET
    default_currency_id = EXCLUDED.default_currency_id,
    program_name = EXCLUDED.program_name,
    expiration_months = EXCLUDED.expiration_months,
    updated_at = now();

INSERT INTO loyalty_tier (
    loyalty_program_id,
    tier_code,
    tier_name,
    priority_level,
    required_miles
)
SELECT lp.loyalty_program_id, 'SILVER', 'Silver', 1, 10000
FROM loyalty_program lp
WHERE lp.program_code = 'ATDPLUS'
ON CONFLICT (loyalty_program_id, tier_code) DO UPDATE
SET
    tier_name = EXCLUDED.tier_name,
    priority_level = EXCLUDED.priority_level,
    required_miles = EXCLUDED.required_miles,
    updated_at = now();

INSERT INTO customer (airline_id, person_id, customer_category_id, customer_since)
SELECT a.airline_id, p.person_id, cc.customer_category_id, date '2024-01-10'
FROM airline a
JOIN person p ON p.first_name = 'Maria' AND p.last_name = 'Lopez'
JOIN customer_category cc ON cc.category_code = 'REGULAR'
WHERE a.airline_code = 'ATD'
ON CONFLICT (airline_id, person_id) DO UPDATE
SET
    customer_category_id = EXCLUDED.customer_category_id,
    customer_since = EXCLUDED.customer_since,
    updated_at = now();

INSERT INTO loyalty_account (customer_id, loyalty_program_id, account_number)
SELECT c.customer_id, lp.loyalty_program_id, 'ATD-LOY-0001'
FROM customer c
JOIN loyalty_program lp ON lp.program_code = 'ATDPLUS'
ON CONFLICT (account_number) DO UPDATE
SET
    customer_id = EXCLUDED.customer_id,
    loyalty_program_id = EXCLUDED.loyalty_program_id,
    updated_at = now();

INSERT INTO loyalty_account_tier (loyalty_account_id, loyalty_tier_id, assigned_at)
SELECT la.loyalty_account_id, lt.loyalty_tier_id, timestamptz '2024-01-10 00:00:00+00'
FROM loyalty_account la
JOIN loyalty_tier lt ON lt.tier_code = 'SILVER'
WHERE la.account_number = 'ATD-LOY-0001'
ON CONFLICT (loyalty_account_id, assigned_at) DO UPDATE
SET
    loyalty_tier_id = EXCLUDED.loyalty_tier_id,
    updated_at = now();

INSERT INTO miles_transaction (
    loyalty_account_id,
    transaction_type,
    miles_delta,
    occurred_at,
    reference_code,
    notes
)
SELECT la.loyalty_account_id, 'EARN', 1500, timestamptz '2024-02-01 10:00:00+00', 'MTX-0001', 'Initial welcome bonus'
FROM loyalty_account la
WHERE la.account_number = 'ATD-LOY-0001'
  AND NOT EXISTS (
      SELECT 1
      FROM miles_transaction mt
      WHERE mt.reference_code = 'MTX-0001'
  );

INSERT INTO customer_benefit (customer_id, benefit_type_id, granted_at, notes)
SELECT c.customer_id, bt.benefit_type_id, timestamptz '2024-02-05 12:00:00+00', 'Granted by onboarding policy'
FROM customer c
JOIN benefit_type bt ON bt.benefit_code = 'PRIORITY_BOARDING'
WHERE NOT EXISTS (
    SELECT 1
    FROM customer_benefit cb
    WHERE cb.customer_id = c.customer_id
      AND cb.benefit_type_id = bt.benefit_type_id
      AND cb.granted_at = timestamptz '2024-02-05 12:00:00+00'
);
