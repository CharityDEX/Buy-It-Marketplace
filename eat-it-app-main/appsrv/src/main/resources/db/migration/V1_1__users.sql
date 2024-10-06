CREATE TABLE IF NOT EXISTS users(
    id BIGSERIAL PRIMARY KEY,
    userUID UUID not NULL,
    userName varchar(50) NOT NULL,
    email varchar(50) not null,
    password varchar(100) not null,
    userText varchar(100),
    photo bytea,
    points integer NOT NULL DEFAULT 0,
    date timestamp DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX uuid_idx ON users (userUID);
CREATE INDEX email_idx ON users ((lower(email)));
CREATE INDEX name_idx ON users (userName);
CREATE INDEX points_idx ON users (points);
