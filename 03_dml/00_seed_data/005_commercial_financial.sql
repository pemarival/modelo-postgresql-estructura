-- 005_commercial_financial.sql
-- Sales, boarding, payment and billing dataset.

INSERT INTO reservation_status (status_code, status_name)
VALUES ('CONFIRMED', 'Confirmed')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO sale_channel (channel_code, channel_name)
VALUES ('WEB', 'Web')
ON CONFLICT (channel_code) DO UPDATE
SET
    channel_name = EXCLUDED.channel_name,
    updated_at = now();

INSERT INTO fare_class (cabin_class_id, fare_class_code, fare_class_name, is_refundable_by_default)
SELECT cc.cabin_class_id, 'YB', 'Economy Basic', false
FROM cabin_class cc
WHERE cc.class_code = 'ECON'
ON CONFLICT (fare_class_code) DO UPDATE
SET
    cabin_class_id = EXCLUDED.cabin_class_id,
    fare_class_name = EXCLUDED.fare_class_name,
    is_refundable_by_default = EXCLUDED.is_refundable_by_default,
    updated_at = now();

INSERT INTO fare (
    airline_id,
    origin_airport_id,
    destination_airport_id,
    fare_class_id,
    currency_id,
    fare_code,
    base_amount,
    valid_from,
    valid_to,
    baggage_allowance_qty,
    change_penalty_amount,
    refund_penalty_amount
)
SELECT al.airline_id, ap_o.airport_id, ap_d.airport_id, fc.fare_class_id, cu.currency_id,
       'ATD-YB-BOG-MDE', 350000.00, date '2024-01-01', NULL, 1, 50000.00, 80000.00
FROM airline al
JOIN airport ap_o ON ap_o.iata_code = 'BOG'
JOIN airport ap_d ON ap_d.iata_code = 'MDE'
JOIN fare_class fc ON fc.fare_class_code = 'YB'
JOIN currency cu ON cu.iso_currency_code = 'COP'
WHERE al.airline_code = 'ATD'
ON CONFLICT (fare_code) DO UPDATE
SET
    airline_id = EXCLUDED.airline_id,
    origin_airport_id = EXCLUDED.origin_airport_id,
    destination_airport_id = EXCLUDED.destination_airport_id,
    fare_class_id = EXCLUDED.fare_class_id,
    currency_id = EXCLUDED.currency_id,
    base_amount = EXCLUDED.base_amount,
    valid_from = EXCLUDED.valid_from,
    valid_to = EXCLUDED.valid_to,
    baggage_allowance_qty = EXCLUDED.baggage_allowance_qty,
    change_penalty_amount = EXCLUDED.change_penalty_amount,
    refund_penalty_amount = EXCLUDED.refund_penalty_amount,
    updated_at = now();

INSERT INTO ticket_status (status_code, status_name)
VALUES ('ISSUED', 'Issued')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO reservation (
    booked_by_customer_id,
    reservation_status_id,
    sale_channel_id,
    reservation_code,
    booked_at,
    expires_at,
    notes
)
SELECT c.customer_id, rs.reservation_status_id, sc.sale_channel_id,
       'RSV-ATD-0001', timestamptz '2024-04-01 10:00:00+00', timestamptz '2024-04-03 10:00:00+00',
       'Test reservation'
FROM customer c
JOIN reservation_status rs ON rs.status_code = 'CONFIRMED'
JOIN sale_channel sc ON sc.channel_code = 'WEB'
ON CONFLICT (reservation_code) DO UPDATE
SET
    booked_by_customer_id = EXCLUDED.booked_by_customer_id,
    reservation_status_id = EXCLUDED.reservation_status_id,
    sale_channel_id = EXCLUDED.sale_channel_id,
    booked_at = EXCLUDED.booked_at,
    expires_at = EXCLUDED.expires_at,
    notes = EXCLUDED.notes,
    updated_at = now();

INSERT INTO reservation_passenger (
    reservation_id,
    person_id,
    passenger_sequence_no,
    passenger_type
)
SELECT r.reservation_id, p.person_id, 1, 'ADULT'
FROM reservation r
JOIN person p ON p.first_name = 'Maria' AND p.last_name = 'Lopez'
WHERE r.reservation_code = 'RSV-ATD-0001'
ON CONFLICT (reservation_id, person_id) DO UPDATE
SET
    passenger_sequence_no = EXCLUDED.passenger_sequence_no,
    passenger_type = EXCLUDED.passenger_type,
    updated_at = now();

INSERT INTO sale (reservation_id, currency_id, sale_code, sold_at, external_reference)
SELECT r.reservation_id, cu.currency_id, 'SAL-ATD-0001', timestamptz '2024-04-01 10:05:00+00', 'EXT-0001'
FROM reservation r
JOIN currency cu ON cu.iso_currency_code = 'COP'
WHERE r.reservation_code = 'RSV-ATD-0001'
ON CONFLICT (sale_code) DO UPDATE
SET
    reservation_id = EXCLUDED.reservation_id,
    currency_id = EXCLUDED.currency_id,
    sold_at = EXCLUDED.sold_at,
    external_reference = EXCLUDED.external_reference,
    updated_at = now();

INSERT INTO ticket (
    sale_id,
    reservation_passenger_id,
    fare_id,
    ticket_status_id,
    ticket_number,
    issued_at
)
SELECT s.sale_id, rp.reservation_passenger_id, f.fare_id, ts.ticket_status_id,
       'TKT-0001', timestamptz '2024-04-01 10:06:00+00'
FROM sale s
JOIN reservation_passenger rp ON rp.reservation_id = s.reservation_id
JOIN fare f ON f.fare_code = 'ATD-YB-BOG-MDE'
JOIN ticket_status ts ON ts.status_code = 'ISSUED'
WHERE s.sale_code = 'SAL-ATD-0001'
ON CONFLICT (ticket_number) DO UPDATE
SET
    sale_id = EXCLUDED.sale_id,
    reservation_passenger_id = EXCLUDED.reservation_passenger_id,
    fare_id = EXCLUDED.fare_id,
    ticket_status_id = EXCLUDED.ticket_status_id,
    issued_at = EXCLUDED.issued_at,
    updated_at = now();

INSERT INTO ticket_segment (ticket_id, flight_segment_id, segment_sequence_no, fare_basis_code)
SELECT t.ticket_id, fs.flight_segment_id, 1, 'YBASIC'
FROM ticket t
JOIN flight_segment fs ON fs.segment_number = 1
JOIN flight f ON f.flight_id = fs.flight_id
WHERE t.ticket_number = 'TKT-0001'
  AND f.flight_number = 'ATD101'
ON CONFLICT (ticket_id, segment_sequence_no) DO UPDATE
SET
    flight_segment_id = EXCLUDED.flight_segment_id,
    fare_basis_code = EXCLUDED.fare_basis_code,
    updated_at = now();

INSERT INTO seat_assignment (
    ticket_segment_id,
    flight_segment_id,
    aircraft_seat_id,
    assigned_at,
    assignment_source
)
SELECT ts.ticket_segment_id, ts.flight_segment_id, aseat.aircraft_seat_id,
       timestamptz '2024-04-01 10:10:00+00', 'AUTO'
FROM ticket_segment ts
JOIN ticket t ON t.ticket_id = ts.ticket_id
JOIN aircraft_seat aseat ON aseat.seat_row_number = 1 AND aseat.seat_column_code = 'A'
WHERE t.ticket_number = 'TKT-0001'
ON CONFLICT (ticket_segment_id) DO UPDATE
SET
    flight_segment_id = EXCLUDED.flight_segment_id,
    aircraft_seat_id = EXCLUDED.aircraft_seat_id,
    assigned_at = EXCLUDED.assigned_at,
    assignment_source = EXCLUDED.assignment_source,
    updated_at = now();

INSERT INTO baggage (
    ticket_segment_id,
    baggage_tag,
    baggage_type,
    baggage_status,
    weight_kg,
    checked_at
)
SELECT ts.ticket_segment_id, 'BAG-0001', 'CHECKED', 'REGISTERED', 18.50, timestamptz '2024-04-10 11:30:00+00'
FROM ticket_segment ts
JOIN ticket t ON t.ticket_id = ts.ticket_id
WHERE t.ticket_number = 'TKT-0001'
ON CONFLICT (baggage_tag) DO UPDATE
SET
    ticket_segment_id = EXCLUDED.ticket_segment_id,
    baggage_type = EXCLUDED.baggage_type,
    baggage_status = EXCLUDED.baggage_status,
    weight_kg = EXCLUDED.weight_kg,
    checked_at = EXCLUDED.checked_at,
    updated_at = now();

INSERT INTO boarding_group (group_code, group_name, sequence_no)
VALUES ('A', 'Group A', 1)
ON CONFLICT (group_code) DO UPDATE
SET
    group_name = EXCLUDED.group_name,
    sequence_no = EXCLUDED.sequence_no,
    updated_at = now();

INSERT INTO check_in_status (status_code, status_name)
VALUES ('COMPLETED', 'Completed')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO check_in (
    ticket_segment_id,
    check_in_status_id,
    boarding_group_id,
    checked_in_by_user_id,
    checked_in_at
)
SELECT ts.ticket_segment_id, cis.check_in_status_id, bg.boarding_group_id,
       ua.user_account_id, timestamptz '2024-04-10 11:40:00+00'
FROM ticket_segment ts
JOIN ticket t ON t.ticket_id = ts.ticket_id
JOIN check_in_status cis ON cis.status_code = 'COMPLETED'
JOIN boarding_group bg ON bg.group_code = 'A'
JOIN user_account ua ON ua.username = 'maria.lopez'
WHERE t.ticket_number = 'TKT-0001'
ON CONFLICT (ticket_segment_id) DO UPDATE
SET
    check_in_status_id = EXCLUDED.check_in_status_id,
    boarding_group_id = EXCLUDED.boarding_group_id,
    checked_in_by_user_id = EXCLUDED.checked_in_by_user_id,
    checked_in_at = EXCLUDED.checked_in_at,
    updated_at = now();

INSERT INTO boarding_pass (check_in_id, boarding_pass_code, barcode_value, issued_at)
SELECT ci.check_in_id, 'BP-0001', 'BARCODE-0001', timestamptz '2024-04-10 11:45:00+00'
FROM check_in ci
JOIN ticket_segment ts ON ts.ticket_segment_id = ci.ticket_segment_id
JOIN ticket t ON t.ticket_id = ts.ticket_id
WHERE t.ticket_number = 'TKT-0001'
ON CONFLICT (boarding_pass_code) DO UPDATE
SET
    check_in_id = EXCLUDED.check_in_id,
    barcode_value = EXCLUDED.barcode_value,
    issued_at = EXCLUDED.issued_at,
    updated_at = now();

INSERT INTO boarding_validation (
    boarding_pass_id,
    boarding_gate_id,
    validated_by_user_id,
    validated_at,
    validation_result,
    notes
)
SELECT bp.boarding_pass_id, bg.boarding_gate_id, ua.user_account_id,
       timestamptz '2024-04-10 12:50:00+00', 'APPROVED', 'Validation successful'
FROM boarding_pass bp
JOIN check_in ci ON ci.check_in_id = bp.check_in_id
JOIN ticket_segment ts ON ts.ticket_segment_id = ci.ticket_segment_id
JOIN ticket t ON t.ticket_id = ts.ticket_id
JOIN boarding_gate bg ON bg.gate_code = 'A1'
JOIN user_account ua ON ua.username = 'maria.lopez'
WHERE t.ticket_number = 'TKT-0001'
  AND NOT EXISTS (
      SELECT 1
      FROM boarding_validation bv
      WHERE bv.boarding_pass_id = bp.boarding_pass_id
        AND bv.validated_at = timestamptz '2024-04-10 12:50:00+00'
  );

INSERT INTO payment_status (status_code, status_name)
VALUES ('CAPTURED', 'Captured')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO payment_method (method_code, method_name)
VALUES ('CARD', 'Credit Card')
ON CONFLICT (method_code) DO UPDATE
SET
    method_name = EXCLUDED.method_name,
    updated_at = now();

INSERT INTO payment (
    sale_id,
    payment_status_id,
    payment_method_id,
    currency_id,
    payment_reference,
    amount,
    authorized_at
)
SELECT s.sale_id, ps.payment_status_id, pm.payment_method_id, c.currency_id,
       'PAY-0001', 350000.00, timestamptz '2024-04-01 10:07:00+00'
FROM sale s
JOIN payment_status ps ON ps.status_code = 'CAPTURED'
JOIN payment_method pm ON pm.method_code = 'CARD'
JOIN currency c ON c.iso_currency_code = 'COP'
WHERE s.sale_code = 'SAL-ATD-0001'
ON CONFLICT (payment_reference) DO UPDATE
SET
    sale_id = EXCLUDED.sale_id,
    payment_status_id = EXCLUDED.payment_status_id,
    payment_method_id = EXCLUDED.payment_method_id,
    currency_id = EXCLUDED.currency_id,
    amount = EXCLUDED.amount,
    authorized_at = EXCLUDED.authorized_at,
    updated_at = now();

INSERT INTO payment_transaction (
    payment_id,
    transaction_reference,
    transaction_type,
    transaction_amount,
    processed_at,
    provider_message
)
SELECT p.payment_id, 'PTX-0001', 'CAPTURE', 350000.00, timestamptz '2024-04-01 10:08:00+00', 'Approved'
FROM payment p
WHERE p.payment_reference = 'PAY-0001'
ON CONFLICT (transaction_reference) DO UPDATE
SET
    payment_id = EXCLUDED.payment_id,
    transaction_type = EXCLUDED.transaction_type,
    transaction_amount = EXCLUDED.transaction_amount,
    processed_at = EXCLUDED.processed_at,
    provider_message = EXCLUDED.provider_message,
    updated_at = now();

INSERT INTO refund (
    payment_id,
    refund_reference,
    amount,
    requested_at,
    processed_at,
    refund_reason
)
SELECT p.payment_id, 'RF-0001', 50000.00, timestamptz '2024-04-15 09:00:00+00', timestamptz '2024-04-15 10:00:00+00', 'Schedule change'
FROM payment p
WHERE p.payment_reference = 'PAY-0001'
ON CONFLICT (refund_reference) DO UPDATE
SET
    payment_id = EXCLUDED.payment_id,
    amount = EXCLUDED.amount,
    requested_at = EXCLUDED.requested_at,
    processed_at = EXCLUDED.processed_at,
    refund_reason = EXCLUDED.refund_reason,
    updated_at = now();

INSERT INTO tax (tax_code, tax_name, rate_percentage, effective_from, effective_to)
VALUES ('VAT19', 'VAT 19 Percent', 19.000, date '2024-01-01', NULL)
ON CONFLICT (tax_code) DO UPDATE
SET
    tax_name = EXCLUDED.tax_name,
    rate_percentage = EXCLUDED.rate_percentage,
    effective_from = EXCLUDED.effective_from,
    effective_to = EXCLUDED.effective_to,
    updated_at = now();

INSERT INTO exchange_rate (from_currency_id, to_currency_id, effective_date, rate_value)
SELECT c_from.currency_id, c_to.currency_id, date '2024-04-01', 0.00026000
FROM currency c_from
JOIN currency c_to ON c_to.iso_currency_code = 'USD'
WHERE c_from.iso_currency_code = 'COP'
ON CONFLICT (from_currency_id, to_currency_id, effective_date) DO NOTHING;

INSERT INTO invoice_status (status_code, status_name)
VALUES ('ISSUED', 'Issued')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO invoice (
    sale_id,
    invoice_status_id,
    currency_id,
    invoice_number,
    issued_at,
    due_at,
    notes
)
SELECT s.sale_id, ist.invoice_status_id, c.currency_id,
       'INV-0001', timestamptz '2024-04-01 10:09:00+00', timestamptz '2024-04-30 23:59:00+00',
       'Test invoice'
FROM sale s
JOIN invoice_status ist ON ist.status_code = 'ISSUED'
JOIN currency c ON c.iso_currency_code = 'COP'
WHERE s.sale_code = 'SAL-ATD-0001'
ON CONFLICT (invoice_number) DO UPDATE
SET
    sale_id = EXCLUDED.sale_id,
    invoice_status_id = EXCLUDED.invoice_status_id,
    currency_id = EXCLUDED.currency_id,
    issued_at = EXCLUDED.issued_at,
    due_at = EXCLUDED.due_at,
    notes = EXCLUDED.notes,
    updated_at = now();

INSERT INTO invoice_line (
    invoice_id,
    tax_id,
    line_number,
    line_description,
    quantity,
    unit_price
)
SELECT i.invoice_id, t.tax_id, 1, 'Base fare', 1.00, 350000.00
FROM invoice i
JOIN tax t ON t.tax_code = 'VAT19'
WHERE i.invoice_number = 'INV-0001'
ON CONFLICT (invoice_id, line_number) DO UPDATE
SET
    tax_id = EXCLUDED.tax_id,
    line_description = EXCLUDED.line_description,
    quantity = EXCLUDED.quantity,
    unit_price = EXCLUDED.unit_price,
    updated_at = now();
