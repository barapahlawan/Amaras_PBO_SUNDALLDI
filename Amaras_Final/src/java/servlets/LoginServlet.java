package servlets; // Ganti sesuai dengan package-mu

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Hardcoded admin credentials
        String adminEmail = "admin@mail.com";
        String adminPassword = "admin";

        try {
            // Cek apakah ini login admin yang di-hardcode
            if (email.equals(adminEmail) && password.equals(adminPassword)) {
                HttpSession session = request.getSession();
                session.setAttribute("fullname", "Admin Amaras"); // Atau nama lain untuk admin
                session.setAttribute("email", adminEmail);
                response.sendRedirect("dashboardAdmin.jsp"); // Redirect ke dashboard admin
                return; // Penting: hentikan eksekusi selanjutnya setelah redirect
            }

            // Jika bukan admin yang di-hardcode, lanjutkan dengan pengecekan database untuk pengguna biasa
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/amaras", "root", ""); // Ganti sesuai database Anda

            // Cek apakah email ada di database
            String checkEmailSql = "SELECT * FROM pengguna WHERE email=?";
            PreparedStatement checkEmailStmt = conn.prepareStatement(checkEmailSql);
            checkEmailStmt.setString(1, email);
            ResultSet emailRs = checkEmailStmt.executeQuery();

            if (!emailRs.next()) {
                // Email tidak ditemukan
                response.sendRedirect("Login.jsp?error=emailNotRegistered");
            } else {
                // Email ditemukan, cek password
                String checkPasswordSql = "SELECT fullname FROM pengguna WHERE email=? AND password=?"; // Tidak perlu mengambil role
                PreparedStatement checkPasswordStmt = conn.prepareStatement(checkPasswordSql);
                checkPasswordStmt.setString(1, email);
                checkPasswordStmt.setString(2, password);
                ResultSet loginRs = checkPasswordStmt.executeQuery();

                if (loginRs.next()) {
                    // Login pengguna biasa berhasil
                    HttpSession session = request.getSession();
                    session.setAttribute("fullname", loginRs.getString("fullname"));
                    session.setAttribute("email", email);
                    response.sendRedirect("dashboard.jsp"); // Redirect ke dashboard pengguna
                } else {
                    // Password salah
                    response.sendRedirect("Login.jsp?error=wrongPassword");
                }

                loginRs.close();
                checkPasswordStmt.close();
            }

            emailRs.close();
            checkEmailStmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Login.jsp?error=exception");
        }
    }
}