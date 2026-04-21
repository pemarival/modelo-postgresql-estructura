CREATE TABLE cabin_class (
    cabin_class_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    class_code varchar(10) NOT NULL,
    class_name varchar(60) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_cabin_class_code UNIQUE (class_code),
    CONSTRAINT uq_cabin_class_name UNIQUE (class_name)
);


