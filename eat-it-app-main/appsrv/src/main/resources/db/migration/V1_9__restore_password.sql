CREATE TABLE IF NOT EXISTS restore_password(
    id BIGSERIAL PRIMARY KEY,
    userId bigint NOT NULL,
    sendingCode varchar(4) not null,
    attempt int not null default 3,
    date timestamp DEFAULT CURRENT_TIMESTAMP
);
