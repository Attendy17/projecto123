<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Date" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit User - minifacebook</title>
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
      margin-bottom: 20px;
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
    }

    .nav-right a:hover {
      text-decoration: underline;
    }

    .container {
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      margin: 0 auto;
      width: 100%;
    }

    .form-group {
      margin-bottom: 15px;
    }

    .form-group label {
      font-weight: bold;
      color: #555;
      display: block;
      margin-bottom: 5px;
    }

    .form-group input,
    .form-group select {
      width: 100%;
      padding: 10px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    .form-buttons {
      margin-top: 20px;
      display: flex;
      justify-content: center;
    }

    .form-buttons input {
      background-color: #555555;
      color: #fff;
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .photo-gallery {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
    }

    .photo-post {
      text-align: center;
      width: 100%;
    }

    .photo-post img {
      width: 100%;
      max-width: 200px;
      border-radius: 4px;
    }

    .photo-post button {
      background-color: #555555;
      color: #fff;
      border: none;
      padding: 6px 12px;
      border-radius: 4px;
      cursor: pointer;
      margin-top: 8px;
    }

    .photo-post button:hover {
      background-color: #444;
    }

    /* Columnas */
    @media only screen and (min-width: 600px) {
      .nav-bar {
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
      }

      .photo-post {
        width: 45%;
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

    @media only screen and (min-width: 768px) {
      .photo-post {
        width: 30%;
      }
    }
  </style>
</head>
<body>
<%
  Object user = session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("loginHashing.html");
    return;
  }

  String role = (String) session.getAttribute("role");
  if (role == null || !role.equalsIgnoreCase("admin")) {
    out.println("<h2>Access denied: You do not have permission to edit users.</h2>");
    return;
  }

  String idParam = request.getParameter("id");
  if (idParam == null || idParam.trim().isEmpty()) {
    out.println("<h2>Error: No user ID provided.</h2>");
    return;
  }

  long userIdToEdit = Long.parseLong(idParam.trim());
  AdminDAO adminDAO = new AdminDAO();
  ResultSet rs = adminDAO.getUserById(userIdToEdit);
  if (!rs.next()) {
    out.println("<h2>Error: User not found.</h2>");
    rs.close();
    adminDAO.close();
    return;
  }

  String name = rs.getString("name");
  String email = rs.getString("email");
  Date birthDate = rs.getDate("birth_date");
  String gender = rs.getString("gender");
  rs.close();
  adminDAO.close();
%>

  <div class="taskbar">
    <h1>minifacebook</h1>
  </div>

  <div class="nav-bar">
    <div class="nav-left">Edit User - Admin Panel</div>
    <div class="nav-right">
      <a href="adminDashboard.jsp">Dashboard</a>
      <a href="signout.jsp">Sign Out</a>
    </div>
  </div>

  <div class="container col-12">
    <h2>Edit User</h2>
    <form action="updateUser.jsp" method="post" enctype="multipart/form-data">
      <input type="hidden" name="id" value="<%= userIdToEdit %>" />
      <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= name %>" required />
      </div>
      <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= email %>" required />
      </div>
      <div class="form-group">
        <label for="birthDate">Birth Date:</label>
        <input type="date" id="birthDate" name="birthDate" value="<%= (birthDate != null) ? birthDate.toString() : "" %>" required />
      </div>
      <div class="form-group">
        <label for="gender">Gender:</label>
        <select id="gender" name="gender" required>
          <option value="Male" <%= "Male".equalsIgnoreCase(gender) ? "selected" : "" %>>Male</option>
          <option value="Female" <%= "Female".equalsIgnoreCase(gender) ? "selected" : "" %>>Female</option>
          <option value="Other" <%= "Other".equalsIgnoreCase(gender) ? "selected" : "" %>>Other</option>
        </select>
      </div>
      <div class="form-group">
        <label for="profilePicture">Profile Picture (Upload):</label>
        <input type="file" id="profilePicture" name="profilePicture" accept="image/*" />
      </div>
      <div class="form-buttons">
        <input type="submit" value="Update User" />
      </div>
    </form>
  </div>

  <div class="container col-12" style="margin-top: 20px;">
    <h2>User Photo Posts</h2>
    <div class="photo-gallery">
<%
  AdminDAO adminDAOPhotos = new AdminDAO();
  ResultSet rsPhotos = adminDAOPhotos.getUserPhotos(userIdToEdit);
  while (rsPhotos.next()) {
    String imageURL = rsPhotos.getString("image_url");
    long photoId = rsPhotos.getLong("id");
%>
      <div class="photo-post col-4">
        <img src="/<%= imageURL %>" alt="Photo Post" />
        <form action="deletePhotoAdmin.jsp" method="post" onsubmit="return confirm('Are you sure you want to delete this photo?');">
          <input type="hidden" name="photoId" value="<%= photoId %>" />
          <input type="hidden" name="userId" value="<%= userIdToEdit %>" />
          <button type="submit">Delete</button>
        </form>
      </div>
<%
  }
  rsPhotos.close();
  adminDAOPhotos.close();
%>
    </div>
  </div>
</body>
</html>

