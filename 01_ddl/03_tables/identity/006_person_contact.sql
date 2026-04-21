CREATE TABLE person_contact (
    person_contact_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id uuid NOT NULL REFERENCES person(person_id),
    contact_type_id uuid NOT NULL REFERENCES contact_type(contact_type_id),
    contact_value varchar(180) NOT NULL,
    is_primary boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_person_contact_value UNIQUE (person_id, contact_type_id, contact_value)
);


