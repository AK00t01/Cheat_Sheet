<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>My Bookmarked Snippets</title>
    <style>
        .bookmark-shell {
            max-width: 1240px;
        }
        .bookmark-hero {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(15, 111, 255, 0.06));
            border: 1px solid rgba(15, 23, 42, 0.08);
        }
        .bookmark-stats {
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(15, 23, 42, 0.08);
        }
        .snippet-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1px solid rgba(0, 0, 0, 0.08) !important;
            overflow: hidden;
        }
        .snippet-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.12) !important;
        }
        .category-badge {
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }
        .snippet-preview {
            min-height: 88px;
            white-space: pre-wrap;
            display: -webkit-box;
            -webkit-line-clamp: 4;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .snippet-surface {
            color: #111827;
        }
        .snippet-surface .snippet-title,
        .snippet-surface .snippet-topic,
        .snippet-surface .snippet-meta,
        .snippet-surface .snippet-preview {
            color: inherit !important;
        }
        .snippet-surface .snippet-preview {
            background: rgba(255, 255, 255, 0.45);
            border-color: rgba(17, 24, 39, 0.10) !important;
        }
        .snippet-surface[style*="background-color: black"],
        .snippet-surface[style*="background-color: #000000"],
        .snippet-surface[style*="background-color: rgb(0, 0, 0)"] {
            color: #ffffff;
        }
        .snippet-surface[style*="background-color: black"] .snippet-preview,
        .snippet-surface[style*="background-color: #000000"] .snippet-preview,
        .snippet-surface[style*="background-color: rgb(0, 0, 0)"] .snippet-preview {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.16) !important;
        }
        .snippet-meta {
            color: #5f6f86;
        }
        .saved-indicator {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.45rem 0.7rem;
            border-radius: 999px;
            background: rgba(220, 38, 38, 0.08);
            color: #b91c1c;
            font-size: 0.78rem;
            font-weight: 700;
        }
        .empty-card {
            background: linear-gradient(180deg, rgba(255,255,255,0.98), rgba(248,250,252,0.96));
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="container py-5 bookmark-shell">
        
        <div class="bookmark-hero rounded-4 p-4 p-lg-5 mb-5 shadow-sm">
            <div class="d-flex justify-content-between flex-wrap align-items-center gap-3">
                <div>
                    <div class="small text-uppercase fw-bold text-warning mb-2">Saved Content</div>
                    <h1 class="h2 fw-bold text-dark mb-2">
                        <i class="bi bi-heart-fill text-danger me-2"></i>My Bookmarks
                    </h1>
                    <p class="text-muted mb-0">Your personal library of curated code reference cards, frameworks, and tips.</p>
                </div>
                <a href="home" class="btn btn-outline-primary rounded-pill px-4 fw-bold">
                    <i class="bi bi-search me-1"></i> Explore More
                </a>
            </div>
        </div>

        <div class="bookmark-stats rounded-4 p-3 p-lg-4 mb-4 shadow-sm">
            <div class="row g-3 align-items-center">
                <div class="col-lg-8">
                    <div class="fw-semibold text-dark">Keep your best references close.</div>
                    <div class="small text-muted">Bookmarks work like a quick-access reading list for snippets you want to revisit, compare, or reuse later.</div>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">${empty sheets ? 0 : sheets.size()} saved snippets</span>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty sheets}">
                <div class="row justify-content-center py-5">
                    <div class="col-12 col-md-6 text-center">
                        <div class="empty-card p-5 rounded-4 shadow-sm border">
                            <div class="text-danger bg-danger bg-opacity-10 p-4 rounded-circle d-inline-block mb-4">
                                <i class="bi bi-bookmark-dash fs-1 d-flex"></i>
                            </div>
                            <h3 class="fw-bold text-dark mb-2">Your collection is empty</h3>
                            <p class="text-muted mb-4">You haven't bookmarked any cheat sheets yet. When viewing a snippet, click the heart icon to save it here for fast offline access.</p>
                            <a href="home" class="btn btn-primary fw-bold px-4 shadow-sm">
                                Browse Trending Snippets
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="snippet" items="${sheets}">
                        <div class="col-12 col-md-6 col-lg-4">
                            <div class="card snippet-card snippet-surface h-100 rounded-3 shadow-sm" style="background-color: ${snippet.bgColor}; font-family: ${snippet.fontFamily};">
                                <div class="card-body p-4 d-flex flex-column justify-content-between">
                                    
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="d-flex flex-wrap align-items-center gap-2">
                                                <span class="badge bg-light text-primary border category-badge text-uppercase fw-bold px-2 py-1">
                                                    <c:out value="${snippet.categoryName}"/>
                                                </span>
                                                <span class="saved-indicator">
                                                    <i class="bi bi-heart-fill"></i> Saved
                                                </span>
                                            </div>
                                            <small class="snippet-topic font-monospace"><c:out value="${snippet.topicName}"/></small>
                                        </div>
                                        
                                        <h5 class="snippet-title fw-bold mb-2 mt-2">
                                            <c:out value="${snippet.title}"/>
                                        </h5>
                                        
                                        <div class="p-3 rounded border font-monospace small mb-3 snippet-preview" style="background-color: ${snippet.bgColor}; font-family: ${snippet.fontFamily};">
                                            <c:out value="${snippet.content}"/>
                                        </div>
                                    </div>
                                    
                                    <div class="mt-3 pt-3 border-top">
                                        <div class="d-flex justify-content-between align-items-center small snippet-meta mb-3">
                                            <span><i class="bi bi-person me-1"></i> <c:out value="${snippet.createdBy}"/></span>
                                            <span><i class="bi bi-eye me-1"></i> <c:out value="${snippet.viewCount}"/></span>
                                        </div>
                                        
                                        <div class="row g-2">
                                            <div class="col-8">
                                                <a href="view?id=${snippet.id}" class="btn btn-sm btn-primary w-100 fw-bold py-2 rounded-pill">
                                                    <i class="bi bi-box-arrow-up-right me-1"></i> View Cheatsheet Details
                                                </a>
                                            </div>
                                            <div class="col-4">
                                                <button type="button" class="btn btn-sm btn-outline-danger w-100 py-2 rounded-pill" 
                                                        onclick="removeBookmark('${snippet.id}', this)" title="Remove Bookmark">
                                                    <i class="bi bi-trash3"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
        <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro - Coding made easier.</p>
        </div>
    </footer>

    <script>
        function removeBookmark(snippetId, buttonElement) {
            if (confirm("Are you sure you want to remove this snippet from your bookmarks?")) {
                fetch('bookmark?id=' + snippetId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.status !== "added") {
                        const cardColumn = buttonElement.closest('.col-12');
                        cardColumn.style.transition = 'all 0.3s ease';
                        cardColumn.style.opacity = '0';
                        cardColumn.style.transform = 'scale(0.9)';
                        
                        setTimeout(() => {
                            cardColumn.remove();
                            if (document.querySelectorAll('.snippet-card').length === 0) {
                                window.location.reload();
                            }
                        }, 300);
                    }
                })
                .catch(err => console.error("Error updating bookmark state:", err));
            }
        }
    </script>
</body>
</html>
