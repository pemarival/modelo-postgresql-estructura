CREATE TABLE exchange_rate (
    exchange_rate_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    from_currency_id uuid NOT NULL REFERENCES currency(currency_id),
    to_currency_id uuid NOT NULL REFERENCES currency(currency_id),
    effective_date date NOT NULL,
    rate_value numeric(18, 8) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_exchange_rate UNIQUE (from_currency_id, to_currency_id, effective_date),
    CONSTRAINT ck_exchange_rate_pair CHECK (from_currency_id <> to_currency_id),
    CONSTRAINT ck_exchange_rate_value CHECK (rate_value > 0)
);


