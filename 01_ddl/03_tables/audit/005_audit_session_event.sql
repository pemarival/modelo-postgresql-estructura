CREATE TABLE audit_session_event (
    audit_session_event_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_account_id uuid REFERENCES user_account(user_account_id),
    session_identifier varchar(120),
    event_type varchar(30) NOT NULL,
    event_result varchar(20) NOT NULL,
    failure_reason varchar(300),
    source_system varchar(80),
    ip_address varchar(45),
    user_agent varchar(300),
    occurred_at timestamptz NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_audit_session_event_type CHECK (event_type IN ('LOGIN', 'LOGOUT', 'TOKEN_REFRESH', 'PASSWORD_CHANGE', 'MFA_CHALLENGE')),
    CONSTRAINT ck_audit_session_event_result CHECK (event_result IN ('SUCCESS', 'FAILURE'))
);
