<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %>
<%@ page import="ut.JAR.CPEN410.MySQLCompleteConnector" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>My Friends - minifacebook</title>
    <!-- Prevent browser caching to always show fresh content -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <style>
      /* CSS Reset and basic styling */
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        font-family: Calibri, sans-serif;
        font-weight: bold;
        background-color: #f8f9fa;
        color: #333;
      }
      /* Top taskbar style */
      .taskbar {
        background-color: #333;
        color: #fff;
        padding: 10px 20px;
        text-align: center;
      }
      /* Navigation bar container */
      .nav-bar {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
        background-color: #333;
        padding: 10px 20px;
      }
      /* Left side nav */
      .nav-left {
        color: #fff;
        font-size: 18px;
      }
      /* Right side nav links container */
      .nav-right {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
      }
      /* Nav links styling */
      .nav-right a {
        color: #fff;
        text-decoration: none;
        padding: 6px 12px;
        border-radius: 4px;
        transition: background-color 0.3s ease;
      }
      .nav-right a:hover {
        background-color: #555;
      }
      /* Main content container */
      .container {
        width: 90%;
        max-width: 1000px;
        margin: 20px auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }
      /* Page title */
      h1 {
        text-align: center;
        margin-bottom: 20px;
      }
      /* Table styling */
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }
      th, td {
        padding: 10px;
        border: 1px solid #ccc;
        text-align: left;
      }
      th {
        background-color: #444;
        color: white;
      }
      /* Profile picture styling */
      img {
        border-radius: 50%;
        object-fit: cover;
      }
      /* Responsive grid system */
      .row {
        display: flex;
        flex-wrap: wrap;
      }
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
      /* Responsive adjustments for small screens */
      @media only screen and (max-width: 600px) {
        .nav-bar {
          flex-direction: column;
        }
        .nav-right {
          flex-direction: column;
          width: 100%;
        }
        .nav-right a {
          width: 100%;
          text-align: left;
        }
      }
    </style>
  </head>
  <body>
<%
    // Get logged-in user's ID and name from session
    Long userId = (Long) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    // If user is not logged in, redirect to login page
    if (userId == null || userName == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }
%>
    <!-- Top taskbar -->
    <div class="taskbar">
      <h1>minifacebook</h1>
    </div>

    <!-- Navigation bar with welcome message and links -->
    <div class="nav-bar">
      <div class="nav-left">Welcome, <%= userName %>!</div>
      <div class="nav-right">
        <a href="welcomeMenu.jsp">Home</a>
        <a href="profile.jsp">Profile</a>
        <a href="searchFriends.jsp">Search Friends</a>
        <a href="signout.jsp">Sign Out</a>
      </div>
    </div>

    <!-- Main container for friends list -->
    <div class="container col-12">
      <h1>My Friends</h1>
<%
    // Create DAO object to access friendship data
    FriendshipDAO dao = new FriendshipDAO();
    try {
        // Retrieve list of friends for the current user
        ResultSet rs = dao.listFriends(userId);
%>
      <div class="row">
        <table class="col-12">
          <tr>
            <th class="col-3">Photo</th>
            <th class="col-2">ID</th>
            <th class="col-4">Name</th>
            <th class="col-3">Friendship Date</th>
          </tr>
<%
        // Loop through each friendship record
        while(rs.next()) {
            // Extract friendship and user IDs
            long friendshipId = rs.getLong("id");
            long user1 = rs.getLong("user1_id");
            long user2 = rs.getLong("user2_id");
            Timestamp createdAt = rs.getTimestamp("created_at");

            // Determine friend ID by checking which user is not the current user
            long friendId = (user1 == userId) ? user2 : user1;

            // Format friendship date if available
            String friendshipDate = (createdAt != null) ? createdAt.toLocalDateTime().toLocalDate().toString() : "";

            // Connect to database to get friend's details
            MySQLCompleteConnector connector = new MySQLCompleteConnector();
            connector.doConnection();

            // Query friend's name and profile picture
            ResultSet rsFriend = connector.doSelect("name, profile_picture", "users", "id = " + friendId);

            String friendName = "";
            String profilePic = "cpen410/imagesjson/default-profile.png"; // Default picture if none set

            if(rsFriend.next()) {
                friendName = rsFriend.getString("name");
                String pic = rsFriend.getString("profile_picture");
                if(pic != null && !pic.trim().isEmpty()) profilePic = pic;
            }

            // Close friend's query and DB connection
            rsFriend.close();
            connector.closeConnection();
%>
          <tr>
            <!-- Display friend's profile picture -->
            <td class="col-3"><img src="<%= request.getContextPath() %>/<%= profilePic %>" width="50" height="50" /></td>
            <!-- Display friendship ID -->
            <td class="col-2"><%= friendshipId %></td>
            <!-- Display friend's name -->
            <td class="col-4"><%= friendName %></td>
            <!-- Display friendship creation date -->
            <td class="col-3"><%= friendshipDate %></td>
          </tr>
<%
        }
        // Close friendship list ResultSet and DAO to release resources
        rs.close();
        dao.close();
    } catch(Exception e) {
        // Show error message if listing friends fails
        out.println("Error listing friends: " + e.getMessage());
        e.printStackTrace();
    }
%>
        </table>
      </div>
    </div>
  </body>
</html>
