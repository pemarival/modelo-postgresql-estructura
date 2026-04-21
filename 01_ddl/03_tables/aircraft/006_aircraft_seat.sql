CREATE TABLE aircraft_seat (
    aircraft_seat_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    aircraft_cabin_id uuid NOT NULL REFERENCES aircraft_cabin(aircraft_cabin_id),
    seat_row_number integer NOT NULL,
    seat_column_code varchar(3) NOT NULL,
    is_window boolean NOT NULL DEFAULT false,
    is_aisle boolean NOT NULL DEFAULT false,
    is_exit_row boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_aircraft_seat_position UNIQUE (aircraft_cabin_id, seat_row_number, seat_column_code),
    CONSTRAINT ck_aircraft_seat_row CHECK (seat_row_number > 0)
);


