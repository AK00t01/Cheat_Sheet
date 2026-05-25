<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>Forgot Password</title>
</head>
<body class="bg-light">
 <%@ include file="Topbar.jsp" %>
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h3 class="fw-bold text-dark mb-2">Reset Password</h3>
                    <p class="text-muted small mb-4">Enter your email address and we'll send you a temporary secure link to reset your account credentials.</p>
                    
                    <% if (session.getAttribute("error") != null) { %>
                        <div class="alert alert-danger py-2 small"><%= session.getAttribute("error") %></div>
                        <% session.removeAttribute("error"); %>
                    <% } %>
                    <% if (session.getAttribute("success") != null) { %>
                        <div class="alert alert-success py-2 small"><%= session.getAttribute("success") %></div>
                        <% session.removeAttribute("success"); %>
                    <% } %>

                    <form action="forgot-password" method="post">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold">Send Reset Link</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
        <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro - Coding made easier.</p>
        </div>
    </footer>
</body>
</html>