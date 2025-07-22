<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Validation Hashing - minifacebook</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      .row {
        display: flex;
        flex-wrap: wrap;
        width: 100%;
        padding: 20px;
      }

      [class*="col-"] {
        padding: 15px;
        width: 100%;
      }

      @media only screen and (min-width: 600px) {
        .col-1 { width: 8.33%; }
        .col-2 { width: 16.66%; }
        .col-3 { width: 25%; }
        .col-4 { width: 33.33%; }
        .col-5 { width: 41.66%; }
        .col-6 { width: 50%; }
        .col-7 { width: 58.33%; }
        .col-8 { width: 66.66%; }
        .col-9 { width: 75%; }
        .col-10 { width: 83.33%; }
        .col-11 { width: 91.66%; }
        .col-12 { width: 100%; }

        .col-offset-1 { margin-left: 8.33%; }
        .col-offset-2 { margin-left: 16.66%; }
        .col-offset-3 { margin-left: 25%; }
        .col-offset-4 { margin-left: 33.33%; }
        .col-offset-5 { margin-left: 41.66%; }
        .col-offset-6 { margin-left: 50%; }
      }

      .error-container {
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        padding: 40px;
        text-align: center;
      }

      .error-container h2 {
        color: #333;
        margin-bottom: 20px;
        font-size: 20px;
      }

      .error-container p {
        color: #6F4E37;
        font-weight: bold;
        font-size: 14px;
      }

      .error-container a {
        text-decoration: none;
        color: #6F4E37;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
<%
    String userName = request.getParameter("userName");
    String userPass = request.getParameter("userPass");

    applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();
    ResultSet rs = auth.authenticate(userName, userPass);

    if (rs != null && rs.next()) {
        long userId = rs.getLong("id");
        String name = rs.getString("name");

        session.setAttribute("user", userName);
        session.setAttribute("userId", userId);
        session.setAttribute("userName", userName);
        session.setAttribute("name", name);

        String role = auth.getUserRole(userId);
        session.setAttribute("role", role);

        if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect("adminDashboard.jsp");
        } else {
            response.sendRedirect("welcomeMenu.jsp");
        }
    } else {
%>
    <div class="row">
      <div class="col-6 col-offset-3">
        <div class="error-container">
          <h2>Login Failed</h2>
          <p>Invalid credentials. <a href="loginHashing.html">Try again</a></p>
        </div>
      </div>
    </div>
<%
    }
    auth.close();
%>
  </body>
</html>
