<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>
<%@ page import="ut.JAR.CPEN410.WebPageDAO" %>
<%@ page import="java.sql.*" %>
<html>
  <head>
    <title>Welcome</title>
  </head>
  <body>
<%
    // Verificar que el usuario esté autenticado
    if (session.getAttribute("user") == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }
    
    String userEmail = session.getAttribute("user").toString();
    String previousPageUrl = null;
    
    // Obtener datos del usuario usando el método getUserData de la clase
    applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();
    ResultSet rsUser = auth.getUserData(userEmail);
    
    if (rsUser.next()) {
        long lastPageId = rsUser.getLong("last_page_id");
        if (lastPageId > 0) {
            // Obtener la información de la página previa desde webPageGood usando WebPageDAO
            WebPageDAO pageDAO = new WebPageDAO();
            ResultSet rsPage = pageDAO.getPageById(lastPageId);
            if (rsPage.next()) {
                previousPageUrl = rsPage.getString("pageURL");
            }
            rsPage.close();
            pageDAO.close();
        }
    }
    rsUser.close();
    auth.close();
    
    // Actualizar la sesión con la página actual
    session.setAttribute("currentPage", "welcome.jsp");
    
    // Mostrar mensaje de bienvenida
%>
    <h1>Welcome, <%= userEmail %>!</h1>
<%
    if (previousPageUrl != null) {
%>
    <p><a href="<%= previousPageUrl %>">Volver a la página anterior</a></p>
<%
    } else {
%>
    <p>No se encontró una página previa registrada.</p>
<%
    }
%>
  </body>
</html>
