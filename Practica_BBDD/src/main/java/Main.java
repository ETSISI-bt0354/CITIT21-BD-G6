import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            System.out.println("Whoops, exception error!");
            ex.printStackTrace();
            System.exit(1);
        }
        Connection conn = null;
        try{
            conn = DriverManager.getConnection("jdbc:mysql://contabo:6033/bd-citit21-g6", "bd-citit21-g6", "le_cwoissant69");
            // nuevoAutor("Burgos I.", conn);
            // nuevoAutor("Serrano M.", conn);
            // nuevoAutor("Benjumea J.", conn);
            // listaArticulosPorAutor("Ortega F.", 2021, conn).stream().forEach(System.out::println);
            listaAfiliaciones(conn).stream().forEach(System.out::println);
            conn.close();
        } catch (Exception ex) {
            System.out.println("Uh oh, something that I don't know happened!");
            ex.printStackTrace();
            System.exit(2);
        }
    }

    private static void nuevoAutor(String authorName, Connection conn){
        try {
            ResultSet rs = conn.createStatement().executeQuery("SELECT MAX(author_id) FROM author");
            rs.next();
            Long index = rs.getLong(1);

            PreparedStatement stmt = conn.prepareStatement("INSERT INTO author (author_id, author_name, importance) VALUES (?, ?, 0)");

            stmt.setLong(1, index + 1);
            stmt.setString(2, authorName);

            stmt.executeUpdate();
            stmt.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private static List<String> listaArticulosPorAutor(String authorName, int year, Connection conn) {
        List<String> result = new ArrayList<>();
        try {
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
            stmt.close();
        } catch (SQLException e) {
            System.out.println("Authoooooor is goneeeeeee");
            throw new RuntimeException(e);
        }
        return result;
    }

    private static List<String> listaAfiliaciones(Connection conn) {
        List<String> result = new ArrayList<>();
        try{
            PreparedStatement stmt = conn.prepareStatement("""
            SELECT affiliation_name, COUNT(author_affiliation.author_id) AS num_authors FROM affiliation JOIN author_affiliation 
            ON affiliation.affiliation_id = author_affiliation.affiliation_id GROUP BY affiliation_name ORDER BY num_authors DESC
            """);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()){
                String affiliationName = rs.getString(1);
                int numAuthors = rs.getInt(2);
                result.add(affiliationName + " - " + numAuthors);
            }
            stmt.close();
        } catch (SQLException e) {
            System.out.println("Cough cough cough...");
            throw new RuntimeException(e);
        }
        return result;
    }
}
