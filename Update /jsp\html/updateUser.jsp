<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.nio.file.*, java.util.*, java.nio.charset.StandardCharsets" %>
<%@ page import="jakarta.servlet.http.*, org.apache.commons.fileupload2.jakarta.servlet5.JakartaServletFileUpload, org.apache.commons.fileupload2.core.DiskFileItemFactory, org.apache.commons.fileupload2.core.FileItem" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Update User - minifacebook</title>
  <style>
    /* Reset básico */
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

    /* Columnas para layout futuro o responsividad */
    @media only screen and (max-width: 599px) {
      [class*="col-"] {
        width: 100%;
      }
    }
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
      .container {
        max-width: 600px;
      }
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

<div class="container col-12">
<%
  HttpServletRequest req = (HttpServletRequest) request;
  String contentType = req.getContentType();
  if(contentType == null || !contentType.toLowerCase().contains("multipart/form-data")){
      out.println("<h2>Error: El formulario debe tener enctype=multipart/form-data.</h2>");
      return;
  }

  long userId = 0;
  String name = "";
  String email = "";
  String birthDate = "";
  String gender = "";
  String profilePicturePath = "";

  String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
  File uploadDir = new File(uploadPath);
  if (!uploadDir.exists()){
      uploadDir.mkdirs();
  }

  int maxFileSize = 5000 * 1024; // 5 MB

  DiskFileItemFactory factory = DiskFileItemFactory.builder()
                                .setPath(uploadDir.getAbsolutePath())
                                .get();
  JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
  upload.setSizeMax(maxFileSize);

  try {
      List<FileItem> items = upload.parseRequest(req);
      for(FileItem item : items) {
          if(item.isFormField()){
              String fieldName = item.getFieldName();
              String fieldValue = item.getString(StandardCharsets.UTF_8).trim();
              if("id".equals(fieldName)){
                  userId = Long.parseLong(fieldValue);
              } else if("name".equals(fieldName)){
                  name = fieldValue;
              } else if("email".equals(fieldName)){
                  email = fieldValue;
              } else if("birthDate".equals(fieldName)){
                  birthDate = fieldValue;
              } else if("gender".equals(fieldName)){
                  gender = fieldValue;
              }
          } else {
              String fileName = new File(item.getName()).getName();
              if(fileName != null && !fileName.isEmpty()){
                  String newFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                  Path filePath = FileSystems.getDefault().getPath(uploadPath + newFileName);
                  item.write(filePath);
                  profilePicturePath = "cpen410/imagesjson/" + newFileName;
              }
          }
      }
  } catch(Exception ex) {
      out.println("<h2>Error procesando la subida del archivo: " + ex.getMessage() + "</h2>");
      ex.printStackTrace();
      return;
  }

  AdminDAO adminDAO = new AdminDAO();
  boolean updated = false;
  try {
     updated = adminDAO.updateUser(userId, name, email, birthDate, gender);
     if(!profilePicturePath.isEmpty()){
         adminDAO.updateUserProfilePicture(userId, profilePicturePath);
     }
  } catch(Exception e) {
      out.println("<h2>Error al actualizar el usuario: " + e.getMessage() + "</h2>");
      e.printStackTrace();
      adminDAO.close();
      return;
  }
  adminDAO.close();

  if(updated){
      out.println("<h2>Usuario actualizado correctamente.</h2>");
      out.println("<p><a href='adminDashboard.jsp'>Volver al Dashboard</a></p>");
  } else {
      out.println("<h2>No se pudo actualizar el usuario.</h2>");
      out.println("<p><a href='adminDashboard.jsp'>Volver al Dashboard</a></p>");
  }
%>
</div>

</body>
</html>
