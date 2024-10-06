CREATE TABLE IF NOT EXISTS purchases(
    id BIGSERIAL PRIMARY KEY,
    userId BIGINT not null,
    date timestamp DEFAULT CURRENT_TIMESTAMP,
    points int not null,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS purchases_details(
    id BIGSERIAL PRIMARY KEY,
    purchasesId BIGINT not null,
    barcode varchar(20) not null,
    qnty integer NOT NULL default 1,
    points integer not null,
    FOREIGN KEY (purchasesId) REFERENCES purchases(id) ON DELETE CASCADE ON UPDATE CASCADE
);

