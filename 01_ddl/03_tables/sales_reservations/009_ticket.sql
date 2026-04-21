CREATE TABLE ticket (
    ticket_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    sale_id uuid NOT NULL REFERENCES sale(sale_id),
    reservation_passenger_id uuid NOT NULL REFERENCES reservation_passenger(reservation_passenger_id),
    fare_id uuid NOT NULL REFERENCES fare(fare_id),
    ticket_status_id uuid NOT NULL REFERENCES ticket_status(ticket_status_id),
    ticket_number varchar(20) NOT NULL,
    issued_at timestamptz NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_ticket_number UNIQUE (ticket_number)
);


