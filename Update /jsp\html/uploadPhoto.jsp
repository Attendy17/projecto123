<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.util.*, java.nio.file.*, java.nio.charset.StandardCharsets" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload2.jakarta.servlet5.JakartaServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload2.core.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload2.core.FileItem" %>
<%@ page import="ut.JAR.CPEN410.ProfileDAO" %>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Uploading Photo - minifacebook</title>
  <style>
    /* Base page styling */
    body {
      font-family: Arial, sans-serif;
      background-color: #f8f9fa;
      text-align: center;
      padding-top: 50px;
      color: #333;
    }
    .container {
      max-width: 600px;
      margin: auto;
      background: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    /* Mobile-first layout */
    [class*="col-"] {
      width: 100%;
    }

    /* Responsive grid for tablets and desktops */
    @media only screen and (min-width: 768px) {
      .col-1 {width: 8.33%;}
      .col-2 {width: 16.66%;}
      .col-3 {width: 25%;}
      .col-4 {width: 33.33%;}
      .col-5 {width: 41.66%;}
      .col-6 {width: 50%;}
      .col-7 {width: 58.33%;}
      .col-8 {width: 66.66%;}
      .col-9 {width: 75%;}
      .col-10 {width: 83.33%;}
      .col-11 {width: 91.66%;}
      .col-12 {width: 100%;}
    }
  </style>
</head>
<body>
  <div class="container col-12">
<%
    // Session validation
    Long userId = (Long) session.getAttribute("userId");

    // If user is not logged in, redirect to login page
    if (userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Retrieve logged-in user's name (not used for logic but stored for consistency)
    String userName = (String) session.getAttribute("userName");

    // Verify multipart/form-data request
    HttpServletRequest req = (HttpServletRequest) request;
    String contentType = req.getContentType();
    if (contentType == null || !contentType.toLowerCase().contains("multipart/form-data")) {
        out.println("<h2>Error: Form must include enctype=multipart/form-data.</h2>");
        return;
    }

   
    // File upload configuration
    int maxFileSize = 5000 * 1024; // 5 MB limit
    String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs(); // Create upload directory if it doesn't exist
    }

    String photoPath = "";

    // Set up file upload handler
    DiskFileItemFactory factory = DiskFileItemFactory.builder()
                                    .setPath(uploadDir.getAbsolutePath())
                                    .get();
    JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
    upload.setSizeMax(maxFileSize);

    try {
        // Parse the request to extract file items
        List<FileItem> items = upload.parseRequest(req);
        if (items != null && !items.isEmpty()) {
            for (FileItem item : items) {
                // Only process file fields, ignore form fields
                if (!item.isFormField()) {
                    String fileName = new File(item.getName()).getName();
                    if (fileName != null && !fileName.isEmpty()) {
                        // Create a unique filename with userId and timestamp
                        String newFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                        Path path = FileSystems.getDefault().getPath(uploadPath + newFileName);
                        item.write(path);
                        // Store relative path for database
                        photoPath = "cpen410/imagesjson/" + newFileName;
                    }
                }
            }
        }
    } catch(Exception ex) {
        // Handle file upload errors
        out.println("<h2>Error processing file upload: " + ex.getMessage() + "</h2>");
        ex.printStackTrace();
        return;
    }

    // Save photo record in database
    if (!photoPath.isEmpty()) {
        ProfileDAO profileDAO = new ProfileDAO();
        try {
            profileDAO.addPhoto(userId, photoPath);
        } catch(Exception e) {
            out.println("<h2>Error saving photo to database: " + e.getMessage() + "</h2>");
            e.printStackTrace();
            profileDAO.close();
            return;
        }
        profileDAO.close();
    }

    // Redirect to profile page after upload
    response.sendRedirect("profile.jsp");
%>
  </div>
</body>
</html>
