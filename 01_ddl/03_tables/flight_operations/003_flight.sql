CREATE TABLE flight (
    flight_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airline_id uuid NOT NULL REFERENCES airline(airline_id),
    aircraft_id uuid NOT NULL REFERENCES aircraft(aircraft_id),
    flight_status_id uuid NOT NULL REFERENCES flight_status(flight_status_id),
    flight_number varchar(12) NOT NULL,
    service_date date NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_flight_instance UNIQUE (airline_id, flight_number, service_date)
);


