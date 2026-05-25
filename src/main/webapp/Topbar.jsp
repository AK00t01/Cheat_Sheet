<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="navbar navbar-expand-lg sticky-top py-3" style="backdrop-filter: blur(14px); background: rgba(11, 18, 32, 0.88);">
    <div class="container">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home">
            <span class="d-inline-flex align-items-center justify-content-center rounded-circle" style="width: 2.25rem; height: 2.25rem; background: linear-gradient(135deg, #0f6fff 0%, #12b981 100%);">
                <i class="bi bi-code-slash text-white"></i>
            </span>
            <span class="text-white">CheatSheet Pro</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>      

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto align-items-lg-center gap-lg-2">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-white-50 fw-semibold" href="#" id="catDrop" role="button" data-bs-toggle="dropdown" aria-expanded="false">Categories</a>
                    <ul class="dropdown-menu shadow border-0 p-2" aria-labelledby="catDrop">
                        <c:forEach var="t" items="${sessionScope.categories}">
                            <li><a class="dropdown-item rounded-3 py-2" href="categories?id=${t.categoryId}">${t.categoryName}</a></li>
                        </c:forEach>
                    </ul>
                </li>
                <c:if test="${not empty sessionScope.user && 'ADMIN'.equalsIgnoreCase(sessionScope.user.role)}">
                    <li class="nav-item">
                        <a class="nav-link text-warning fw-bold d-flex align-items-center" href="admin-dashboard">
                            <i class="bi bi-shield-fill-check me-1"></i> Admin Dashboard
                            <c:if test="${not empty pendingReportsCount && pendingReportsCount > 0}">
                                <span class="badge rounded-pill bg-danger ms-2 small font-monospace">${pendingReportsCount}</span>
                            </c:if>
                        </a>
                    </li>
                </c:if>
            </ul>
            
            <div class="position-relative mx-lg-4 my-3 my-lg-0 flex-grow-1" style="max-width: 420px;">
                <form class="d-flex" action="search" method="GET" autocomplete="off">
                    <div class="input-group">
                        <input type="text" id="liveSearch" name="query" 
                               class="form-control form-control-sm" 
                               placeholder="Search snippets..." 
                               oninput="performSearch(this.value)">
                        <button class="btn btn-primary btn-sm px-3" type="submit">Go</button>
                    </div>
                </form>
                <div id="searchSuggestions" class="list-group position-absolute w-100 shadow-lg d-none" 
                     style="z-index: 1050; top: calc(100% + 0.5rem);">
                </div>
            </div>
           
            <div class="d-flex align-items-center ms-lg-auto gap-2 flex-wrap">
                <a href="random-snippet" class="btn btn-outline-light rounded-pill px-3">
                    <i class="bi bi-shuffle me-2"></i>Surprise Me
                </a>
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <button type="button" class="btn btn-outline-light rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#loginModal">
                            Login
                        </button>
                        <button type="button" class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#registerModal">
                            Register
                        </button>
                    </c:when>
                    <c:otherwise>
                        <div class="dropdown">
                            <button class="btn btn-outline-light dropdown-toggle d-flex align-items-center rounded-pill px-3" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-5 me-2"></i>
                                <span>${sessionScope.user.name}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" aria-labelledby="userMenu">
                                <li><a class="dropdown-item rounded-3 py-2" href="profile">My Cheatsheets</a></li>
                                <li><a class="dropdown-item rounded-3 py-2" href="bookmark">My Bookmarks</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item rounded-3 py-2 text-danger" href="${pageContext.request.contextPath}/logout">
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

<div class="modal fade" id="registerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header text-white" style="background: linear-gradient(135deg, #0f6fff 0%, #12b981 100%);">
                <h5 class="modal-title fw-bold">Join CheatSheet Pro</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form action="register" method="POST" id="registrationForm">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="username" placeholder="Enter username" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" name="email" placeholder="name@example.com" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="reg-password" name="password" 
                                   required minlength="6" placeholder="At least 6 characters.">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Confirm Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-check-all"></i></span>
                            <input type="password" class="form-control" id="confirm-password" name="confirmPassword" required placeholder="Repeat password">
                        </div>
                        <div id="passwordError" class="text-danger small mt-1 d-none">
                            Passwords do not match!
                        </div>
                    </div>
                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary btn-lg rounded-pill">Create Account</button>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0 justify-content-center pb-4">
                <span class="text-muted small">Already a member? <a href="#" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#loginModal" class="text-primary text-decoration-none fw-bold">Login</a></span>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="loginModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header text-white" style="background: linear-gradient(135deg, #111827 0%, #0f6fff 100%);">
                <h5 class="modal-title fw-bold">Account Login</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
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
                    <div class="mb-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <label class="form-label small fw-bold mb-0">Password</label>
                        </div>
                        <input type="password" name="password" class="form-control mt-1" placeholder="Enter password" required>
                    </div>
                      
                    <div class="form-check mb-4 mt-2">
                        <input type="checkbox" name="rememberMe" value="true" class="form-check-input" id="rememberMe">
                        <label class="form-check-label small fw-semibold text-muted" for="rememberMe">Remember Me</label>
                       
                    </div>
                                               <a href="forgot-password" class="text-muted small text-decoration-none">Forgot password?</a>
                    <button type="submit" class="btn btn-primary w-100 py-2.5 fw-bold shadow-sm">Sign In</button>
                </form>
            </div>
            <div class="modal-footer justify-content-center border-0 pb-4">
                <p class="small text-muted mb-0">Don't have an account? <a href="#" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#registerModal" class="text-primary text-decoration-none fw-bold">Register here</a></p>
            </div>
        </div>
    </div>
</div>

<script>
    let debounceTimer;

    document.addEventListener("DOMContentLoaded", function() {
        // 1. Password Matching Verification Rule
        const regForm = document.getElementById('registrationForm');
        if (regForm) {
            regForm.onsubmit = function(e) {
                const password = document.getElementById('reg-password').value;
                const confirm = document.getElementById('confirm-password').value;
                const errorDiv = document.getElementById('passwordError');

                if (password !== confirm) {
                    e.preventDefault();
                    errorDiv.classList.remove('d-none');
                    return false;
                }
                errorDiv.classList.add('d-none');
                return true;
            };
        }

        // 2. Automated Modal Recovery Check
        const hasError = "<c:out value='${sessionScope.error}'/>";
        if (hasError && hasError.trim().length > 0) {
            var loginEl = document.getElementById('loginModal');
            if (loginEl) {
                var loginModal = new bootstrap.Modal(loginEl);
                loginModal.show();
            }
        }
    });

    // 3. Independent Global Async Search Context
    function performSearch(keyword) {
        const suggestionBox = document.getElementById("searchSuggestions");
        clearTimeout(debounceTimer);

        if (keyword.trim().length < 2) {
            suggestionBox.classList.add("d-none");
            return;
        }

        suggestionBox.classList.remove("d-none");
        suggestionBox.innerHTML = '<div class="list-group-item small text-muted text-center py-2">' +
                                  '<span class="spinner-border spinner-border-sm me-2"></span>Searching...' +
                                  '</div>';

        debounceTimer = setTimeout(() => {
            fetch('${pageContext.request.contextPath}/live-search?query=' + encodeURIComponent(keyword.trim()))
                .then(response => response.text())
                .then(data => {
                    suggestionBox.innerHTML = data;
                    if (data.trim() === "") {
                        suggestionBox.classList.add("d-none");
                    }
                })
                .catch(err => {
                    console.error("Live Search Error:", err);
                });
        }, 300);
    }

    // 4. Click-Away Interceptor Event
    document.addEventListener("click", function(event) {
        const suggestionBox = document.getElementById("searchSuggestions");
        const searchInput = document.getElementById("liveSearch");

        if (suggestionBox && searchInput && !suggestionBox.contains(event.target) && event.target !== searchInput) {
            suggestionBox.classList.add("d-none");
        }
    });
</script>

<c:remove var="error" scope="session" />