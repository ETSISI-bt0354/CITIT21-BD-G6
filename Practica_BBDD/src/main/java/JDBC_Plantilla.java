import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JDBC_Plantilla {

    private static final String DB_SERVER = "contabo";

    private static final int DB_PORT = 6033;

    private static final String DB_NAME =  "bd-citit21-g6";

    private static final String DB_USER = "bd-citit21-g6";

    private static final String DB_PASS = "le_cwoissant69";

    private static Connection conn;

    public static void main(String[] args) throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://" + DB_SERVER + ":" + DB_PORT + "/" + DB_NAME;
        conn = DriverManager.getConnection(url, DB_USER, DB_PASS);

        nuevoAutor("Burgos I.");
        nuevoAutor("Serrano M.");
        nuevoAutor("Benjumea J.");
        nuevoAutor("Valecillos D.");
        nuevoAutor("García, J.");
        listaArticulosPorAutor("Ortega F.", 2021);
        listaAfiliaciones();

        conn.close();
    }

    private static void nuevoAutor (String authorName) throws SQLException {

        ResultSet rs = conn.createStatement().executeQuery("SELECT MAX(author_id) FROM author");
        rs.next();

        boolean colission = false;
        PreparedStatement stmt = conn.prepareStatement("INSERT INTO author (author_id, author_name, importance) VALUES (?, ?, 0)");
        stmt.setString(2, authorName);
        while (!colission)
        {
            try
            {
                stmt.setLong(1, new Random().nextLong());
                stmt.executeUpdate();
                colission = true;
            }
            catch (SQLIntegrityConstraintViolationException ignored) {}
        }
        stmt.close();

    }

    private static void listaArticulosPorAutor (String authorName, int year) throws SQLException {
        List<String> result = new ArrayList<>();

        PreparedStatement stmt = conn.prepareStatement("""
           SELECT title, publication_date FROM article
           JOIN author_article ON article.DOI = author_article.DOI
           JOIN author ON author_article.author_id = author.author_id 
           WHERE author_name = ? AND YEAR(publication_date) = ?
           """);

        stmt.setString(1, authorName);
        stmt.setInt(2, year);

        ResultSet rs = stmt.executeQuery();
        while(rs.next()){
            String title = rs.getString(1);
            Date date = rs.getDate(2);
            result.add(title + " - " + date.toString());
        }
        result.stream().forEach(System.out::println);
        stmt.close();
    }

    private static void listaAfiliaciones() throws SQLException {
        List<String> result = new ArrayList<>();
        PreparedStatement stmt = conn.prepareStatement("""
            SELECT affiliation_name, COUNT(author_affiliation.author_id) AS num_authors FROM affiliation 
            JOIN author_affiliation ON affiliation.affiliation_id = author_affiliation.affiliation_id 
            GROUP BY affiliation_name ORDER BY num_authors DESC
            """);
        ResultSet rs = stmt.executeQuery();
        while(rs.next()){
            String affiliationName = rs.getString(1);
            int numAuthors = rs.getInt(2);
            result.add(affiliationName + " - " + numAuthors);
        }
        result.stream().forEach(System.out::println);
        stmt.close();
    }
}
