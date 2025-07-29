<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %> <!-- Import class to handle database authentication and user creation -->
<%@ page import="java.sql.*" %> <!-- Import Java SQL classes for ResultSet handling -->
<html>
  <head>
    <meta charset="UTF-8">
    <title>Sign Up Result</title>
    <style>
      /* Basic layout and styling for the result page */
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      .container {
        width: 50%;
        background-color: #ffffff;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
        text-align: center;
      }

      h2 {
        color: #343a40;
        margin-bottom: 20px;
      }

      a {
        text-decoration: none;
        color: #007bff;
        font-weight: bold;
      }

      a:hover {
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <div class="container">
<%
    // Get user input from the sign-up form
    String userName = request.getParameter("userName");
    String userPass = request.getParameter("userPass");
    String completeName = request.getParameter("completeName");
    String birthDate = request.getParameter("birthDate");
    String gender = request.getParameter("gender");

    try {
        // Instantiate authentication/registration handler
        applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();

        // Attempt to add the new user to the database
        boolean res = auth.addUser(userName, completeName, userPass, birthDate, gender);

        if(res) {
            // If registration is successful, try to authenticate the user to retrieve their ID
            ResultSet rs = auth.authenticate(userName, userPass);

            if(rs != null && rs.next()){
                long userId = rs.getLong("id");
                session.setAttribute("userId", userId); // Store user ID in session
            }

            // Redirect to form to complete personal information
            response.sendRedirect("addPersonalInfo.jsp");
        } else {
%>
            <!-- If user registration failed, show a message and link to retry -->
            <h2>Sign Up Failed</h2>
            <a href="newUser.html">Try Again</a>
<%
        }

        // Close the database connection
        auth.close();

    } catch(Exception e) {
        // Handle and show any unexpected errors during the process
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
        e.printStackTrace();
    }
%>
    </div>
  </body>
</html>
