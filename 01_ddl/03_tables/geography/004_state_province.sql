CREATE TABLE state_province (
    state_province_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    country_id uuid NOT NULL REFERENCES country(country_id),
    state_code varchar(10),
    state_name varchar(128) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_state_country_name UNIQUE (country_id, state_name)
);


