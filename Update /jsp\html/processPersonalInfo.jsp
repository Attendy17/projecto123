<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.PersonalInfoDAO" %>
<%@ page import="java.sql.*" %>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Process Personal Info</title>
    <style>
      body {
        font-family: Calibri, sans-serif;
        font-weight: bold;
        background-color: #f5f5f5;
        color: #4e4e4e;
        margin: 0;
        padding: 0;
      }

      .container {
        width: 90%;
        max-width: 900px;
        margin: 40px auto;
        background-color: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .row {
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 20px;
      }

      .col-25 { width: 25%; padding: 10px; }
      .col-50 { width: 50%; padding: 10px; }
      .col-75 { width: 75%; padding: 10px; }
      .col-100 { width: 100%; padding: 10px; }

      h1, h2 {
        text-align: center;
        color: #4e4e4e;
      }

      .error {
        color: #b30000;
        text-align: center;
        font-size: 18px;
      }
    </style>
  </head>
  <body>
    <div class="container">
<%
    Long userId = (Long) session.getAttribute("userId");
    if (userId == null) {
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            userId = Long.parseLong(userIdStr);
            session.setAttribute("userId", userId);
        }
    }

    if (userId == null) {
%>
      <div class="row">
        <div class="col-100">
          <h2 class="error">Error: Usuario no autenticado.</h2>
        </div>
      </div>
<%
    } else {
        String street = request.getParameter("street");
        String town = request.getParameter("town");
        String state = request.getParameter("state");
        String country = request.getParameter("country");
        String degree = request.getParameter("degree");
        String school = request.getParameter("school");

        PersonalInfoDAO infoDAO = new PersonalInfoDAO();

        boolean addrInserted = infoDAO.addAddress(userId, street, town, state, country);
        boolean eduInserted = infoDAO.addEducation(userId, degree, school);

        if (addrInserted && eduInserted) {
            response.sendRedirect("welcome.jsp");
        } else {
%>
      <div class="row">
        <div class="col-100">
          <h2 class="error">Error al guardar la información personal.</h2>
        </div>
      </div>
<%
        }

        infoDAO.close();
    }
%>
    </div>
  </body>
</html>
