<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>My Cheat Sheets</title>
        <%@ include file="Header.jsp" %>
<style type="text/css">
              .snippet-card {
            transition: transform 0.2s;
            border: none;
            border-radius: 12px;
        }
        .snippet-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
 </style>       
</head>        
    

<body class="bg-light">

    <!-- Assuming you have a standard topbar -->
    <%@ include file="Topbar.jsp"%>]

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold">My Snippets</h2>
            <a href="creat-sheet" class="btn btn-success">
                <i class="bi bi-plus-lg"></i> Create New
            </a>
        </div>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <c:forEach var="s" items="${myList}">
                <div class="col">
                    <!-- Dynamic Background and Font from your database -->
                    <div class="card h-100 shadow-sm border-0 snippet-card" 
                         style="background-color: ${s.bgColor}; font-family: ${s.fontFamily};">
                        
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                               ${s.categoryName} <i class="bi bi-chevron-right mx-1" style="font-size: 0.7rem;">
                                        </i> ${s.topic} 
                                        <small class="text-muted">${s.createdAt}</small>
                            </div>
                            
                            <h5 class="card-title fw-bold">${s.title}</h5>
                            <p class="card-text text-truncate" style="max-height: 3.6em; overflow: hidden;">
                                ${s.content}
                            </p>
                            
                            <!-- Rating Section -->
                            <div class="text-warning mb-2">
                                <i class="bi bi-star-fill"></i> ${s.rating} 
                                <span class="text-muted small">(${s.userCounts} reviews)</span>
                            </div>
                        </div>

                        <div class="card-footer bg-transparent border-top-0 d-flex justify-content-between align-items-center pb-3">
                            <small class="text-muted">
                                <i class="bi bi-eye"></i> ${s.viewCount} views
                            </small>
                            <div class="btn-group">
                                <a href="view?id=${s.sheetId}" class="btn btn-sm btn-outline-dark">View</a>
                                <a href="edit?id=${s.sheetId}" class="btn btn-sm btn-outline-primary">Edit</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty myList}">
            <div class="text-center mt-5">
                <i class="bi bi-file-earmark-plus fs-1 text-muted"></i>
                <p class="text-muted mt-2">You haven't created any snippets yet.</p>
            </div>
        </c:if>
    </div>

</body>
</html>