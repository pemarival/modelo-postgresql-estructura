CREATE TABLE check_in (
    check_in_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_segment_id uuid NOT NULL REFERENCES ticket_segment(ticket_segment_id),
    check_in_status_id uuid NOT NULL REFERENCES check_in_status(check_in_status_id),
    boarding_group_id uuid REFERENCES boarding_group(boarding_group_id),
    checked_in_by_user_id uuid REFERENCES user_account(user_account_id),
    checked_in_at timestamptz NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_check_in_ticket_segment UNIQUE (ticket_segment_id)
);


