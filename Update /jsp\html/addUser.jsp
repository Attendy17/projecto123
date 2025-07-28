<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>
<%@ page import="java.sql.*" %>
<html>
  <head>
    <title>Sign Up Result</title>
  </head>
  <body>
<%
    // Retrieve parameters sent from newUser.html
    // Note: "userName" will be used as the email.
    String userName = request.getParameter("userName");
    String userPass = request.getParameter("userPass");
    String completeName = request.getParameter("completeName");
    String birthDate = request.getParameter("birthDate"); // format 'YYYY-MM-DD'
    String gender = request.getParameter("gender");
    
    try {
        // Create an instance of applicationDBAuthenticationGoodComplete to handle authentication and user creation.
        applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();
        // Call addUser method with 5 parameters (without profile picture)
        boolean res = auth.addUser(userName, completeName, userPass, birthDate, gender);
        if(res) {
            // If insertion is successful, obtain the userId via authenticate (email is unique)
            ResultSet rs = auth.authenticate(userName, userPass);
            if(rs != null && rs.next()){
                long userId = rs.getLong("id");
                // Store userId in the session for later use
                session.setAttribute("userId", userId);
            }
            // Redirect to addPersonalInfo.jsp to continue the process
            response.sendRedirect("addPersonalInfo.jsp");
        } else {
%>
            <h2>Sign Up Failed</h2>
            <a href="newUser.html">Try Again</a>
<%
        }
        // Close the connection/resources
        auth.close();
    } catch(Exception e) {
        // Display error message and print stack trace for debugging purposes
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    }
%>
  </body>
</html>
