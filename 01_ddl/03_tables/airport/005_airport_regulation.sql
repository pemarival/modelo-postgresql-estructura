CREATE TABLE airport_regulation (
    airport_regulation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airport_id uuid NOT NULL REFERENCES airport(airport_id),
    regulation_code varchar(30) NOT NULL,
    regulation_title varchar(150) NOT NULL,
    issuing_authority varchar(120) NOT NULL,
    effective_from date NOT NULL,
    effective_to date,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_airport_regulation UNIQUE (airport_id, regulation_code),
    CONSTRAINT ck_airport_regulation_dates CHECK (effective_to IS NULL OR effective_to >= effective_from)
);


