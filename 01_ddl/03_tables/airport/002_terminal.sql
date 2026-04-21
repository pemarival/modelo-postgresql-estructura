CREATE TABLE terminal (
    terminal_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    airport_id uuid NOT NULL REFERENCES airport(airport_id),
    terminal_code varchar(10) NOT NULL,
    terminal_name varchar(80),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_terminal_code UNIQUE (airport_id, terminal_code)
);


