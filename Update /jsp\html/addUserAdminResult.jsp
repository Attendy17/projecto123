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
    * { box-sizing: border-box; }
    body      { font-family: Calibri, sans-serif; background: #f5f5f5; margin: 0; padding: 0; }
    .container { width: 100%; padding: 40px; display: flex; justify-content: center; align-items: center; }
    .row      { display: flex; flex-wrap: wrap; width: 100%; }
    .col-100  { width: 100%; padding: 15px; }
    .col-75   { width: 75%; padding: 15px; }
    .col-66   { width: 66.66%; padding: 15px; }
    .col-50   { width: 50%; padding: 15px; }
    .col-33   { width: 33.33%; padding: 15px; }
    .col-25   { width: 25%; padding: 15px; }
    .card     { max-width: 600px; width: 100%; background: #ffffff; border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1); padding: 30px; text-align: center; }
    h1        { color: #4e4e4e; font-weight: bold; }
    .error h1 { color: #b30000; }
    a.btn     { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #4e4e4e;
                color: #fff; text-decoration: none; border-radius: 4px; font-weight: bold; }
  </style>
</head>
<body>

<%
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

  boolean okUser  = false, okAddr = false, okEdu  = false;
  long    newId   = -1;

  AdminDAO admin = new AdminDAO();
  try {
    okUser = admin.addUser(name, email, pass, birthDate, gender, "", "", isAdmin);
  } catch (Exception ex) {
    ex.printStackTrace();
  }
  admin.close();

  if (okUser) {
    applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();
    ResultSet rs = auth.authenticate(email, pass);
    if (rs != null && rs.next()) {
      newId = rs.getLong("id");
    }
    if (rs != null) rs.close();
    auth.close();
  }

  if (newId != -1) {
    PersonalInfoDAO info = new PersonalInfoDAO();
    okAddr = info.addAddress  (newId, street, town, state, country);
    okEdu  = info.addEducation(newId, degree, school);
    info.close();
  }

  boolean success = okUser && okAddr && okEdu;
%>

<div class="container">
  <div class="row">
    <div class="col-100">
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
    </div>
  </div>
</div>

</body>
</html>
