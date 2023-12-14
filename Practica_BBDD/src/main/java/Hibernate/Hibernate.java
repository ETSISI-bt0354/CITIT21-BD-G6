package Hibernate;

import Hibernate.model.Affiliation;
import Hibernate.model.Author;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class Hibernate {

    public static void main (String[] args) throws Exception {
        StandardServiceRegistry registry = new StandardServiceRegistryBuilder()
                .configure()
                .build();

        SessionFactory sessionFactory = new MetadataSources(registry)
                .buildMetadata()
                .buildSessionFactory();

        Session session = sessionFactory.openSession();

        // @TODO Crea una afiliación con nombre "Universidad Politécnica de Madrid" de la
        // ciudad de Madrid, España y guarda dicha afiliación en la base de datos.

        Affiliation affiliation = new Affiliation("Universidad Politécnica de Madrid", "Madrid", "España");
        session.beginTransaction();
        session.save(affiliation);
        session.getTransaction().commit();

        // @TODO Lee el fichero CSV authors.csv que encontrarás en resources y recorrelo usando
        // CSVParser para crear los autores que en el se encuentran. Asigna dichos autores a la
        // afiliación creada anteriormente. Guarda estos autores y sus afiliaciones en la base
        // de datos.

        CSVParser parser = CSVParser.parse(Files.newBufferedReader(Paths.get("/home/intron014/UPM/BDWork/Practica_BBDD/src/main/resources/authors.csv")), CSVFormat.RFC4180);
        List<CSVRecord> theList = parser.getRecords();
        theList.remove(0);
        for(CSVRecord csvRecord : theList){
            String authorName = csvRecord.get(0);
            double importance = Double.parseDouble(csvRecord.get(1));
            Author author = new Author(authorName, importance);
            affiliation.getAuthors().add(author);
        }
        session.beginTransaction();
        session.saveOrUpdate(affiliation);
        session.getTransaction().commit();
        session.close();
    }
}
