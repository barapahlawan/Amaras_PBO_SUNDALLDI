/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/totalDonasi")
public class totalDonasi extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        // Ambil data dari form
        String jumlahStr = request.getParameter("jumlah_donasi");
        String metodePembayaran = request.getParameter("metode_pembayaran");
        
        // Ambil ID pengguna dari session (harus login dulu)
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");
        
        if (userEmail == null) {
            // User belum login, redirect ke halaman login
            response.sendRedirect("Login.jsp?error=mustLogin");
            return;
        }
        
        // Validasi input
        if (jumlahStr == null || jumlahStr.trim().isEmpty() ||
            metodePembayaran == null || metodePembayaran.trim().isEmpty()) {
            response.sendRedirect("Donasi.jsp?error=emptyFields");
            return;
        }
        
        int jumlahDonasi;
        try {
            jumlahDonasi = Integer.parseInt(jumlahStr);
            if (jumlahDonasi <= 0) {
                response.sendRedirect("Donasi.jsp?error=invalidAmount");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("Donasi.jsp?error=invalidAmount");
            return;
        }
        
        Connection conn = null;
        PreparedStatement getUserStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet userRs = null;
        ResultSet generatedKeys = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/amaras", "root", "");
            
            // Ambil ID pengguna berdasarkan email dari session
            String getUserSql = "SELECT id FROM pengguna WHERE email = ?";
            getUserStmt = conn.prepareStatement(getUserSql);
            getUserStmt.setString(1, userEmail);
            userRs = getUserStmt.executeQuery();
            
            if (!userRs.next()) {
                // Email tidak ditemukan di database pengguna
                response.sendRedirect("Login.jsp?error=userNotFound");
                return;
            }
            
            int userId = userRs.getInt("id");
            
            // Insert data donasi ke database dengan ID pengguna
            String insertSql = "INSERT INTO donasi (id, jumlah_donasi, metode_pembayaran, tanggal_donasi) VALUES (?, ?, ?, ?)";
            insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            
            insertStmt.setInt(1, userId); // ID dari tabel pengguna
            insertStmt.setInt(2, jumlahDonasi);
            insertStmt.setString(3, metodePembayaran);
            insertStmt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            
            int rowsAffected = insertStmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Ambil ID donasi yang baru dibuat
                generatedKeys = insertStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int donasiId = generatedKeys.getInt(1);
                    
                    // Ambil total donasi dari semua pengguna
                    String totalDonasiSql = "SELECT SUM(jumlah_donasi) AS total_donasi FROM donasi";
                    PreparedStatement totalStmt = conn.prepareStatement(totalDonasiSql);
                    ResultSet totalRs = totalStmt.executeQuery();
                    
                    long totalDonasi = 0;
                    if (totalRs.next()) {
                        totalDonasi = totalRs.getLong("total_donasi");
                    }
                    
                    // Simpan informasi donasi di session
                    session.setAttribute("id_donasi", donasiId);
                    session.setAttribute("userId", userId);
                    session.setAttribute("jumlahDonasi", jumlahDonasi);
                    session.setAttribute("metodePembayaran", metodePembayaran);
                    session.setAttribute("totalDonasi", totalDonasi);  // Set total donasi ke session
                    
                    // Redirect ke halaman konfirmasi
                    response.sendRedirect("Donasi.jsp?success=true");
                } else {
                    response.sendRedirect("Donasi.jsp?error=failedToGetId");
                }
            } else {
                response.sendRedirect("Donasi.jsp?error=failedToInsert");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Donasi.jsp?error=database");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("Donasi.jsp?error=driver");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Donasi.jsp?error=exception");
        } finally {
            // Tutup semua koneksi
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (userRs != null) userRs.close();
                if (getUserStmt != null) getUserStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
}

