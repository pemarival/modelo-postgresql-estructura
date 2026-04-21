CREATE TABLE role_permission (
    role_permission_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    security_role_id uuid NOT NULL REFERENCES security_role(security_role_id),
    security_permission_id uuid NOT NULL REFERENCES security_permission(security_permission_id),
    granted_at timestamptz NOT NULL DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_role_permission UNIQUE (security_role_id, security_permission_id)
);


