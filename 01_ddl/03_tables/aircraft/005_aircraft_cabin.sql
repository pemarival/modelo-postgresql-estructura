CREATE TABLE aircraft_cabin (
    aircraft_cabin_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    aircraft_id uuid NOT NULL REFERENCES aircraft(aircraft_id),
    cabin_class_id uuid NOT NULL REFERENCES cabin_class(cabin_class_id),
    cabin_code varchar(10) NOT NULL,
    deck_number smallint NOT NULL DEFAULT 1,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_aircraft_cabin_code UNIQUE (aircraft_id, cabin_code),
    CONSTRAINT ck_aircraft_cabin_deck CHECK (deck_number > 0)
);


