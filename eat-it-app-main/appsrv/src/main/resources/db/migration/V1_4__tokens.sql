CREATE TABLE IF NOT EXISTS tokens(
    id BIGSERIAL primary key,
    userUID UUID NOT NULL,
    token text NOT NULL,
    refreshToken text  NOT NULL,
    exp timestamp not null
);
CREATE INDEX IF NOT EXISTS userUUID_idx ON tokens (userUID);
CREATE INDEX IF NOT EXISTS token_idx ON tokens (token);
CREATE INDEX IF NOT EXISTS refresh_idx ON tokens (refreshToken);
