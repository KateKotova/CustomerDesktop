CREATE TABLE IF NOT EXISTS db_TA7.korz
(
    id BINARY( 16 ) NOT NULL PRIMARY KEY,
    disk_id BINARY( 16 ) NULL,
    raz_id BINARY( 16 ) NULL,
    cena DECIMAL( 15, 2 ) NULL,
    cell_num BINARY( 16 ) NULL
)