CREATE TABLE loyalty_program (
    loyalty_program_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airline_id uuid NOT NULL REFERENCES airline(airline_id),
    default_currency_id uuid NOT NULL REFERENCES currency(currency_id),
    program_code varchar(20) NOT NULL,
    program_name varchar(120) NOT NULL,
    expiration_months integer,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_loyalty_program_code UNIQUE (airline_id, program_code),
    CONSTRAINT uq_loyalty_program_name UNIQUE (airline_id, program_name),
    CONSTRAINT ck_loyalty_program_expiration CHECK (expiration_months IS NULL OR expiration_months > 0)
);


