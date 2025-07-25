<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %>
<%@ page import="ut.JAR.CPEN410.MySQLCompleteConnector" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Mis Amigos - minifacebook</title>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
      }
      .taskbar {
        background-color: #6F4E37;
        color: #fff;
        padding: 10px 20px;
        text-align: center;
      }
      .nav-bar {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
        background-color: #6F4E37;
        padding: 10px 20px;
      }
      .nav-left {
        color: #fff;
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 10px;
      }
      .nav-right {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
      }
      .nav-right a {
        color: #fff;
        text-decoration: none;
        font-weight: bold;
        padding: 6px 12px;
        border-radius: 4px;
        transition: background-color 0.3s ease;
        background-color: transparent;
      }
      .nav-right a:hover {
        background-color: #8c6d54;
      }
      .container {
        width: 90%;
        max-width: 800px;
        margin: 20px auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }
      h1 {
        color: #333;
        text-align: center;
        margin-bottom: 20px;
      }
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        overflow-x: auto;
      }
      th, td {
        padding: 8px;
        border: 1px solid #ddd;
        text-align: left;
      }
      th {
        background-color: #6F4E37;
        color: #fff;
      }
      img {
        border-radius: 50%;
        object-fit: cover;
      }
      @media only screen and (max-width: 600px) {
        .nav-bar {
          flex-direction: column;
          align-items: flex-start;
        }
        .nav-right {
          flex-direction: column;
          width: 100%;
        }
        .nav-right a {
          margin-left: 0;
          width: 100%;
          text-align: left;
        }
      }
      @media only screen and (min-width: 600px) {
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
    </style>
  </head>
  <body>
<%
    Long userId = (Long) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    if (userId == null || userName == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }
%>
    <div class="taskbar">
      <h1>minifacebook</h1>
    </div>
    <div class="nav-bar">
      <div class="nav-left">
        Welcome, <%= userName %>!
      </div>
      <div class="nav-right">
        <a href="welcomeMenu.jsp">Home</a>
        <a href="profile.jsp">Profile</a>
        <a href="searchFriends.jsp">Search Friends</a>
        <a href="signout.jsp">Sign Out</a>
      </div>
    </div>
    <div class="container">
      <h1>Mis Amigos</h1>
<%
    FriendshipDAO dao = new FriendshipDAO();
    try {
        ResultSet rs = dao.listFriends(userId);
%>
      <table>
        <tr>
          <th>Profile Picture</th>
          <th>ID Amistad</th>
          <th>Nombre Amigo</th>
          <th>Fecha de Amistad</th>
        </tr>
<%
        while(rs.next()) {
            long friendshipId = rs.getLong("id");
            long user1 = rs.getLong("user1_id");
            long user2 = rs.getLong("user2_id");
            Timestamp createdAt = rs.getTimestamp("created_at");
            long friendId = (user1 == userId) ? user2 : user1;
            String fechaAmistad = "";
            if (createdAt != null) {
                fechaAmistad = createdAt.toLocalDateTime().toLocalDate().toString();
            }
            MySQLCompleteConnector connector = new MySQLCompleteConnector();
            connector.doConnection();
            ResultSet rsFriend = connector.doSelect("name, profile_picture", "users", "id = " + friendId);
            String friendName = "";
            String profilePic = "";
            if(rsFriend.next()){
                friendName = rsFriend.getString("name");
                profilePic = rsFriend.getString("profile_picture");
            }
            rsFriend.close();
            connector.closeConnection();
            if(profilePic == null || profilePic.trim().isEmpty()){
                profilePic = "cpen410/imagesjson/default-profile.png";
            }
%>
        <tr>
          <td><img src="<%= request.getContextPath() %>/<%= profilePic %>" alt="Profile Picture" width="50" height="50"/></td>
          <td><%= friendshipId %></td>
          <td><%= friendName %></td>
          <td><%= fechaAmistad %></td>
        </tr>
<%
        }
        rs.close();
        dao.close();
    } catch(Exception e) {
        out.println("Error al listar amigos: " + e.getMessage());
        e.printStackTrace();
    }
%>
      </table>
    </div>
  </body>
</html>
