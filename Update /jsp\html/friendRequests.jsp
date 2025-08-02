<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %>
<%@ page import="ut.JAR.CPEN410.MySQLCompleteConnector" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>My Friends - minifacebook</title>
    <!-- Prevent browser caching to always load fresh data -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <style>
      /* Mobile-first layout: all columns take full width by default */
      [class*="col-"] {
        width: 100%;
      }

      /* Responsive grid for tablets and desktops */
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

      /* Reset default margin/padding and set box sizing */
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      /* Body styling */
      body {
        font-family: Calibri, sans-serif;
        font-weight: bold;
        background-color: #f8f9fa; /* light gray background */
        color: #333; /* dark gray text */
      }

      /* Top taskbar styles */
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

      /* Left side nav text */
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

      /* Nav links style */
      .nav-right a {
        color: #fff;
        text-decoration: none;
        padding: 6px 12px;
        border-radius: 4px;
        transition: background-color 0.3s ease;
      }

      /* Hover effect for nav links */
      .nav-right a:hover {
        background-color: #555;
      }

      /* Main container styles */
      .container {
        width: 90%;
        max-width: 1000px;
        margin: 20px auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }

      /* Page heading */
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

      /* Table headers and cells */
      th, td {
        padding: 10px;
        border: 1px solid #ccc;
        text-align: left;
      }

      /* Table header background */
      th {
        background-color: #444;
        color: white;
      }

      /* Profile image styling */
      img {
        border-radius: 50%;
        object-fit: cover;
      }

      /* Grid container for rows */
      .row {
        display: flex;
        flex-wrap: wrap;
      }

      /* Responsive layout for small screens */
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
    // Retrieve the logged-in user's ID from session
    Long userId = (Long) session.getAttribute("userId");

    // Redirect to login if userId is missing (not logged in)
    if (userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Retrieve the logged-in user's name from session (no null check here per spec)
    String userName = (String) session.getAttribute("userName");
%>

    <!-- Top taskbar with site title -->
    <div class="taskbar">
      <h1>minifacebook</h1>
    </div>

    <!-- Navigation bar with welcome message and navigation links -->
    <div class="nav-bar">
      <div class="nav-left">Welcome, <%= userName %>!</div>
      <div class="nav-right">
        <a href="welcomeMenu.jsp">Home</a>
        <a href="profile.jsp">Profile</a>
        <a href="searchFriends.jsp">Search Friends</a>
        <a href="signout.jsp">Sign Out</a>
      </div>
    </div>

    <!-- Main container displaying the friends list -->
    <div class="container col-12">
      <h1>My Friends</h1>
<%
    // Instantiate DAO to access friendship data
    FriendshipDAO dao = new FriendshipDAO();
    try {
        // Query the database to get the list of friends for the logged-in user
        ResultSet rs = dao.listFriends(userId);
%>
      <div class="row">
        <table class="col-12">
          <tr>
            <th class="col-3">Photo</th>
            <th class="col-2">ID</th>
            <th class="col-4">Name</th>
            <th class="col-3">Date</th>
          </tr>
<%
        // Iterate over each friendship record returned
        while(rs.next()) {
            // Extract friendship details
            long friendshipId = rs.getLong("id");
            long user1 = rs.getLong("user1_id");
            long user2 = rs.getLong("user2_id");
            Timestamp createdAt = rs.getTimestamp("created_at");

            // Determine which user in the friendship is the friend (not the current user)
            long friendId = (user1 == userId) ? user2 : user1;

            // Format the friendship date if available
            String friendshipDate = (createdAt != null) ? createdAt.toLocalDateTime().toLocalDate().toString() : "";

            // Connect to DB to fetch friend's name and profile picture
            MySQLCompleteConnector connector = new MySQLCompleteConnector();
            connector.doConnection();

            ResultSet rsFriend = connector.doSelect("name, profile_picture", "users", "id = " + friendId);

            String friendName = "";
            String profilePic = "cpen410/imagesjson/default-profile.png"; // Default profile picture

            if(rsFriend.next()) {
                friendName = rsFriend.getString("name");
                String pic = rsFriend.getString("profile_picture");
                if(pic != null && !pic.trim().isEmpty()) profilePic = pic;
            }

            // Close friend details query and DB connection
            rsFriend.close();
            connector.closeConnection();
%>
          <tr>
            <!-- Show friend's profile picture -->
            <td class="col-3"><img src="<%= request.getContextPath() %>/<%= profilePic %>" width="50" height="50" /></td>
            <!-- Show friendship record ID -->
            <td class="col-2"><%= friendshipId %></td>
            <!-- Show friend's name -->
            <td class="col-4"><%= friendName %></td>
            <!-- Show friendship creation date -->
            <td class="col-3"><%= friendshipDate %></td>
          </tr>
<%
        }
        // Close friendship result set and DAO resources
        rs.close();
        dao.close();
    } catch(Exception e) {
        // Print error message if an exception occurs during friend listing
        out.println("Error listing friends: " + e.getMessage());
        e.printStackTrace();
    }
%>
        </table>
      </div>
    </div>
  </body>
</html>
