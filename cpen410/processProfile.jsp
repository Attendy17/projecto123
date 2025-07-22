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
    <title>Processing Profile - minifacebook</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        text-align: center;
        padding-top: 50px;
      }

      .message {
        font-size: 16px;
        color: #333;
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
    HttpServletRequest req = (HttpServletRequest) request;
    String contentType = req.getContentType();
    if (contentType == null || !contentType.toLowerCase().contains("multipart/form-data")) {
%>
    <p class="message">Error: El formulario debe tener enctype=multipart/form-data.</p>
<%
        return;
    }

    Long userId = (Long) session.getAttribute("userId");
    if (userId == null) {
%>
    <p class="message">Error: Usuario no autenticado. Por favor, inicie sesión.</p>
<%
        return;
    }

    int maxFileSize = 5000 * 1024;
    String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) uploadDir.mkdirs();

    String profilePicturePath = "";
    String degree = "", school = "", street = "", town = "", state = "", country = "";

    DiskFileItemFactory factory = DiskFileItemFactory.builder().setPath(uploadDir.getAbsolutePath()).get();
    JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
    upload.setSizeMax(maxFileSize);

    try {
        List<FileItem> items = upload.parseRequest(req);
        if (items != null && !items.isEmpty()) {
            for (FileItem item : items) {
                if (item.isFormField()) {
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
    <p class="message">Error procesando la subida del archivo: <%= ex.getMessage() %></p>
<%
        ex.printStackTrace();
        return;
    }

    ProfileDAO profileDAO = new ProfileDAO();
    try {
        if (!profilePicturePath.isEmpty()) profileDAO.updateProfilePicture(userId, profilePicturePath);
        if (!degree.isEmpty() || !school.isEmpty()) profileDAO.updateEducation(userId, degree, school);
        if (!street.isEmpty() || !town.isEmpty() || !state.isEmpty() || !country.isEmpty()) {
            profileDAO.updateAddress(userId, street, town, state, country);
        }
    } catch(Exception e) {
%>
    <p class="message">Error actualizando el perfil: <%= e.getMessage() %></p>
<%
        e.printStackTrace();
        profileDAO.close();
        return;
    }
    profileDAO.close();
    response.sendRedirect("profile.jsp");
%>
  </body>
</html>
