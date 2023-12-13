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
            conn = DriverManager.getConnection("jdbc:mysql://contabo:6033", "bd-citit21-g6", "le_cwoissant69");
        } catch (Exception ex) {
            System.out.println("Uh oh, something that I don't know happened!");
            ex.printStackTrace();
            System.exit(2);
        }
    }

    private static void nuevoAutor(String authorName){

    }
}
