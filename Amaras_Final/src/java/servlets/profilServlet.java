/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this lic   ense
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 *
 * @author Alexandra Naibaho
 */
@WebServlet(name = "profilServlet", urlPatterns = {"/profilServlet"})
public class profilServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ambil session login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("id");
        String fullname = (String) session.getAttribute("fullname");

        // List untuk menyimpan riwayat donasi
        List<Map<String, Object>> donasiList = new ArrayList<>();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Koneksi ke database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/nama_database", "root", "password");

            String sql = "SELECT id_donasi, jumlah_donasi, metode_pembayaran, tanggal_donasi FROM donasi WHERE id = ? ORDER BY tanggal_donasi DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> donasi = new HashMap<>();
                donasi.put("id_donasi", rs.getInt("id_donasi"));
                donasi.put("jumlah_donasi", rs.getInt("jumlah_donasi"));
                donasi.put("metode_pembayaran", rs.getString("metode_pembayaran"));
                donasi.put("tanggal_donasi", rs.getTimestamp("tanggal_donasi"));
                donasi.put("fullname", fullname); // dari session
                donasiList.add(donasi);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Tutup koneksi
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        // Kirim ke JSP
        request.setAttribute("donasiHistory", donasiList);
        RequestDispatcher rd = request.getRequestDispatcher("profil.jsp");
        rd.forward(request, response);
    }
}
