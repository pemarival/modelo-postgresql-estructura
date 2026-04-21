CREATE TABLE reservation (
    reservation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    booked_by_customer_id uuid REFERENCES customer(customer_id),
    reservation_status_id uuid NOT NULL REFERENCES reservation_status(reservation_status_id),
    sale_channel_id uuid NOT NULL REFERENCES sale_channel(sale_channel_id),
    reservation_code varchar(20) NOT NULL,
    booked_at timestamptz NOT NULL,
    expires_at timestamptz,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_reservation_code UNIQUE (reservation_code),
    CONSTRAINT ck_reservation_dates CHECK (expires_at IS NULL OR expires_at > booked_at)
);


