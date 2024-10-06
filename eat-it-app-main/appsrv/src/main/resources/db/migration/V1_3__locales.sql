CREATE TABLE IF NOT EXISTS locales(
    id varchar(20) NOT NULL,
    localeCode varchar(10) NOT NULL,
    localeText varchar(100) not null
);

CREATE INDEX id_idx ON locales (id);
CREATE INDEX localeCode_idx ON locales (localeCode);

insert into locales(id, localeCode, localeText) values('agb:agr','_default','Agriculture');
insert into locales(id, localeCode, localeText) values('agb:prc','_default','Processing');
insert into locales(id, localeCode, localeText) values('agb:pck','_default','Packaging');
insert into locales(id, localeCode, localeText) values('agb:trn','_default','Transportation');
insert into locales(id, localeCode, localeText) values('agb:dst','_default','Distribution');
insert into locales(id, localeCode, localeText) values('agb:cns','_default','Consumption');
insert into locales(id, localeCode, localeText) values('agb:agr','en_uk','Agriculture');

insert into locales(id, localeCode, localeText) values('adj:ing:header','_default','Origins of Ingredients');
insert into locales(id, localeCode, localeText) values('adj:ing:low','_default','Low impact origins of ingredients');
insert into locales(id, localeCode, localeText) values('adj:ing:medium','_default','Medium impact origins of ingredients');
insert into locales(id, localeCode, localeText) values('adj:ing:high','_default','High impact origins of ingredients');
insert into locales(id, localeCode, localeText) values('adj:ing:missing','_default','Missing origins of ingredients');

insert into locales(id, localeCode, localeText) values('adj:pck:header','_default','Packaging Information');
insert into locales(id, localeCode, localeText) values('adj:pck:low','_default','Packaging with low impact');
insert into locales(id, localeCode, localeText) values('adj:pck:medium','_default','Packaging with medium impact');
insert into locales(id, localeCode, localeText) values('adj:pck:high','_default','Packaging with high impact');

insert into locales(id, localeCode, localeText) values('adj:lbl:header','_default','Labels with Environmental Benefits');
insert into locales(id, localeCode, localeText) values('adj:lbl:low','_default','Contains positive labels');

insert into locales(id, localeCode, localeText) values('adj:hrm:header','_default','Harmed Species');
insert into locales(id, localeCode, localeText) values('adj:hrm:low','_default','No species were harmed');
insert into locales(id, localeCode, localeText) values('adj:hrm:high','_default','Species were harmed');
