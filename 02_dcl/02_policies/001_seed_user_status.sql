INSERT INTO user_status (status_code, status_name)
VALUES
    ('ACTIVE', 'Active'),
    ('SUSPENDED', 'Suspended'),
    ('LOCKED', 'Locked')
ON CONFLICT (status_code) DO UPDATE
SET
    status_name = EXCLUDED.status_name,
    updated_at = now();
