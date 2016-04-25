CREATE TABLE IF NOT EXISTS notes (
    id           INTEGER NOT NULL PRIMARY KEY,
    note         VARCHAR(255),
    is_todo      INTEGER NOT NULL,
    is_done      INTEGER NOT NULL
);
