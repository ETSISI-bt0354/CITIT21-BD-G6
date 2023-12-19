CREATE TABLE editorial(
    editorial_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    nationality VARCHAR(250) NOT NULL,
    name VARCHAR(250) NOT NULL,
    PRIMARY KEY (editorial_id),
    CONSTRAINT UNIQUE (nationality, name)
);

CREATE TABLE investigation_area (
    investigation_area_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    name VARCHAR(250) UNIQUE NOT NULL,
    PRIMARY KEY (investigation_area_id)
);

CREATE TABLE journal (
    journal_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    journal_name VARCHAR(300) NOT NULL,
    issn INT UNIQUE NOT NULL,
    JIF INT NOT NULL,
    JIF_Quartile INT NOT NULL,
    publishing_period INT NOT NULL,
    editorial_id INT NOT NULL,
    investigation_id INT NOT NULL,
    PRIMARY KEY (journal_id),
    CONSTRAINT
        FOREIGN KEY (editorial_id) REFERENCES editorial(editorial_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (investigation_id) REFERENCES investigation_area(investigation_area_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE article (
    DOI VARCHAR(50) UNIQUE NOT NULL,
    num_citations INT NOT NULL DEFAULT 0,
    title VARCHAR(250) NOT NULL,
    url VARCHAR(250) NOT NULL,
    publication_date DATE NOT NULL,
    journal_id INT NOT NULL,
    PRIMARY KEY (DOI),
    CONSTRAINT
        FOREIGN KEY (journal_id) REFERENCES journal(journal_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE article_citation (
    citated_article_DOI VARCHAR(50) NOT NULL,
    citating_article_DOI VARCHAR(50) NOT NULL,
    PRIMARY KEY (citated_article_DOI, citating_article_DOI),
    CONSTRAINT
        FOREIGN KEY (citated_article_DOI) REFERENCES article(DOI)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (citating_article_DOI) REFERENCES article(DOI)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE author (
    author_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    name VARCHAR(250) NOT NULL,
    PRIMARY KEY (author_id)
);

CREATE TABLE signs (
    article_DOI VARCHAR(50) NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (article_DOI, author_id),
    CONSTRAINT
        FOREIGN KEY (article_DOI) REFERENCES article(DOI)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author(author_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE reviews (
    sent_date   DATE NOT NULL,
    result      ENUM ('Positive', 'Negative') DEFAULT NULL,
    review_date DATE DEFAULT NULL,
    DOI         VARCHAR(50) NOT NULL,
    author_id   INT NOT NULL,
    PRIMARY KEY (DOI, author_id),
    CONSTRAINT
        FOREIGN KEY (DOI) REFERENCES article (DOI)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE collaboration (
    collaboration_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    article_DOI VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY (collaboration_id, article_DOI),
    CONSTRAINT
        FOREIGN KEY (article_DOI) REFERENCES article (DOI)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE collab_author_rel (
    collaboration_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (collaboration_id, author_id),
    CONSTRAINT
        FOREIGN KEY (collaboration_id) REFERENCES collaboration (collaboration_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE affiliation (
    affiliation_id BIGINT UNIQUE NOT NULL AUTO_INCREMENT,
    affiliation_name VARCHAR(250) NOT NULL,
    country_name VARCHAR(250) NOT NULL,
    city VARCHAR(250) NOT NULL,
    PRIMARY KEY (affiliation_id)
);

CREATE TABLE affiliation_author_rel (
    affiliation_id BIGINT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (affiliation_id, author_id),
    CONSTRAINT
        FOREIGN KEY (affiliation_id) REFERENCES affiliation (affiliation_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE workgroup (
    workgroup_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    name VARCHAR(250) NOT NULL,
    investigation_area_id INT NOT NULL,
    PRIMARY KEY (workgroup_id),
    CONSTRAINT
        FOREIGN KEY (investigation_area_id) REFERENCES investigation_area (investigation_area_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE in_workgroup (
    author_id INT NOT NULL,
    affiliation_id BIGINT NOT NULL,
    workgroup_id INT NOT NULL,
    PRIMARY KEY (author_id, affiliation_id, workgroup_id),
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (affiliation_id) REFERENCES affiliation (affiliation_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT
        FOREIGN KEY (workgroup_id) REFERENCES workgroup (workgroup_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
