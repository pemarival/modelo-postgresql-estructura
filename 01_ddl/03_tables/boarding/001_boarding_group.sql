CREATE TABLE boarding_group (
    boarding_group_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    group_code varchar(10) NOT NULL,
    group_name varchar(50) NOT NULL,
    sequence_no integer NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_boarding_group_code UNIQUE (group_code),
    CONSTRAINT uq_boarding_group_name UNIQUE (group_name),
    CONSTRAINT ck_boarding_group_sequence CHECK (sequence_no > 0)
);


