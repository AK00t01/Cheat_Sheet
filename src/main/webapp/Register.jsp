<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
</head>
<body>

    <h2>Register</h2>

    <!-- Display Error Messages from the Servlet -->
    <c:if test="${not empty error}">
        <p style="color: red;">
            <c:out value="${error}" />
        </p>
    </c:if>

    <!-- Display Success Messages (if redirected with a parameter) -->
    <c:if test="${not empty param.msg}">
        <p style="color: green;">
            <c:out value="${param.msg}" />
        </p>
    </c:if>

    <form action="register" method="post">
        <!-- We use value="${param.username}" to keep the text if the page reloads due to an error -->
        Username: 
        <input type="text" name="username" placeholder="Username" value="<c:out value='${param.username}'/>" required>
        <br>

        Email: 
        <input type="email" name="email" placeholder="Email" value="<c:out value='${param.email}'/>" required>
        <br>

        Password: 
        <input type="password" name="password" placeholder="Password" required minlength="8"
    pattern=".*[a-zA-Z].*" 
    title="Password must be at least 8 characters long and contain at least one letter.">
        <br>

        Confirm Password: 
        <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
        <br>

        <input type="submit" value="Register">
    </form>

    <p>Already have an account? <a href="Login.jsp">Login here</a></p>

</body>
</html>