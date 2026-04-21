CREATE TABLE city (
    city_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    state_province_id uuid NOT NULL REFERENCES state_province(state_province_id),
    time_zone_id uuid NOT NULL REFERENCES time_zone(time_zone_id),
    city_name varchar(128) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_city_state_name UNIQUE (state_province_id, city_name)
);


