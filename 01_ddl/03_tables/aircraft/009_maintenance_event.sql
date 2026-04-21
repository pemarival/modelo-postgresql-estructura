CREATE TABLE maintenance_event (
    maintenance_event_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    aircraft_id uuid NOT NULL REFERENCES aircraft(aircraft_id),
    maintenance_type_id uuid NOT NULL REFERENCES maintenance_type(maintenance_type_id),
    maintenance_provider_id uuid REFERENCES maintenance_provider(maintenance_provider_id),
    status_code varchar(20) NOT NULL,
    started_at timestamptz NOT NULL,
    completed_at timestamptz,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_maintenance_event_status CHECK (status_code IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT ck_maintenance_event_dates CHECK (completed_at IS NULL OR completed_at >= started_at)
);


