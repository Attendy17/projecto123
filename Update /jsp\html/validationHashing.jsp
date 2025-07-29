<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Validation Hashing - minifacebook</title>
    <style>
      /* Reset margin, padding and set box-sizing */
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      /* Basic body styling: font, background, center content vertically and horizontally */
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      /* Container for flexible rows, wrapping and padding */
      .row {
        display: flex;
        flex-wrap: wrap;
        width: 100%;
        padding: 20px;
      }

      /* Generic column classes with padding and full width by default */
      [class*="col-"] {
        padding: 15px;
        width: 100%;
      }

      /* Responsive column widths for screens wider than 600px */
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

        /* Offset classes to add left margin for spacing */
        .col-offset-1 { margin-left: 8.33%; }
        .col-offset-2 { margin-left: 16.66%; }
        .col-offset-3 { margin-left: 25%; }
        .col-offset-4 { margin-left: 33.33%; }
        .col-offset-5 { margin-left: 41.66%; }
        .col-offset-6 { margin-left: 50%; }
      }

      /* Styling the error container box */
      .error-container {
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        padding: 40px;
        text-align: center;
      }

      /* Styling for error title */
      .error-container h2 {
        color: #333;
        margin-bottom: 20px;
        font-size: 20px;
      }

      /* Styling for error message text */
      .error-container p {
        color: #6F4E37;
        font-weight: bold;
        font-size: 14px;
      }

      /* Styling for link inside error message */
      .error-container a {
        text-decoration: none;
        color: #6F4E37;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
<%
    // Retrieve username and password parameters from login form
    String userName = request.getParameter("userName");
    String userPass = request.getParameter("userPass");

    // Instantiate authentication helper class to validate credentials
    applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();

    // Call authentication method which returns a ResultSet if credentials are valid
    ResultSet rs = auth.authenticate(userName, userPass);

    // Check if the ResultSet contains a valid user
    if (rs != null && rs.next()) {
        // Retrieve user ID and full name from the database result
        long userId = rs.getLong("id");
        String name = rs.getString("name");

        // Set session attributes for the logged-in user
        session.setAttribute("user", userName);
        session.setAttribute("userId", userId);
        session.setAttribute("userName", userName);
        session.setAttribute("name", name);

        // Retrieve user role (e.g., ADMIN or USER)
        String role = auth.getUserRole(userId);
        session.setAttribute("role", role);

        // Redirect user based on role: admins go to admin dashboard, others to welcome page
        if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect("adminDashboard.jsp");
        } else {
            response.sendRedirect("welcomeMenu.jsp");
        }
    } else {
        // If authentication fails, show error message with link to try login again
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
    // Close authentication resources
    auth.close();
%>
  </body>
</html>
