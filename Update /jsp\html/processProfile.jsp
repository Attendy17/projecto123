<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.util.*, java.nio.file.*, java.nio.charset.StandardCharsets" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload2.jakarta.servlet5.JakartaServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload2.core.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload2.core.FileItem" %>
<%@ page import="ut.JAR.CPEN410.ProfileDAO" %>

<html>
<head>
  <meta charset="UTF-8">
  <title>Processing Profile - MiniFacebook</title>
  <style>
    /* Mobile-first layout: full width columns by default */
    [class*="col-"] {
      width: 100%;
    }

    /* Responsive grid for tablets and desktops */
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

    /* Reset and base styling */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: Calibri, sans-serif;
      background-color: #f8f9fa;
      color: #333;
      text-align: center;
      padding: 40px;
    }
    .message {
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 20px;
    }
    .row {
      display: flex;
      flex-wrap: wrap;
      margin: 0 auto;
      max-width: 1200px;
    }
    [class^="col-"] {
      padding: 10px;
    }
  </style>
</head>
<body>

<%
    // Retrieve the logged-in user's ID from session
    Long userId = (Long) session.getAttribute("userId");

    // If user is not logged in, redirect to login page
    if(userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Retrieve the logged-in user's name from session
    String userName = (String) session.getAttribute("userName");

    // Ensure the form is multipart for file upload
    HttpServletRequest req = (HttpServletRequest) request;
    String contentType = req.getContentType();
    if (contentType == null || !contentType.toLowerCase().contains("multipart/form-data")) {
%>
    <div class="row">
      <div class="col-12">
        <p class="message">Error: Form must include enctype="multipart/form-data".</p>
      </div>
    </div>
<%
        return;
    }

    // Define upload constraints
    int maxFileSize = 5000 * 1024; // 5 MB
    String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) uploadDir.mkdirs();

    // Variables to store uploaded data
    String profilePicturePath = "";
    String degree = "", school = "", street = "", town = "", state = "", country = "";

    // Configure file upload factory and handler
    DiskFileItemFactory factory = DiskFileItemFactory.builder()
            .setPath(uploadDir.getAbsolutePath())
            .get();
    JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
    upload.setSizeMax(maxFileSize);

    try {
        // Parse request and process items
        List<FileItem> items = upload.parseRequest(req);
        if (items != null && !items.isEmpty()) {
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // Process regular form fields
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString(StandardCharsets.UTF_8).trim();
                    switch(fieldName) {
                        case "degree": degree = fieldValue; break;
                        case "school": school = fieldValue; break;
                        case "street": street = fieldValue; break;
                        case "town": town = fieldValue; break;
                        case "state": state = fieldValue; break;
                        case "country": country = fieldValue; break;
                    }
                } else {
                    // Process file upload
                    String fileName = new File(item.getName()).getName();
                    if (fileName != null && !fileName.isEmpty()) {
                        String newFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                        Path path = FileSystems.getDefault().getPath(uploadPath + newFileName);
                        item.write(path);
                        profilePicturePath = "cpen410/imagesjson/" + newFileName;
                    }
                }
            }
        }
    } catch(Exception ex) {
%>
    <div class="row">
      <div class="col-12">
        <p class="message">Error processing file upload: <%= ex.getMessage() %></p>
      </div>
    </div>
<%
        ex.printStackTrace();
        return;
    }

    // DAO to update profile information
    ProfileDAO profileDAO = new ProfileDAO();
    try {
        if (!profilePicturePath.isEmpty())
            profileDAO.updateProfilePicture(userId, profilePicturePath);

        if (!degree.isEmpty() || !school.isEmpty())
            profileDAO.updateEducation(userId, degree, school);

        if (!street.isEmpty() || !town.isEmpty() || !state.isEmpty() || !country.isEmpty())
            profileDAO.updateAddress(userId, street, town, state, country);
    } catch(Exception e) {
%>
    <div class="row">
      <div class="col-12">
        <p class="message">Error updating profile: <%= e.getMessage() %></p>
      </div>
    </div>
<%
        e.printStackTrace();
        profileDAO.close();
        return;
    }

    // Close DAO resources and redirect to profile page
    profileDAO.close();
    response.sendRedirect("profile.jsp");
%>

</body>
</html>
