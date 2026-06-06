package servlets;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/donasiServlet")
public class donasiServlet extends HttpServlet {

    // Email admin hardcoded (SANGAT disarankan untuk menggunakan sistem peran/role yang lebih aman di produksi)
    private static final String ADMIN_EMAIL = "admin@mail.com";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ambil data dari form donasi (dari Donasi.jsp atau serupa)
        String jumlahStr = request.getParameter("jumlah_donasi");
        String metodePembayaran = request.getParameter("metode_pembayaran");

        // Ambil email pengguna dari session (pastikan pengguna sudah login)
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");

        // Jika user belum login, redirect ke halaman login
        if (userEmail == null || userEmail.trim().isEmpty()) {
            response.sendRedirect("Login.jsp?error=mustLogin");
            return;
        }

        // Validasi input form
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
        ResultSet generatedKeys = null; // Untuk mengambil ID donasi yang di-generate

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
                response.sendRedirect("Login.jsp?error=userNotFound"); // User tidak ditemukan
                return;
            }

            int userId = userRs.getInt("id"); // Dapatkan ID pengguna

            // Masukkan data donasi ke tabel 'donasi'
            // Asumsi: tabel donasi memiliki kolom id_donasi (PK, AUTO_INCREMENT), id (FK ke pengguna), jumlah_donasi, metode_pembayaran, tanggal_donasi
            String insertSql = "INSERT INTO donasi (id, jumlah_donasi, metode_pembayaran, tanggal_donasi) VALUES (?, ?, ?, ?)";
            insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);

            insertStmt.setInt(1, userId); // FK id dari tabel pengguna
            insertStmt.setInt(2, jumlahDonasi);
            insertStmt.setString(3, metodePembayaran);
            insertStmt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));

            int rowsAffected = insertStmt.executeUpdate();

            if (rowsAffected > 0) {
                generatedKeys = insertStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int donasiId = generatedKeys.getInt(1); // Ambil id_donasi yang baru di-generate

                    // Simpan beberapa detail donasi ke session jika diperlukan untuk konfirmasi
                    session.setAttribute("id_donasi", donasiId);
                    session.setAttribute("jumlahDonasi", jumlahDonasi);
                    session.setAttribute("metodePembayaran", metodePembayaran);

                    response.sendRedirect("Donasi.jsp?success=true"); // Redirect ke halaman Donasi dengan pesan sukses
                } else {
                    response.sendRedirect("Donasi.jsp?error=failedToGetId");
                }
            } else {
                response.sendRedirect("Donasi.jsp?error=failedToInsert");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Donasi.jsp?error=databaseError");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("Donasi.jsp?error=driverNotFound");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Donasi.jsp?error=generalException");
        } finally {
            // Tutup semua resource JDBC
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");

        // Cek status login
        if (userEmail == null || userEmail.trim().isEmpty()) {
            response.sendRedirect("Login.jsp?error=mustLogin");
            return;
        }

        // Cek apakah user adalah admin
        boolean isAdmin = ADMIN_EMAIL.equals(userEmail);

        // --- Logika untuk updateDonasi (admin atau user) ---
        if ("updateDonasi".equals(action)) {
            String donasiIdStr = request.getParameter("donasi_id");
            String newMetode = request.getParameter("metode");
            String newJumlahStr = request.getParameter("jumlah");

            if (donasiIdStr == null || donasiIdStr.trim().isEmpty()) {
                response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=missingId" : "profil.jsp?error=missingId");
                return;
            }

            try {
                int donasiId = Integer.parseInt(donasiIdStr);

                Connection conn = null;
                PreparedStatement checkStmt = null;
                PreparedStatement updateStmt = null;
                ResultSet checkRs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/amaras", "root", "");

                    // Verifikasi kepemilikan donasi JIKA BUKAN ADMIN
                    if (!isAdmin) {
                        String checkOwnerSql = "SELECT d.id_donasi FROM donasi d " +
                                               "JOIN pengguna p ON d.id = p.id " +
                                               "WHERE d.id_donasi = ? AND p.email = ?";
                        checkStmt = conn.prepareStatement(checkOwnerSql);
                        checkStmt.setInt(1, donasiId);
                        checkStmt.setString(2, userEmail);
                        checkRs = checkStmt.executeQuery();

                        if (!checkRs.next()) {
                            response.sendRedirect("profil.jsp?error=accessDenied");
                            return;
                        }
                    } else {
                        // Admin bisa update tanpa verifikasi kepemilikan. Hanya perlu memastikan donasiId itu ada.
                        String checkExistenceSql = "SELECT id_donasi FROM donasi WHERE id_donasi = ?";
                        checkStmt = conn.prepareStatement(checkExistenceSql);
                        checkStmt.setInt(1, donasiId);
                        checkRs = checkStmt.executeQuery();
                        if (!checkRs.next()) {
                            response.sendRedirect("donasiServlet?action=viewAllDonasi&error=donasiNotFound");
                            return;
                        }
                    }

                    // Bangun query update secara dinamis
                    StringBuilder updateSql = new StringBuilder("UPDATE donasi SET ");
                    boolean hasUpdate = false;

                    if (newMetode != null && !newMetode.trim().isEmpty()) {
                        updateSql.append("metode_pembayaran = ?");
                        hasUpdate = true;
                    }

                    if (newJumlahStr != null && !newJumlahStr.trim().isEmpty()) {
                        if (hasUpdate) updateSql.append(", ");
                        updateSql.append("jumlah_donasi = ?");
                        hasUpdate = true;
                    }

                    if (!hasUpdate) {
                        response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=noUpdateData" : "profil.jsp?error=noUpdateData");
                        return;
                    }

                    updateSql.append(" WHERE id_donasi = ?");

                    updateStmt = conn.prepareStatement(updateSql.toString());
                    int paramIndex = 1;

                    if (newMetode != null && !newMetode.trim().isEmpty()) {
                        updateStmt.setString(paramIndex++, newMetode);
                    }

                    if (newJumlahStr != null && !newJumlahStr.trim().isEmpty()) {
                        try {
                            int newJumlah = Integer.parseInt(newJumlahStr);
                            if (newJumlah <= 0) {
                                response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=invalidAmount" : "profil.jsp?error=invalidAmount");
                                return;
                            }
                            updateStmt.setInt(paramIndex++, newJumlah);
                        } catch (NumberFormatException e) {
                            response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=invalidAmount" : "profil.jsp?error=invalidAmount");
                            return;
                        }
                    }

                    updateStmt.setInt(paramIndex, donasiId);

                    int rowsUpdated = updateStmt.executeUpdate();

                    if (rowsUpdated > 0) {
                        response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&success=donasiUpdated" : "profil.jsp?success=donasiUpdated");
                    } else {
                        response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=updateFailed" : "profil.jsp?error=updateFailed");
                    }

                } finally {
                    if (checkRs != null) checkRs.close();
                    if (checkStmt != null) checkStmt.close();
                    if (updateStmt != null) updateStmt.close();
                    if (conn != null) conn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=exception" : "profil.jsp?error=exception");
            }

        // --- Logika untuk deleteDonasi (admin atau user) ---
        } else if ("deleteDonasi".equals(action)) {
            String donasiIdStr = request.getParameter("donasi_id");

            if (donasiIdStr == null || donasiIdStr.trim().isEmpty()) {
                response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=missingId" : "profil.jsp?error=missingId");
                return;
            }

            try {
                int donasiId = Integer.parseInt(donasiIdStr);

                Connection conn = null;
                PreparedStatement deleteStmt = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/amaras", "root", "");

                    String deleteSql;
                    if (!isAdmin) {
                        // User hanya bisa menghapus donasinya sendiri
                        deleteSql = "DELETE d FROM donasi d " +
                                     "JOIN pengguna p ON d.id = p.id " +
                                     "WHERE d.id_donasi = ? AND p.email = ?";
                        deleteStmt = conn.prepareStatement(deleteSql);
                        deleteStmt.setInt(1, donasiId);
                        deleteStmt.setString(2, userEmail);
                    } else {
                        // Admin bisa menghapus donasi apapun
                        deleteSql = "DELETE FROM donasi WHERE id_donasi = ?";
                        deleteStmt = conn.prepareStatement(deleteSql);
                        deleteStmt.setInt(1, donasiId);
                    }

                    int rowsDeleted = deleteStmt.executeUpdate();

                    if (rowsDeleted > 0) {
                        response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&success=donasiDeleted" : "profil.jsp?success=donasiDeleted");
                    } else {
                        response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=deleteFailed" : "profil.jsp?error=deleteFailed");
                    }
                } finally {
                    if (deleteStmt != null) deleteStmt.close();
                    if (conn != null) conn.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(isAdmin ? "donasiServlet?action=viewAllDonasi&error=exception" : "profil.jsp?error=exception");
            }

        // --- Logika untuk viewDonasi (riwayat donasi user) ---
        } else if ("viewDonasi".equals(action)) {
            // Jika admin mencoba mengakses viewDonasi, arahkan ke viewAllDonasi
            if (isAdmin) {
                response.sendRedirect("donasiServlet?action=viewAllDonasi");
                return;
            }

            Connection conn = null;
            PreparedStatement viewStmt = null;
            ResultSet viewRs = null;
            List<Map<String, Object>> donasiList = new ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/amaras", "root", "");

                // Query untuk mendapatkan riwayat donasi HANYA untuk user yang sedang login
                String viewSql = "SELECT d.id_donasi, d.jumlah_donasi, d.metode_pembayaran, d.tanggal_donasi " +
                                 "FROM donasi d JOIN pengguna p ON d.id = p.id " +
                                 "WHERE p.email = ? ORDER BY d.tanggal_donasi DESC";
                viewStmt = conn.prepareStatement(viewSql);
                viewStmt.setString(1, userEmail);
                viewRs = viewStmt.executeQuery();

                while (viewRs.next()) {
                    Map<String, Object> donasi = new HashMap<>();
                    donasi.put("id_donasi", viewRs.getInt("id_donasi"));
                    donasi.put("jumlah_donasi", viewRs.getInt("jumlah_donasi"));
                    donasi.put("metode_pembayaran", viewRs.getString("metode_pembayaran"));
                    donasi.put("tanggal_donasi", viewRs.getTimestamp("tanggal_donasi"));
                    donasiList.add(donasi);
                }

                // Set atribut untuk JSP
                request.setAttribute("donasiHistory", donasiList);
                // Forward ke profil.jsp
                RequestDispatcher dispatcher = request.getRequestDispatcher("profil.jsp");
                dispatcher.forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("profil.jsp?error=exception");
            } finally {
                try {
                    if (viewRs != null) viewRs.close();
                    if (viewStmt != null) viewStmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        // --- Logika untuk totalDonasi (untuk halaman utama/dashboard, jika diperlukan) ---
        } else if ("totalDonasi".equals(action)) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int totalDonasi = 0; // Initialize totalDonasi outside try block

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/amaras", "root", "");

                String sql = "SELECT SUM(jumlah_donasi) AS total FROM donasi";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    totalDonasi = rs.getInt("total");
                }

                request.setAttribute("totalDonasi", totalDonasi);
                // --- START OF MODIFICATION (Solusi sebelumnya yang benar) ---
            String targetPage; // Deklarasikan targetPage di sini
            if (userEmail.trim().isEmpty()) {
                // User is not logged in (guest)
                targetPage = "index.jsp";
            } else if (isAdmin) {
                // User is an admin
                targetPage = "dashboardAdmin.jsp";
            } else {
                // User is a regular logged-in user
                targetPage = "dashboard.jsp";
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher(targetPage); // Inisialisasi dispatcher di sini
            // --- END OF MODIFICATION ---

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("index.jsp?error=totalDonasiError");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        // --- Logika untuk viewAllDonasi (semua riwayat donasi untuk ADMIN) ---
        } else if ("viewAllDonasi".equals(action)) {
            // Pengecekan apakah pengguna adalah admin
            if (!isAdmin) {
                response.sendRedirect("dashboard.jsp?error=accessDeniedAdmin"); // Redirect jika bukan admin
                return;
            }

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            List<Map<String, Object>> allDonations = new ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/amaras", "root", "");

                // Query untuk mendapatkan SEMUA riwayat donasi, dengan join ke tabel pengguna
                String sql = "SELECT d.id_donasi, d.jumlah_donasi, d.metode_pembayaran, d.tanggal_donasi, " +
                             "p.fullname, p.email " +
                             "FROM donasi d " +
                             "JOIN pengguna p ON d.id = p.id " +
                             "ORDER BY d.tanggal_donasi DESC";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    Map<String, Object> donation = new HashMap<>();
                    donation.put("id_donasi", rs.getInt("id_donasi"));
                    donation.put("jumlah_donasi", rs.getInt("jumlah_donasi"));
                    donation.put("metode_pembayaran", rs.getString("metode_pembayaran"));
                    donation.put("tanggal_donasi", rs.getTimestamp("tanggal_donasi"));
                    donation.put("fullname", rs.getString("fullname")); // Ambil nama donor
                    donation.put("email", rs.getString("email"));     // Ambil email donor
                    allDonations.add(donation);
                }

                // Set atribut untuk JSP
                request.setAttribute("allDonations", allDonations);
                // Forward ke Riwayat.jsp
                RequestDispatcher dispatcher = request.getRequestDispatcher("Riwayat.jsp");
                dispatcher.forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard.jsp?error=exceptionOnViewAll");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
        } else if ("viewDonasiSaya".equals(action)) { // <--- GANTI DI SINI
            // Jika admin mencoba mengakses viewDonasiSaya, arahkan ke viewAllDonasi
            if (isAdmin) {
                response.sendRedirect("donasiServlet?action=viewAllDonasi");
                return;
            }

            Connection conn = null;
            PreparedStatement viewStmt = null;
            ResultSet viewRs = null;
            List<Map<String, Object>> donasiList = new ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/amaras", "root", "");

                // Query untuk mendapatkan riwayat donasi HANYA untuk user yang sedang login
                String viewSql = "SELECT d.id_donasi, d.jumlah_donasi, d.metode_pembayaran, d.tanggal_donasi " +
                                 "FROM donasi d JOIN pengguna p ON d.id = p.id " +
                                 "WHERE p.email = ? ORDER BY d.tanggal_donasi DESC";
                viewStmt = conn.prepareStatement(viewSql);
                viewStmt.setString(1, userEmail);
                viewRs = viewStmt.executeQuery();

                while (viewRs.next()) {
                    Map<String, Object> donasi = new HashMap<>();
                    donasi.put("id_donasi", viewRs.getInt("id_donasi"));
                    donasi.put("jumlah_donasi", viewRs.getInt("jumlah_donasi"));
                    donasi.put("metode_pembayaran", viewRs.getString("metode_pembayaran"));
                    donasi.put("tanggal_donasi", viewRs.getTimestamp("tanggal_donasi"));
                    donasiList.add(donasi);
                }

                // Set atribut untuk JSP
                request.setAttribute("donasiHistory", donasiList);
                // Forward ke profil.jsp
                RequestDispatcher dispatcher = request.getRequestDispatcher("profil.jsp");
                dispatcher.forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("profil.jsp?error=exception");
            } finally {
                try {
                    if (viewRs != null) viewRs.close();
                    if (viewStmt != null) viewStmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            // Aksi default jika tidak ada parameter 'action' yang valid
            response.sendRedirect("dashboard.jsp?error=unknownAction");
        }
    }
}