CREATE TABLE IF NOT EXISTS users_new(
    id BIGSERIAL PRIMARY KEY,
    userName varchar(50) NOT NULL,
    email varchar(50) not null,
    password varchar(100) not null,
    sendingCode varchar(4) not null,
    date timestamp DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX un_email_idx ON users_new ((lower(email)));
CREATE INDEX un_name_idx ON users_new (userName);
