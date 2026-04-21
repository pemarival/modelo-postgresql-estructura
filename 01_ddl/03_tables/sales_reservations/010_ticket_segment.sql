CREATE TABLE ticket_segment (
    ticket_segment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id uuid NOT NULL REFERENCES ticket(ticket_id),
    flight_segment_id uuid NOT NULL REFERENCES flight_segment(flight_segment_id),
    segment_sequence_no integer NOT NULL,
    fare_basis_code varchar(20),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_ticket_segment_sequence UNIQUE (ticket_id, segment_sequence_no),
    CONSTRAINT uq_ticket_segment_flight UNIQUE (ticket_id, flight_segment_id),
    CONSTRAINT uq_ticket_segment_pair UNIQUE (ticket_segment_id, flight_segment_id),
    CONSTRAINT ck_ticket_segment_sequence CHECK (segment_sequence_no > 0)
);


