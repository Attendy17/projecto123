<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session to log out the user.
    session.invalidate();
    // Redirect the user to the login page.
    response.sendRedirect("loginHashing.html");
%>
