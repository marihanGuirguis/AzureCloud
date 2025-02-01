-- init/init.sql
CREATE TABLE translations (
    ID SERIAL PRIMARY KEY,
    source_language VARCHAR(2),
    destination_language VARCHAR(2),
    text TEXT
);