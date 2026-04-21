CREATE TABLE security_role (
    security_role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    role_code varchar(30) NOT NULL,
    role_name varchar(100) NOT NULL,
    role_description text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_security_role_code UNIQUE (role_code),
    CONSTRAINT uq_security_role_name UNIQUE (role_name)
);


