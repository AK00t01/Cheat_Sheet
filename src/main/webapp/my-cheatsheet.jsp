<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>User Profile | CheatSheet Pro</title>
    <style>
        .profile-avatar {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, #0f6fff 0%, #12b981 100%);
            color: white;
            font-size: 2.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            box-shadow: 0 4px 10px rgba(15, 111, 255, 0.2);
        }
        .sheet-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1px solid rgba(0,0,0,0.05) !important;
        }
        .sheet-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.12) !important;
        }
        .breadcrumb-badge {
            font-size: 0.72rem;
            font-weight: 600;
            background: rgba(0, 0, 0, 0.05);
            padding: 4px 10px;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="container py-5">
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-5 bg-white">
            <div class="d-flex align-items-center flex-wrap gap-4">
                <div class="profile-avatar fw-bold">
                    ${fn:substring(user.name, 0, 1).toUpperCase()}
                </div>
                <div>
                    <h2 class="fw-bold text-dark mb-1"><c:out value="${user.name}" /></h2>
                    <p class="text-muted mb-2"><i class="bi bi-envelope me-1"></i> <c:out value="${user.email}" /></p>
                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill small">
                        <i class="bi bi-shield-check me-1"></i>${user.role} Account
                    </span>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold text-dark m-0">
                <i class="bi bi-grid-1x2-fill text-primary me-2"></i>My Created Contributions
            </h4>
            <span class="badge bg-dark rounded-pill px-3">${myList.size()} Sheets</span>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${empty myList}">
                    <div class="col-12 text-center py-5">
                        <div class="p-5 bg-white rounded-4 border shadow-sm">
                            <i class="bi bi-journal-plus text-muted fs-1 d-block mb-3"></i>
                            <h5 class="fw-bold">No cheat sheets created yet</h5>
                            <p class="text-muted mb-4">Share your knowledge by creating your first reference card card block framework.</p>
                            <a href="create-cheatsheet.jsp" class="btn btn-primary fw-bold px-4 rounded-pill">
                                + Create New Sheet
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="sheet" items="${myList}">
                        <div class="col-md-6 col-lg-4">
                            <div class="card sheet-card h-100 border-0 shadow-sm rounded-3" 
                                 style="background-color: <c:out value='${not empty sheet.bgColor ? sheet.bgColor : \"#ffffff\"}' /> !important;">
                                
                                <div class="card-body p-4 d-flex flex-column justify-content-between"
                                     style="font-family: <c:out value='${not empty sheet.fontFamily ? sheet.fontFamily : \"inherit\"}' /> !important;">
                                    
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div class="breadcrumb-badge text-secondary">
                                                <span class="text-dark fw-bold"><c:out value="${sheet.categoryName}"/></span>
                                                <i class="bi bi-chevron-right text-muted" style="font-size: 0.65rem;"></i>
                                                <span><c:out value="${sheet.topic}"/></span>
                                            </div>
                                            <small class="text-muted"><i class="bi bi-eye"></i> ${sheet.viewCount}</small>
                                        </div>
                                        
                                        <h5 class="fw-bold text-dark mb-2"><c:out value="${sheet.title}"/></h5>
                                    </div>
                                    
                                    <div class="d-flex gap-2 mt-4 pt-3 border-top border-dark border-opacity-10">
                                        <a href="view?id=${sheet.sheetId}" class="btn btn-sm btn-outline-dark w-100 fw-bold bg-white bg-opacity-20">
                                            View Card
                                        </a>
                                        <a href="edit?id=${sheet.sheetId}" class="btn btn-sm btn-light border bg-white bg-opacity-50" title="Edit Content">
                                            <i class="bi bi-pencil-square"></i>
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
        <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro - Coding made easier.</p>
        </div>
    </footer>
</body>
</html>