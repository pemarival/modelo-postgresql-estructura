CREATE TABLE boarding_pass (
    boarding_pass_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    check_in_id uuid NOT NULL REFERENCES check_in(check_in_id),
    boarding_pass_code varchar(40) NOT NULL,
    barcode_value varchar(120) NOT NULL,
    issued_at timestamptz NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_boarding_pass_check_in UNIQUE (check_in_id),
    CONSTRAINT uq_boarding_pass_code UNIQUE (boarding_pass_code),
    CONSTRAINT uq_boarding_pass_barcode UNIQUE (barcode_value)
);


