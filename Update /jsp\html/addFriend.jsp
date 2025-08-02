<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %> <!-- Import the DAO class to manage friend requests -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send Friend Request - MiniFacebook</title>
    <style>
        /* Basic styling and responsive layout setup */
        * {
            box-sizing: border-box;
        }
        .row::after {
            content: "";
            clear: both;
            display: table;
        }
        [class*="col-"] {
            float: left;
            padding: 15px;
        }
        html {
            font-family: 'Calibri', sans-serif;
            font-weight: bold;
        }
        .header {
            background-color: #444;
            color: #fff;
            padding: 20px;
            text-align: center;
        }
        .footer {
            background-color: #777;
            color: #fff;
            text-align: center;
            font-size: 14px;
            padding: 15px;
            margin-top: 40px;
        }
        .content {
            background-color: #f4f4f4;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
        }
        a {
            text-decoration: none;
            color: #2b2b2b;
            font-weight: bold;
        }
        a:hover {
            color: #555;
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
    // User verification - identical to reference code
    Long userId = (Long) session.getAttribute("userId");

    if(userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    String userName = (String) session.getAttribute("userName");
%>

<!-- Page header -->
<div class="header">
    <h1>MiniFacebook</h1>
</div>

<!-- Centered content layout using responsive grid -->
<div class="row">
    <div class="col-3"></div>
    <div class="col-6">
        <div class="content">

        <%
            // Get the friendId from the request (sent from previous page/form)
            String friendIdStr = request.getParameter("friendId");

            // Validate that the friend ID is present
            if (friendIdStr == null || friendIdStr.trim().isEmpty()) {
                out.println("<h2>No friend ID specified.</h2>");
                return;
            }

            // Convert friendId from String to long
            long friendId = Long.parseLong(friendIdStr);

            // Create instance of DAO to handle friend request operation
            FriendshipDAO dao = new FriendshipDAO();

            try {
                // Attempt to send friend request
                boolean success = dao.sendFriendRequest(userId, friendId);
                dao.close(); // Close database connection

                // Display appropriate message depending on outcome
                if (success) {
                    out.println("<h2>Friend request sent successfully.</h2>");
                } else {
                    out.println("<h2>Friend request already exists or could not be sent.</h2>");
                }
            } catch(Exception e) {
                // Handle errors and print details
                out.println("<h2>Error sending friend request: " + e.getMessage() + "</h2>");
                e.printStackTrace();
            }
        %>

        <!-- Link to return to friend search page -->
        <br><br>
        <a href="searchFriends.jsp">← Back to search friends</a>
        </div>
    </div>
    <div class="col-3"></div>
</div>

<!-- Page footer -->
<div class="footer">
    <p>MiniFacebook &copy; 2025</p>
</div>

</body>
</html>
