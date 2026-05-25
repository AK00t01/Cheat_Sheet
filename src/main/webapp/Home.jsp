<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="Header.jsp" %>
    <title>Home - CheatSheet Pro</title>
    <style>
        .hero-section {
            background:
                radial-gradient(circle at top left, rgba(255,255,255,0.22), transparent 28%),
                linear-gradient(135deg, #0f172a 0%, #0f6fff 52%, #12b981 100%);
            color: white;
            padding: 88px 0 76px;
            margin-bottom: 40px;
            border-radius: 0 0 32px 32px;
        }
        .snippet-card {
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
            overflow: hidden;
        }
        .snippet-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(15,23,42,0.14) !important;
        }
        .topic-badge {
            background-color: #f8f9fa;
            color: #495057;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            display: inline-block;
            margin: 4px;
            transition: 0.3s;
            border: 1px solid #e9ecef;
            font-size: 0.9rem;
        }
        .topic-badge:hover {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        .breadcrumb-text {
            letter-spacing: 0.5px;
            font-weight: 600;
        }
        /* Fix for potential alignment shifts during alerts */
        .alert-container {
            min-height: 50px;
        }
        .hero-chip {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.55rem 1rem;
            border-radius: 999px;
            background: rgba(255,255,255,0.14);
            border: 1px solid rgba(255,255,255,0.18);
            font-size: 0.95rem;
        }
    </style>
</head>
<body>

    <%@ include file="Topbar.jsp" %>

    <div class="container mt-3 alert-container">
        <%-- Success Message for Snippet Creation --%>
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>
      
        <c:if test="${not empty sessionScope.authError}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.authError}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="authError" scope="session" />
        </c:if>
        
        <%-- Error Message for Login/General Failures --%>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%-- We remove it here after showing it in the alert --%>
            <c:remove var="error" scope="session" />
        </c:if>
    </div>

    <header class="hero-section text-center">
        <div class="container">
            <div class="hero-chip mb-3">
                <i class="bi bi-lightning-charge-fill"></i>
                <span>Browse freely. Contribute when signed in.</span>
            </div>
            <h1 class="display-4 fw-bold">Learning shortcuts that are actually easy to revisit</h1>
            <p class="lead text-white-50 mx-auto" style="max-width: 760px;">Explore code snippets, compare patterns, and open any detail page without logging in. Sign in only when you want to rate, bookmark, comment, or publish your own cheatsheets.</p>
            <div class="mt-4">
                <a href="#explore" class="btn btn-light btn-lg px-4 me-2 shadow-sm">Explore Now</a>
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <button type="button" class="btn btn-outline-light btn-lg px-4" data-bs-toggle="modal" data-bs-target="#loginModal">Sign In to Create</button>
                    </c:when>
                    <c:otherwise>
                        <a href="creat-sheet" class="btn btn-outline-light btn-lg px-4">Add New Cheatsheet</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <main class="container" id="explore">
        <div class="row">
            
            <aside class="col-lg-3 mb-4">
                <div class="card shadow-sm border-0 sticky-top" style="top: 20px;">
                    <div class="card-header bg-white py-3">
                        <h6 class="mb-0 fw-bold"><i class="bi bi-grid-fill text-primary me-2"></i>Popular Categories</h6>
                    </div>
                    <div class="card-body">
                        <c:forEach var="categories" items="${sessionScope.categories}">
                            <a href="categories?id=${categories.categoryId}" class="topic-badge w-100 text-center">
                                ${categories.categoryName}
                            </a>
                        </c:forEach>
                        <c:if test="${empty sessionScope.categories}">
                            <div class="text-center py-3">
                                <p class="text-muted small mb-0">No topics found.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                
            </aside>
      
            <div class="col-lg-9">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold mb-0">Popular CheatSheets</h4>
                    <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">
                        <i class="bi bi-fire text-danger me-1"></i> Trending Now
                    </span>
                </div>

                <div class="row">
                    <c:forEach var="sheet" items="${cheatsheet}">
                        <div class="col-md-6 col-xl-4 mb-4">
                            <div class="card h-100 shadow-sm snippet-card" style="background-color: ${sheet.bgColor}; ">
                                <div class="card-body d-flex flex-column">
                                    
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                       <small class="text-uppercase text-primary breadcrumb-text small fw-bold">
                                        ${sheet.categoryName} <i class="bi bi-chevron-right mx-1" style="font-size: 0.7rem;">
                                        </i> ${sheet.topicName}
                                         </small>                       
                                      
                                        <small class="text-muted" style="font-size: 0.75rem;">
                                            <i class="bi bi-calendar3"></i> ${sheet.createdAt}
                                        </small>
                                    </div>

                                    <h5 class="card-title fw-bold text-dark mb-2" style="font-family: ${sheet.fontFamily}">${sheet.title}</h5>
                                    
                                    <p class="card-text text-secondary mb-4 small" style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.6;" style="font-family: ${sheet.fontFamily}">
                                        ${sheet.content}
                                    </p>

                                    <div class="d-flex justify-content-between align-items-center border-top pt-3 mt-auto">
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-person-circle text-secondary me-2"></i>
                                            <span class="fw-semibold text-dark small">${sheet.createdBy}</span>
                                        </div>
                                        <div class="text-muted small">
                                            <i class="bi bi-eye-fill me-1"></i> ${sheet.viewCount}
                                        </div>
                                    </div>
                                </div>
                                 
                                <div class="card-footer bg-white border-0 pb-3 pt-0" style="background: transparent !important;">
                                    <a href="view?id=${sheet.id}" class="btn btn-primary btn-sm w-100 rounded-pill">
                                        View Cheatsheet Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty cheatsheet}">
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-search display-1 text-light"></i>
                            <h5 class="text-muted mt-3">No cheat sheets found</h5>
                            <p class="small text-secondary">Try checking back later or create one yourself!</p>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>
    </main>

    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro -  made easier.</p>
        </div>
    </footer>


    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const hasError = "${sessionScope.error}";
            if (hasError && hasError.trim().length > 0) {
                var loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
                loginModal.show();
            }
        });
    </script>
</body>
</html>
