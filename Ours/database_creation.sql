CREATE TABLE editorial(
    editorial_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    nationality VARCHAR(250) NOT NULL,
    name VARCHAR(250) NOT NULL,
    PRIMARY KEY (editorial_id),
    KEY (nationality, name)
);

CREATE TABLE investigation_area (
    investigation_area_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    name VARCHAR(250) NOT NULL,
    PRIMARY KEY (investigation_area_id),
    KEY (name)
);

CREATE TABLE journal (
    journal_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    journal_name VARCHAR(250) NOT NULL,
    issn INT UNIQUE NOT NULL,
    JIF INT NOT NULL,
    JIF_Quartile INT NOT NULL,
    publishing_period INT NOT NULL,
    editorial_id INT NOT NULL,
    investigation_id INT NOT NULL,
    PRIMARY KEY (journal_id),
    KEY (issn),
    CONSTRAINT
        FOREIGN KEY (editorial_id) REFERENCES editorial(editorial_id),
    CONSTRAINT
        FOREIGN KEY (investigation_id) REFERENCES investigation_area(investigation_area_id)
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
);

CREATE TABLE article_citation (
    citated_article_DOI VARCHAR(50) NOT NULL,
    citating_article_DOI VARCHAR(50) NOT NULL,
    PRIMARY KEY (citated_article_DOI, citating_article_DOI),
    CONSTRAINT
        FOREIGN KEY (citated_article_DOI) REFERENCES article(DOI),
    CONSTRAINT
        FOREIGN KEY (citating_article_DOI) REFERENCES article(DOI)
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
        FOREIGN KEY (article_DOI) REFERENCES article(DOI),
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE reviews (
    sent_date   DATE        NOT NULL,
    result      ENUM ('Positive', 'Negative'),
    review_date DATE,
    DOI         VARCHAR(50) NOT NULL,
    author_id   INT         NOT NULL,
    PRIMARY KEY (DOI, author_id),
    CONSTRAINT
        FOREIGN KEY (DOI) REFERENCES article (DOI),
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
);

CREATE TABLE collaboration (
    collaboration_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    article_DOI VARCHAR(50) NOT NULL,
    PRIMARY KEY (collaboration_id),
    CONSTRAINT
        FOREIGN KEY (article_DOI) REFERENCES article (DOI)
);

CREATE TABLE collab_author_rel (
    collaboration_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (collaboration_id, author_id),
    CONSTRAINT
        FOREIGN KEY (collaboration_id) REFERENCES collaboration (collaboration_id),
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
);

CREATE TABLE affiliation (
    affiliation_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    affiliation_name VARCHAR(250) NOT NULL,
    country_name VARCHAR(250) NOT NULL,
    city VARCHAR(250) NOT NULL,
    PRIMARY KEY (affiliation_id)
);

CREATE TABLE affiliation_author_rel (
    affiliation_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (affiliation_id, author_id),
    CONSTRAINT
        FOREIGN KEY (affiliation_id) REFERENCES affiliation (affiliation_id),
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
);

CREATE TABLE workgroup (
    workgroup_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    name VARCHAR(250) NOT NULL,
    investigation_area_id INT NOT NULL,
    PRIMARY KEY (workgroup_id),
    CONSTRAINT
        FOREIGN KEY (investigation_area_id) REFERENCES investigation_area (investigation_area_id)
);

CREATE TABLE in_workgroup (
    author_id INT NOT NULL,
    affiliation_id INT NOT NULL,
    workgroup_id INT NOT NULL,
    PRIMARY KEY (author_id, affiliation_id, workgroup_id),
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id),
    CONSTRAINT
        FOREIGN KEY (affiliation_id) REFERENCES affiliation (affiliation_id),
    CONSTRAINT
        FOREIGN KEY (workgroup_id) REFERENCES workgroup (workgroup_id)
);
