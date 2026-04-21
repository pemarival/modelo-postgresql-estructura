CREATE TABLE sale (
    sale_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id uuid NOT NULL REFERENCES reservation(reservation_id),
    currency_id uuid NOT NULL REFERENCES currency(currency_id),
    sale_code varchar(30) NOT NULL,
    sold_at timestamptz NOT NULL,
    external_reference varchar(50),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_sale_code UNIQUE (sale_code)
);


