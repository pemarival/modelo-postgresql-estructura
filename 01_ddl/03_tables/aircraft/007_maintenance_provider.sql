CREATE TABLE maintenance_provider (
    maintenance_provider_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    address_id uuid REFERENCES address(address_id),
    provider_name varchar(150) NOT NULL,
    contact_name varchar(120),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_maintenance_provider_name UNIQUE (provider_name)
);


