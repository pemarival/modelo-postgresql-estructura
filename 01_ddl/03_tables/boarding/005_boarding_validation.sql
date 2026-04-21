CREATE TABLE boarding_validation (
    boarding_validation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    boarding_pass_id uuid NOT NULL REFERENCES boarding_pass(boarding_pass_id),
    boarding_gate_id uuid REFERENCES boarding_gate(boarding_gate_id),
    validated_by_user_id uuid REFERENCES user_account(user_account_id),
    validated_at timestamptz NOT NULL,
    validation_result varchar(20) NOT NULL,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_boarding_validation_result CHECK (validation_result IN ('APPROVED', 'REJECTED', 'MANUAL_REVIEW'))
);


