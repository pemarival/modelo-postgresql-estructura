CREATE TABLE address (
    address_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    district_id uuid NOT NULL REFERENCES district(district_id),
    address_line_1 varchar(200) NOT NULL,
    address_line_2 varchar(200),
    postal_code varchar(20),
    latitude numeric(10, 7),
    longitude numeric(10, 7),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_address_latitude CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    CONSTRAINT ck_address_longitude CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);


