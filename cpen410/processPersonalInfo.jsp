<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.PersonalInfoDAO" %>
<%@ page import="java.sql.*" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Process Personal Info</title>
    <style>
      body { font-family: Arial, sans-serif; margin: 20px; }
    </style>
  </head>
  <body>
<%
    // Attempt to retrieve the userId from the session.
    // If it is not present, try to get it from a hidden form field (fallback).
    Long userId = (Long) session.getAttribute("userId");
    if (userId == null) {
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            userId = Long.parseLong(userIdStr);
            // Store the retrieved userId in the session for subsequent requests.
            session.setAttribute("userId", userId);
        }
    }
    
    // If userId is still null, then the user is not authenticated.
    if (userId == null) {
        out.println("<h1>Error: Usuario no autenticado.</h1>");
        return;
    }
    
    // Retrieve form parameters for address and education.
    String street = request.getParameter("street");
    String town = request.getParameter("town");
    String state = request.getParameter("state");
    String country = request.getParameter("country");
    String degree = request.getParameter("degree");
    String school = request.getParameter("school");
    
    // Create an instance of PersonalInfoDAO to handle database operations.
    PersonalInfoDAO infoDAO = new PersonalInfoDAO();
    
    // Insert address information into the database.
    boolean addrInserted = infoDAO.addAddress(userId, street, town, state, country);
    // Insert educational information into the database.
    boolean eduInserted = infoDAO.addEducation(userId, degree, school);
    
    // If both insertions are successful, redirect the user to the welcome page.
    if (addrInserted && eduInserted) {
        response.sendRedirect("welcome.jsp");
    } else {
        // Otherwise, display an error message.
        out.println("<h1>Error adding personal information.</h1>");
    }
    
    // Close the DAO connection.
    infoDAO.close();
%>
  </body>
</html>
