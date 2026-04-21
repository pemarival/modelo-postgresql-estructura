CREATE TABLE boarding_gate (
    boarding_gate_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    terminal_id uuid NOT NULL REFERENCES terminal(terminal_id),
    gate_code varchar(10) NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_boarding_gate_code UNIQUE (terminal_id, gate_code)
);


