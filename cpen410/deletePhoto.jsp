<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.ProfileDAO" %>
<%
    // Obtener el parametro photoId enviado desde el formulario
    String photoIdStr = request.getParameter("photoId");
    if(photoIdStr != null && !photoIdStr.trim().isEmpty()){
        try {
            long photoId = Long.parseLong(photoIdStr);
            ProfileDAO profileDAO = new ProfileDAO();
            // Llamar al metodo para eliminar la foto
            profileDAO.deletePhoto(photoId);
            profileDAO.close();
        } catch(Exception e) {
            out.println("Error al borrar la foto: " + e.getMessage());
        }
    }
    // Redireccionar de vuelta a profile.jsp
    response.sendRedirect("profile.jsp");
%>
