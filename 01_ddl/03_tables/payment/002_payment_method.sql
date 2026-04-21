CREATE TABLE payment_method (
    payment_method_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    method_code varchar(20) NOT NULL,
    method_name varchar(80) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_payment_method_code UNIQUE (method_code),
    CONSTRAINT uq_payment_method_name UNIQUE (method_name)
);


