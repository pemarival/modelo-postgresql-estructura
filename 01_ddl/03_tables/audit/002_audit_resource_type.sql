CREATE TABLE audit_resource_type (
    audit_resource_type_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    resource_code varchar(50) NOT NULL,
    resource_name varchar(120) NOT NULL,
    resource_description text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_audit_resource_type_code UNIQUE (resource_code),
    CONSTRAINT uq_audit_resource_type_name UNIQUE (resource_name)
);
