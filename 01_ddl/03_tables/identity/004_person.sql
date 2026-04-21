CREATE TABLE person (
    person_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    person_type_id uuid NOT NULL REFERENCES person_type(person_type_id),
    nationality_country_id uuid REFERENCES country(country_id),
    first_name varchar(80) NOT NULL,
    middle_name varchar(80),
    last_name varchar(80) NOT NULL,
    second_last_name varchar(80),
    birth_date date,
    gender_code varchar(1),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_person_gender CHECK (gender_code IS NULL OR gender_code IN ('F', 'M', 'X'))
);


