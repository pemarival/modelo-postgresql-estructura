CREATE TABLE user_role (
    user_role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_account_id uuid NOT NULL REFERENCES user_account(user_account_id),
    security_role_id uuid NOT NULL REFERENCES security_role(security_role_id),
    assigned_at timestamptz NOT NULL DEFAULT now(),
    assigned_by_user_id uuid REFERENCES user_account(user_account_id),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_user_role UNIQUE (user_account_id, security_role_id)
);


