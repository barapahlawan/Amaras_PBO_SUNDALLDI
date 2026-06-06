package servlets;  // Ganti sesuai package Anda

import classes.JDBC;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/amaras", "root", ""); // ganti sesuai konfigurasi MySQL Anda

            // Cek apakah email sudah ada
            String checkQuery = "SELECT id FROM pengguna WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Email sudah terdaftar
                response.sendRedirect("Register.jsp?error=email-exists");
            } else {
                // Simpan data baru
                String insertQuery = "INSERT INTO pengguna (fullname, email, password) VALUES (?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                insertStmt.setString(1, fullname);
                insertStmt.setString(2, email);
                insertStmt.setString(3, password);

                insertStmt.executeUpdate();

                // Simpan session & redirect
                HttpSession session = request.getSession();
                session.setAttribute("fullname", fullname);
                session.setAttribute("email", email);
                response.sendRedirect("dashboard.jsp");

                insertStmt.close();
            }

            rs.close();
            checkStmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Register.jsp?error=exception");
        }
    }
}
