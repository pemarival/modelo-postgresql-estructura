INSERT INTO security_role (role_code, role_name, role_description)
VALUES
    ('PLATFORM_ADMIN', 'Platform Administrator', 'Full access to all platform capabilities.'),
    ('SECURITY_ADMIN', 'Security Administrator', 'Manages users, roles and permissions.'),
    ('OPERATIONS_AGENT', 'Operations Agent', 'Manages airports, aircraft and flight operations.'),
    ('SALES_AGENT', 'Sales Agent', 'Manages sales, reservations and ticketing.'),
    ('FINANCE_ANALYST', 'Finance Analyst', 'Manages payments and billing operations.'),
    ('LOYALTY_AGENT', 'Loyalty Agent', 'Manages customer and loyalty processes.'),
    ('AUDITOR_READONLY', 'Auditor Readonly', 'Read-only access for audit and compliance.'),
    ('SUPPORT_AGENT', 'Support Agent', 'Supports customers with profile and booking assistance.')
ON CONFLICT (role_code) DO UPDATE
SET
    role_name = EXCLUDED.role_name,
    role_description = EXCLUDED.role_description,
    updated_at = now();
