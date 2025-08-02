<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Delete User - minifacebook</title>
    <style>
      /* Base styling */
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        text-align: center;
        padding: 20px;
      }
      /* Container for message box */
      .container {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        max-width: 400px;
        margin: auto;
      }
      /* Links style */
      a {
        color: #6F4E37;
        text-decoration: none;
        font-weight: bold;
      }

      /* Mobile-first layout */
      [class*="col-"] {
          width: 100%;
      }

      /* Responsive grid for tablets and desktops */
      @media only screen and (min-width: 768px) {
          .col-1 {width: 8.33%;}
          .col-2 {width: 16.66%;}
          .col-3 {width: 25%;}
          .col-4 {width: 33.33%;}
          .col-5 {width: 41.66%;}
          .col-6 {width: 50%;}
          .col-7 {width: 58.33%;}
          .col-8 {width: 66.66%;}
          .col-9 {width: 75%;}
          .col-10 {width: 83.33%;}
          .col-11 {width: 91.66%;}
          .col-12 {width: 100%;}
      }
    </style>
  </head>
  <body>
<%
    // Session verification
    Long userId = (Long) session.getAttribute("userId");

    // Redirect to login if no session
    if(userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Retrieve logged-in username
    String userName = (String) session.getAttribute("userName");

    // Process user deletion
    // Get the user ID parameter from request
    String idParam = request.getParameter("id");

    if(idParam == null || idParam.trim().isEmpty()){
        out.println("<div class='container'><h2>Error: No user ID provided.</h2></div>");
        return;
    }

    long userId = Long.parseLong(idParam.trim());

    AdminDAO adminDAO = new AdminDAO();
    boolean deleted = false;

    try {
        // Attempt to delete the specified user
        deleted = adminDAO.deleteUser(targetUserId);
    } catch(Exception e){
        out.println("<div class='container'><h2>Error deleting user: " + e.getMessage() + "</h2></div>");
        e.printStackTrace();
    } finally {
        adminDAO.close();
    }

    // Display result
    if(deleted){
        out.println("<div class='container'><h2>User deleted successfully.</h2>");
        out.println("<p><a href='adminDashboard.jsp'>Back to Dashboard</a></p></div>");
    } else {
        out.println("<div class='container'><h2>Unable to delete the user.</h2>");
        out.println("<p><a href='adminDashboard.jsp'>Back to Dashboard</a></p></div>");
    }
%>
  </body>
</html>
