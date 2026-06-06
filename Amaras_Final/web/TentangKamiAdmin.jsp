<%-- 
    Document   : TentangKamiAdmin
    Created on : 2 Jun 2025, 20.00.20
    Author     : Alexandra Naibaho
--%>

<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yayasan Amaras Harapan Bangsa</title>
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
            margin-bottom: 0;
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
            transition: all 0.3s ease;
        }

        nav ul li a:hover {
            opacity: 0.8;
        }

        .hero {
            background: linear-gradient(to right, #1a56a2, #4285f4);
            color: white;
            padding: 4rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            width: 55%;
        }

        .hero-content h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .hero-content p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .donate-btn {
            background-color: white;
            color: #1a56a2;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
        }

        .donate-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .hero-image img {
            width: 80%;
            max-width: 300px;
            opacity: 1;
        }

        .services {
            padding: 2rem 5%;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(3, 7fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .service-card {
            background-color: white;
            border-radius: 12px;
            padding: 2rem;
            width: 400%;
            max-width: 1220px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .service-title {
            font-size: 1.5rem;
            color: #1a56a2;
            margin-bottom: 0.5rem;
        }

        .service-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            text-align: justify;
        }

        footer {
            background: linear-gradient(to right, #1a56a2, #4285f4);
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .register-text {
            font-size: 1.2rem;
        }

        .register-btn {
            background-color: white;
            color: #1a56a2;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .register-btn:hover {
            background-color: #f5f5f5;
        }

        @media (max-width: 768px) {
            .hero {
                flex-direction: column;
                padding: 7rem 5%;
            }

            .hero-content, .hero-image {
                width: 100%;
                text-align: center;
            }

            .hero-image {
                margin-top: 20rem;
            }

            .services-grid {
                grid-template-columns: 7fr;
            }

            footer {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="logo-container">
            <img src="logo.png" alt="Yayasan Amaras Logo" height="50">
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
    <%
    String deskripsi = "", visimisi = "", kontak = "", alamat = "";
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // atau com.mysql.jdbc.Driver jika versi lama
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/amaras", "root", "");
        
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
        conn.close(); 
    } catch (Exception e) {
        out.println("<p style='color:red;'>Gagal mengambil data: " + e.getMessage() + "</p>");
    }
    %>
    
    <section class="services">       
        <div class="services-grid">
            <div class="service-card">
                <div class="hero-image">
                    <center><img src="logo.png" alt="Yayasan Amaras Logo" style="width: 150%; max-width: 300px; opacity: 1;"></center>
                </div>
                <h3 class="service-title">Tentang Kami</h3>
                <p class="service-description"><%= deskripsi.replaceAll("\\n", "<br>") %></p>
                
                <h3 class="service-title">Visi Misi</h3>
                <p class="service-description"><%= visimisi.replaceAll("\\n", "<br>") %></p>
                
                <h4 class="service-title">Kontak</h4>
                <p class="service-description"><%= kontak %></p>

                <h4 class="service-title">Alamat</h4>
                <p class="service-description"><%= alamat %></p>

                <div style="margin-top: 20px; text-align: right;">
                    <a href="admin.jsp" class="donate-btn">Edit</a>
                </div>
            </div>
        </div>
    </section>
</body>
</html>