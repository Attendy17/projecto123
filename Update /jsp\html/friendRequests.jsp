<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.FriendshipDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Friend Requests - minifacebook</title>
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
        flex-direction: column;
        gap: 10px;
        background-color: #6F4E37;
        padding: 10px 20px;
      }

      .nav-left {
        color: #fff;
        font-size: 18px;
        font-weight: bold;
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
      }

      .nav-right a:hover {
        text-decoration: underline;
      }

      .container {
        background-color: #fff;
        padding: 20px;
        margin: 20px auto;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        width: 90%;
        max-width: 800px;
      }

      h2 {
        text-align: center;
        color: #333;
        margin-bottom: 20px;
      }

      table {
        width: 100%;
        border-collapse: collapse;
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

      td a {
        color: #6F4E37;
        font-weight: bold;
        text-decoration: none;
      }

      td a:hover {
        text-decoration: underline;
      }

      /* Column classes for tablet */
      @media screen and (min-width: 600px) {
        .col-1  { width: 8.33%; }
        .col-2  { width: 16.66%; }
        .col-3  { width: 25%; }
        .col-4  { width: 33.33%; }
        .col-5  { width: 41.66%; }
        .col-6  { width: 50%; }
        .col-7  { width: 58.33%; }
        .col-8  { width: 66.66%; }
        .col-9  { width: 75%; }
        .col-10 { width: 83.33%; }
        .col-11 { width: 91.66%; }
        .col-12 { width: 100%; }

        .nav-bar {
          flex-direction: row;
          justify-content: space-between;
          align-items: center;
        }
      }

      /* Column classes for desktop */
      @media screen and (min-width: 768px) {
        .col-1  { width: 8.33%; }
        .col-2  { width: 16.66%; }
        .col-3  { width: 25%; }
        .col-4  { width: 33.33%; }
        .col-5  { width: 41.66%; }
        .col-6  { width: 50%; }
        .col-7  { width: 58.33%; }
        .col-8  { width: 66.66%; }
        .col-9  { width: 75%; }
        .col-10 { width: 83.33%; }
        .col-11 { width: 91.66%; }
        .col-12 { width: 100%; }
      }
    </style>
    <script>
      window.onpageshow = function(event) {
        if (event.persisted) {
          window.location.reload();
        }
      };
    </script>
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
      <div class="nav-left">Welcome, <%= userName %>!</div>
      <div class="nav-right">
        <a href="welcomeMenu.jsp">Home</a>
        <a href="profile.jsp">Profile</a>
        <a href="searchFriends.jsp">Search Friends</a>
        <a href="friendList.jsp">Friend List</a>
        <a href="signout.jsp">Sign Out</a>
      </div>
    </div>

    <div class="container col-12">
      <h2>Incoming Friend Requests</h2>
<%
    FriendshipDAO dao = new FriendshipDAO();
    ResultSet rs = null;
    try {
        rs = dao.listIncomingRequests(userId);
        boolean hasRequests = false;
%>
      <table>
        <tr>
          <th>ID Request</th>
          <th>Sender</th>
          <th>Date</th>
          <th>Action</th>
        </tr>
<%
        while(rs.next()){
            hasRequests = true;
            long requestId = rs.getLong("id");
            String senderName = rs.getString("senderName");
            Timestamp createdAt = rs.getTimestamp("created_at");
%>
        <tr>
          <td><%= requestId %></td>
          <td><%= senderName %></td>
          <td><%= createdAt %></td>
          <td>
            <a href="handleRequest.jsp?action=accept&friendshipId=<%= requestId %>">Accept</a>
          </td>
        </tr>
<%
        }
        rs.close();
        dao.close();
        if (!hasRequests) {
%>
        <tr>
          <td colspan="4" style="text-align:center;">No incoming friend requests.</td>
        </tr>
<%
        }
    } catch(Exception e) {
        out.println("<p>Error loading friend requests: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
      </table>
    </div>
  </body>
</html>
