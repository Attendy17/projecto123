<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ut.JAR.CPEN410.PersonalInfoDAO" %>
<%@ page import="java.sql.*" %>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Process Personal Info</title>
    <style>
      /* Mobile-first layout: all columns full width */
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

      /* Basic styling */
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
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }

      .row {
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 20px;
      }

      .col-25 { padding: 10px; width: 25%; }
      .col-50 { padding: 10px; width: 50%; }
      .col-75 { padding: 10px; width: 75%; }
      .col-100 { padding: 10px; width: 100%; }

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
    // Retrieve logged-in user ID from session
    Long userId = (Long) session.getAttribute("userId");

    // If no userId in session, redirect to login page and stop processing
    if (userId == null) {
        response.sendRedirect("loginHashing.html");
        return;
    }

    // Retrieve user name from session (not used here but required per spec)
    String userName = (String) session.getAttribute("userName");

    // Retrieve personal info parameters from request
    String street = request.getParameter("street");
    String town = request.getParameter("town");
    String state = request.getParameter("state");
    String country = request.getParameter("country");
    String degree = request.getParameter("degree");
    String school = request.getParameter("school");

    // Create DAO instance for DB operations
    PersonalInfoDAO infoDAO = new PersonalInfoDAO();

    // Attempt to insert address and education info
    boolean addrInserted = infoDAO.addAddress(userId, street, town, state, country);
    boolean eduInserted = infoDAO.addEducation(userId, degree, school);

    if (addrInserted && eduInserted) {
        // Redirect to welcome page on success
        response.sendRedirect("welcome.jsp");
    } else {
%>
      <div class="row">
        <div class="col-100">
          <h2 class="error">Error saving personal information.</h2>
        </div>
      </div>
<%
    }

    // Close DAO resources
    infoDAO.close();
%>
    </div>
  </body>
</html>
