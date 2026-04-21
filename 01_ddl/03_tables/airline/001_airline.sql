CREATE TABLE airline (
    airline_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    home_country_id uuid NOT NULL REFERENCES country(country_id),
    airline_code varchar(10) NOT NULL,
    airline_name varchar(150) NOT NULL,
    iata_code varchar(2),
    icao_code varchar(3),
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_airline_code UNIQUE (airline_code),
    CONSTRAINT uq_airline_name UNIQUE (airline_name),
    CONSTRAINT uq_airline_iata UNIQUE (iata_code),
    CONSTRAINT uq_airline_icao UNIQUE (icao_code),
    CONSTRAINT ck_airline_iata_len CHECK (iata_code IS NULL OR char_length(iata_code) = 2),
    CONSTRAINT ck_airline_icao_len CHECK (icao_code IS NULL OR char_length(icao_code) = 3)
);


