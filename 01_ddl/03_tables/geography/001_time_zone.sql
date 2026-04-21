CREATE TABLE time_zone (
    time_zone_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    time_zone_name varchar(64) NOT NULL,
    utc_offset_minutes integer NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_time_zone_name UNIQUE (time_zone_name)
);


