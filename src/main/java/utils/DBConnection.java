package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static String getEnv(String key, String fallback) {
        String v = System.getenv(key);
        return (v == null || v.trim().isEmpty()) ? fallback : v.trim();
    }

    private static final String HOST     = getEnv("MYSQLHOST", getEnv("DB_HOST", "localhost"));
    private static final String PORT     = getEnv("MYSQLPORT", getEnv("DB_PORT", "3306"));
    private static final String DB       = getEnv("MYSQLDATABASE", getEnv("DB_NAME", "studentdb1"));
    private static final String USER     = getEnv("MYSQLUSER", getEnv("DB_USER", "root"));
    private static final String PASSWORD = getEnv("MYSQLPASSWORD", getEnv("DB_PASSWORD", "Aravind@1727"));

    private static final String URL =
        "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB +
        "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
