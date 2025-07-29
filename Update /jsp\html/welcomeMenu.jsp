<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.CPEN410.ProfileDAO" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<html>
  <head>
    <meta charset="UTF-8">
    <title>Welcome Menu - minifacebook</title>
    <style>
      /* Reset default margin, padding and use border-box for sizing */
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      /* Basic body styles: font and background */
      body {
        font-family: Arial, sans-serif;
        font-size: 14px;
        background-color: #f8f9fa;
      }

      /* Top taskbar with background color, white text and padding */
      .taskbar {
        background-color: #6F4E37;
        color: #fff;
        padding: 10px 20px;
        text-align: center;
      }

      /* Navigation bar container styles */
      .nav-bar {
        background-color: #6F4E37;
        padding: 10px 20px;
        display: flex;
        flex-direction: column;
        gap: 10px;
      }

      /* Styling for the user greeting */
      .nav-user {
        color: #fff;
        font-weight: bold;
      }

      /* Navigation links container with vertical layout and spacing */
      .nav-links {
        display: flex;
        flex-direction: column;
        gap: 10px;
      }

      /* Navigation links style: white text, no underline, bold, padding, rounded corners */
      .nav-links a {
        color: #fff;
        text-decoration: none;
        font-weight: bold;
        font-size: 14px;
        padding: 6px 10px;
        border-radius: 4px;
        transition: background-color 0.3s ease;
      }

      /* Hover effect for navigation links */
      .nav-links a:hover {
        background-color: #8c6d54;
      }

      /* Container for friend photo posts: flex wrap with centered alignment */
      .friend-gallery {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        padding: 20px;
        gap: 20px;
      }

      /* Each friend photo container: full width on small screens */
      .friend-photo {
        flex: 1 1 100%;
        max-width: 100%;
        text-align: center;
      }

      /* Image styling with max width and rounded corners */
      .friend-photo img {
        width: 100%;
        max-width: 200px;
        height: auto;
        border-radius: 4px;
      }

      /* Caption styling under each photo */
      .friend-photo p {
        margin-top: 5px;
        color: #333;
      }

      /* Responsive columns for tablets and above */
      @media screen and (min-width: 600px) {
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

      /* Layout adjustments for desktops and larger screens */
      @media screen and (min-width: 768px) {
        /* Nav bar switches to horizontal layout */
        .nav-bar {
          flex-direction: row;
          justify-content: space-between;
          align-items: center;
        }

        /* Navigation links become horizontal and wrap */
        .nav-links {
          flex-direction: row;
          flex-wrap: wrap;
        }

        /* Friend photo containers take approx 30% width each */
        .friend-photo {
          flex: 1 1 30%;
          max-width: 30%;
        }
      }
    </style>
  </head>
  <body>
<%
    // Retrieve logged-in user's ID from the session
    Long userId = (Long) session.getAttribute("userId");

    // If user is not logged in, redirect to login page
    if(userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Get user's display name from session to greet
    String userName = (String) session.getAttribute("userName");
%>
    <!-- Top navigation bar with welcome message and links -->
    <div class="taskbar">
      <h1>minifacebook</h1>
    </div>

    <div class="nav-bar">
      <div class="nav-user">Welcome, <%= userName %>!</div>
      <div class="nav-links">
        <a href="profile.jsp">Profile</a>
        <a href="searchFriends.jsp">Search Friends</a>
        <a href="friendList.jsp">Friend List</a>
        <a href="friendRequests.jsp">Friend Requests</a>
        <a href="signout.jsp">Sign Out</a>
      </div>
    </div>

    <!-- Section title -->
    <div class="col-12" style="text-align:center; margin-top:20px;">
      <h2>Friend Photo Posts</h2>
    </div>

    <!-- Gallery container for friend photos -->
    <div class="friend-gallery">
<%
    // Create a ProfileDAO instance to fetch friend photos
    ProfileDAO dao = new ProfileDAO();

    // Get ResultSet of friend photo posts for this user
    ResultSet rsFriendPhotos = dao.getFriendPhotos(userId);

    // Loop through each photo record
    while(rsFriendPhotos.next()){
        String friendPhotoURL = rsFriendPhotos.getString("image_url");
        String friendName = rsFriendPhotos.getString("name");
%>
      <!-- Single friend photo card -->
      <div class="friend-photo col-4">
        <img src="/<%= friendPhotoURL %>" alt="Photo by <%= friendName %>">
        <p><%= friendName %></p>
      </div>
<%
    }
    // Close ResultSet and DAO resources
    rsFriendPhotos.close();
    dao.close();
%>
    </div>
  </body>
</html>
