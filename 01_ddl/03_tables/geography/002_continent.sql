CREATE TABLE continent (
    continent_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    continent_code varchar(3) NOT NULL,
    continent_name varchar(64) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_continent_code UNIQUE (continent_code),
    CONSTRAINT uq_continent_name UNIQUE (continent_name)
);


