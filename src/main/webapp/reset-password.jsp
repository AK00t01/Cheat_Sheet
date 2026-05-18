<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>Update Password</title>
</head>
<body class="bg-light">
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card border-0 shadow-sm rounded-3 p-4">
                    <h3 class="fw-bold text-dark mb-3">Choose New Password</h3>
                    
                    <form action="reset-password" method="post" id="resetPasswordForm">
                        <input type="hidden" name="token" value="${param.token}">
                        
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">New Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" id="password" name="password" class="form-control" 
                                       required minlength="6" pattern="(?=.*[a-zA-Z]).{6,}" 
                                       placeholder="At least 6 characters with a letter">
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="confirm-password" class="form-label small fw-bold text-secondary">Confirm Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-check-all"></i></span>
                                <input type="password" class="form-control" id="confirm-password" required placeholder="Repeat password">
                            </div>
                            <div id="passwordError" class="text-danger small mt-1 d-none">
                                <i class="bi bi-exclamation-circle-fill me-1"></i> Passwords do not match!
                            </div>
                        </div>
                        
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-success btn-lg rounded-pill fw-bold shadow-sm">
                                Update Password
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById("resetPasswordForm").addEventListener("submit", function(event) {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirm-password").value;
            const errorDiv = document.getElementById("passwordError");

            if (password !== confirmPassword) {
                // Stop form from posting data to the servlet
                event.preventDefault(); 
                
                // Show the Bootstrap error message
                errorDiv.classList.remove("d-none");
                document.getElementById("confirm-password").classList.add("is-invalid");
            } else {
                errorDiv.classList.add("d-none");
                document.getElementById("confirm-password").classList.remove("is-invalid");
            }
        });
    </script>
</body>
</html>