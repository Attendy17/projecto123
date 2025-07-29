<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.ProfileDAO" %>
<%
    // Get the photoId parameter sent from the form
    String photoIdStr = request.getParameter("photoId");
    if(photoIdStr != null && !photoIdStr.trim().isEmpty()){
        try {
            long photoId = Long.parseLong(photoIdStr);
            ProfileDAO profileDAO = new ProfileDAO();
            // Call the method to delete the photo
            profileDAO.deletePhoto(photoId);
            profileDAO.close();
        } catch(Exception e) {
            out.println("Error al borrar la foto: " + e.getMessage());
        }
    }
   // Redirect back to profile.jsp
    response.sendRedirect("profile.jsp");
%>
