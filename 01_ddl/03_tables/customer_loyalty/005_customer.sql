CREATE TABLE customer (
    customer_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airline_id uuid NOT NULL REFERENCES airline(airline_id),
    person_id uuid NOT NULL REFERENCES person(person_id),
    customer_category_id uuid REFERENCES customer_category(customer_category_id),
    customer_since date NOT NULL DEFAULT current_date,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_customer_airline_person UNIQUE (airline_id, person_id)
);


