package classes;

import java.sql.*;

public class JDBC {
    private Connection con;
    private boolean isConnected;
    private String message;
    
    public Connection connect() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/amaras?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                "root", "");
            isConnected = true;
            message = "DB connected";
            System.out.println("Database connection successful!");
            return con;
        } catch (Exception e) {
            isConnected = false;
            message = e.getMessage();
            System.err.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public void disconnect(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database disconnected successfully");
            }
        } catch(Exception e) {
            message = e.getMessage();
            System.err.println("Error during disconnect: " + e.getMessage());
        }
    }
    
    public String getData(String query, String namaKolom, String param) {
        String dataDariDB = null;
        Connection connection = null;
        try {
            connection = connect();
            if (!isConnected || connection == null) {
                return null;
            }
            PreparedStatement pst = connection.prepareStatement(query);
            pst.setString(1, param);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                dataDariDB = rs.getString(namaKolom);
                if (dataDariDB != null) {
                    dataDariDB = dataDariDB.trim();
                }
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            System.err.println("Error in getData: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            disconnect(connection);
        }
        return dataDariDB;
    }
    
    public boolean runQuery(String query, String... params) {
        boolean success = false;
        Connection connection = null;
        try {
            connection = connect();
            if (!isConnected || connection == null) {
                System.err.println("Cannot execute query - not connected: " + message);
                return false;
            }
            PreparedStatement pst = connection.prepareStatement(query);
            for (int i = 0; i < params.length; i++) {
                pst.setString(i + 1, params[i]);
            }
            int affectedRows = pst.executeUpdate();
            success = affectedRows > 0;
            pst.close();
            System.out.println("Query executed, rows affected: " + affectedRows);
        } catch (Exception e) {
            message = e.getMessage();
            System.err.println("Error in runQuery: " + e.getMessage());
            e.printStackTrace();
        } finally {
            disconnect(connection);
        }
        return success;
    }
    
    public boolean isConnected() {
        return isConnected;
    }
    
    public String getMessage() {
        return message;
    }
}
