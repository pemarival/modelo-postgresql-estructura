CREATE TABLE fare (
    fare_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airline_id uuid NOT NULL REFERENCES airline(airline_id),
    origin_airport_id uuid NOT NULL REFERENCES airport(airport_id),
    destination_airport_id uuid NOT NULL REFERENCES airport(airport_id),
    fare_class_id uuid NOT NULL REFERENCES fare_class(fare_class_id),
    currency_id uuid NOT NULL REFERENCES currency(currency_id),
    fare_code varchar(30) NOT NULL,
    base_amount numeric(12, 2) NOT NULL,
    valid_from date NOT NULL,
    valid_to date,
    baggage_allowance_qty integer NOT NULL DEFAULT 0,
    change_penalty_amount numeric(12, 2),
    refund_penalty_amount numeric(12, 2),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_fare_code UNIQUE (fare_code),
    CONSTRAINT ck_fare_airports CHECK (origin_airport_id <> destination_airport_id),
    CONSTRAINT ck_fare_base_amount CHECK (base_amount >= 0),
    CONSTRAINT ck_fare_baggage_allowance CHECK (baggage_allowance_qty >= 0),
    CONSTRAINT ck_fare_change_penalty CHECK (change_penalty_amount IS NULL OR change_penalty_amount >= 0),
    CONSTRAINT ck_fare_refund_penalty CHECK (refund_penalty_amount IS NULL OR refund_penalty_amount >= 0),
    CONSTRAINT ck_fare_validity CHECK (valid_to IS NULL OR valid_to >= valid_from)
);


