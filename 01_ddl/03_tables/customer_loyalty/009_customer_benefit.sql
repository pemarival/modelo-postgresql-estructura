CREATE TABLE customer_benefit (
    customer_benefit_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id uuid NOT NULL REFERENCES customer(customer_id),
    benefit_type_id uuid NOT NULL REFERENCES benefit_type(benefit_type_id),
    granted_at timestamptz NOT NULL,
    expires_at timestamptz,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_customer_benefit UNIQUE (customer_id, benefit_type_id, granted_at),
    CONSTRAINT ck_customer_benefit_dates CHECK (expires_at IS NULL OR expires_at > granted_at)
);


