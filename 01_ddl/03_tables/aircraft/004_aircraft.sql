CREATE TABLE aircraft (
    aircraft_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airline_id uuid NOT NULL REFERENCES airline(airline_id),
    aircraft_model_id uuid NOT NULL REFERENCES aircraft_model(aircraft_model_id),
    registration_number varchar(20) NOT NULL,
    serial_number varchar(40) NOT NULL,
    in_service_on date,
    retired_on date,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_aircraft_registration UNIQUE (registration_number),
    CONSTRAINT uq_aircraft_serial UNIQUE (serial_number),
    CONSTRAINT ck_aircraft_service_dates CHECK (retired_on IS NULL OR in_service_on IS NULL OR retired_on >= in_service_on)
);


