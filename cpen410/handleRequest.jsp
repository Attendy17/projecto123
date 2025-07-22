<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Procesar Solicitud de Amistad - minifacebook</title>
    <style>
      body { font-family: Arial, sans-serif; background-color: #f8f9fa; text-align: center; padding-top: 50px; }
      a { text-decoration: none; color: #6F4E37; font-weight: bold; }
    </style>
  </head>
  <body>
<%
    // Verificar que el usuario esté autenticado
    Long userId = (Long) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }
    
    String action = request.getParameter("action");
    String friendshipIdStr = request.getParameter("friendshipId");
    if (action == null || friendshipIdStr == null || friendshipIdStr.trim().isEmpty()) {
        out.println("Parámetros inválidos.");
        return;
    }
    long friendshipId = Long.parseLong(friendshipIdStr);
    
    FriendshipDAO dao = new FriendshipDAO();
    boolean result = false;
    try {
        // Solo se permite la acción de "accept"
        if ("accept".equalsIgnoreCase(action)) {
            result = dao.acceptFriendRequest(friendshipId);
        }
        dao.close();
    } catch(Exception e) {
        out.println("Error al procesar la solicitud: " + e.getMessage());
        e.printStackTrace();
        return;
    }
    
    if(result) {
        out.println("<h2>Solicitud aceptada correctamente.</h2>");
    } else {
        out.println("<h2>No se pudo procesar la acción o ya fue procesada.</h2>");
    }
%>
<a href="friendRequests.jsp">Volver a Solicitudes</a>
  </body>
</html>
