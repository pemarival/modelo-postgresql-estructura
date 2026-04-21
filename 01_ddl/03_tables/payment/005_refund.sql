CREATE TABLE refund (
    refund_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id uuid NOT NULL REFERENCES payment(payment_id),
    refund_reference varchar(40) NOT NULL,
    amount numeric(12, 2) NOT NULL,
    requested_at timestamptz NOT NULL,
    processed_at timestamptz,
    refund_reason text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_refund_reference UNIQUE (refund_reference),
    CONSTRAINT ck_refund_amount CHECK (amount > 0),
    CONSTRAINT ck_refund_dates CHECK (processed_at IS NULL OR processed_at >= requested_at)
);


