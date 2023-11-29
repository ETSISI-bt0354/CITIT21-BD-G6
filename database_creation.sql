CREATE TABLE journal (
    journal_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    nationality VARCHAR(250) NOT NULL,
    name VARCHAR(250) NOT NULL,
    PRIMARY KEY (journal_id)
)