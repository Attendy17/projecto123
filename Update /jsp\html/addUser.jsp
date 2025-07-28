<%@ page import="ut.JAR.CPEN410.applicationDBAuthenticationGoodComplete" %>
<%@ page import="java.sql.*" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Sign Up Result</title>
    <style>
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
    String userName = request.getParameter("userName");
    String userPass = request.getParameter("userPass");
    String completeName = request.getParameter("completeName");
    String birthDate = request.getParameter("birthDate");
    String gender = request.getParameter("gender");

    try {
        applicationDBAuthenticationGoodComplete auth = new applicationDBAuthenticationGoodComplete();
        boolean res = auth.addUser(userName, completeName, userPass, birthDate, gender);
        if(res) {
            ResultSet rs = auth.authenticate(userName, userPass);
            if(rs != null && rs.next()){
                long userId = rs.getLong("id");
                session.setAttribute("userId", userId);
            }
            response.sendRedirect("addPersonalInfo.jsp");
        } else {
%>
            <h2>Sign Up Failed</h2>
            <a href="newUser.html">Try Again</a>
<%
        }
        auth.close();
    } catch(Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
        e.printStackTrace();
    }
%>
    </div>
  </body>
</html>
