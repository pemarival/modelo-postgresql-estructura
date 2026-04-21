CREATE TABLE security_permission (
    security_permission_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    permission_code varchar(50) NOT NULL,
    permission_name varchar(120) NOT NULL,
    permission_description text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_security_permission_code UNIQUE (permission_code),
    CONSTRAINT uq_security_permission_name UNIQUE (permission_name)
);


