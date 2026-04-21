CREATE TABLE reservation_passenger (
    reservation_passenger_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id uuid NOT NULL REFERENCES reservation(reservation_id),
    person_id uuid NOT NULL REFERENCES person(person_id),
    passenger_sequence_no integer NOT NULL,
    passenger_type varchar(20) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_reservation_passenger_person UNIQUE (reservation_id, person_id),
    CONSTRAINT uq_reservation_passenger_sequence UNIQUE (reservation_id, passenger_sequence_no),
    CONSTRAINT ck_reservation_passenger_sequence CHECK (passenger_sequence_no > 0),
    CONSTRAINT ck_reservation_passenger_type CHECK (passenger_type IN ('ADULT', 'CHILD', 'INFANT'))
);


