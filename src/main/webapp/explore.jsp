<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>Explore Snippets</title>
    <style type="text/css">
        .filter-hero {
            background: linear-gradient(135deg, rgba(15,111,255,0.10), rgba(18,185,129,0.10));
            border: 1px solid rgba(15, 23, 42, 0.08);
        }
        .snippet-card {
            transition: transform 0.2s, box-shadow 0.2s;
            overflow: hidden;
        }
        .snippet-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 18px 38px rgba(15,23,42,0.14) !important;
        }
    </style>
</head>
<body class="bg-light">

    <%@ include file="Topbar.jsp" %>
  

    <div class="container mt-4 mb-5">
        <div class="filter-hero rounded-4 p-4 p-lg-5 mb-4 shadow-sm">
            <div class="row g-4 align-items-center">
                <div class="col-lg-8">
                    <div class="small text-uppercase fw-bold text-primary mb-2">Explore</div>
                    <h1 class="h2 fw-bold mb-2">Narrow the library by topic, then open any snippet instantly</h1>
                    <p class="text-muted mb-0">Use the topic chips to filter faster, or jump straight into the detail pages to read full code and notes.</p>
                </div>
                <div class="col-lg-4">
                    <div class="bg-white rounded-4 p-3 shadow-sm border">
                        <div class="small text-muted mb-1">Current view</div>
                        <div class="fw-semibold">${empty sheets ? 'No snippets loaded yet' : 'Snippets ready to browse'}</div>
                    </div>
                </div>
            </div>
        </div>

<%--         <div class="mb-5">
            <h4 class="fw-bold mb-3">Filter by Topic</h4>
            <div class="d-flex flex-wrap gap-2">
                <c:forEach var="t" items="${topic}">
                    <a href="categories?id=${t.topicId}" class="btn btn-outline-primary rounded-pill px-4">
                        ${t.topicName}
                    </a>
                </c:forEach>
            </div>
        </div> --%>

        <hr>

        <!-- Snippets Grid -->
        <h4 class="fw-bold mb-4">Available Snippets</h4>
        <div class="row row-cols-1 row-cols-md-3 g-4" >
            <c:forEach var="s" items="${sheets}">
                <div class="col">
                    <div class="card h-100 shadow-sm border-0 snippet-card" style="background-color: ${s.bgColor}; font-family: ${s.fontFamily};">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="badge bg-light text-dark border">${s.topicName}</span>
                                <small class="text-muted"><i class="bi bi-eye me-1"></i>${s.viewCount}</small>
                            </div>
                            <h5 class="card-title fw-bold">${s.title}</h5>
                            <p class="card-text text-muted small">
                                ${s.content.length() > 100 ? s.content.substring(0, 100).concat('...') : s.content}
                            </p>
                        </div>
                        <div class="card-footer bg-white border-top-0 d-flex justify-content-end align-items-center pb-3">
                            <a href="view?id=${s.id}" class="btn btn-sm btn-primary px-3 rounded-pill">View Details</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty sheets}">
                <div class="col-12 text-center py-5">
                    <i class="bi bi-folder-x fs-1 text-muted"></i>
                    <p class="mt-3 text-muted">No snippets found in this category.</p>
                </div>
            </c:if>
        </div>
    </div>
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro - Coding made easier.</p>
        </div>
    </footer>
</body>
</html>
