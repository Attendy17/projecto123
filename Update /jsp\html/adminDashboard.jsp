<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Date" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - minifacebook</title>
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
        font-family: Calibri, sans-serif;
        background-color: #f8f9fa;
        padding: 20px;
        font-size: 14px;
      }
      .taskbar {
        background-color: #555555;
        color: #fff;
        padding: 10px 20px;
        text-align: center;
        margin-bottom: 20px;
      }
      .nav-bar {
        display: flex;
        flex-direction: column;
        background-color: #555555;
        padding: 10px 20px;
        gap: 10px;
        margin-bottom: 20px;
      }
      .nav-left {
        color: #fff;
        font-size: 18px;
        font-weight: bold;
      }
      .nav-right {
        display: flex;
        flex-direction: column;
        gap: 10px;
      }
      .nav-right a {
        color: #fff;
        text-decoration: none;
        font-weight: bold;
        padding: 6px 10px;
        border-radius: 4px;
        transition: background-color 0.3s ease;
      }
      .nav-right a:hover {
        background-color: #777;
      }
      .container {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        overflow-x: auto;
      }
      h2 {
        text-align: center;
        color: #333;
        margin-bottom: 15px;
      }
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
      }
      th, td {
        padding: 8px;
        border: 1px solid #ddd;
        text-align: left;
      }
      th {
        background-color: #555555;
        color: #fff;
      }
      td {
        color: #333;
      }
      img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
      }
      a.button {
        color: #555555;
        font-weight: bold;
        text-decoration: none;
      }

      /* Responsive columns for 600px (tablet) */
      @media screen and (min-width: 600px) {
        .nav-bar {
          flex-direction: row;
          justify-content: space-between;
          align-items: center;
        }
        .nav-right {
          flex-direction: row;
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
      }

      @media screen and (min-width: 768px) {
        .nav-right a {
          font-size: 15px;
        }
      }
    </style>
  </head>
  <body>
<%
    Long userId = (Long) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");

    if(userId == null || role == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(role)) {
        out.println("<h2>Access Denied: You do not have administrator privileges.</h2>");
        return;
    }

    AdminDAO adminDAO = new AdminDAO();
    ResultSet rs = adminDAO.listUsers();
%>
    <div class="taskbar">
      <h1>minifacebook</h1>
    </div>

    <div class="nav-bar">
      <div class="nav-left col-4">Admin Dashboard</div>
      <div class="nav-right col-8">
        <a href="welcomeMenu.jsp">Home</a>
        <a href="signout.jsp">Sign Out</a>
      </div>
    </div>

    <div class="container">
      <h2>List of Users</h2>
      <table>
        <tr>
          <th class="col-1">ID</th>
          <th class="col-2">Name</th>
          <th class="col-3">Email</th>
          <th class="col-2">Birth Date</th>
          <th class="col-2">Gender</th>
          <th class="col-1">Profile Picture</th>
          <th class="col-1">Actions</th>
        </tr>
<%
    while(rs.next()){
        long id = rs.getLong("id");
        String nameUser = rs.getString("name");
        String emailUser = rs.getString("email");
        Date birthDate = rs.getDate("birth_date");
        String genderUser = rs.getString("gender");
        String profilePicture = rs.getString("profile_picture");
        if(profilePicture == null || profilePicture.trim().isEmpty()){
            profilePicture = "cpen410/imagesjson/default-profile.png";
        }
%>
        <tr>
          <td><%= id %></td>
          <td><%= nameUser %></td>
          <td><%= emailUser %></td>
          <td><%= birthDate %></td>
          <td><%= genderUser %></td>
          <td><img src="<%= request.getContextPath() %>/<%= profilePicture %>" alt="Profile Picture"/></td>
          <td>
            <a class="button" href="editUser.jsp?id=<%= id %>">Edit</a> |
            <a class="button" href="deleteUser.jsp?id=<%= id %>" onclick="return confirm('Are you sure?');">Delete</a>
          </td>
        </tr>
<%
    }
    rs.close();
    adminDAO.close();
%>
      </table>
      <p style="text-align:center; margin-top: 15px;">
        <a class="button" href="addUserAdmin.jsp">Add New User</a>
      </p>
    </div>
  </body>
</html>
