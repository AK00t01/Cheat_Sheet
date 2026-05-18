<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>Search Results | CheatSheet Pro</title>
    <style>
        .result-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .result-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1) !important;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="container py-5">
        <div class="mb-4">
            <p class="text-muted small mb-1">Search Matrix Results</p>
            <h3 class="fw-bold text-dark">
                <i class="bi bi-search text-primary me-2"></i>
                Showing results for: <span class="text-primary">"<c:out value="${searchQuery}"/>"</span>
            </h3>
            <span class="badge bg-secondary rounded-pill px-3">${resultsList.size()} matches discovered</span>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${empty resultsList}">
                    <div class="col-12 text-center py-5">
                        <div class="p-5 bg-white rounded-4 border shadow-sm max-width-md mx-auto">
                            <i class="bi bi-folder-x text-muted fs-1 d-block mb-3"></i>
                            <h5 class="fw-bold">No exact matches found</h5>
                            <p class="text-muted">We couldn't find any snippets, categories, or developer tags matching your search query. Try checking your spelling or using different keywords.</p>
                            <a href="dashboard.jsp" class="btn btn-outline-primary rounded-pill fw-bold px-4 mt-2">
                                Return to Dashboard
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
<c:forEach var="item" items="${resultsList}">
    <div class="col-md-6 col-lg-4">
        <div class="card result-card h-100 border-0 shadow-sm rounded-3" 
             style="background-color: <c:out value='${not empty item.bgColor ? item.bgColor : \"#ffffff\"}'/> !important;">
            
            <div class="card-body p-4 d-flex flex-column justify-content-between">
                <div>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-10 px-2 py-1 small text-uppercase">
                            <c:out value="${item.categoryName}"/>
                        </span>
                        
                        <small class="text-muted">
                            <i class="bi bi-person-circle"></i> 
                            <a href="my-cheatsheets?userId=${item.userId}" class="text-decoration-none text-secondary ms-1 fw-semibold">
                                @<c:out value="${item.createdBy}"/>
                            </a>
                        </small>
                    </div>
                    
                    <h5 class="fw-bold text-dark mb-2"><c:out value="${item.title}"/></h5>
                    
                    <p class="text-muted small text-overflow-3 mb-0" 
                       style="display: -webkit-box; 
                              -webkit-line-clamp: 3; 
                              -webkit-box-orient: vertical; 
                              overflow: hidden; 
                              font-family: <c:out value='${not empty item.fontFamily ? item.fontFamily : \"monospace\"}'/>; 
                              background: rgba(0, 0, 0, 0.04); 
                              padding: 10px; 
                              border-radius: 6px;">
                        <c:out value="${item.content}"/>
                    </p>
                </div>
                
                <div class="mt-4">
                    <a href="view?id=${item.id}" class="btn btn-sm btn-primary w-100 fw-bold rounded-pill shadow-sm">
                        View Full CheatSheet <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>