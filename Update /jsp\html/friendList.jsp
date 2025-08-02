<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %>
<%@ page import="ut.JAR.CPEN410.MySQLCompleteConnector" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Friends - minifacebook</title>
    <!-- Prevent browser caching -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <style>
        /* CSS Reset */
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

        /* Mobile-first layout for grid columns */
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

        /* Top bar with app name */
        .taskbar {
            background-color: #333;
            color: #fff;
            padding: 10px 20px;
            text-align: center;
        }

        /* Navigation bar styles */
        .nav-bar {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            padding: 10px 20px;
        }

        /* Left section of navbar (welcome text) */
        .nav-left {
            color: #fff;
            font-size: 18px;
        }

        /* Right section of navbar (links) */
        .nav-right {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

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

        /* Main container for the content */
        .container {
            width: 90%;
            max-width: 1000px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        /* Section titles */
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        /* Table styling for friends list */
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

        /* Friend's profile picture */
        img {
            border-radius: 50%;
            object-fit: cover;
        }

        /* Responsive navbar for mobile */
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
    // ==============================
    // Session verification (exact as reference)
    // ==============================
    Long userId = (Long) session.getAttribute("userId");

    if(userId == null) {
        // Redirect to login page if not logged in
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Retrieve the logged-in user's name
    String userName = (String) session.getAttribute("userName");
%>

    <!-- Top taskbar with app name -->
    <div class="taskbar">
        <h1>minifacebook</h1>
    </div>

    <!-- Navigation bar with welcome text and menu links -->
    <div class="nav-bar">
        <div class="nav-left">Welcome, <%= userName %>!</div>
        <div class="nav-right">
            <a href="welcomeMenu.jsp">Home</a>
            <a href="profile.jsp">Profile</a>
            <a href="searchFriends.jsp">Search Friends</a>
            <a href="signout.jsp">Sign Out</a>
        </div>
    </div>

    <!-- Container for the friends list -->
    <div class="container col-12">
        <h1>My Friends</h1>
<%
    // Create DAO object to retrieve friendships
    FriendshipDAO dao = new FriendshipDAO();
    try {
        // Get list of friends for current user
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
        // Loop through each friend in the list
        while(rs.next()) {
            // Retrieve friendship data
            long friendshipId = rs.getLong("id");
            long user1 = rs.getLong("user1_id");
            long user2 = rs.getLong("user2_id");
            Timestamp createdAt = rs.getTimestamp("created_at");

            // Determine friend's user ID
            long friendId = (user1 == userId) ? user2 : user1;

            // Format friendship creation date
            String friendshipDate = (createdAt != null) ? createdAt.toLocalDateTime().toLocalDate().toString() : "";

            // Query friend details from database
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

            // Close friend's result set and DB connection
            rsFriend.close();
            connector.closeConnection();
%>
                <!-- Friend row in the table -->
                <tr>
                    <td class="col-3"><img src="<%= request.getContextPath() %>/<%= profilePic %>" width="50" height="50" /></td>
                    <td class="col-2"><%= friendshipId %></td>
                    <td class="col-4"><%= friendName %></td>
                    <td class="col-3"><%= friendshipDate %></td>
                </tr>
<%
        }
        // Close main result set and DAO
        rs.close();
        dao.close();
    } catch(Exception e) {
        // Show error if fetching friends fails
        out.println("Error listing friends: " + e.getMessage());
        e.printStackTrace();
    }
%>
            </table>
        </div>
    </div>
</body>
</html>
