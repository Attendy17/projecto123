<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>

<%
  // Retrieve the logged-in user from the session
  Object user = session.getAttribute("user");
  
  // If no user is logged in, redirect to login page
  if (user == null) {
    response.sendRedirect("loginHashing.html"); 
    return;
  }

  // Retrieve the role of the logged-in user
  String role = (String) session.getAttribute("role");
  
  // Check if the user is an admin, otherwise deny access
  if (role == null || !role.equalsIgnoreCase("admin")) {
    out.println("<h2>Access denied: You do not have permission to delete photos.</h2>");
    return;
  }

  // Get the photo ID and user ID parameters from the request
  String photoIdStr = request.getParameter("photoId");
  String userIdStr  = request.getParameter("userId"); // ID of the user who owns the photo

  // If photoId is provided and not empty, proceed to delete the photo
  if (photoIdStr != null && !photoIdStr.trim().isEmpty()) {
    try {
      // Parse photoId to long
      long photoId = Long.parseLong(photoIdStr);
      
      // Create AdminDAO object to interact with database
      AdminDAO adminDAO = new AdminDAO();
      
      // Call method to delete photo by photoId
      adminDAO.deletePhoto(photoId);
      
      // Close DAO resources
      adminDAO.close();
    } catch (Exception e) {
      // Print error message if deletion fails
      out.println("<h2>Error deleting photo:</h2> " + e.getMessage());
    }
  }

  // Redirect to edit user page if userId is provided; otherwise redirect to admin dashboard
  if (userIdStr != null && !userIdStr.trim().isEmpty()) {
    response.sendRedirect("editUser.jsp?id=" + userIdStr);
  } else {
    response.sendRedirect("adminDashboard.jsp");
  }
%>
