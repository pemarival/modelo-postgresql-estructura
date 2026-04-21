CREATE TABLE country (
    country_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    continent_id uuid NOT NULL REFERENCES continent(continent_id),
    iso_alpha2 varchar(2) NOT NULL,
    iso_alpha3 varchar(3) NOT NULL,
    country_name varchar(128) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_country_alpha2 UNIQUE (iso_alpha2),
    CONSTRAINT uq_country_alpha3 UNIQUE (iso_alpha3),
    CONSTRAINT uq_country_name UNIQUE (country_name)
);


