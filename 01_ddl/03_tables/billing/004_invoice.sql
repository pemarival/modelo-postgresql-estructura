CREATE TABLE invoice (
    invoice_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    sale_id uuid NOT NULL REFERENCES sale(sale_id),
    invoice_status_id uuid NOT NULL REFERENCES invoice_status(invoice_status_id),
    currency_id uuid NOT NULL REFERENCES currency(currency_id),
    invoice_number varchar(40) NOT NULL,
    issued_at timestamptz NOT NULL,
    due_at timestamptz,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_invoice_number UNIQUE (invoice_number),
    CONSTRAINT ck_invoice_dates CHECK (due_at IS NULL OR due_at >= issued_at)
);


