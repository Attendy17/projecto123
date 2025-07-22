<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Edit Profile - minifacebook</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      .container {
        width: 90%;
        max-width: 600px;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }

      h2 {
        text-align: center;
        color: #333;
        margin-bottom: 20px;
      }

      .form-group {
        margin-bottom: 15px;
      }

      .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
        color: #555;
      }

      .form-group input,
      .form-group select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
      }

      .form-buttons {
        text-align: right;
        margin-top: 20px;
      }

      .form-buttons input[type="submit"] {
        background-color: #6F4E37;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        transition: 0.3s;
      }

      
      .form-buttons input[type="submit"]:hover {
        background-color: #605e5e;
        color: lch(64.36% 0.01 296.81);
      }

      /* Column system */
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
    if(userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }
%>
    <div class="container">
      <h2>Edit Profile</h2>
      <form action="processProfile.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="userId" value="<%= userId %>">

        <div class="form-group">
          <label for="profilePicture">Profile Picture (Upload):</label>
          <input type="file" id="profilePicture" name="profilePicture" accept="image/*">
        </div>

        <div class="form-group">
          <label for="degree">Degree:</label>
          <input type="text" id="degree" name="degree">
        </div>

        <div class="form-group">
          <label for="school">School:</label>
          <input type="text" id="school" name="school">
        </div>

        <div class="form-group">
          <label for="street">Street:</label>
          <input type="text" id="street" name="street">
        </div>

        <div class="form-group">
          <label for="town">Town:</label>
          <input type="text" id="town" name="town">
        </div>

        <div class="form-group">
          <label for="state">State:</label>
          <input type="text" id="state" name="state">
        </div>

        <div class="form-group">
          <label for="country">Country:</label>
          <input type="text" id="country" name="country">
        </div>

        <div class="form-buttons">
          <input type="submit" value="Save Changes">
        </div>
      </form>
    </div>
  </body>
</html>
