CREATE TABLE sale_channel (
    sale_channel_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_code varchar(20) NOT NULL,
    channel_name varchar(80) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_sale_channel_code UNIQUE (channel_code),
    CONSTRAINT uq_sale_channel_name UNIQUE (channel_name)
);


