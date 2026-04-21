CREATE TABLE aircraft_manufacturer (
    aircraft_manufacturer_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    manufacturer_name varchar(120) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_aircraft_manufacturer_name UNIQUE (manufacturer_name)
);


