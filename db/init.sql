CREATE TABLE leaked_hashes (
    hash CHAR(40) PRIMARY KEY      -- skrót SHA-1, nigdy hasło jawne
);

CREATE TEMP TABLE import (line TEXT);
COPY import FROM '/data/leaked-sha1.txt';

INSERT INTO leaked_hashes (hash)
SELECT DISTINCT lower(trim(both E' \r' FROM line))
FROM import
WHERE trim(both E' \r' FROM line) <> '';
