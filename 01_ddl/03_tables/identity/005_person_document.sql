CREATE TABLE person_document (
    person_document_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id uuid NOT NULL REFERENCES person(person_id),
    document_type_id uuid NOT NULL REFERENCES document_type(document_type_id),
    issuing_country_id uuid REFERENCES country(country_id),
    document_number varchar(64) NOT NULL,
    issued_on date,
    expires_on date,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_person_document_natural UNIQUE (document_type_id, issuing_country_id, document_number),
    CONSTRAINT ck_person_document_dates CHECK (expires_on IS NULL OR issued_on IS NULL OR expires_on >= issued_on)
);


