CREATE TABLE user_account (
    user_account_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id uuid NOT NULL REFERENCES person(person_id),
    user_status_id uuid NOT NULL REFERENCES user_status(user_status_id),
    username varchar(80) NOT NULL,
    password_hash varchar(255) NOT NULL,
    last_login_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_user_account_person UNIQUE (person_id),
    CONSTRAINT uq_user_account_username UNIQUE (username)
);


