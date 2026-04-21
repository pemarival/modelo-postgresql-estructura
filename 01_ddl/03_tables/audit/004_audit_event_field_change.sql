CREATE TABLE audit_event_field_change (
    audit_event_field_change_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    audit_event_id uuid NOT NULL REFERENCES audit_event(audit_event_id),
    field_name varchar(120) NOT NULL,
    old_value text,
    new_value text,
    value_data_type varchar(30),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_audit_event_field_change UNIQUE (audit_event_id, field_name),
    CONSTRAINT ck_audit_event_field_diff CHECK (old_value IS DISTINCT FROM new_value)
);
