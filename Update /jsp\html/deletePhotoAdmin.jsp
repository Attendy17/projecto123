<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>

<%
  
  Object user = session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("loginHashing.html"); 
    return;
  }

  String role = (String) session.getAttribute("role");
  if (role == null || !role.equalsIgnoreCase("admin")) {
    out.println("<h2>Access denied: You do not have permission to delete photos.</h2>");
    return;
  }


  String photoIdStr = request.getParameter("photoId");
  String userIdStr  = request.getParameter("userId"); // ID del usuario al que pertenece la foto


  if (photoIdStr != null && !photoIdStr.trim().isEmpty()) {
    try {
      long photoId = Long.parseLong(photoIdStr);
      AdminDAO adminDAO = new AdminDAO();
      adminDAO.deletePhoto(photoId);
      adminDAO.close();
    } catch (Exception e) {
      out.println("<h2>Error deleting photo:</h2> " + e.getMessage());
    }
  }


  if (userIdStr != null && !userIdStr.trim().isEmpty()) {
    response.sendRedirect("editUser.jsp?id=" + userIdStr);
  } else {
    response.sendRedirect("adminDashboard.jsp");
  }
%>
