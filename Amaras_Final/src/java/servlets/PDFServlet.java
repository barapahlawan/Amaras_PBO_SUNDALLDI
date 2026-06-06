package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.text.NumberFormat;
import java.util.Locale;

// Import iText libraries
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;

@WebServlet("/PDFServlet")
public class PDFServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("downloadDonationHistory".equals(action)) {
            generateDonationHistoryPDF(request, response);
        } else {
            response.sendRedirect("dashboard.jsp");
        }
    }
    
    private void generateDonationHistoryPDF(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");
        String fullName = (String) session.getAttribute("fullname");
        
        if (userEmail == null) {
            response.sendRedirect("Login.jsp?error=mustLogin");
            return;
        }
        
        Connection conn = null;
        PreparedStatement viewStmt = null;
        ResultSet viewRs = null;
        
        try {
            // Ambil data donasi dari database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/amaras", "root", "");
            
            String viewSql = "SELECT d.id_donasi, d.jumlah_donasi, d.metode_pembayaran, d.tanggal_donasi " +
                     "FROM donasi d JOIN pengguna p ON d.id = p.id " +
                     "WHERE p.email = ? ORDER BY d.tanggal_donasi DESC";
            viewStmt = conn.prepareStatement(viewSql);
            viewStmt.setString(1, userEmail);
            viewRs = viewStmt.executeQuery();
           
            List<Map<String, Object>> donasiList = new ArrayList<>();
            int totalDonasi = 0;
            
            while (viewRs.next()) {
                Map<String, Object> donasi = new HashMap<>();
                donasi.put("id_donasi", viewRs.getInt("id_donasi"));
                donasi.put("jumlah_donasi", viewRs.getInt("jumlah_donasi"));
                donasi.put("metode_pembayaran", viewRs.getString("metode_pembayaran"));
                donasi.put("tanggal_donasi", viewRs.getTimestamp("tanggal_donasi"));
                donasiList.add(donasi);
                
                totalDonasi += viewRs.getInt("jumlah_donasi");
            }
            
            // Set response headers untuk PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Riwayat_Donasi_" + 
                             fullName.replaceAll("\\s+", "_") + ".pdf\"");
            
            // Create PDF document
            Document document = new Document(PageSize.A4);
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            
            document.open();
            
            // Add header
            addPDFHeader(document, fullName, userEmail);
            
            // Add donation history table
            addDonationTable(document, donasiList, totalDonasi);
            
            // Add footer
            addPDFFooter(document);
            
            document.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profil.jsp?error=pdfGeneration");
        } finally {
            try {
                if (viewRs != null) viewRs.close();
                if (viewStmt != null) viewStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void addPDFHeader(Document document, String fullName, String email) throws DocumentException {
        // Logo dan header yayasan
        Paragraph header = new Paragraph();
        header.setAlignment(Element.ALIGN_CENTER);
        
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLUE);
        Font subtitleFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12);
        
        Paragraph title = new Paragraph("YAYASAN AMARAS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        
        Paragraph subtitle = new Paragraph("HARAPAN BANGSA", subtitleFont);
        subtitle.setAlignment(Element.ALIGN_CENTER);
        document.add(subtitle);
        
        // Garis pemisah
        LineSeparator line = new LineSeparator();
        document.add(new Chunk(line));
        document.add(Chunk.NEWLINE);
        
        // Informasi dokumen
        Paragraph docTitle = new Paragraph("RIWAYAT DONASI", new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD));
        docTitle.setAlignment(Element.ALIGN_CENTER);
        document.add(docTitle);
        document.add(Chunk.NEWLINE);
        
        // Informasi donatur
        Paragraph donaturInfo = new Paragraph();
        donaturInfo.add(new Chunk("Nama Donatur: ", new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD)));
        donaturInfo.add(new Chunk(fullName, normalFont));
        donaturInfo.add(Chunk.NEWLINE);
        donaturInfo.add(new Chunk("Email: ", new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD)));
        donaturInfo.add(new Chunk(email, normalFont));
        donaturInfo.add(Chunk.NEWLINE);
        donaturInfo.add(new Chunk("Tanggal Cetak: ", new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD)));
        donaturInfo.add(new Chunk(new SimpleDateFormat("dd MMMM yyyy, HH:mm", new Locale("id", "ID")).format(new java.util.Date()), normalFont));
        
        document.add(donaturInfo);
        document.add(Chunk.NEWLINE);
    }
    
    private void addDonationTable(Document document, List<Map<String, Object>> donasiList, int totalDonasi) 
        throws DocumentException {
        
        if (donasiList.isEmpty()) {
            Paragraph noData = new Paragraph("Belum ada riwayat donasi.", 
                                           new Font(Font.FontFamily.HELVETICA, 12, Font.ITALIC));
            noData.setAlignment(Element.ALIGN_CENTER);
            document.add(noData);
            return;
        }
        
        // Create table
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);
        
        // Set column widths
        float[] columnWidths = {1f, 2f, 2f, 2f};
        table.setWidths(columnWidths);
        
        // Table headers
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);
        PdfPCell[] headers = {
            new PdfPCell(new Phrase("ID", headerFont)),
            new PdfPCell(new Phrase("Jumlah Donasi", headerFont)),
            new PdfPCell(new Phrase("Metode Pembayaran", headerFont)),
            new PdfPCell(new Phrase("Tanggal", headerFont))
        };
        
        // Style headers
        for (PdfPCell header : headers) {
            header.setBackgroundColor(BaseColor.BLUE);
            header.setHorizontalAlignment(Element.ALIGN_CENTER);
            header.setPadding(10);
            table.addCell(header);
        }
        
        // Add data rows
        Font dataFont = new Font(Font.FontFamily.HELVETICA, 11);
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm", new Locale("id", "ID"));
        
        for (Map<String, Object> donasi : donasiList) {
            // ID Donasi
            PdfPCell idCell = new PdfPCell(new Phrase("#" + donasi.get("id_donasi"), dataFont));
            idCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            idCell.setPadding(8);
            table.addCell(idCell);
            
            // Jumlah Donasi
            Integer jumlah = (Integer) donasi.get("jumlah_donasi");
            PdfPCell jumlahCell = new PdfPCell(new Phrase(currencyFormat.format(jumlah), dataFont));
            jumlahCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            jumlahCell.setPadding(8);
            table.addCell(jumlahCell);
            
            // Metode Pembayaran
            PdfPCell metodeCell = new PdfPCell(new Phrase((String) donasi.get("metode_pembayaran"), dataFont));
            metodeCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            metodeCell.setPadding(8);
            table.addCell(metodeCell);
            
            // Tanggal
            java.sql.Timestamp tanggal = (java.sql.Timestamp) donasi.get("tanggal_donasi");
            PdfPCell tanggalCell = new PdfPCell(new Phrase(dateFormat.format(tanggal), dataFont));
            tanggalCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            tanggalCell.setPadding(8);
            table.addCell(tanggalCell);
        }
        
        document.add(table);
        
        // Add total
        Paragraph total = new Paragraph();
        total.setAlignment(Element.ALIGN_RIGHT);
        total.add(new Chunk("Total Donasi: ", new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD)));
        total.add(new Chunk(currencyFormat.format(totalDonasi), 
                           new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.BLUE)));
        
        document.add(Chunk.NEWLINE);
        document.add(total);
    }
    
    private void addPDFFooter(Document document) throws DocumentException {
        document.add(Chunk.NEWLINE);
        document.add(Chunk.NEWLINE);
        
        // Garis pemisah
        LineSeparator line = new LineSeparator();
        document.add(new Chunk(line));
        
        Paragraph footer = new Paragraph();
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.add(new Chunk("Terima kasih atas kontribusi Anda untuk Yayasan Amaras", 
                           new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC)));
        footer.add(Chunk.NEWLINE);
        footer.add(new Chunk("Dokumen ini digenerate secara otomatis oleh sistem", 
                           new Font(Font.FontFamily.HELVETICA, 8, Font.ITALIC, BaseColor.GRAY)));
        
        document.add(footer);
    }
}