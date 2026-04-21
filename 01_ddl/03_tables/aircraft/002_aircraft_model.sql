CREATE TABLE aircraft_model (
    aircraft_model_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    aircraft_manufacturer_id uuid NOT NULL REFERENCES aircraft_manufacturer(aircraft_manufacturer_id),
    model_code varchar(30) NOT NULL,
    model_name varchar(120) NOT NULL,
    max_range_km integer,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_aircraft_model_code UNIQUE (aircraft_manufacturer_id, model_code),
    CONSTRAINT uq_aircraft_model_name UNIQUE (aircraft_manufacturer_id, model_name),
    CONSTRAINT ck_aircraft_model_range CHECK (max_range_km IS NULL OR max_range_km > 0)
);


