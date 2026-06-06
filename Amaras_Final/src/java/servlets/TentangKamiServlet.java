/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets; 

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TentangKamiervlet")
public class TentangKamiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/amaras", "root", "");
            
            PreparedStatement ps = null;

            if ("updateDeskripsi".equals(action)) {
                String deskripsi = request.getParameter("deskripsi");
                ps = conn.prepareStatement("UPDATE tentang_kami SET deskripsi = ? WHERE id = 1");
                ps.setString(1, deskripsi);

            } else if ("updateVisiMisi".equals(action)) {
                String visimisi = request.getParameter("visimisi");
                ps = conn.prepareStatement("UPDATE tentang_kami SET visimisi = ? WHERE id = 1");
                ps.setString(1, visimisi);

            } else if ("updateKontak".equals(action)) {
                String kontak = request.getParameter("kontak");
                String alamat = request.getParameter("alamat");
                ps = conn.prepareStatement("UPDATE tentang_kami SET kontak = ?, alamat = ? WHERE id = 1");
                ps.setString(1, kontak);
                ps.setString(2, alamat);
            }

            if (ps != null) {
                ps.executeUpdate();
                ps.close();
            }


            conn.close();

            // ✅ Redirect ke halaman admin yang akan menampilkan perubahan
            response.sendRedirect("TentangKamiAdmin.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().println("<p style='color:red;'>Terjadi kesalahan: " + e.getMessage() + "</p>");
        }
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */