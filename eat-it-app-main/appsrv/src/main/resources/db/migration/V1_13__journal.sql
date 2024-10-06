CREATE TABLE IF NOT EXISTS journal_mail(
    id BIGSERIAL PRIMARY KEY,
    date timestamp DEFAULT CURRENT_TIMESTAMP,
    template varchar(50) NOT NULL,
    userName varchar(50) NOT NULL,
    email varchar(50) not null,
    code varchar(10) not null
);
CREATE INDEX jm_email_idx ON journal_mail ((lower(email)));
CREATE INDEX jm_name_idx ON journal_mail (lower(userName));
CREATE INDEX jm_date_idx ON journal_mail (date);

CREATE TABLE IF NOT EXISTS journal_signup(
                                           id BIGSERIAL PRIMARY KEY,
                                           date timestamp DEFAULT CURRENT_TIMESTAMP,
                                           userName varchar(50) NOT NULL,
                                           email varchar(50) not null
);
CREATE INDEX jsu_email_idx ON journal_signup ((lower(email)));
CREATE INDEX jsu_name_idx ON journal_signup (lower(userName));
CREATE INDEX jsu_date_idx ON journal_signup (date);

CREATE TABLE IF NOT EXISTS journal_restore(
                                             id BIGSERIAL PRIMARY KEY,
                                             date timestamp DEFAULT CURRENT_TIMESTAMP,
                                             login varchar(50) NOT NULL
);
CREATE INDEX jrs_login_idx ON journal_restore ((lower(login)));
CREATE INDEX jrs_date_idx ON journal_restore (date);
