CREATE TABLE seat_assignment (
    seat_assignment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_segment_id uuid NOT NULL,
    flight_segment_id uuid NOT NULL,
    aircraft_seat_id uuid NOT NULL REFERENCES aircraft_seat(aircraft_seat_id),
    assigned_at timestamptz NOT NULL,
    assignment_source varchar(20) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_seat_assignment_ticket_segment UNIQUE (ticket_segment_id),
    CONSTRAINT uq_seat_assignment_flight_seat UNIQUE (flight_segment_id, aircraft_seat_id),
    CONSTRAINT ck_seat_assignment_source CHECK (assignment_source IN ('AUTO', 'MANUAL', 'CUSTOMER')),
    CONSTRAINT fk_seat_assignment_ticket_segment FOREIGN KEY (ticket_segment_id, flight_segment_id)
        REFERENCES ticket_segment(ticket_segment_id, flight_segment_id)
);


