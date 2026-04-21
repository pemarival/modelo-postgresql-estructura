CREATE TABLE loyalty_tier (
    loyalty_tier_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    loyalty_program_id uuid NOT NULL REFERENCES loyalty_program(loyalty_program_id),
    tier_code varchar(20) NOT NULL,
    tier_name varchar(80) NOT NULL,
    priority_level integer NOT NULL,
    required_miles integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_loyalty_tier_code UNIQUE (loyalty_program_id, tier_code),
    CONSTRAINT uq_loyalty_tier_name UNIQUE (loyalty_program_id, tier_name),
    CONSTRAINT ck_loyalty_tier_priority CHECK (priority_level > 0),
    CONSTRAINT ck_loyalty_tier_required_miles CHECK (required_miles >= 0)
);


