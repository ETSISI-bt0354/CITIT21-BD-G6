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
}
