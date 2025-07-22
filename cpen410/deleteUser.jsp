<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Delete User - minifacebook</title>
    <style>
      /* Basic styling for the page */
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        text-align: center;
        padding: 20px;
      }
      /* Container styling for the message box */
      .container {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        max-width: 400px;
        margin: auto;
      }
      /* Styling for links */
      a {
        color: #6F4E37;
        text-decoration: none;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
<%
   // Retrieve the user ID parameter from the request query string
   String idParam = request.getParameter("id");
   if(idParam == null || idParam.trim().isEmpty()){
       // If no ID is provided, display an error message and stop processing
       out.println("<h2>Error: No user ID provided.</h2>");
       return;
   }
   
   // Parse the user ID from the string parameter
   long userId = Long.parseLong(idParam.trim());
   
   // Create an instance of AdminDAO to perform database operations
   AdminDAO adminDAO = new AdminDAO();
   boolean deleted = false;
   try {
       // Attempt to delete the user with the provided ID
       deleted = adminDAO.deleteUser(userId);
   } catch(Exception e){
       // If an exception occurs, display an error message with details
       out.println("<h2>Error deleting user: " + e.getMessage() + "</h2>");
       e.printStackTrace();
   }
   // Close the database connection
   adminDAO.close();
   
   // Display a message based on whether the deletion was successful
   if(deleted){
       out.println("<h2>User deleted successfully.</h2>");
       out.println("<p><a href='adminDashboard.jsp'>Back to Dashboard</a></p>");
   } else {
       out.println("<h2>Unable to delete the user.</h2>");
       out.println("<p><a href='adminDashboard.jsp'>Back to Dashboard</a></p>");
   }
%>
  </body>
</html>
