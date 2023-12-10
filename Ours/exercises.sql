# g) Resolver en SQL la consulta: “Obtener el nombre de la revista y el total de ci-
# tas (num citations) que hayan recibido sus artı́culos para aquella/s revista/s
# que, perteneciendo al primer cuartil del factor de impacto (q1), tengan el mayor
# número de citas de toda la base de datos”.

SELECT j.journal_name AS journal_name, SUM(a.num_citations) AS total_citations
FROM journal j
JOIN article a ON j.journal_id = a.journal_id
WHERE JIF_Quartile = 'Q1'
GROUP BY j.journal_name
ORDER BY total_citations DESC;

# h) Resolver en SQL la consulta: “Obtener aquellas entidades (affiliation name)
# que tienen asociados al menos 10 autores que hayan publicado más de 5 artı́culos
# en el año más reciente que figuren en la base de datos (este año debe calcularse
# de forma dinámica con la consulta)”.

SELECT a.affiliation_name
FROM affiliation a
WHERE a.affiliation_id IN (
    SELECT aa.affiliation_id
    FROM author_affiliation aa
    WHERE aa.author_id IN (
        SELECT aa.author_id
        FROM author_article aa
        JOIN `bd-citit21-g6`.author a2 on a2.author_id = aa.author_id
        JOIN `bd-citit21-g6`.author_affiliation aa2 on a2.author_id = aa2.author_id
        JOIN `bd-citit21-g6`.article a3 on aa.DOI = a3.DOI
        WHERE YEAR(a3.publication_date) = (
            SELECT MAX(YEAR(a3.publication_date))
            FROM article a3
        )
    )
    GROUP BY aa.affiliation_id
    HAVING COUNT(aa.author_id) >= 10
);

# m) Crear una función que, recibiendo como parámetro un identificador de una revista
# devuelva el número medio de artı́culos por año que dicha revista ha publicado.
# Escribir el código necesario para poder probarlo.

DELIMITER $$
CREATE FUNCTION average_article_per_year(id INT)
    RETURNS DECIMAL(10,2)
    DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE date, min_date DATE;
    DECLARE num_articles INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT publication_date FROM article where journal_id = id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO date;
        IF date < min_date THEN
            SET min_date = date;
        END IF;
        SET num_articles = num_articles + 1;

        IF done THEN
            LEAVE read_loop;
        END IF;
    END LOOP;
    CLOSE cur;

    RETURN num_articles / (YEAR(CURDATE()) - YEAR(min_date) + 1);

END $$
DELIMITER ;