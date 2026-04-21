CREATE TABLE flight_delay (
    flight_delay_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    flight_segment_id uuid NOT NULL REFERENCES flight_segment(flight_segment_id),
    delay_reason_type_id uuid NOT NULL REFERENCES delay_reason_type(delay_reason_type_id),
    reported_at timestamptz NOT NULL,
    delay_minutes integer NOT NULL,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_flight_delay_minutes CHECK (delay_minutes > 0)
);


