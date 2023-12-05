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