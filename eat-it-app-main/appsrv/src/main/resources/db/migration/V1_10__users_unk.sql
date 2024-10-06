DROP INDEX IF EXISTS uuid_idx;
DROP INDEX IF EXISTS email_idx;
DROP INDEX IF EXISTS name_idx;
CREATE UNIQUE INDEX IF NOT EXISTS unk_uuid_idx ON users (userUID);
CREATE UNIQUE INDEX IF NOT EXISTS unk_email_idx ON users ((lower(email)));
CREATE UNIQUE INDEX IF NOT EXISTS unk_name_idx ON users (lower(userName));
