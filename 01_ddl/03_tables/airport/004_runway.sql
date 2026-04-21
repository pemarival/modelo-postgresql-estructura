CREATE TABLE runway (
    runway_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airport_id uuid NOT NULL REFERENCES airport(airport_id),
    runway_code varchar(20) NOT NULL,
    length_meters integer NOT NULL,
    surface_type varchar(30),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_runway_code UNIQUE (airport_id, runway_code),
    CONSTRAINT ck_runway_length CHECK (length_meters > 0)
);


