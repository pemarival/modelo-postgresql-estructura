CREATE TABLE flight_segment (
    flight_segment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    flight_id uuid NOT NULL REFERENCES flight(flight_id),
    origin_airport_id uuid NOT NULL REFERENCES airport(airport_id),
    destination_airport_id uuid NOT NULL REFERENCES airport(airport_id),
    segment_number integer NOT NULL,
    scheduled_departure_at timestamptz NOT NULL,
    scheduled_arrival_at timestamptz NOT NULL,
    actual_departure_at timestamptz,
    actual_arrival_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_flight_segment_number UNIQUE (flight_id, segment_number),
    CONSTRAINT ck_flight_segment_airports CHECK (origin_airport_id <> destination_airport_id),
    CONSTRAINT ck_flight_segment_schedule CHECK (scheduled_arrival_at > scheduled_departure_at),
    CONSTRAINT ck_flight_segment_actuals CHECK (
        actual_arrival_at IS NULL
        OR actual_departure_at IS NULL
        OR actual_arrival_at >= actual_departure_at
    )
);


