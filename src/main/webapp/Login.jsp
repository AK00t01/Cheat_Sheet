<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>Login - Cheat Sheet</title>
</head>
<body>
<%@ include file="Topbar.jsp" %>
    <div class="container vh-100 d-flex justify-content-center align-items-center">
        <div class="card shadow-lg" style="max-width: 400px; width: 100%;">
            
            <div class="card-header bg-primary text-white text-center py-3">
                <h4 class="mb-0"><i class="bi bi-shield-lock-fill"></i> Account Login</h4>
            </div>

            <div class="card-body p-4">
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <div><c:out value="${error}" /></div>
                    </div>
                </c:if>

                <c:if test="${not empty param.msg}">
                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <div><c:out value="${param.msg}" /></div>
                    </div>
                </c:if>

                <form action="login" method="post">
                    <div class="mb-3">
                        <label class="form-label">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" class="form-control" 
                                   placeholder="name@example.com" 
                                   value="<c:out value='${param.email}'/>" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-key"></i></span>
                            <input type="password" name="password" class="form-control" 
                                   placeholder="Enter password" required>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">Login</button>
                    </div>
                </form>
            </div>

            <div class="card-footer text-center py-3 bg-light">
                <p class="mb-0 small text-muted">Don't have an account? 
                    <a href="Register.jsp" class="text-primary text-decoration-none fw-bold">Register here</a>
                </p>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>