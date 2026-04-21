CREATE TABLE loyalty_account_tier (
    loyalty_account_tier_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    loyalty_account_id uuid NOT NULL REFERENCES loyalty_account(loyalty_account_id),
    loyalty_tier_id uuid NOT NULL REFERENCES loyalty_tier(loyalty_tier_id),
    assigned_at timestamptz NOT NULL,
    expires_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_loyalty_account_tier_point UNIQUE (loyalty_account_id, assigned_at),
    CONSTRAINT ck_loyalty_account_tier_dates CHECK (expires_at IS NULL OR expires_at > assigned_at)
);


