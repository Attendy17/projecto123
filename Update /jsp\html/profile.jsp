<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.CPEN410.ProfileDAO" %>
<%@ page import="ut.JAR.CPEN410.MySQLCompleteConnector" %>

<html>
<head>
  <meta charset="UTF-8">
  <title>Profile - minifacebook</title>
  <style>
    /* General styling for layout and responsiveness */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: Arial, sans-serif;
      font-size: 14px;
      background-color: #f8f9fa;
    }

    .taskbar {
      background-color: #6F4E37;
      color: #fff;
      padding: 10px 20px;
      text-align: center;
    }

    .nav-bar {
      background-color: #6F4E37;
      padding: 10px 20px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .nav-left {
      color: #fff;
      font-weight: bold;
    }

    .nav-right {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }

    .nav-right a {
      color: #fff;
      text-decoration: none;
      font-weight: bold;
      padding: 6px 12px;
      border-radius: 4px;
      transition: background-color 0.3s ease;
    }

    .nav-right a:hover {
      background-color: #8c6d54;
    }

    .profile-container, .photo-section {
      width: 90%;
      max-width: 800px;
      margin: 20px auto;
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .profile-header {
      text-align: center;
      margin-bottom: 20px;
    }

    .profile-header img {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      border: 2px solid #ccc;
      object-fit: cover;
    }

    .profile-info p {
      color: #555;
      margin-bottom: 6px;
    }

    .edit-link {
      text-align: center;
      margin-top: 20px;
    }

    .edit-link a {
      text-decoration: none;
      color: #6F4E37;
      font-weight: bold;
    }

    .photo-section h2 {
      text-align: center;
      color: #333;
    }

    .photo-section form {
      text-align: center;
      margin-bottom: 20px;
    }

    .photo-section input[type="file"] {
      padding: 8px;
      width: 70%;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    .photo-section button {
      padding: 8px 12px;
      border: none;
      border-radius: 4px;
      background-color: #6F4E37;
      color: #fff;
      cursor: pointer;
      margin-top: 10px;
    }

    .photo-gallery {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
    }

    .photo-post {
      margin: 10px;
      text-align: center;
    }

    .photo-post img {
      width: 200px;
      height: auto;
      border-radius: 4px;
    }

    .photo-post form {
      margin-top: 5px;
    }

    /* Responsive column layout for larger screens */
    @media only screen and (min-width: 600px), (min-width: 768px) {
      .nav-bar {
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
      }

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
  // Check if user is authenticated
  Long userId = (Long) session.getAttribute("userId");
  if (userId == null) {
    response.sendRedirect("loginHas
