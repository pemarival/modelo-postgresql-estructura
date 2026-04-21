CREATE TABLE baggage (
    baggage_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_segment_id uuid NOT NULL REFERENCES ticket_segment(ticket_segment_id),
    baggage_tag varchar(30) NOT NULL,
    baggage_type varchar(20) NOT NULL,
    baggage_status varchar(20) NOT NULL,
    weight_kg numeric(6, 2) NOT NULL,
    checked_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_baggage_tag UNIQUE (baggage_tag),
    CONSTRAINT ck_baggage_type CHECK (baggage_type IN ('CHECKED', 'CARRY_ON', 'SPECIAL')),
    CONSTRAINT ck_baggage_status CHECK (baggage_status IN ('REGISTERED', 'LOADED', 'CLAIMED', 'LOST')),
    CONSTRAINT ck_baggage_weight CHECK (weight_kg > 0)
);


