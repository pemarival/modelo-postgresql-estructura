CREATE TABLE invoice_line (
    invoice_line_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id uuid NOT NULL REFERENCES invoice(invoice_id),
    tax_id uuid REFERENCES tax(tax_id),
    line_number integer NOT NULL,
    line_description varchar(200) NOT NULL,
    quantity numeric(12, 2) NOT NULL,
    unit_price numeric(12, 2) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_invoice_line_number UNIQUE (invoice_id, line_number),
    CONSTRAINT ck_invoice_line_number CHECK (line_number > 0),
    CONSTRAINT ck_invoice_line_quantity CHECK (quantity > 0),
    CONSTRAINT ck_invoice_line_unit_price CHECK (unit_price >= 0)
);


