CREATE TABLE payment (
    payment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    sale_id uuid NOT NULL REFERENCES sale(sale_id),
    payment_status_id uuid NOT NULL REFERENCES payment_status(payment_status_id),
    payment_method_id uuid NOT NULL REFERENCES payment_method(payment_method_id),
    currency_id uuid NOT NULL REFERENCES currency(currency_id),
    payment_reference varchar(40) NOT NULL,
    amount numeric(12, 2) NOT NULL,
    authorized_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_payment_reference UNIQUE (payment_reference),
    CONSTRAINT ck_payment_amount CHECK (amount > 0)
);


