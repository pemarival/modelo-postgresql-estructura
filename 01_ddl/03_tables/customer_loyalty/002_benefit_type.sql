CREATE TABLE benefit_type (
    benefit_type_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    benefit_code varchar(30) NOT NULL,
    benefit_name varchar(100) NOT NULL,
    benefit_description text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_benefit_type_code UNIQUE (benefit_code),
    CONSTRAINT uq_benefit_type_name UNIQUE (benefit_name)
);


