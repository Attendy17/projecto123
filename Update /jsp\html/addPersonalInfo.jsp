<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <!-- Set up page properties and character encoding -->
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Personal Information</title>
  <style>
    //Reset and base styling 
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    // Overall layout and typography 
    body {
      font-family: 'Calibri', sans-serif;
      background-color: #f8f9fa;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      font-size: 14px;
    }

    //Container box styling 
    .container {
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      width: 90%;
      max-width: 500px;
      padding: 40px;
    }

    // Headings styling
    h1 {
      text-align: center;
      margin-bottom: 20px;
      color: #333;
      font-weight: bold;
    }

    h2 {
      color: #333;
      margin-bottom: 10px;
      font-weight: bold;
    }

    // Section spacing 
    .section {
      margin-bottom: 20px;
    }

    // Input fields styling 
    .form-group {
      margin-bottom: 15px;
    }

    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #555;
    }

    .form-group input,
    .form-group select {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 14px;
    }

    // Submit and reset buttons styling 
    .form-buttons {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
    }

    .form-buttons input[type="submit"],
    .form-buttons input[type="reset"] {
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
      font-weight: bold;
    }

    .form-buttons input[type="submit"] {
      background-color: #6F4E37;
      color: #fff;
    }

    .form-buttons input[type="reset"] {
      background-color: #e2e6ea;
      color: #333;
    }

    // Simple CSS grid for layout responsiveness 
    .row {
      display: flex;
      flex-wrap: wrap;
      margin: 0 -10px;
    }

    .row > div[class^="col-"] {
      padding: 0 10px;
    }

    // Column widths for different breakpoints 
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

    //Stack columns on small screens
    @media screen and (max-width: 600px) {
      .row > div[class^="col-"] {
        width: 100% !important;
      }
    }
  </style>
</head>
<body>

<%
  // Check if user is authenticated by looking for the userId in the session
  Long userId = (Long) session.getAttribute("userId");
  if (userId == null) {
%>
  <!-- If not authenticated, show an error message -->
  <div class="container">
    <h1>Error: User not authenticated</h1>
    <p>Please log in again.</p>
  </div>
<%
    // Stop further processing if user is not logged in
    return;
  }
%>
  //Form to collect personal information from the user
  <div class="container">
    <h1>Personal Information</h1>
    
    //Submit data via POST to another JSP page for processing
    <form id="personalInfoForm" action="processPersonalInfo.jsp" method="post">
      
      //Hidden field to pass user ID with the form 
      <input type="hidden" name="userId" value="<%= userId %>" />

      //Section for address details
      <div class="section">
        <h2>Address</h2>
        <div class="form-group">
          <label for="street">Street:</label>
          <input type="text" id="street" name="street" required />
        </div>
        <div class="form-group">
          <label for="town">Town:</label>
          <input type="text" id="town" name="town" required />
        </div>
        <div class="form-group">
          <label for="state">State:</label>
          <input type="text" id="state" name="state" required />
        </div>
        <div class="form-group">
          <label for="country">Country:</label>
          <input type="text" id="country" name="country" required />
        </div>
      </div>

      //Section for education details
      <div class="section">
        <h2>Education</h2>
        <div class="form-group">
          <label for="degree">Degree:</label>
          <select id="degree" name="degree" required>
            <option value="">Select a degree</option>
            <option value="High School Degree">High School Degree</option>
            <option value="Bachelor's Degree">Bachelor's Degree</option>
            <option value="Master's Degree">Master's Degree</option>
            <option value="Doctorate Degree">Doctorate Degree</option>
            <option value="Other">Other</option>
          </select>
        </div>
        <div class="form-group">
          <label for="school">School:</label>
          <input type="text" id="school" name="school" required />
        </div>
      </div>

      //Buttons to submit or reset the form
      <div class="form-buttons">
        <input type="submit" value="Submit" />
        <input type="reset" value="Reset" />
      </div>
    </form>
  </div>
</body>
</html>
