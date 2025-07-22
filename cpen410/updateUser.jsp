<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.nio.file.*, java.util.*, java.nio.charset.StandardCharsets" %>
<%@ page import="jakarta.servlet.http.*, org.apache.commons.fileupload2.jakarta.servlet5.JakartaServletFileUpload, org.apache.commons.fileupload2.core.DiskFileItemFactory, org.apache.commons.fileupload2.core.FileItem" %>
<%@ page import="ut.JAR.CPEN410.AdminDAO" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Update User - minifacebook</title>
    <style>
      /* Basic styling for the page */
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        text-align: center;
        padding: 20px;
      }
      /* Container styling for the update message */
      .container {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        max-width: 600px;
        margin: auto;
      }
    </style>
  </head>
  <body>
    <div class="container">
<%
    // Verificar que la petición tenga tipo multipart/form-data
    HttpServletRequest req = (HttpServletRequest) request;
    String contentType = req.getContentType();
    if(contentType == null || !contentType.toLowerCase().contains("multipart/form-data")){
        out.println("<h2>Error: El formulario debe tener enctype=multipart/form-data.</h2>");
        return;
    }
    
    // Variables para almacenar los datos recibidos
    long userId = 0;
    String name = "";
    String email = "";
    String birthDate = "";
    String gender = "";
    String profilePicturePath = "";
    
    // Definir la ruta física para almacenar las imágenes
    String uploadPath = application.getRealPath("/") + "cpen410/imagesjson/";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()){
        uploadDir.mkdirs();
    }
    
    int maxFileSize = 5000 * 1024; // 5 MB
    
    // Configurar Apache Commons FileUpload
    DiskFileItemFactory factory = DiskFileItemFactory.builder()
                                  .setPath(uploadDir.getAbsolutePath())
                                  .get();
    JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);
    upload.setSizeMax(maxFileSize);
    
    try {
        List<FileItem> items = upload.parseRequest(req);
        for(FileItem item : items) {
            if(item.isFormField()){
                // Procesar campos de formulario normales
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
                // Procesar el campo de archivo (foto de perfil)
                String fileName = new File(item.getName()).getName();
                if(fileName != null && !fileName.isEmpty()){
                    // Generar un nombre único para el archivo
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
    
    // Actualizar la información del usuario en la base de datos
    AdminDAO adminDAO = new AdminDAO();
    boolean updated = false;
    try {
        // Actualizar datos básicos (nombre, email, fecha de nacimiento y género)
        updated = adminDAO.updateUser(userId, name, email, birthDate, gender);
        // Si se subió una foto, actualizar la ruta en la base de datos
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
    
    // Mostrar mensajes de éxito o error
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
