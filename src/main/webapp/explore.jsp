<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <style type="text/css">
            .snippet-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
        }
    </style>
</head>
<body class="bg-light">

    <%@ include file="Topbar.jsp" %>
  

    <div class="container mt-4">
        <!-- Sub-Categories (Topics) Section -->
        <div class="mb-5">
            <h4 class="fw-bold mb-3">Filter by Topic</h4>
            <div class="d-flex flex-wrap gap-2">
                <c:forEach var="t" items="${topic}">
                    <a href="topic?id=${t.topicId}" class="btn btn-outline-primary rounded-pill px-4">
                        ${t.topicName}
                    </a>
                </c:forEach>
            </div>
        </div>

        <hr>

        <!-- Snippets Grid -->
        <h4 class="fw-bold mb-4">Available Snippets</h4>
        <div class="row row-cols-1 row-cols-md-3 g-4" >
            <c:forEach var="s" items="${sheets}">
                <div class="col">
                    <div class="card h-100 shadow-sm border-0 snippet-card" style="background-color: ${s.bgColor}; font-family: ${s.fontFamily}; transition: transform 0.2s;">
                        <div class="card-body">
                            <h5 class="card-title fw-bold">${s.title}</h5>
                            <p class="card-text text-muted small">
                                ${s.content.length() > 100 ? s.content.substring(0, 100).concat('...') : s.content}
                            </p>
                        </div>
                        <div class="card-footer bg-white border-top-0 d-flex justify-content-between align-items-center pb-3">
                            <small class="text-muted">
                                <i class="bi bi-eye"></i> ${s.viewCount} views
                            </small>
                            <a href="view?id=${s.id}" class="btn btn-sm btn-primary px-3">View Details</a>
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

</body>
</html>