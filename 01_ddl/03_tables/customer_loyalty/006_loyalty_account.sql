CREATE TABLE loyalty_account (
    loyalty_account_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id uuid NOT NULL REFERENCES customer(customer_id),
    loyalty_program_id uuid NOT NULL REFERENCES loyalty_program(loyalty_program_id),
    account_number varchar(40) NOT NULL,
    opened_at timestamptz NOT NULL DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_loyalty_account_number UNIQUE (account_number),
    CONSTRAINT uq_loyalty_account_customer_program UNIQUE (customer_id, loyalty_program_id)
);


