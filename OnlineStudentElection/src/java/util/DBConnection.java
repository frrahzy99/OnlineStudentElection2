package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:derby://localhost:1527/OnlineStudentElection;create=true";
    private static final String USER = "app";
    private static final String PASSWORD = "app";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connected successfully");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}

//jdbc:derby://localhost:1527/OnlineStudentElection [ on APP]