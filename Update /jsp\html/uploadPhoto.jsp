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
    <title>Uploading Photo - minifacebook</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        text-align: center;
        padding-top: 50px;
      }
    </style>
  </head>
  <body>
<%
    // Convert the request to HttpServletRequest for file upload processing.
    HttpServletRequest req = (HttpServletRequest) request;
    
    // Check that the request's content type is multipart/form-data.
    String contentType = req.getContentType();
    if (contentType == null || !contentType.toLowerCase().contains("multipart/form-data")) {
        out.println("Error: The form must have enctype=multipart/form-data.");
        return;
    }
    
    // Verify that the user is authenticated.
    Long userId = (Long) session.getAttribute("userId");
    if (userId == null) {
        out.println("Error: User not authenticated. Please log in.");
        return;
    }
    
    int maxFileSize = 5000 * 1024; // Maximum file size: 5 MB.
    // Define the physical path to store uploaded images.
    // For example, this could be "C:\path\to\webapps\ROOT\cpen410\imagesjson\"
    String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }
    
    // Variable to store the relative path of the uploaded photo.
    String photoPath = "";
    
    // Set up DiskFileItemFactory using the builder API with the upload directory path.
    DiskFileItemFactory factory = DiskFileItemFactory.builder()
                                  .setPath(uploadDir.getAbsolutePath())
                                  .get();
    // Create a file upload handler and set the maximum file size.
    JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
    upload.setSizeMax(maxFileSize);
    
    try {
        // Parse the multipart/form-data request into FileItem objects.
        List<FileItem> items = upload.parseRequest(req);
        if (items != null && !items.isEmpty()) {
            for (FileItem item : items) {
                // Only process file upload fields.
                if (!item.isFormField()) {
                    String fileName = new File(item.getName()).getName();
                    if (fileName != null && !fileName.isEmpty()) {
                        // Generate a unique filename using the userId and current timestamp.
                        String newFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                        Path path = FileSystems.getDefault().getPath(uploadPath + newFileName);
                        // Write the uploaded file to the destination path.
                        item.write(path);
                        // Set the relative path to store in the database.
                        photoPath = "cpen410/imagesjson/" + newFileName;
                    }
                }
            }
        }
    } catch(Exception ex) {
        out.println("Error processing the file upload: " + ex.getMessage());
        ex.printStackTrace();
        return;
    }
    
    // If a photo was successfully uploaded, insert the photo post into the database.
    if (!photoPath.isEmpty()) {
        ProfileDAO profileDAO = new ProfileDAO();
        try {
            profileDAO.addPhoto(userId, photoPath);
        } catch(Exception e) {
            out.println("Error saving the photo post: " + e.getMessage());
            e.printStackTrace();
            profileDAO.close();
            return;
        }
        profileDAO.close();
    }
    
    // Redirect the user back to the profile page after uploading.
    response.sendRedirect("profile.jsp");
%>
  </body>
</html>
