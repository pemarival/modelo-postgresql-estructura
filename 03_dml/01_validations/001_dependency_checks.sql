-- 001_dependency_checks.sql
-- Dependency-oriented checks for test data integrity.

DO $$
DECLARE
    v_count integer;
BEGIN
    -- Domain coverage checks.
    SELECT count(*) INTO v_count FROM airline WHERE airline_code = 'ATD';
    IF v_count = 0 THEN
        RAISE EXCEPTION 'Validation failed: airline ATD not found.';
    END IF;

    SELECT count(*) INTO v_count FROM person WHERE first_name = 'Maria' AND last_name = 'Lopez';
    IF v_count = 0 THEN
        RAISE EXCEPTION 'Validation failed: person Maria Lopez not found.';
    END IF;

    SELECT count(*) INTO v_count FROM flight WHERE flight_number = 'ATD101' AND service_date = date '2024-04-10';
    IF v_count = 0 THEN
        RAISE EXCEPTION 'Validation failed: flight ATD101 not found.';
    END IF;

    SELECT count(*) INTO v_count FROM sale WHERE sale_code = 'SAL-ATD-0001';
    IF v_count = 0 THEN
        RAISE EXCEPTION 'Validation failed: sale SAL-ATD-0001 not found.';
    END IF;

    -- Foreign key relationship checks with explicit assertions.
    SELECT count(*) INTO v_count
    FROM customer c
    LEFT JOIN person p ON p.person_id = c.person_id
    LEFT JOIN airline a ON a.airline_id = c.airline_id
    WHERE p.person_id IS NULL OR a.airline_id IS NULL;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Validation failed: customer has broken dependencies (% rows).', v_count;
    END IF;

    SELECT count(*) INTO v_count
    FROM reservation_passenger rp
    LEFT JOIN reservation r ON r.reservation_id = rp.reservation_id
    LEFT JOIN person p ON p.person_id = rp.person_id
    WHERE r.reservation_id IS NULL OR p.person_id IS NULL;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Validation failed: reservation_passenger has broken dependencies (% rows).', v_count;
    END IF;

    SELECT count(*) INTO v_count
    FROM ticket_segment ts
    LEFT JOIN ticket t ON t.ticket_id = ts.ticket_id
    LEFT JOIN flight_segment fs ON fs.flight_segment_id = ts.flight_segment_id
    WHERE t.ticket_id IS NULL OR fs.flight_segment_id IS NULL;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Validation failed: ticket_segment has broken dependencies (% rows).', v_count;
    END IF;

    SELECT count(*) INTO v_count
    FROM payment p
    LEFT JOIN sale s ON s.sale_id = p.sale_id
    LEFT JOIN payment_status ps ON ps.payment_status_id = p.payment_status_id
    LEFT JOIN payment_method pm ON pm.payment_method_id = p.payment_method_id
    WHERE s.sale_id IS NULL OR ps.payment_status_id IS NULL OR pm.payment_method_id IS NULL;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Validation failed: payment has broken dependencies (% rows).', v_count;
    END IF;

    SELECT count(*) INTO v_count
    FROM invoice_line il
    LEFT JOIN invoice i ON i.invoice_id = il.invoice_id
    WHERE i.invoice_id IS NULL;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Validation failed: invoice_line has broken dependencies (% rows).', v_count;
    END IF;

    RAISE NOTICE 'Dependency validations passed successfully.';
END;
$$;
