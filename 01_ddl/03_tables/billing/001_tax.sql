CREATE TABLE tax (
    tax_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tax_code varchar(20) NOT NULL,
    tax_name varchar(100) NOT NULL,
    rate_percentage numeric(6, 3) NOT NULL,
    effective_from date NOT NULL,
    effective_to date,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_tax_code UNIQUE (tax_code),
    CONSTRAINT uq_tax_name UNIQUE (tax_name),
    CONSTRAINT ck_tax_rate CHECK (rate_percentage >= 0),
    CONSTRAINT ck_tax_dates CHECK (effective_to IS NULL OR effective_to >= effective_from)
);


