<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.Timestamp" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Donasi - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #f8fafc;
            color: #1e293b;
            line-height: 1.6;
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


    .container {
      max-width: 900px;
      margin: 40px auto;
      background-color: white;
      border-radius: 12px;
      padding: 25px;
      position: relative;
    }


        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: white;
            color: #667eea;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background-color: #f1f5f9;
            transform: translateY(-1px);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            border-left: 4px solid #667eea;
        }

        .stat-card h3 {
            font-size: 0.9rem;
            font-weight: 500;
            color: #64748b;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card .value {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
        }

        .donations-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .table-header {
            background-color: #f8fafc;
            padding: 20px;
            border-bottom: 1px solid #e2e8f0;
        }

        .table-header h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1e293b;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            text-align: left;
            padding: 16px 20px;
            border-bottom: 1px solid #e2e8f0;
        }

        th {
            background-color: #f8fafc;
            font-weight: 600;
            color: #475569;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            color: #64748b;
        }

        tr:hover {
            background-color: #f8fafc;
        }

        .amount {
            font-weight: 600;
            color: #059669;
        }

        .method-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .method-bank {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .method-ewallet {
            background-color: #dcfce7;
            color: #166534;
        }

        .method-cash {
            background-color: #fef3c7;
            color: #92400e;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 16px;
            color: #cbd5e1;
        }

        .empty-state h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background-color: #dcfce7;
            color: #166534;
            border-left: 4px solid #16a34a;
        }

        .alert-error {
            background-color: #fef2f2;
            color: #991b1b;
            border-left: 4px solid #dc2626;
        }

        .actions {
            display: flex;
            gap: 8px;
        }

        .btn {
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-edit {
            background-color: #fef3c7;
            color: #92400e;
        }

        .btn-delete {
            background-color: #fef2f2;
            color: #991b1b;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 1.5rem;
            }
            
            th, td {
                padding: 12px 8px;
                font-size: 0.875rem;
            }

            .top-header {
                flex-direction: column;
                align-items: flex-start;
                padding: 10px;
            }

            .top-header .nav-links {
                margin-top: 10px;
            }

            .top-header .nav-links a {
                margin-left: 0;
                margin-right: 15px;
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
                <li><a href="dashboardAdmin.jsp">Beranda</a></li>
                <li><a href="Login.jsp">Keluar</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        

        <div class="header">
            <h1><i class="fas fa-history"></i> Riwayat Donasi</h1>
            <p>Kelola dan pantau semua donasi yang masuk</p>
        </div>

        <% if ("donasiUpdated".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                Donasi berhasil diperbarui!
            </div>
        <% } %>
        
        <% if ("donasiDeleted".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                Donasi berhasil dihapus!
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                Terjadi kesalahan: <%= request.getParameter("error") %>
            </div>
        <% } %>

        <%
            List<Map<String, Object>> allDonations = (List<Map<String, Object>>) request.getAttribute("allDonations");
            int totalDonations = 0;
            long totalAmount = 0;
            
            if (allDonations != null) {
                totalDonations = allDonations.size();
                for (Map<String, Object> donation : allDonations) {
                    totalAmount += (Integer) donation.get("jumlah_donasi");
                }
            }
        %>

        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Donasi</h3>
                <div class="value"><%= totalDonations %></div>
            </div>
            <div class="stat-card">
                <h3>Total Dana Terkumpul</h3>
                <div class="value">Rp <%= String.format("%,d", totalAmount) %></div>
            </div>
        </div>

        <div class="donations-table">
            <div class="table-header">
                <h2>Data Donasi</h2>
            </div>
            
            <% if (allDonations != null && !allDonations.isEmpty()) { %>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>ID Donasi</th>
                                <th>Nama Donor</th>
                                <th>Email</th>
                                <th>Jumlah</th>
                                <th>Metode</th>
                                <th>Tanggal</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                for (Map<String, Object> donation : allDonations) {
                            %>
                            <tr>
                                <td>#<%= donation.get("id_donasi") %></td>
                                <td><%= donation.get("fullname") %></td>
                                <td><%= donation.get("email") %></td>
                                <td class="amount">Rp <%= String.format("%,d", (Integer) donation.get("jumlah_donasi")) %></td>
                                <td>
                                    <%
                                        String metode = (String) donation.get("metode_pembayaran");
                                        String badgeClass = "method-cash";
                                        if (metode.toLowerCase().contains("bank") || metode.toLowerCase().contains("transfer")) {
                                            badgeClass = "method-bank";
                                        } else if (metode.toLowerCase().contains("wallet") || metode.toLowerCase().contains("ovo") || 
                                                    metode.toLowerCase().contains("gopay") || metode.toLowerCase().contains("dana")) {
                                            badgeClass = "method-ewallet";
                                        }
                                    %>
                                    <span class="method-badge <%= badgeClass %>"><%= metode %></span>
                                </td>
                                <td><%= dateFormat.format((Timestamp) donation.get("tanggal_donasi")) %></td>
                                <td>
                                    <div class="actions">
                                        
                                        <a href="#" onclick="deleteDonation(<%= donation.get("id_donasi") %>)" class="btn btn-delete">
                                            <i class="fas fa-trash"></i> Hapus
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>Belum Ada Riwayat Donasi</h3>
                    <p>Donasi yang masuk akan ditampilkan di sini.</p>
                </div>
            <% } %>
        </div>
    </div>

    <div id="editModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000;">
        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 30px; border-radius: 12px; width: 90%; max-width: 400px;">
            <h3 style="margin-bottom: 20px; color: #1e293b;">Edit Donasi</h3>
            <form id="editForm" method="get" action="donasiServlet">
                <input type="hidden" name="action" value="updateDonasi">
                <input type="hidden" name="donasi_id" id="editDonasiId">
                
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Metode Pembayaran:</label>
                    <select name="metode" id="editMetode" style="width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px;">
                        <option value="Bank Transfer">Bank Transfer</option>
                        <option value="OVO">OVO</option>
                        <option value="GoPay">GoPay</option>
                        <option value="DANA">DANA</option>
                        <option value="Cash">Cash</option>
                    </select>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Jumlah Donasi:</label>
                    <input type="number" name="jumlah" id="editJumlah" min="1" style="width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px;">
                </div>
                
                <div style="display: flex; gap: 10px; justify-content: flex-end;">
                    <button type="button" onclick="closeEditModal()" style="padding: 10px 20px; background: #e2e8f0; border: none; border-radius: 6px; cursor: pointer;">Batal</button>
                    <button type="submit" style="padding: 10px 20px; background: #667eea; color: white; border: none; border-radius: 6px; cursor: pointer;">Simpan</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function editDonation(id, metode, jumlah) {
            document.getElementById('editDonasiId').value = id;
            document.getElementById('editMetode').value = metode;
            document.getElementById('editJumlah').value = jumlah;
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function deleteDonation(id) {
            if (confirm('Apakah Anda yakin ingin menghapus donasi ini?')) {
                window.location.href = 'donasiServlet?action=deleteDonasi&donasi_id=' + id;
            }
        }

        // Close modal when clicking outside
        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });
    </script>
</body>
</html>