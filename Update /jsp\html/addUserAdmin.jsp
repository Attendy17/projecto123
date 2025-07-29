<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %> <!-- Import custom authentication class for handling DB operations -->
<%@ page import="java.sql.*" %> <!-- Import Java SQL classes to work with database results -->
<html>
  <head>
    <title>Sign Up Result</title>
    <style>
      /* Base styles for layout and appearance */
      body {
        background-color: #ffffff;
        font-family: 'Calibri', sans-serif;
        font-weight: bold;
        margin: 0;
        padding: 0;
      }

      a {
        color: #555;
        text-decoration: none;
      }

      .container {
        padding: 30px;
        max-width: 800px;
        margin: auto;
      }

      .row::after {
        content: "";
        clear: both;
        display: table;
      }

      [class*="col-"] {
        float: left;
        padding: 15px;
        width: 100%;
      }

      /* Responsive column layout */
      @media only screen and (min-width: 768px) {
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
      }

      h2 {
        color: #333;
        margin-bottom: 20px;
      }

      .center {
        text-align: center;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-12 center">
<%
    // Get form input from request parameters
    String userName = request.getParameter("userName");
    String userPass = request.getParameter("userPass");
    String completeName = request.getParameter("completeName");
    String birthDate = request.getParameter("birthDate");
    String gender = request.getParameter("gender");

    try {
        // Create authentication/DB access object
        applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();

        // Attempt to add user to the database
        boolean res = auth.addUser(userName, completeName, userPass, birthDate, gender);

        if (res) {
            // If user is successfully created, authenticate to retrieve their ID
            ResultSet rs = auth.authenticate(userName, userPass);
            if (rs != null && rs.next()) {
                long userId = rs.getLong("id"); // Get user ID from DB result
                session.setAttribute("userId", userId); // Store ID in session for login persistence
            }

            // Redirect to form for adding more personal information
            response.sendRedirect("addPersonalInfo.jsp");
        } else {
%>
            <!-- If registration fails, show error and link back -->
            <h2>Sign Up Failed</h2>
            <a href="newUser.html">Try Again</a>
<%
        }

        // Always close database connection
        auth.close();

    } catch (Exception e) {
%>
        <!-- Show unexpected error message -->
        <h2>Error: <%= e.getMessage() %></h2>
<%
        e.printStackTrace(); // Print error to server log (for debugging)
    }
%>
        </div>
      </div>
    </div>
  </body>
</html>
