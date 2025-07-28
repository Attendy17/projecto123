<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<%@ page import="ut.JAR.CPEN410.PersonalInfoDAO" %>
<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add User – Result</title>
  <style>
    body      { font-family: Arial, sans-serif; background:#f8f9fa; padding:40px; }
    .card     { max-width:550px; margin:0 auto; background:#fff; border-radius:8px;
                box-shadow:0 2px 10px rgba(0,0,0,.1); padding:30px; text-align:center; }
    h1        { color:#4e310c; }
    .error h1 { color:#b30000; }
    a.btn     { display:inline-block; margin-top:20px; padding:10px 22px; background:#4e310c;
                color:#fff; text-decoration:none; border-radius:4px; }
  </style>
</head>
<body>

<%
// ───────────────────────── Validación de sesión y rol
  Object user = session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("loginHashing.html"); 
    return;
  }

  String role = (String) session.getAttribute("role");
  if (role == null || !role.equalsIgnoreCase("admin")) {
    out.println("<h2>Access denied: You do not have permission to add users.</h2>");
    return;
  }

  // ───────────────────────── Recoger parámetros del formulario
  String name      = request.getParameter("name");
  String email     = request.getParameter("email");
  String pass      = request.getParameter("userPass");
  String birthDate = request.getParameter("birthDate");
  String gender    = request.getParameter("gender");
  boolean isAdmin  = "true".equalsIgnoreCase(request.getParameter("isAdmin"));

  String street  = request.getParameter("street");
  String town    = request.getParameter("town");
  String state   = request.getParameter("state");
  String country = request.getParameter("country");

  String degree  = request.getParameter("degree");
  String school  = request.getParameter("school");

  // ───────────────────────── Inserción en la base de datos
  boolean okUser  = false, okAddr = false, okEdu  = false;
  long    newId   = -1;

  AdminDAO admin = new AdminDAO();
  try {
    okUser = admin.addUser(name, email, pass, birthDate, gender, "", "", isAdmin);
  } catch (Exception ex) {
    ex.printStackTrace();
  }
  admin.close();

  // ───────────────────────── Obtener el ID del nuevo usuario
  if (okUser) {
    applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();
    ResultSet rs = auth.authenticate(email, pass);
    if (rs != null && rs.next()) {
      newId = rs.getLong("id");
    }
    if (rs != null) rs.close();
    auth.close();
  }

  // ───────────────────────── Insertar dirección y educación si se creó el usuario
  if (newId != -1) {
    PersonalInfoDAO info = new PersonalInfoDAO();
    okAddr = info.addAddress  (newId, street, town, state, country);
    okEdu  = info.addEducation(newId, degree, school);
    info.close();
  }

  boolean success = okUser && okAddr && okEdu;
%>

<!-- ───────────────────────── Resultado en pantalla -->
<div class="card <%= (success ? "" : "error") %>">
<% if (success) { %>
    <h1>User created successfully</h1>
    <p><strong><%= email %></strong> is now
       <%= (isAdmin ? "an <em>ADMIN</em>" : "a regular <em>USER</em>") %>.</p>
    <a class="btn" href="adminDashboard.jsp">Back to dashboard</a>
<% } else { %>
    <h1>User could not be created</h1>
    <p>Please check the data and try again.</p>
    <a class="btn" href="addUserAdmin.jsp">Return to form</a>
<% } %>
</div>

</body>
</html>
