<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Send Friend Request - minifacebook</title>
    <style>
      /* Basic styling for the page */
      body { font-family: Arial, sans-serif; background-color: #f8f9fa; text-align: center; padding-top: 50px; }
      a { text-decoration: none; color: #6F4E37; font-weight: bold; }
    </style>
  </head>
  <body>
<%
    // Check if the user is authenticated by verifying the session attribute "userId"
    Long userId = (Long) session.getAttribute("userId");
    if (userId == null) {
        // If not authenticated, redirect to the login page and exit further processing
        response.sendRedirect("loginHashing.html");
        return;
    }
    
    // Retrieve the "friendId" parameter from the request, representing the ID of the friend to add
    String friendIdStr = request.getParameter("friendId");
    if (friendIdStr == null || friendIdStr.trim().isEmpty()) {
        // If friendId is missing or empty, output an error message and stop processing
        out.println("No friend ID specified.");
        return;
    }
    // Convert the friendId parameter from String to a long value
    long friendId = Long.parseLong(friendIdStr);
    
    // Create an instance of FriendshipDAO to manage friend-related operations
    FriendshipDAO dao = new FriendshipDAO();
    try {
        // Attempt to send a friend request from the authenticated user to the specified friend
        boolean success = dao.sendFriendRequest(userId, friendId);
        // Close the DAO to free database resources
        dao.close();
        if (success) {
            // Display a success message if the friend request was sent successfully
            out.println("<h2>Friend request sent successfully.</h2>");
        } else {
            // Display a message if the request already exists or could not be sent
            out.println("<h2>Friend request already exists or could not be sent.</h2>");
        }
    } catch(Exception e) {
        // In case of an exception, display an error message and print the stack trace for debugging
        out.println("Error sending friend request: " + e.getMessage());
        e.printStackTrace();
    }
%>
<!-- Link to navigate back to the friend search page -->
<a href="searchFriends.jsp">Back to search friends</a>
  </body>
</html>
