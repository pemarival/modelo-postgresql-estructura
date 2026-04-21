CREATE TABLE customer_category (
    customer_category_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_code varchar(20) NOT NULL,
    category_name varchar(80) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_customer_category_code UNIQUE (category_code),
    CONSTRAINT uq_customer_category_name UNIQUE (category_name)
);


