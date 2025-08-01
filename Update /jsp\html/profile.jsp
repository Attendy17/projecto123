<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.CPEN410.ProfileDAO" %>
<%@ page import="ut.JAR.CPEN410.MySQLCompleteConnector" %>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Profile - minifacebook</title>
  <style>
    /* Reset y base */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: Calibri, sans-serif;
      font-weight: bold;
      background-color: #ffffff;
      color: #333;
      line-height: 1.5;
      min-height: 100vh;
      padding: 20px 0;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    .taskbar {
      background-color: #6F4E37;
      color: #fff;
      width: 100%;
      padding: 12px 20px;
      text-align: center;
      font-size: 1.5rem;
      font-weight: bold;
      margin-bottom: 15px;
    }
    .nav-bar {
      background-color: #6F4E37;
      color: #fff;
      width: 90%;
      max-width: 900px;
      padding: 10px 20px;
      border-radius: 6px;
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
      margin-bottom: 30px;
    }
    .nav-left {
      font-size: 1.1rem;
      flex: 1 1 auto;
    }
    .nav-right {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      flex: 1 1 auto;
      justify-content: flex-end;
    }
    .nav-right a {
      color: #fff;
      text-decoration: none;
      font-weight: bold;
      padding: 6px 14px;
      border-radius: 4px;
      transition: background-color 0.3s ease;
      white-space: nowrap;
    }
    .nav-right a:hover {
      background-color: #8c6d54;
    }
    .profile-container,
    .photo-section {
      background-color: #fff;
      width: 90%;
      max-width: 900px;
      padding: 25px 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      margin-bottom: 30px;
    }
    .row {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
      margin-bottom: 20px;
    }
    [class*="col-"] {
      width: 100%;
      padding: 0 10px;
      box-sizing: border-box;
    }
    @media only screen and (min-width: 600px) {
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
    @media only screen and (min-width: 768px) {
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
    .profile-header img {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      border: 2px solid #ccc;
      object-fit: cover;
      display: block;
      margin: 0 auto;
    }
    .profile-info p {
      color: #555;
      margin-bottom: 10px;
      font-size: 1rem;
    }
    .edit-link {
      text-align: center;
      margin-top: 20px;
    }
    .edit-link a {
      text-decoration: none;
      color: #6F4E37;
      font-weight: bold;
      font-size: 1rem;
    }
    .edit-link a:hover {
      text-decoration: underline;
    }
    .photo-section h2 {
      text-align: center;
      color: #333;
      margin-bottom: 15px;
    }
    .photo-section form {
      text-align: center;
      margin-bottom: 20px;
    }
    .photo-section input[type="file"] {
      padding: 8px;
      width: 70%;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    .photo-section button {
      padding: 8px 16px;
      border: none;
      border-radius: 4px;
      background-color: #6F4E37;
      color: #fff;
      cursor: pointer;
      margin-top: 10px;
    }
    .photo-gallery {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 15px;
    }
    .photo-post {
      margin: 10px;
      text-align: center;
    }
    .photo-post img {
      width: 200px;
      height: auto;
      border-radius: 4px;
      display: block;
      margin: 0 auto;
    }
    .photo-post form {
      margin-top: 5px;
    }
  </style>
</head>
<body>
<%
  Long userId = (Long) session.getAttribute("userId");
  if (userId == null) {
    response.sendRedirect("loginHashing.html");
    return;
  }

  ProfileDAO profileDAO = new ProfileDAO();
  ResultSet rsProfile = profileDAO.getUserProfile(userId);
  String name = "", email = "", profilePicture = "";
  Date birthDate = null;
  if (rsProfile.next()) {
    name = rsProfile.getString("name");
    email = rsProfile.getString("email");
    profilePicture = rsProfile.getString("profile_picture");
    birthDate = rsProfile.getDate("birth_date");
  }
  rsProfile.close();
  profileDAO.close();

  if (profilePicture == null || profilePicture.trim().isEmpty()) {
    profilePicture = "cpen410/imagesjson/default-profile.png";
  }

  MySQLCompleteConnector connector = new MySQLCompleteConnector();
  connector.doConnection();

  ResultSet rsAddress = connector.doSelect("street, town, state, country", "addresses", "user_id = " + userId);
  String street = "", town = "", state = "", country = "";
  if (rsAddress.next()) {
    street = rsAddress.getString("street");
    town = rsAddress.getString("town");
    state = rsAddress.getString("state");
    country = rsAddress.getString("country");
  }
  rsAddress.close();

  ResultSet rsEdu = connector.doSelect("degree, school", "education", "user_id = " + userId);
  String degree = "", school = "";
  if (rsEdu.next()) {
    degree = rsEdu.getString("degree");
    school = rsEdu.getString("school");
  }
  rsEdu.close();

  connector.closeConnection();
%>

<div class="taskbar">
  minifacebook
</div>

<div class="nav-bar">
  <div class="nav-left">Welcome, <%= name %>!</div>
  <div class="nav-right">
    <a href="welcomeMenu.jsp">Home</a>
    <a href="searchFriends.jsp">Search Friends</a>
    <a href="friendList.jsp">Friend List</a>
    <a href="signout.jsp">Sign Out</a>
  </div>
</div>

<div class="profile-container">
  <div class="row">
    <div class="col-4">
      <div class="profile-header">
        <img src="<%= request.getContextPath() + "/" + profilePicture %>" alt="Profile Picture" />
      </div>
    </div>
    <div class="col-8">
      <h2><%= name %></h2>
      <div class="profile-info">
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Birth Date:</strong> <%= (birthDate != null) ? birthDate.toString() : "N/A" %></p>
        <p><strong>Address:</strong>
          <%= street %>
          <%= (town != null && !town.isEmpty()) ? ", " + town : "" %>
          <%= (state != null && !state.isEmpty()) ? ", " + state : "" %>
          <%= (country != null && !country.isEmpty()) ? ", " + country : "" %>
        </p>
        <p><strong>Education:</strong>
          <%= degree %>
          <%= (school != null && !school.isEmpty()) ? " - " + school : "" %>
        </p>
      </div>
      <div class="edit-link">
        <a href="editProfile.jsp">Edit Profile</a>
      </div>
    </div>
  </div>
</div>

<div class="photo-section">
  <h2>My Photo Posts</h2>
  <form action="uploadPhoto.jsp" method="post" enctype="multipart/form-data">
    <input type="file" id="photoFile" name="photoFile" accept="image/*" required />
    <button type="submit">Publish Photo</button>
  </form>

  <div class="photo-gallery">
    <%
      ProfileDAO photoDAO = new ProfileDAO();
      ResultSet rsPhotos = photoDAO.getUserPhotos(userId);
      while (rsPhotos.next()) {
        String imageURL = rsPhotos.getString("image_url");
        long photoId = rsPhotos.getLong("id");
    %>
    <div class="photo-post col-3">
      <img src="<%= request.getContextPath() + "/" + imageURL %>" alt="Photo Post" />
      <form action="deletePhoto.jsp" method="post" onsubmit="return confirm('Are you sure you want to delete this photo?');">
        <input type="hidden" name="photoId" value="<%= photoId %>" />
        <button type="submit">Delete</button>
      </form>
    </div>
    <%
      }
      rsPhotos.close();
      photoDAO.close();
    %>
  </div>
</div>

</body>
</html>
