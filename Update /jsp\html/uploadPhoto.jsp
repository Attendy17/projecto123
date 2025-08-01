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
  </style>
</head>
<body>
  <div class="container">
<%
  HttpServletRequest req = (HttpServletRequest) request;
  String contentType = req.getContentType();
  if (contentType == null || !contentType.toLowerCase().contains("multipart/form-data")) {
      out.println("<h2>Error: El formulario debe tener enctype=multipart/form-data.</h2>");
      return;
  }
  
  Long userId = (Long) session.getAttribute("userId");
  if (userId == null) {
      out.println("<h2>Error: Usuario no autenticado. Por favor inicia sesión.</h2>");
      return;
  }
  
  int maxFileSize = 5000 * 1024; // 5 MB
  String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
  File uploadDir = new File(uploadPath);
  if (!uploadDir.exists()) {
      uploadDir.mkdirs();
  }
  
  String photoPath = "";
  
  DiskFileItemFactory factory = DiskFileItemFactory.builder()
                                .setPath(uploadDir.getAbsolutePath())
                                .get();
  JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
  upload.setSizeMax(maxFileSize);
  
  try {
      List<FileItem> items = upload.parseRequest(req);
      if (items != null && !items.isEmpty()) {
          for (FileItem item : items) {
              if (!item.isFormField()) {
                  String fileName = new File(item.getName()).getName();
                  if (fileName != null && !fileName.isEmpty()) {
                      String newFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                      Path path = FileSystems.getDefault().getPath(uploadPath + newFileName);
                      item.write(path);
                      photoPath = "cpen410/imagesjson/" + newFileName;
                  }
              }
          }
      }
  } catch(Exception ex) {
      out.println("<h2>Error procesando la subida del archivo: " + ex.getMessage() + "</h2>");
      ex.printStackTrace();
      return;
  }
  
  if (!photoPath.isEmpty()) {
      ProfileDAO profileDAO = new ProfileDAO();
      try {
          profileDAO.addPhoto(userId, photoPath);
      } catch(Exception e) {
          out.println("<h2>Error guardando la foto: " + e.getMessage() + "</h2>");
          e.printStackTrace();
          profileDAO.close();
          return;
      }
      profileDAO.close();
  }
  
  // Redirige a profile.jsp después de subir la foto
  response.sendRedirect("profile.jsp");
%>
  </div>
</body>
</html>
