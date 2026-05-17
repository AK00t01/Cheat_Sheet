<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>${detail.title}</title>
    <style>
        /* Smooth transition for the heart icon */
        #bookmarkIcon {
            transition: transform 0.2s ease-in-out;
            cursor: pointer;
        }
        #bookmarkIcon:active {
            transform: scale(1.3);
        }
        /* Custom styling for the code block container */
        .code-container {
            position: relative;
        }
        .code-container .copy-btn {
            z-index: 10;
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                
                <div class="card shadow-sm border-0 mb-4" style="background-color: ${detail.bgColor}; font-family: ${detail.fontFamily};">
                    <div class="card-body p-4">
                        
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <small class="text-uppercase fw-bold text-primary">
                                ${detail.categoryName} <i class="bi bi-chevron-right mx-1"></i> ${detail.topic}
                            </small>

                            <div class="d-flex align-items-center">
                                <button class="btn btn-link text-danger p-0 border-0 me-3" type="button" 
                                        onclick="toggleBookmark('${detail.sheetId}')" title="Bookmark this">
                                    <i id="bookmarkIcon" class="bi ${isBookmarked ? 'bi-heart-fill' : 'bi-heart'} fs-5"></i>
                                </button>

                                <div class="text-warning me-3">
                                    <i class="bi bi-star-fill"></i> ${rate.rating != null ? rate.rating : '0.0'} 
                                    <span class="text-muted small">(${rate.userCounts!= null ? rate.userCounts : '0'})</span>
                                </div>

                                <div class="dropdown">
                                    <button class="btn btn-link text-dark p-0 border-0" type="button" 
                                            id="snippetMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-three-dots-vertical fs-5"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                                        <c:if test="${sessionScope.user.id == detail.userId}"> 
                                            <li>
                                                <a class="dropdown-item text-primary" href="edit?id=${detail.sheetId}">
                                                    <i class="bi bi-pencil-square me-2"></i> Edit Snippet
                                                </a>
                                            </li>
                                            <li>
                                                <a class="dropdown-item text-danger" href="delete?id=${detail.sheetId}" 
                                                   onclick="return confirm('Delete this snippet forever?')">
                                                    <i class="bi bi-trash me-2"></i> Delete
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                        </c:if>
                                        <li>
                                            <a class="dropdown-item" href="#" onclick="window.print()">
                                                <i class="bi bi-printer me-2"></i> Print Snippet
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item text-warning" href="report?id=${detail.sheetId}">
                                                <i class="bi bi-flag me-2"></i> Report
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <h1 class="fw-bold mb-3">${detail.title}</h1>
                        <hr>
                        
                        <div class="code-container">
                            <button class="btn btn-sm btn-outline-light copy-btn position-absolute top-0 end-0 mt-2 me-2 opacity-50 hover-opacity-100" 
                                    onclick="copyCode()" id="copyBtn">
                                <i class="bi bi-clipboard"></i> Copy
                            </button>
                            <pre id="snippetCode" class="bg-dark text-light p-4 rounded shadow-inner" 
                                 style="white-space: pre-wrap; font-family: 'Courier New', Courier, monospace;"><code><c:out value="${detail.content}" /></code></pre>
                        </div>
                        
                        <div class="mt-4 pt-3 border-top d-flex justify-content-between text-muted small">
                            <span><i class="bi bi-person"></i> ${detail.createdBy}</span>
                            <span><i class="bi bi-calendar3"></i> ${detail.createdAt}</span>
                            <span><i class="bi bi-eye"></i> ${detail.viewCount} views</span>
                        </div>
                    </div>
                </div>

                <div class="mb-4 bg-white p-3 rounded shadow-sm border">
                    <label class="form-label fw-bold text-dark mb-0">Your Rating:</label>
                    <form action="rate" method="post" class="d-inline ms-2">
                        <input type="hidden" name="snippetId" value="${detail.sheetId}">
                        <div class="btn-group" role="group">
                            <c:forEach var="i" begin="1" end="5">
                                <input type="radio" class="btn-check" name="rating" id="star${i}" value="${i}" 
                                       ${userRating == i ? 'checked' : ''} onchange="this.form.submit()">
                                <label class="btn btn-sm ${userRating >= i ? 'btn-warning active' : 'btn-outline-warning'}" for="star${i}">
                                    <i class="bi ${userRating >= i ? 'bi-star-fill' : 'bi-star'}"></i>
                                </label>
                            </c:forEach>
                        </div>
                    </form>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <h4 class="fw-bold mb-4">Discussion</h4>

                        <c:if test="${not empty sessionScope.success}">
                            <div class="alert alert-success py-2 small">${sessionScope.success}</div>
                            <c:remove var="success" scope="session" />
                        </c:if>

                        <div class="mb-5">
                            <form action="post-comment" method="post">
                                <input type="hidden" name="snippetId" value="${detail.sheetId}">
                                <div class="mb-3">                  
                                    <textarea name="commentText" class="form-control" rows="3" placeholder="Join the discussion..." required></textarea>
                                </div>
                                <div class="text-end">
                                    <button type="submit" class="btn btn-primary fw-bold px-4">Post Comment</button>
                                </div>
                            </form>
                        </div>   

                        <c:choose>
                            <c:when test="${empty comments}">
                                <p class="text-muted fst-italic">No comments yet.</p>
                            </c:when>
                            <c:otherwise>                                           
                                <c:forEach var="comment" items="${comments}">
                                    <c:set var="currentComment" value="${comment}" scope="request" />
                                    <jsp:include page="comment_item.jsp" />
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script>
// ==========================================
// 1. GLOBAL TRACKING MAPS FOR TIMERS
// ==========================================
let activeCommentTimers = {};
let activeCommentIntervals = {};
let snippetUndoTimeout;

// ==========================================
// 2. COMMENT SOFT-DELETE & UNDO LOGIC
// ==========================================
function initiateCommentDelete(commentId) {
    const cardElement = document.getElementById('commentCard-' + commentId);
    const alertElement = document.getElementById('commentUndoAlert-' + commentId);
    const countdownElement = document.getElementById('commentCountdown-' + commentId);
    
    // Swap components visually
    cardElement.classList.add('d-none');
    alertElement.classList.remove('d-none');
    alertElement.classList.add('d-flex');

    // Initialize countdown variable
    let timeLeft = 10;
    countdownElement.innerText = "(" + timeLeft + "s remaining)";
    // Start a 1-second repeating interval to update the countdown text
    activeCommentIntervals[commentId] = setInterval(function() {
        timeLeft--;
        if (timeLeft > 0) {
        	countdownElement.innerText = "(" + timeLeft + "s remaining)";
        	} else {
            clearInterval(activeCommentIntervals[commentId]);
            delete activeCommentIntervals[commentId];
        }
    }, 1000);

    // Set final 10-second absolute execution timeout
    activeCommentTimers[commentId] = setTimeout(function() {
        executeCommentDatabaseAction(commentId, 'delete');
        
        // Remove the element completely from the webpage DOM
        const wrapper = document.getElementById('commentWrapper-' + commentId);
        if (wrapper) wrapper.remove();
        
        // Clean up tracking references
        delete activeCommentTimers[commentId];
        if (activeCommentIntervals[commentId]) {
            clearInterval(activeCommentIntervals[commentId]);
            delete activeCommentIntervals[commentId];
        }
    }, 10000); 
}

function undoCommentDelete(commentId) {
    // Abort the 10-second DB delete action
    if (activeCommentTimers[commentId]) {
        clearTimeout(activeCommentTimers[commentId]);
        delete activeCommentTimers[commentId];
    }
    
    // Abort the 1-second interval loop text updater
    if (activeCommentIntervals[commentId]) {
        clearInterval(activeCommentIntervals[commentId]);
        delete activeCommentIntervals[commentId];
    }
    
    const cardElement = document.getElementById('commentCard-' + commentId);
    const alertElement = document.getElementById('commentUndoAlert-' + commentId);
    
    // Swap elements back to show original comment bubble safely
    alertElement.classList.remove('d-flex');
    alertElement.classList.add('d-none');
    cardElement.classList.remove('d-none');
}

function executeCommentDatabaseAction(commentId, actionType) {
    let params = new URLSearchParams();
    params.append('id', commentId);
    params.append('action', actionType);

    fetch('modify-comment', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(data => {
        if (!data.success) {
            console.error("Database synchronization failed for action: " + actionType);
        }
    })
    .catch(error => console.error("Network sync error:", error));
}

function toggleReplyForm(commentId) {
    const form = document.getElementById('replyForm-' + commentId);
    form.classList.toggle('d-none');
    if (!form.classList.contains('d-none')) {
        form.querySelector('input').focus();
    }
}

// ==========================================
// 3. SNIPPET (CHEATSHEET) SOFT-DELETE LOGIC
// ==========================================
function requestDelete(snippetId) {
    // Dim the main snippet card to show it's pending deletion
    const card = document.querySelector('.card.shadow-sm.mb-4');
    card.style.transition = 'opacity 0.5s';
    card.style.opacity = '0.2';
    card.style.pointerEvents = 'none';

    // Show the Snippet Undo Toast banner
    const toastEl = document.getElementById('deleteToast');
    const toast = new bootstrap.Toast(toastEl, { autohide: false });
    toast.show();

    // Fire actual DB delete query if they don't click undo within 10 seconds
    snippetUndoTimeout = setTimeout(() => {
        fetch('delete-snippet?id=' + snippetId, { method: 'POST' })
            .then(() => {
                window.location.href = 'home?msg=Deleted';
            });
    }, 10000);
}

function undoDelete(snippetId) {
    // Clear out execution timer
    clearTimeout(snippetUndoTimeout);
    
    // Hide Toast banner UI and restore card view state
    const toastEl = document.getElementById('deleteToast');
    const toast = bootstrap.Toast.getInstance(toastEl);
    if (toast) toast.hide();

    const card = document.querySelector('.card.shadow-sm.mb-4');
    card.style.opacity = '1';
    card.style.pointerEvents = 'auto';
    
    // Notify server to cancel/clear the deleted_at flag
    fetch('restore-snippet?id=' + snippetId, { method: 'POST' });
}

// ==========================================
// 4. BOOKMARK TOGGLE (AJAX LOGIC)
// ==========================================
function toggleBookmark(snippetId) {
    const icon = document.getElementById('bookmarkIcon');
    
    fetch('bookmark?id=' + snippetId, { method: 'POST' })
    .then(res => res.json())
    .then(data => {
        if (data.status === "added") {
            icon.classList.replace('bi-heart', 'bi-heart-fill');
        } else {
            icon.classList.replace('bi-heart-fill', 'bi-heart');
        }
    })
    .catch(() => alert("Please login to bookmark items!"));
}

// ==========================================
// 5. UTILITY: COPY TO CLIPBOARD
// ==========================================
function copyCode() {
    const codeText = document.getElementById("snippetCode").innerText;
    const btn = document.getElementById("copyBtn");
    
    navigator.clipboard.writeText(codeText).then(() => {
        const original = btn.innerHTML;
        btn.innerHTML = '<i class="bi bi-check2"></i> Copied!';
        btn.classList.replace('btn-outline-light', 'btn-success');
        
        setTimeout(() => {
            btn.innerHTML = original;
            btn.classList.replace('btn-success', 'btn-outline-light');
        }, 2000);
    }).catch(err => console.error("Clipboard copy failed", err));
}
</script>
</body>
</html>