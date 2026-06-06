<%-- 
    Document   : profil
    Created on : 31 May 2025, 00.55.09
    Author     : gloranaisanampe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Profil Donatur - Yayasan Amaras</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

    body, html {
      height: 100%;
      background: #f2f2f2;
    }

/* Header Styling */
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


    .container {
      max-width: 900px;
      margin: 40px auto;
      background-color: white;
      border-radius: 12px;
      padding: 25px;
      position: relative;
    }

    .profile-section {
      display: flex;
      gap: 30px;
      align-items: center;
      border-bottom: 1px solid #ccc;
      padding-bottom: 25px;
    }

    .profile-img {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      background-color: #e0f0fb;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 60px;
      color: #00AEEF;
    }

    .profile-info {
      flex: 1;
    }

    .profile-info h2 {
      font-size: 22px;
      margin-bottom: 4px;
    }

    .profile-info p {
      font-size: 16px;
      margin-bottom: 6px;
    }

    .status {
      background-color: #e4f7e6;
      color: #28a745;
      padding: 6px 12px;
      border-radius: 20px;
      display: inline-block;
      font-size: 14px;
      font-weight: bold;
    }

    .contact-box {
      margin-top: 15px;
      background-color: #f9f9f9;
      padding: 10px 15px;
      border-radius: 8px;
      border: 1px solid #ddd;
    }

    .contact-box p {
      margin-bottom: 5px;
    }

    .donation-history {
      margin-top: 25px;
    }

    .donation-header {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 15px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .donation-header i {
      color: #00AEEF;
    }

    .donation-item {
      background-color: #f5fafd;
      padding: 15px;
      border-left: 5px solid #00AEEF;
      border-radius: 8px;
      margin-bottom: 12px;
      box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }

    .donation-item strong {
      display: block;
      font-size: 16px;
      margin-bottom: 4px;
    }

    .donation-list {
      max-height: 400px;
      overflow-y: auto;
      padding-right: 10px;
    }

    /* Scrollbar styling */
    .donation-list::-webkit-scrollbar {
      width: 8px;
    }

    .donation-list::-webkit-scrollbar-thumb {
      background-color: #00AEEF;
      border-radius: 4px;
    }

    .donation-list::-webkit-scrollbar-track {
      background: #f1f1f1;
    }

    .donation-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }

    .donation-table th,
    .donation-table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }

    .donation-table th {
      background-color: #f8f9fa;
      font-weight: 600;
      color: #495057;
    }

    .donation-table tr:hover {
      background-color: #f5f5f5;
    }

    .amount {
      font-weight: bold;
      color: #28a745;
    }

    .no-donations {
      text-align: center;
      padding: 40px;
      color: #6c757d;
      font-style: italic;
    }

    .download-btn {
      background-color: #00AEEF;
      color: white;
      padding: 12px 24px;
      font-size: 16px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      margin-top: 25px;
      float: right;
    }

    .download-btn:hover {
      background-color: #0095d4;
    }

    @media (max-width: 768px) {
      .profile-section {
        flex-direction: column;
        align-items: flex-start;
      }

      .download-btn {
        width: 100%;
        float: none;
        margin-top: 20px;
      }

      .donation-table {
        font-size: 14px;
      }

      .donation-table th,
      .donation-table td {
        padding: 8px;
      }
    }
  </style>
</head>
<body>
  <header>
        <div class="logo-container">
            <div class="logo-icon">
                <!-- Using image file for logo -->
                <img src="logo.png" alt="Yayasan Amaras Logo" height="50">
            </div>
            <div class="logo-text">
                <h1>YAYASAN AMARAS</h1>
                <h2>HARAPAN BANGSA</h2>
            </div>
        </div>
        <nav>
            <ul>
                <li><a href="dashboard.jsp">Beranda</a></li>
                <li><a href="Login.jsp">Keluar</a></li>
            </ul>
        </nav>
    </header>

  <div class="container">
    <div class="profile-section">
      <div class="profile-img">
        <i class="fas fa-user"></i>
      </div>
      <div class="profile-info">
          <h2>${sessionScope.fullname}</h2>
        <p>Donatur</p>
        <span class="status"><i class="fas fa-circle" style="font-size: 10px;"></i> Anggota Aktif</span>
        <div class="contact-box">
            <%@ page session="true" %>
            <p><strong>Email:</strong> ${sessionScope.email}</p>
        </div>
      </div>
    </div>

    <div class="donation-history">
        <div class="donation-header">
            <i class="fas fa-hand-holding-dollar"></i> Riwayat Donasi
        </div>

        <div class="donation-list">
            <%
                List<Map<String, Object>> donasiHistory = (List<Map<String, Object>>) request.getAttribute("donasiHistory");
                if (donasiHistory != null && !donasiHistory.isEmpty()) {
                    // Format untuk mata uang Rupiah
                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
                    // Format untuk tanggal
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy, HH:mm", new Locale("id", "ID"));
            %>
            <table class="donation-table">
                <thead>
                    <tr>
                        <th>ID Donasi</th>
                        <th>Jumlah Donasi</th>
                        <th>Metode Pembayaran</th>
                        <th>Tanggal Donasi</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Map<String, Object> donasi : donasiHistory) {
                    %>
                    <tr>
                        <td>#<%= donasi.get("id_donasi") %></td>
                        <td class="amount">
                            <%
                                Integer jumlah = (Integer) donasi.get("jumlah_donasi");
                                out.print(currencyFormat.format(jumlah));
                            %>
                        </td>
                        <td><%= donasi.get("metode_pembayaran") %></td>
                        <td>
                            <%
                                java.sql.Timestamp tanggal = (java.sql.Timestamp) donasi.get("tanggal_donasi");
                                out.print(dateFormat.format(tanggal));
                            %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                } else {
            %>
            <div class="no-donations">
                <i class="fas fa-heart" style="font-size: 48px; color: #dee2e6; margin-bottom: 15px;"></i>
                <p>Belum ada riwayat donasi</p>
                <p style="font-size: 14px; margin-top: 10px;">
                    <a href="Donasi.jsp" style="color: #00AEEF; text-decoration: none;">Mulai berdonasi sekarang</a>
                </p>
            </div>
            <%
                }
            %>
        </div>

        <button class="download-btn" onclick="downloadHistory()">
            <i class="fas fa-download"></i> Unduh Riwayat
        </button>
        <div style="clear: both;"></div>
    </div>
  </div>

  <script>
    function downloadHistory() {
        <%
            if (donasiHistory != null && !donasiHistory.isEmpty()) {
        %>
            // Redirect ke servlet untuk generate PDF
            window.location.href = 'PDFServlet?action=downloadDonationHistory';
        <%
            } else {
        %>
            alert('Tidak ada riwayat donasi untuk diunduh');
        <%
            }
        %>
    }
    
    // Alternatif: Print halaman ini sebagai PDF menggunakan browser
    function printPage() {
        window.print();
    }
  </script>
</body>
</html>