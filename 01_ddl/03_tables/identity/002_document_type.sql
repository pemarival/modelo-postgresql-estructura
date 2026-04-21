CREATE TABLE document_type (
    document_type_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    type_code varchar(20) NOT NULL,
    type_name varchar(80) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_document_type_code UNIQUE (type_code),
    CONSTRAINT uq_document_type_name UNIQUE (type_name)
);


