import java.sql.Connection;
import java.sql.Statement;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import utils.DBConnection;

@WebListener
public class SchemaInit implements ServletContextListener {

    private static final String[] DDL = {
        "CREATE TABLE IF NOT EXISTS students ("
        + " id INT NOT NULL AUTO_INCREMENT,"
        + " fullname VARCHAR(100) DEFAULT NULL,"
        + " username VARCHAR(50) DEFAULT NULL,"
        + " password VARCHAR(100) DEFAULT NULL,"
        + " phone VARCHAR(15) DEFAULT NULL,"
        + " email VARCHAR(100) DEFAULT NULL,"
        + " student_code VARCHAR(30) DEFAULT NULL,"
        + " PRIMARY KEY (id),"
        + " UNIQUE KEY username (username),"
        + " UNIQUE KEY phone (phone),"
        + " UNIQUE KEY email (email),"
        + " UNIQUE KEY student_code (student_code)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        "CREATE TABLE IF NOT EXISTS student_phones ("
        + " id INT NOT NULL AUTO_INCREMENT,"
        + " student_code VARCHAR(30) NOT NULL,"
        + " phone VARCHAR(15) NOT NULL,"
        + " PRIMARY KEY (id),"
        + " UNIQUE KEY phone (phone)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        "CREATE TABLE IF NOT EXISTS users ("
        + " id INT NOT NULL AUTO_INCREMENT,"
        + " name VARCHAR(100) DEFAULT NULL,"
        + " username VARCHAR(50) DEFAULT NULL,"
        + " password VARCHAR(100) DEFAULT NULL,"
        + " phone VARCHAR(20) DEFAULT NULL,"
        + " email VARCHAR(100) DEFAULT NULL,"
        + " regno VARCHAR(30) DEFAULT NULL,"
        + " PRIMARY KEY (id),"
        + " UNIQUE KEY username (username)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    };

    public void contextInitialized(ServletContextEvent sce) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                sce.getServletContext().log("SchemaInit: no database connection available");
                return;
            }
            Statement st = con.createStatement();
            for (String sql : DDL) {
                st.executeUpdate(sql);
            }
            st.close();
            con.close();
            sce.getServletContext().log("SchemaInit: tables ensured");
        } catch (Exception e) {
            sce.getServletContext().log("SchemaInit: failed", e);
        }
    }

    public void contextDestroyed(ServletContextEvent sce) {
    }
}
