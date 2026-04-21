CREATE TABLE check_in_status (
    check_in_status_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    status_code varchar(20) NOT NULL,
    status_name varchar(80) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_check_in_status_code UNIQUE (status_code),
    CONSTRAINT uq_check_in_status_name UNIQUE (status_name)
);


