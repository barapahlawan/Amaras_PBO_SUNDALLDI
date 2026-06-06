<%-- 
    Document   : koneksi
    Created on : 1 Jun 2025, 22.16.43
    Author     : Alicia Mazza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/amaras", "root", "");
    } catch (Exception e) {
        out.println("Koneksi Gagal: " + e.getMessage());
    }
%>