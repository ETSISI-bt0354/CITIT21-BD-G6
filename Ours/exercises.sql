# c) Resolver en SQL la consulta: “Obtener los nombres, en orden alfabético, de aque-
# llos autores que perteneciendo a la “Universidad Politécnica de Madrid” han pu-
# blicado algún artículo en el año 2020 o en el año 2021 ”.

SELECT author_name
FROM author
    JOIN author_article ON author.author_id = author_article.author_id
    JOIN author_affiliation ON author.author_id = author_affiliation.author_id
    JOIN affiliation ON author_affiliation.affiliation_id = affiliation.affiliation_id
    JOIN article ON author_article.DOI = article.DOI
WHERE affiliation.affiliation_name = 'Universidad Politecnica de Madrid'
  AND (YEAR(article.publication_date) = 2020 OR YEAR(article.publication_date) = 2021)
ORDER BY author.author_name ASC;

# d) Resolver en SQL la consulta: “Obtener los nombres, en orden alfabético, de aque-
# llos autores que perteneciendo a la “Universidad Politécnica de Madrid” han pu-
# blicado algún artículo en el año 2020 y tambien en el año 2021 ”.

SELECT author_name
FROM author
    JOIN author_article ON author.author_id = author_article.author_id
    JOIN author_affiliation ON author.author_id = author_affiliation.author_id
    JOIN affiliation ON author_affiliation.affiliation_id = affiliation.affiliation_id
    JOIN article ON author_article.DOI = article.DOI
WHERE affiliation.affiliation_name = 'Universidad Politecnica de Madrid'
  AND YEAR(article.publication_date) = 2020
  AND author.author_id IN (
  SELECT author.author_id
  FROM author
      JOIN author_article ON author.author_id = author_article.author_id
      JOIN author_affiliation ON author.author_id = author_affiliation.author_id
      JOIN affiliation ON author_affiliation.affiliation_id = affiliation.affiliation_id
      JOIN article ON author_article.DOI = article.DOI
  WHERE affiliation.affiliation_name = 'Universidad Politecnica de Madrid'
    AND YEAR(article.publication_date) = 2021
  )
ORDER BY author.author_name ASC;

# e) Obtener el nombre de los autores y el nombre de la afiliación
# de aquellos autores que, perteneciendo a alguna entidad española,
# no han publicado ningún artículo ni en 2020 ni en 2021, ordenados
# por afiliación y dentro de cada entidad, por nombre de autor

SELECT affiliation_name, author.author_name
FROM author
JOIN author_affiliation ON author.author_id = author_affiliation.author_id
JOIN affiliation ON author_affiliation.affiliation_id = affiliation.affiliation_id
WHERE affiliation.country_name = 'spain'
AND author.author_id NOT IN (SELECT author.author_id
	FROM author
	JOIN author_article ON author.author_id = author_article.author_id
	JOIN article ON author_article.DOI = article.DOI
	WHERE YEAR(article.publication_date) = 2021 OR YEAR(article.publication_date) = 2020)
ORDER BY affiliation_name, author.author_name ASC;


# f) Obtener el nombre de la revista, su issn y el total
# de citas (num citations) de todos los artículos publicados
# para cada una de ellas en aquellas revistas que están clasificadas
# dentro del primer cuartil de factor de impacto (Q1)

SELECT journal_name, issn, SUM(article.num_citations) AS total_citations
FROM journal
JOIN article ON journal.journal_id = article.journal_id
WHERE journal.JIF_Quartile = 'Q1'
GROUP BY journal_name, issn;

# g) Resolver en SQL la consulta: “Obtener el nombre de la revista y el total de ci-
# tas (num citations) que hayan recibido sus artículos para aquella/s revista/s
# que, perteneciendo al primer cuartil del factor de impacto (Q1), tengan el mayor
# número de citas de toda la base de datos”.

SELECT journal_name, SUM(article.num_citations) AS total_citations
FROM journal
JOIN article ON journal.journal_id = article.journal_id
WHERE JIF_Quartile = 'Q1'
GROUP BY journal.journal_name
HAVING total_citations >= ALL (
    SELECT SUM(article.num_citations)
    FROM journal
    JOIN article ON journal.journal_id = article.journal_id
    GROUP BY journal.journal_id
);

# h) Resolver en SQL la consulta: “Obtener aquellas entidades (affiliation name)
# que tienen asociados al menos 10 autores que hayan publicado más de 5 artı́culos
# en el año más reciente que figuren en la base de datos (este año debe calcularse
# de forma dinámica con la consulta)”.

SELECT affiliation_name
FROM affiliation
WHERE affiliation.affiliation_id IN (
    SELECT affiliation_id
    FROM author_affiliation
    WHERE author_affiliation.author_id IN (
        SELECT author_article.author_id
        FROM author_article
        JOIN article on author_article.DOI = article.DOI
        WHERE YEAR(article.publication_date) = (
            SELECT MAX(YEAR(article.publication_date))
            FROM article
        )
        GROUP BY author_article.author_id
        HAVING COUNT(*) >= 5
    )
    GROUP BY author_affiliation.affiliation_id
    HAVING COUNT(*) >= 10
);

# i) Resolver en SQL la consulta: “Obtener el nombre de aquellas revistas que, ha-
# biendo publicado más de 300 artículos en el año de mayor antigüedad que figure
# en la base de datos tengan un factor de impacto (JIF) superior a la media de
# los factores de impacto del global de las revistas de la base de datos. El año debe
# calcularse de forma dinámica con la consulta”.

SELECT journal.journal_name
FROM journal
JOIN article on journal.journal_id = article.journal_id
WHERE journal.JIF > (
    SELECT AVG(journal.JIF)
    FROM journal )
AND YEAR(article.publication_date) = (
    SELECT MIN(YEAR(article.publication_date))
    FROM article )
GROUP BY article.journal_id, journal.journal_name
HAVING COUNT(article.DOI) > 300;

# j) Resolver en SQL la consulta: “Obtener el nombre de aquellas revistas que hayan
# recibido en el global de sus artículos un mayor número de citas que la media de
# las citas recibidas por cada revista para el global de sus artículos de la base de
# datos”.

SELECT journal_name
FROM journal
JOIN article on journal.journal_id = article.journal_id
GROUP BY article.journal_id
HAVING SUM(article.num_citations) > (
    SELECT AVG(globalCitations)
    FROM (
        SELECT SUM(article.num_citations) as globalCitations
        FROM article
        GROUP BY article.journal_id
    ) AS avg_citations
);

# k) Resolver en SQL la consulta: “Obtener el nombre de aquellos autores que hayan
# publicado artículos en todos los diferentes años que figuren en la base de datos”.

SELECT author_name
FROM author
JOIN author_article ON author.author_id = author_article.author_id
JOIN article ON author_article.DOI = article.DOI
GROUP BY author.author_id
HAVING COUNT(DISTINCT YEAR(article.publication_date)) = (
    SELECT COUNT(DISTINCT YEAR(article.publication_date))
    FROM article
);

# l) Crear un procedimiento que, recibiendo un año como parámetro, devuelva, en
# dos parámetros de salida, el nombre de la revista y el número de autores para
# aquella revista que haya publicado en dicho año el artı́culo con un mayor número
# de autores. Si existen varias revistas con el máximo de autores, habrá que propor-
# cionar como resultado una cadena que contenga, separados por puntos y comas,
# los nombres de dichas revistas (en un parámetro de salida solamente puede de-
# volverse un valor). Se deberá usar obligatoriamente, al menos, un cursor en la
# resolución del procedimiento.

DELIMITER $$
CREATE PROCEDURE article_max_author (IN search_year INT, OUT article_name VARCHAR(722), OUT num_author INT)
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE one_article INT DEFAULT TRUE;
    DECLARE title VARCHAR(240);
    DECLARE cur CURSOR FOR SELECT article.title, COUNT(author_id) as num_auth
							FROM article 
							JOIN author_article ON author_article.DOI = article.DOI
                            WHERE year(publication_date) = search_year
                            GROUP BY title, author_article.DOI
                            HAVING num_auth >= all(SELECT count(*) 
											FROM author_article 
                                            WHERE author_article.DOI IN (SELECT article.DOI FROM article WHERE year(article.publication_date) = search_year)
                                            GROUP BY DOI);
                            
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
		FETCH cur INTO title, num_author;
        IF done THEN
			LEAVE read_loop;
		END IF;
        
        IF one_article THEN
			SET article_name = title;
            SET one_article = FALSE;
		ELSE
			SET article_name = CONCAT(article_name, ';', title);
		END IF;
	END LOOP;
    CLOSE cur;
END$$
DELIMITER ;

# m) Crear una función que, recibiendo como parámetro un identificador de una revista
# devuelva el número medio de artı́culos por año que dicha revista ha publicado.
# Escribir el código necesario para poder probarlo.

DELIMITER $$
CREATE FUNCTION journal_average_article_per_year(id BIGINT)
    RETURNS DECIMAL(10, 4)
    DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE article_date, min_date DATE;
    DECLARE num_articles INT DEFAULT 0;
    DECLARE ratio DECIMAL(10, 2);
    DECLARE cur CURSOR FOR SELECT publication_date FROM article where journal_id = id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO article_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        IF min_date IS NULL OR article_date < min_date THEN
            SET min_date = article_date;
        END IF;
        
        SET num_articles = num_articles + 1;
        
    END LOOP;
    CLOSE cur;

    RETURN num_articles / (YEAR(CURDATE()) - YEAR(min_date) + 1); # +1 por división por cero. Si solo has publicado 2 artículos en elaño actual, serían 2 / 1 año

END $$
DELIMITER ;

SELECT distinct journal_id, journal_average_article_per_year(journal_id) from journal;

# n) Crear la tabla correspondiente a la asignación y realización de las revisiones de los
# artı́culos por parte de los autores (que actúan como revisores) que se ha obtenido
# en el análisis inicial. Una vez creada, crear un trigger que impida que se pueda
# insertar a un revisor de un artı́culo si dicho revisor figura ya como autor del
# mismo. Probar su funcionamiento con el código necesario.

CREATE TABLE reviews (
    sent_date   DATE        NOT NULL,
    result      ENUM ('Positive', 'Negative') DEFAULT NULL,
    review_date DATE		DEFAULT NULL,
    DOI         VARCHAR(50) NOT NULL,
    author_id   BIGINT         NOT NULL,
    PRIMARY KEY (DOI, author_id),
    CONSTRAINT
        FOREIGN KEY (DOI) REFERENCES article (DOI),
    CONSTRAINT
        FOREIGN KEY (author_id) REFERENCES author (author_id)
);
DROP TRIGGER author_does_not_review;
DELIMITER $$
CREATE TRIGGER author_does_not_review BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
	IF EXISTS(SELECT * FROM author_article WHERE author_article.DOI = NEW.DOI AND author_article.author_id = NEW.author_id) THEN
		SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'Error: EL autor no puede ser revisor de su artículo';
	END IF;
END $$
DELIMITER ;

# No falla
INSERT INTO reviews (DOI, author_id, sent_date) VALUES ('10.1080/0144929X.2016.1159249', 6503848058, '2020/05/04');

# Falla
INSERT INTO reviews (DOI, author_id, sent_date) VALUES ('10.1080/0144929X.2016.1159249', 36818108400, '2020/05/04');

SELECT * FROM reviews;