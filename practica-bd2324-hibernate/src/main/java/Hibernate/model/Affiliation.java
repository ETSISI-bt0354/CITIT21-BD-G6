package Hibernate.model;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

// @TODO Realiza todas las anotaciones necesarias en esta clase para que
// que sus instancias sean guardadas en la base de datos utilizando
// Hibernate. Respecta las restricciones de modelado impuestas en el
// enunciado de la práctica. No es necesario modificar el código de esta
// clase, únicamente debes hacer las anotaciones que consideres
// necesarias.
@Entity
@Table(name = "affiliation")
public class Affiliation {

    @Id
    @GeneratedValue
    @Column(name = "affiliation_id", nullable = false)
    private Long affiliation_id;

    @Column(name = "affiliation_name", length = 400, nullable = false)
    private String affiliation_name;

    @Column(name = "city", length = 200)
    private String city;

    @Column(name = "country_name", length = 200)
    private String country_name;

    @ManyToMany
    @JoinTable(name = "author_affiliation")
    private Set<Author> authors;

    public Affiliation() {

    }

    public Affiliation(String affiliation_name, String city, String country_name) {
        this.affiliation_name = affiliation_name;
        this.city = city;
        this.country_name = country_name;
        this.authors = new HashSet<>();
    }

    public Long getAffiliation_id() {
        return affiliation_id;
    }

    public String getAffiliation_name() {
        return affiliation_name;
    }

    public String getCity() {
        return city;
    }

    public String getCountry_name() {
        return country_name;
    }

    public Set<Author> getAuthors() {
        return authors;
    }
}
