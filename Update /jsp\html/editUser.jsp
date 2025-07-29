<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Date" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit User - minifacebook</title>
  <style>
    /* Basic CSS reset and styling */
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

    /* Styling for the top taskbar */
    .taskbar {
      background-color: #555555;
      color: #fff;
      padding: 10px 20px;
      text-align: center;
      margin-bottom: 20px;
    }

    /* Navigation bar container styles */
    .nav-bar {
      display: flex;
      flex-direction: column;
      background-color: #555555;
      padding: 10px 20px;
      margin-bottom: 20px;
    }

    /* Left side of nav bar: title */
    .nav-left {
      color: #fff;
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 10px;
    }

    /* Right side of nav bar: links */
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

    /* Main container for form and content */
    .container {
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      margin: 0 auto;
      width: 100%;
    }

    /* Form group styling */
    .form-group {
      margin-bottom: 15px;
    }

    .form-group label {
      font-weight: bold;
      color: #555;
      display: block;
      margin-bottom: 5px;
    }

    /* Inputs and selects styling */
    .form-group input,
    .form-group select {
      width: 100%;
      padding: 10px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    /* Form buttons container */
    .form-buttons {
      margin-top: 20px;
      display: flex;
      justify-content: center;
    }

    /* Submit button styling */
    .form-buttons input {
      background-color: #555555;
      color: #fff;
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    /* Photo gallery layout */
    .photo-gallery {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
    }

    /* Individual photo post styling */
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

    /* Responsive columns for tablets and larger screens */
    @media only screen and (min-width: 600px) {
      .nav-bar {
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
      }

      .photo-post {
        width: 45%;
      }
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
  // Retrieve the logged-in user object from session
  Object user = session.getAttribute("user");
  
  // If no user logged in, redirect to login page
  if (user == null) {
    response.sendRedirect("loginHashing.html");
    return;
  }

  // Get the role of the logged-in user
  String role = (String) session.getAttribute("role");
  
  // Verify if the user is an admin; if not, show access denied message
  if (role == null || !role.equalsIgnoreCase("admin")) {
    out.println("<h2>Access denied: You do not have permission to edit users.</h2>");
    return;
  }

  // Get the user ID to edit from request parameter
  String idParam = request.getParameter("id");
  
  // If no ID provided, show error message and stop
  if (idParam == null || idParam.trim().isEmpty()) {
    out.println("<h2>Error: No user ID provided.</h2>");
    return;
  }

  // Parse user ID to long
  long userIdToEdit = Long.parseLong(idParam.trim());

  // Create AdminDAO instance to interact with DB
  AdminDAO adminDAO = new AdminDAO();

  // Query the database for user details by ID
  ResultSet rs = adminDAO.getUserById(userIdToEdit);
  
  // If no user found with the given ID, display error and stop
  if (!rs.next()) {
    out.println("<h2>Error: User not found.</h2>");
    rs.close();
    adminDAO.close();
    return;
  }

  // Retrieve user information from result set
  String name = rs.getString("name");
  String email = rs.getString("email");
  Date birthDate = rs.getDate("birth_date");
  String gender = rs.getString("gender");

  // Close ResultSet and DAO to free resources
  rs.close();
  adminDAO.close();
%>

  <!-- Top taskbar with site title -->
  <div class="taskbar">
    <h1>minifacebook</h1>
  </div>

  <!-- Navigation bar with dashboard and sign out links -->
  <div class="nav-bar">
    <div class="nav-left">Edit User - Admin Panel</div>
    <div class="nav-right">
      <a href="adminDashboard.jsp">Dashboard</a>
      <a href="signout.jsp">Sign Out</a>
    </div>
  </div>

  <!-- User edit form pre-filled with existing data -->
  <div class="container col-12">
    <h2>Edit User</h2>
    <form action="updateUser.jsp" method="post" enctype="multipart/form-data">
      <!-- Hidden input to keep track of user ID -->
      <input type="hidden" name="id" value="<%= userIdToEdit %>" />

      <!-- Name input field -->
      <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= name %>" required />
      </div>

      <!-- Email input field -->
      <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= email %>" required />
      </div>

      <!-- Birth date input field -->
      <div class="form-group">
        <label for="birthDate">Birth Date:</label>
        <input type="date" id="birthDate" name="birthDate" value="<%= (birthDate != null) ? birthDate.toString() : "" %>" required />
      </div>

      <!-- Gender select dropdown -->
      <div class="form-group">
        <label for="gender">Gender:</label>
        <select id="gender" name="gender" required>
          <option value="Male" <%= "Male".equalsIgnoreCase(gender) ? "selected" : "" %>>Male</option>
          <option value="Female" <%= "Female".equalsIgnoreCase(gender) ? "selected" : "" %>>Female</option>
          <option value="Other" <%= "Other".equalsIgnoreCase(gender) ? "selected" : "" %>>Other</option>
        </select>
      </div>

      <!-- Profile picture upload -->
      <div class="form-group">
        <label for="profilePicture">Profile Picture (Upload):</label>
        <input type="file" id="profilePicture" name="profilePicture" accept="image/*" />
      </div>

      <!-- Submit button -->
      <div class="form-buttons">
        <input type="submit" value="Update User" />
      </div>
    </form>
  </div>

  <!-- Section to show user's photo posts with delete option -->
  <div class="container col-12" style="margin-top: 20px;">
    <h2>User Photo Posts</h2>
    <div class="photo-gallery">
<%
  // Create new AdminDAO instance for fetching user's photos
  AdminDAO adminDAOPhotos = new AdminDAO();
  
  // Retrieve user's photos from database
  ResultSet rsPhotos = adminDAOPhotos.getUserPhotos(userIdToEdit);

  // Loop through each photo record and display
  while (rsPhotos.next()) {
    String imageURL = rsPhotos.getString("image_url");
    long photoId = rsPhotos.getLong("id");
%>
      <div class="photo-post col-4">
        <!-- Display photo -->
        <img src="/<%= imageURL %>" alt="Photo Post" />
        
        <!-- Form to delete photo -->
        <form action="deletePhoto
