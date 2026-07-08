import java.sql.Connection;
import java.sql.PreparedStatement;

public class SaveMessage {
    public static void saveMessage() {
        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO messages(text) VALUES(?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "Hello World");
            ps.setString(1, "Hello India");


            ps.executeUpdate();
            System.out.println("Saved");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}