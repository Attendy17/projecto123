<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>

<%
    // Retrieve the logged-in user's ID from session
    Long userId = (Long) session.getAttribute("userId");

    // If no user is logged in, redirect to login page
    if (userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Retrieve the username from session (optional: display or log usage)
    String userName = (String) session.getAttribute("userName");

    // Get the role from session
    String role = (String) session.getAttribute("role");

    // If the role is not admin, deny access
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        out.println("<h2>Access Denied: You do not have permission to delete photos.</h2>");
        return;
    }

    // Photo ID to delete
    String photoIdStr = request.getParameter("photoId");

    // User ID of the owner of the photo (used for redirection)
    String userIdStr  = request.getParameter("userId");

    // Photo Deletion Logic
    if (photoIdStr != null && !photoIdStr.trim().isEmpty()) {
        try {
            // Convert photoId from String to long
            long photoId = Long.parseLong(photoIdStr);

            // Create AdminDAO instance to interact with DB
            AdminDAO adminDAO = new AdminDAO();

            // Delete the photo
            adminDAO.deletePhoto(photoId);

            // Close database resources
            adminDAO.close();

        } catch (Exception e) {
            // Print error message if deletion fails
            out.println("<h2>Error deleting photo:</h2> " + e.getMessage());
        }
    }
 // Redirect back to the edit user page for the specified user
    if (userIdStr != null && !userIdStr.trim().isEmpty()) {
        response.sendRedirect("editUser.jsp?id=" + userIdStr);
    } else {// If no user ID is provided, go back to admin dashboard
        response.sendRedirect("adminDashboard.jsp");
    }
%>
