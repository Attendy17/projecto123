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
    /* Basic CSS styling for layout and card design */
    * { box-sizing: border-box; }
    body {
      font-family: Calibri, sans-serif;
      background: #f5f5f5;
      margin: 0;
      padding: 0;
    }
    .container {
      width: 100%;
      padding: 40px;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .row { display: flex; flex-wrap: wrap; width: 100%; }
    .col-100  { width: 100%; padding: 15px; }
    .card {
      max-width: 600px;
      width: 100%;
      background: #ffffff;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      padding: 30px;
      text-align: center;
    }
    h1        { color: #4e4e4e; font-weight: bold; }
    .error h1 { color: #b30000; }
    a.btn {
      display: inline-block;
      margin-top: 20px;
      padding: 10px 20px;
      background: #4e4e4e;
      color: #fff;
      text-decoration: none;
      border-radius: 4px;
      font-weight: bold;
    }
  </style>
</head>
<body>

<%
  // Check if user is logged in, otherwise redirect to login page
  Object user = session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("loginHashing.html"); 
    return;
  }

  // Verify if the logged-in user has admin privileges
  String role = (String) session.getAttribute("role");
  if (role == null || !role.equalsIgnoreCase("admin")) {
    out.println("<h2>Access denied: You do not have permission to add users.</h2>");
    return;
  }

  // Retrieve form data sent from the addUserAdmin.jsp form
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

  // Booleans to track if each database operation succeeds
  boolean okUser  = false, okAddr = false, okEdu  = false;
  long    newId   = -1;

  // Attempt to add the new user
  AdminDAO admin = new AdminDAO();
  try {
    okUser = admin.addUser(name, email, pass, birthDate, gender, "", "", isAdmin);
  } catch (Exception ex) {
    ex.printStackTrace();
  }
  admin.close();

  // If user creation was successful, authenticate and retrieve the user ID
  if (okUser) {
    applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();
    ResultSet rs = auth.authenticate(email, pass);
    if (rs != null && rs.next()) {
      newId = rs.getLong("id"); // Extract newly created user ID
    }
    if (rs != null) rs.close();
    auth.close();
  }

  // Add the address and education info if we have the new user's ID
  if (newId != -1) {
    PersonalInfoDAO info = new PersonalInfoDAO();
    okAddr = info.addAddress  (newId, street, town, state, country);
    okEdu  = info.addEducation(newId, degree, school);
    info.close();
  }

  // Determine if all operations were successful
  boolean success = okUser && okAddr && okEdu;
%>

<!-- Display success or error message in a styled card -->
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
