package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/KomentarServlet")
public class KomentarServlet extends HttpServlet {

    // Konfigurasi Database
    private static final String DB_URL = "jdbc:mysql://localhost:3306/amaras";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    // Konstanta untuk validasi dan batasan
    private static final int MIN_COMMENT_LENGTH = 10;
    private static final int MAX_COMMENT_LENGTH = 1000;
    private static final int DEFAULT_COMMENT_FETCH_LIMIT = 5;
    private static final int MAX_COMMENT_FETCH_LIMIT = 50;
    private static final String DATE_FORMAT_PATTERN = "yyyy-MM-dd HH:mm:ss";
    
    // Hardcoded admin email (sama seperti di LoginServlet)
    private static final String ADMIN_EMAIL = "admin@mail.com";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("deleteComment".equals(action)) {
            System.out.println("Peringatan: Penghapusan komentar dilakukan via GET. Sangat disarankan menggunakan metode HTTP DELETE.");
            doDelete(request, response);
        } else if ("getComments".equals(action)) {
            getComments(request, response);
        } else {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("error: Aksi tidak valid. Gunakan 'getComments' atau kirim permintaan DELETE untuk menghapus.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String pesan = request.getParameter("commentMessage");
        HttpSession session = request.getSession(false);

        PrintWriter out = response.getWriter();

        // --- Validasi Sesi dan Autentikasi Pengguna ---
        if (session == null || session.getAttribute("email") == null) {
            out.write("error: Session tidak ditemukan atau Anda belum login. Silakan login kembali.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String userEmail = (String) session.getAttribute("email");

        if (userEmail.trim().isEmpty()) {
            out.write("error: Silakan login terlebih dahulu untuk berkomentar.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // --- Validasi Konten Komentar ---
        if (pesan == null || pesan.trim().isEmpty()) {
            out.write("error: Komentar tidak boleh kosong.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if (pesan.trim().length() < MIN_COMMENT_LENGTH) {
            out.write("error: Komentar minimal " + MIN_COMMENT_LENGTH + " karakter.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if (pesan.trim().length() > MAX_COMMENT_LENGTH) {
            out.write("error: Komentar maksimal " + MAX_COMMENT_LENGTH + " karakter.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String cleanedComment = sanitizeInput(pesan.trim());

        // Cek apakah ini admin
        boolean isAdmin = ADMIN_EMAIL.equals(userEmail);
        
        if (isAdmin) {
            // Admin bisa langsung komentar tanpa validasi donasi
            insertCommentDirect(userEmail, cleanedComment, out, response);
            return;
        }

        // Untuk user biasa, lakukan validasi donasi
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int userId = -1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            conn.setAutoCommit(false);

            // 1. Dapatkan user ID dari email yang ada di sesi
            String sqlUser = "SELECT id FROM pengguna WHERE email = ?";
            pstmt = conn.prepareStatement(sqlUser);
            pstmt.setString(1, userEmail);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                conn.rollback();
                out.write("error: User tidak ditemukan di database.");
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            userId = rs.getInt("id");
            rs.close();
            pstmt.close();

            // 2. VALIDASI DONASI - Cek apakah user sudah pernah berdonasi
            String sqlCheckDonasi = "SELECT COUNT(*) as jumlah_donasi FROM donasi WHERE id = ?";
            pstmt = conn.prepareStatement(sqlCheckDonasi);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int jumlahDonasi = rs.getInt("jumlah_donasi");
                
                if (jumlahDonasi == 0) {
                    conn.rollback();
                    out.write("error: Anda harus berdonasi terlebih dahulu untuk dapat berkomentar.");
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
            } else {
                conn.rollback();
                out.write("error: Gagal memeriksa status donasi.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }
            rs.close();
            pstmt.close();

            // 3. Insert komentar baru
            String sqlInsert = "INSERT INTO komentar (user_id, pesan, tanggal_komentar) VALUES (?, ?, NOW())";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setInt(1, userId);
            pstmt.setString(2, cleanedComment);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                conn.commit();
                out.write("success");
                System.out.println("Komentar berhasil disimpan oleh user ID: " + userId + " (email: " + userEmail + ")");
            } else {
                conn.rollback();
                out.write("error: Gagal menyimpan komentar ke database.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("MySQL driver tidak ditemukan: " + e.getMessage());
            out.write("error: Database driver tidak tersedia. Hubungi administrator.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error saat melakukan rollback: " + ex.getMessage());
                }
            }
            System.err.println("SQL Error di doPost: " + e.getMessage());
            e.printStackTrace();
            out.write("error: Terjadi kesalahan database: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            System.err.println("Error umum di doPost: " + e.getMessage());
            e.printStackTrace();
            out.write("error: Terjadi kesalahan sistem yang tidak terduga.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }

    /**
     * Insert komentar langsung untuk admin tanpa validasi donasi
     */
    private void insertCommentDirect(String adminEmail, String cleanedComment, PrintWriter out, HttpServletResponse response) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Insert komentar admin dengan user_id = 0 atau user_id khusus
            // Menggunakan user_id = 0 untuk menandai komentar admin
            String sqlInsert = "INSERT INTO komentar (user_id, pesan, tanggal_komentar) VALUES (0, ?, NOW())";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setString(1, cleanedComment);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.write("success");
                System.out.println("Komentar berhasil disimpan oleh admin: " + adminEmail);
            } else {
                out.write("error: Gagal menyimpan komentar admin ke database.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("MySQL driver tidak ditemukan: " + e.getMessage());
            out.write("error: Database driver tidak tersedia. Hubungi administrator.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (SQLException e) {
            System.err.println("SQL Error saat menyimpan komentar admin: " + e.getMessage());
            e.printStackTrace();
            out.write("error: Terjadi kesalahan database: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            System.err.println("Error umum saat menyimpan komentar admin: " + e.getMessage());
            e.printStackTrace();
            out.write("error: Terjadi kesalahan sistem yang tidak terduga.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    private void getComments(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int limit = DEFAULT_COMMENT_FETCH_LIMIT;
        String limitStr = request.getParameter("limit");
        if (limitStr != null && !limitStr.trim().isEmpty()) {
            try {
                limit = Integer.parseInt(limitStr.trim());
                if (limit <= 0) limit = DEFAULT_COMMENT_FETCH_LIMIT;
                if (limit > MAX_COMMENT_FETCH_LIMIT) limit = MAX_COMMENT_FETCH_LIMIT;
            } catch (NumberFormatException e) {
                limit = DEFAULT_COMMENT_FETCH_LIMIT;
            }
        }

        // Modifikasi query untuk menangani komentar admin (user_id = 0)
        String sql = "SELECT k.id_komentar, " +
                     "CASE WHEN k.user_id = 0 THEN 'Admin Amaras' ELSE p.fullname END as fullname, " +
                     "CASE WHEN k.user_id = 0 THEN '" + ADMIN_EMAIL + "' ELSE p.email END as email, " +
                     "k.pesan, k.tanggal_komentar, k.user_id " +
                     "FROM komentar k " +
                     "LEFT JOIN pengguna p ON k.user_id = p.id " +
                     "ORDER BY k.tanggal_komentar DESC " +
                     "LIMIT ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_PATTERN);

            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;

                int idKomentar = rs.getInt("id_komentar");
                String fullname = rs.getString("fullname");
                String email = rs.getString("email");
                String pesan = rs.getString("pesan");
                int userId = rs.getInt("user_id");
                
                Timestamp tanggalKomentarTimestamp = rs.getTimestamp("tanggal_komentar");
                String tanggalFormatted = (tanggalKomentarTimestamp != null) ? sdf.format(new Date(tanggalKomentarTimestamp.getTime())) : "";

                json.append("{")
                    .append("\"id\":").append(idKomentar).append(",")
                    .append("\"nama\":\"").append(escapeJson(fullname)).append("\",")
                    .append("\"emailPemilik\":\"").append(escapeJson(email)).append("\",")
                    .append("\"pesan\":\"").append(escapeJson(pesan)).append("\",")
                    .append("\"tanggal\":\"").append(tanggalFormatted).append("\",")
                    .append("\"isAdmin\":").append(userId == 0 ? "true" : "false")
                    .append("}");
            }

            json.append("]");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.write(json.toString());

            System.out.println("Berhasil mengambil " + limit + " komentar.");

        } catch (ClassNotFoundException e) {
            System.err.println("MySQL driver tidak ditemukan: " + e.getMessage());
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("error: Database driver tidak tersedia.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (SQLException e) {
            System.err.println("SQL Error saat mengambil komentar: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("error: Kesalahan database saat mengambil komentar: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            System.err.println("Error umum saat mengambil komentar: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("error: Terjadi kesalahan sistem saat mengambil komentar.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            closeResources(rs, pstmt, conn);
        }
    }

    @Override
   
protected void doDelete(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("text/plain");
    response.setCharacterEncoding("UTF-8");
    PrintWriter out = response.getWriter();

    HttpSession session = request.getSession(false);

    // --- Validasi Sesi dan Autentikasi Pengguna ---
    if (session == null) {
        out.write("error: Session tidak ditemukan. Silakan login kembali.");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return;
    }

    String userEmail = (String) session.getAttribute("email");

    if (userEmail == null || userEmail.trim().isEmpty()) {
        out.write("error: Silakan login terlebih dahulu untuk menghapus komentar.");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return;
    }

    // --- Validasi ID Komentar ---
    String commentIdStr = request.getParameter("commentId");
    if (commentIdStr == null || commentIdStr.trim().isEmpty()) {
        out.write("error: ID Komentar diperlukan untuk penghapusan.");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        return;
    }

    int commentId;
    try {
        commentId = Integer.parseInt(commentIdStr.trim());
    } catch (NumberFormatException e) {
        out.write("error: Format ID Komentar tidak valid.");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        return;
    }

    // Cek apakah ini admin
    boolean isAdmin = ADMIN_EMAIL.equals(userEmail);

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        conn.setAutoCommit(false);

        // Jika admin, bisa menghapus komentar siapa saja
        if (isAdmin) {
            String sqlDelete = "DELETE FROM komentar WHERE id_komentar = ?";
            pstmt = conn.prepareStatement(sqlDelete);
            pstmt.setInt(1, commentId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Reset AUTO_INCREMENT setelah delete
                pstmt.close();
                resetAutoIncrement(conn);
                
                conn.commit();
                out.write("success");
                System.out.println("Komentar ID " + commentId + " dihapus oleh admin: " + userEmail);
            } else {
                conn.rollback();
                out.write("error: Komentar tidak ditemukan atau sudah dihapus.");
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
            return;
        }

        // Jika bukan admin, periksa apakah komentar tersebut milik pengguna yang login
        String sqlUser = "SELECT id FROM pengguna WHERE email = ?";
        pstmt = conn.prepareStatement(sqlUser);
        pstmt.setString(1, userEmail);
        rs = pstmt.executeQuery();

        if (!rs.next()) {
            conn.rollback();
            out.write("error: User tidak ditemukan di database. Email: " + userEmail);
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            System.err.println("User tidak ditemukan dengan email: " + userEmail);
            return;
        }
        
        int userId = rs.getInt("id");
        rs.close();
        pstmt.close();

        // 2. Periksa apakah komentar tersebut milik pengguna yang login
        String sqlCheckOwnership = "SELECT user_id FROM komentar WHERE id_komentar = ?";
        pstmt = conn.prepareStatement(sqlCheckOwnership);
        pstmt.setInt(1, commentId);
        rs = pstmt.executeQuery();

        if (!rs.next()) {
            conn.rollback();
            out.write("error: Komentar tidak ditemukan atau sudah dihapus.");
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        int ownerUserId = rs.getInt("user_id");
        
        // Jika bukan admin dan komentar bukan milik user yang login, tidak bisa dihapus
        if (ownerUserId != userId) {
            conn.rollback();
            out.write("error: Anda tidak diizinkan menghapus komentar ini.");
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Hapus komentar milik user
        String sqlDelete = "DELETE FROM komentar WHERE id_komentar = ? AND user_id = ?";
        pstmt = conn.prepareStatement(sqlDelete);
        pstmt.setInt(1, commentId);
        pstmt.setInt(2, userId);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // Reset AUTO_INCREMENT setelah delete
            pstmt.close();
            resetAutoIncrement(conn);
            
            conn.commit();
            out.write("success");
            System.out.println("Komentar ID " + commentId + " dihapus oleh user ID: " + userId + " (email: " + userEmail + ")");
        } else {
            conn.rollback();
            out.write("error: Gagal menghapus komentar dari database.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

    } catch (ClassNotFoundException e) {
        System.err.println("Driver MySQL tidak ditemukan: " + e.getMessage());
        out.write("error: Driver database tidak tersedia. Hubungi administrator.");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } catch (SQLException e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                System.err.println("Error saat rollback: " + ex.getMessage());
            }
        }
        System.err.println("SQL Error saat menghapus komentar: " + e.getMessage());
        e.printStackTrace();
        out.write("error: Kesalahan database saat menghapus komentar: " + e.getMessage());
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } catch (Exception e) {
        System.err.println("Error umum saat menghapus komentar: " + e.getMessage());
        e.printStackTrace();
        out.write("error: Terjadi kesalahan sistem yang tidak terduga saat menghapus komentar.");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } finally {
        closeResources(rs, pstmt, conn);
    }
}
/**
 * Reset AUTO_INCREMENT setelah delete
 */
private void resetAutoIncrement(Connection conn) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // Dapatkan MAX ID yang ada
        String maxSql = "SELECT COALESCE(MAX(id_komentar), 0) AS max_id FROM komentar";
        pstmt = conn.prepareStatement(maxSql);
        rs = pstmt.executeQuery();
        
        int maxId = 1;
        if (rs.next()) {
            maxId = rs.getInt("max_id") + 1;
        }
        
        rs.close();
        pstmt.close();
        
        // Reset AUTO_INCREMENT
        String alterSql = "ALTER TABLE komentar AUTO_INCREMENT = " + maxId;
        pstmt = conn.prepareStatement(alterSql);
        pstmt.executeUpdate();
        
        System.out.println("AUTO_INCREMENT direset ke: " + maxId);
        
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
    }
}

    private String sanitizeInput(String input) {
        if (input == null) return "";

        return input.replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;");
    }

    private String escapeJson(String input) {
        if (input == null) return "";

        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f");
    }

    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.err.println("Error menutup ResultSet: " + e.getMessage());
        }
        try {
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            System.err.println("Error menutup PreparedStatement: " + e.getMessage());
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error menutup Connection: " + e.getMessage());
        }
    }
}