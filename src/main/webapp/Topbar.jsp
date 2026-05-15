<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <!-- Logo -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-code-slash text-primary"></i> CheatSheet
        </a>

        <!-- Mobile Toggle -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>      

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Left Side: Topics -->
            <ul class="navbar-nav me-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Categories</a>
                    <ul class="dropdown-menu shadow">
                        <c:forEach var="t" items="${sessionScope.categories}">
                            <li><a class="dropdown-item" href="categories?id=${t.categoryId}">${t.categoryName}</a></li>
                        </c:forEach>
                    </ul>
                </li>
            </ul>
            
                        <div class="position-relative">
    <form class="d-flex ms-3" action="home" method="get" autocomplete="off">
        <div class="input-group">
            <input type="text" id="liveSearch" name="query" 
                   class="form-control form-control-sm" 
                   placeholder="Type to search..." 
                   oninput="performSearch(this.value)">
            <button class="btn btn-primary btn-sm" type="submit">
                <i class="bi bi-search"></i>
            </button>
        </div>
    </form>
    <!-- Suggestions box -->
    <div id="searchSuggestions" class="list-group position-absolute w-100 shadow-lg d-none" 
         style="z-index: 1050; top: 35px;">
    </div>
</div>
           
            <!-- Right Side: Auth/User Menu -->
            <div class="d-flex align-items-center ms-auto">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <button type="button" class="btn btn-outline-light me-2" data-bs-toggle="modal" data-bs-target="#loginModal">
                            Login
                        </button>
                        <button type="button" class="btn btn-outline-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#registerModal">
                            Register
                        </button>
                    </c:when>
                    <c:otherwise>
                        <div class="dropdown">
                            <button class="btn btn-dark dropdown-toggle d-flex align-items-center" type="button" id="userMenu" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle fs-5 me-2"></i>
                                <span>${sessionScope.user.name}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                <li><a class="dropdown-item" href="profile">Profile</a></li>
                                <li><a class="dropdown-item" href="my-cheatsheets">My Snippets</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- Global Registration Success Alert (Outside Modal) -->
<div class="container mt-2">
    <div class="d-flex justify-content-center">
        <c:if test="${not empty sessionScope.regSuccess}">
            <div class="alert alert-success py-1 px-3 small mb-0 alert-dismissible fade show d-inline-block shadow-sm" style="border-radius: 20px;">
                <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.regSuccess}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert" style="font-size: 0.65rem;"></button>
            </div>
            <c:remove var="regSuccess" scope="session" />
        </c:if>
    </div>
</div>

<!-- Login Modal -->
<div class="modal fade" id="loginModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold">Account Login</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                
                <!-- Login Specific Errors -->
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger py-2 px-3 small mb-3 border-0 shadow-sm" style="border-radius: 10px;">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.error}
                    </div>
                </c:if>

                <form action="login" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Email Address</label>
                        <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label small fw-bold">Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                    </div>
                    
                    <div class="form-check mb-3">
                        <input type="checkbox" name="rememberMe" value="true" class="form-check-input" id="rememberMe">
                        <label class="form-check-label small fw-bold" for="rememberMe">Remember Me</label>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">Sign In</button>
                </form>
            </div>
            <div class="modal-footer justify-content-center border-0">
                <p class="small text-muted">Don't have an account? <a href="#" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#registerModal">Register here</a></p>
            </div>
        </div>
    </div>
</div>

<!-- Script to handle automatic modal reopening on error -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Check if an error exists in the JSTL sessionScope
        const hasError = "<c:out value='${sessionScope.error}'/>";
        
        if (hasError && hasError.trim().length > 0) {
            var loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
            loginModal.show();
            
            // Remove error after showing so it doesn't pop up on every refresh
            <% session.removeAttribute("error"); %>
        }
    });// 1. Declare the timer variable globally (outside the function)
    let debounceTimer;

    function performSearch(keyword) {
        const suggestionBox = document.getElementById("searchSuggestions");
        
        // 2. Immediately clear any existing timer when the user types
        clearTimeout(debounceTimer);

        // 3. Simple validation for minimum length
        if (keyword.trim().length < 2) {
            suggestionBox.classList.add("d-none");
            return;
        }

        // 4. Visual Feedback: Show the box and a "Searching..." placeholder
        suggestionBox.classList.remove("d-none");
        suggestionBox.innerHTML = '<div class="list-group-item small text-muted text-center py-2">' +
                                  '<span class="spinner-border spinner-border-sm me-2"></span>Searching...' +
                                  '</div>';

        // 5. Start a new timer for 300 milliseconds
        debounceTimer = setTimeout(() => {
            // Use encodeURIComponent to handle special characters like '#' or '&'
            fetch('${pageContext.request.contextPath}/live-search?query=' + encodeURIComponent(keyword))
                .then(response => response.text())
                .then(data => {
                    suggestionBox.innerHTML = data;
                    
                    // If the server returns empty content, hide the box
                    if (data.trim() === "") {
                        suggestionBox.classList.add("d-none");
                    }
                })
                .catch(err => {
                    console.error("Live Search Error:", err);
                    suggestionBox.innerHTML = '<div class="list-group-item small text-danger">Error loading results.</div>';
                });
        }, 300); // 300ms is the standard "pause" threshold
    }
</script>