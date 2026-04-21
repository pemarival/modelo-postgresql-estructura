CREATE TABLE fare_class (
    fare_class_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    cabin_class_id uuid NOT NULL REFERENCES cabin_class(cabin_class_id),
    fare_class_code varchar(10) NOT NULL,
    fare_class_name varchar(80) NOT NULL,
    is_refundable_by_default boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_fare_class_code UNIQUE (fare_class_code),
    CONSTRAINT uq_fare_class_name UNIQUE (fare_class_name)
);


