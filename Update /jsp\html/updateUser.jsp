<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.nio.file.*, java.util.*, java.nio.charset.StandardCharsets" %>
<%@ page import="jakarta.servlet.http.*, org.apache.commons.fileupload2.jakarta.servlet5.JakartaServletFileUpload, org.apache.commons.fileupload2.core.DiskFileItemFactory, org.apache.commons.fileupload2.core.FileItem" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Update User - minifacebook</title>
  <style>
    /* Basic reset */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: Arial, sans-serif;
      background-color: #f8f9fa;
      color: #333;
      padding: 20px;
      text-align: center;
    }

    .container {
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      max-width: 600px;
      margin: 0 auto;
    }

    a {
      color: #6F4E37;
      font-weight: bold;
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }

    /* Mobile-first layout */
    [class*="col-"] {
      width: 100%;
    }

    /* Responsive grid for tablets and desktops */
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

<div class="container col-12">
<%
  // ============================
  // Session validation
  // ============================
  Long sessionUserId = (Long) session.getAttribute("userId");
  if (sessionUserId == null) {
      response.sendRedirect("loginHashing.html");
      return;
  }
  String userName = (String) session.getAttribute("userName");

  // Ensure request contains multipart/form-data for file upload
  HttpServletRequest req = (HttpServletRequest) request;
  String contentType = req.getContentType();
  if (contentType == null || !contentType.toLowerCase().contains("multipart/form-data")) {
      out.println("<h2>Error: The form must have enctype=multipart/form-data.</h2>");
      return;
  }

  // Variables to store form data
  long userId = 0;
  String name = "";
  String email = "";
  String birthDate = "";
  String gender = "";
  String profilePicturePath = "";

  // Set upload path for profile pictures
  String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
  File uploadDir = new File(uploadPath);
  if (!uploadDir.exists()) {
      uploadDir.mkdirs();
  }

  int maxFileSize = 5000 * 1024; // 5 MB max file size

  // Configure file upload handler
  DiskFileItemFactory factory = DiskFileItemFactory.builder()
                                  .setPath(uploadDir.getAbsolutePath())
                                  .get();
  JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
  upload.setSizeMax(maxFileSize);

  // ============================
  // Process form fields and file upload
  // ============================
  try {
      List<FileItem> items = upload.parseRequest(req);
      for (FileItem item : items) {
          if (item.isFormField()) {
              String fieldName = item.getFieldName();
              String fieldValue = item.getString(StandardCharsets.UTF_8).trim();
              switch (fieldName) {
                  case "id": userId = Long.parseLong(fieldValue); break;
                  case "name": name = fieldValue; break;
                  case "email": email = fieldValue; break;
                  case "birthDate": birthDate = fieldValue; break;
                  case "gender": gender = fieldValue; break;
              }
          } else {
              String fileName = new File(item.getName()).getName();
              if (fileName != null && !fileName.isEmpty()) {
                  String newFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                  Path filePath = FileSystems.getDefault().getPath(uploadPath + newFileName);
                  item.write(filePath);
                  profilePicturePath = "cpen410/imagesjson/" + newFileName;
              }
          }
      }
  } catch (Exception ex) {
      out.println("<h2>Error processing file upload: " + ex.getMessage() + "</h2>");
      ex.printStackTrace();
      return;
  }

  // ============================
  // Update user data in database
  // ============================
  AdminDAO adminDAO = new AdminDAO();
  boolean updated = false;
  try {
      updated = adminDAO.updateUser(userId, name, email, birthDate, gender);
      if (!profilePicturePath.isEmpty()) {
          adminDAO.updateUserProfilePicture(userId, profilePicturePath);
      }
  } catch (Exception e) {
      out.println("<h2>Error updating user: " + e.getMessage() + "</h2>");
      e.printStackTrace();
      adminDAO.close();
      return;
  }
  adminDAO.close();

  // ============================
  // Show result message
  // ============================
  if (updated) {
      out.println("<h2>User updated successfully.</h2>");
      out.println("<p><a href='adminDashboard.jsp'>Back to Dashboard</a></p>");
  } else {
      out.println("<h2>Failed to update user.</h2>");
      out.println("<p><a href='adminDashboard.jsp'>Back to Dashboard</a></p>");
  }
%>
</div>

</body>
</html>
