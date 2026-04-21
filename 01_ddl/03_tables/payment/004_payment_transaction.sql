CREATE TABLE payment_transaction (
    payment_transaction_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id uuid NOT NULL REFERENCES payment(payment_id),
    transaction_reference varchar(60) NOT NULL,
    transaction_type varchar(20) NOT NULL,
    transaction_amount numeric(12, 2) NOT NULL,
    processed_at timestamptz NOT NULL,
    provider_message text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_payment_transaction_reference UNIQUE (transaction_reference),
    CONSTRAINT ck_payment_transaction_type CHECK (transaction_type IN ('AUTH', 'CAPTURE', 'VOID', 'REFUND', 'REVERSAL')),
    CONSTRAINT ck_payment_transaction_amount CHECK (transaction_amount > 0)
);


