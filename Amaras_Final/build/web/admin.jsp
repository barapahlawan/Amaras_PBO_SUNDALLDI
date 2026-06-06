<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="koneksi.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Edit Tentang Kami</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f5f5;
        }

        header {
            background: linear-gradient(to right, #1a56a2, #4285f4);
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-container {
            display: flex;
            align-items: center;
        }

        .logo-container img {
            height: 50px;
            margin-right: 10px;
        }

        .logo-text h1 {
            font-size: 1.5rem;
            font-weight: bold;
        }

        .logo-text h2 {
            font-size: 1rem;
            font-weight: normal;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 2rem;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            font-size: 1.1rem;
        }

        nav ul li a:hover {
            opacity: 0.8;
        }

        main {
            padding: 2rem 5%;
        }

        h3 {
            color: #1a56a2;
            margin-bottom: 1rem;
            text-align: center;
        }

        form {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 2rem auto;
        }

        label {
            font-weight: bold;
            color: #1a56a2;
            display: block;
            margin-top: 1rem;
        }

        textarea, input[type="text"] {
            width: 100%;
            padding: 0.8rem;
            margin-top: 0.5rem;
            border-radius: 8px;
            border: 1px solid #ccc;
            resize: vertical;
        }

        input[type="file"] {
            margin-top: 0.5rem;
        }

        .submit-btn {
            margin-top: 2rem;
            background-color: #1a56a2;
            color: white;
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #0f3b75;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 2rem;
            text-decoration: none;
            color: #1a56a2;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<header>
    <div class="logo-container">
        <img src="logo.png" alt="Yayasan Amaras Logo">
        <div class="logo-text">
            <h1>YAYASAN AMARAS</h1>
            <h2>HARAPAN BANGSA</h2>
        </div>
    </div>
    <nav>
        <ul>
            <li><a href="dashboardAdmin.jsp">Beranda</a></li>
            <li><a href="Login.jsp">Keluar</a></li>
        </ul>
    </nav>
</header>

<main>
    <h3>Edit Halaman Tentang Kami</h3>

    <%
        String deskripsi = "", visimisi = "", kontak = "", alamat = "";

        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM tentang_kami WHERE id = 1");
            if (rs.next()) {
                deskripsi = rs.getString("deskripsi") != null ? rs.getString("deskripsi") : "";
                visimisi = rs.getString("visimisi") != null ? rs.getString("visimisi") : "";
                kontak = rs.getString("kontak") != null ? rs.getString("kontak") : "";
                alamat = rs.getString("alamat") != null ? rs.getString("alamat") : "";
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Gagal mengambil data: " + e.getMessage() + "</p>");
        }
    %>

    <!-- Deskripsi -->
    <form action="TentangKamiServlet" method="post">
        <input type="hidden" name="action" value="updateDeskripsi">
        <label>Deskripsi:</label>
        <textarea name="deskripsi" rows="5"><%= deskripsi %></textarea>
        <button type="submit" class="submit-btn">Update Deskripsi</button>
    </form>

    <!-- Visi Misi -->
    <form action="TentangKamiServlet" method="post">
        <input type="hidden" name="action" value="updateVisiMisi">
        <label>Visi Misi:</label>
        <textarea name="visimisi" rows="3"><%= visimisi %></textarea>

        <button type="submit" class="submit-btn">Update Visi Misi</button>
    </form>

    <!-- Kontak & Alamat -->
    <form action="TentangKamiServlet" method="post">
        <input type="hidden" name="action" value="updateKontak">
        <label>Kontak:</label>
        <input type="text" name="kontak" value="<%= kontak %>">

        <label>Alamat:</label>
        <input type="text" name="alamat" value="<%= alamat %>">

        <button type="submit" class="submit-btn">Update Kontak & Alamat</button>
    </form>

    <a href="dashboardAdmin.jsp" class="back-link">← Kembali ke Halaman Utama</a>
</main>

</body>
</html>