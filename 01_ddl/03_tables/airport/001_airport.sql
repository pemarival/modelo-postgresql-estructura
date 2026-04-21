CREATE TABLE airport (
    airport_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    address_id uuid NOT NULL REFERENCES address(address_id),
    airport_name varchar(150) NOT NULL,
    iata_code varchar(3),
    icao_code varchar(4),
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_airport_iata UNIQUE (iata_code),
    CONSTRAINT uq_airport_icao UNIQUE (icao_code),
    CONSTRAINT ck_airport_iata_len CHECK (iata_code IS NULL OR char_length(iata_code) = 3),
    CONSTRAINT ck_airport_icao_len CHECK (icao_code IS NULL OR char_length(icao_code) = 4)
);


