CREATE TABLE audit_action_type (
    audit_action_type_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    action_code varchar(30) NOT NULL,
    action_name varchar(80) NOT NULL,
    action_description text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_audit_action_type_code UNIQUE (action_code),
    CONSTRAINT uq_audit_action_type_name UNIQUE (action_name)
);
