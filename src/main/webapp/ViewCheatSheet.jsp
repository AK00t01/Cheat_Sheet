<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>${detail.title}</title>
    <style>
        .detail-shell {
            max-width: 1100px;
        }
        #bookmarkIcon {
            transition: transform 0.2s ease-in-out;
            cursor: pointer;
        }
        #bookmarkIcon:active {
            transform: scale(1.3);
        }
        .detail-card {
            overflow: hidden;
            color: #111827;
        }
        .detail-kicker {
            color: #111827;
        }
        .detail-summary {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.55rem 0.9rem;
            border-radius: 999px;
            background: rgba(17, 24, 39, 0.08);
            border: 1px solid rgba(17, 24, 39, 0.12);
            color: #111827;
        }
        .detail-summary-count {
            color: #111827;
        }
        .detail-menu-btn {
            color: #111827;
        }
        .detail-divider {
            border-color: rgba(17, 24, 39, 0.18);
            opacity: 1;
        }
        .detail-meta {
            color: #111827;
        }
        .code-container {
            position: relative;
        }
        .code-container .copy-btn {
            z-index: 10;
        }
        .dynamic-code-block {
            color: #212529;
            border-color: rgba(0, 0, 0, 0.1) !important;
        }
        #snippetCode code {
            color: inherit;
        }
        .card[style*="background-color: black"], 
        .card[style*="background-color: #000000"],
        .card[style*="background-color: rgb(0, 0, 0)"] {
            color: #ffffff !important;
        }
        .card[style*="background-color: black"] .detail-kicker,
        .card[style*="background-color: #000000"] .detail-kicker,
        .card[style*="background-color: rgb(0, 0, 0)"] .detail-kicker,
        .card[style*="background-color: black"] .detail-summary,
        .card[style*="background-color: #000000"] .detail-summary,
        .card[style*="background-color: rgb(0, 0, 0)"] .detail-summary,
        .card[style*="background-color: black"] .detail-summary-count,
        .card[style*="background-color: #000000"] .detail-summary-count,
        .card[style*="background-color: rgb(0, 0, 0)"] .detail-summary-count,
        .card[style*="background-color: black"] .detail-menu-btn,
        .card[style*="background-color: #000000"] .detail-menu-btn,
        .card[style*="background-color: rgb(0, 0, 0)"] .detail-menu-btn,
        .card[style*="background-color: black"] .detail-meta,
        .card[style*="background-color: #000000"] .detail-meta,
        .card[style*="background-color: rgb(0, 0, 0)"] .detail-meta {
            color: #ffffff !important;
        }
        .card[style*="background-color: black"] .detail-summary,
        .card[style*="background-color: #000000"] .detail-summary,
        .card[style*="background-color: rgb(0, 0, 0)"] .detail-summary {
            background: rgba(255,255,255,0.14);
            border-color: rgba(255,255,255,0.18);
        }
        .card[style*="background-color: black"] .detail-divider,
        .card[style*="background-color: #000000"] .detail-divider,
        .card[style*="background-color: rgb(0, 0, 0)"] .detail-divider {
            border-color: rgba(255, 255, 255, 0.24);
        }
        .card[style*="background-color: black"] .dynamic-code-block, 
        .card[style*="background-color: #000000"] .dynamic-code-block,
        .card[style*="background-color: rgb(0, 0, 0)"] .dynamic-code-block {
            color: #ffffff !important;
            border-color: rgba(255, 255, 255, 0.2) !important;
        }
        .card[style*="background-color: black"] .dynamic-btn, 
        .card[style*="background-color: #000000"] .dynamic-btn,
        .card[style*="background-color: rgb(0, 0, 0)"] .dynamic-btn {
            color: #ffffff !important;
            border-color: #ffffff !important;
        }
        .guest-banner {
            border: 1px dashed rgba(15, 111, 255, 0.28);
            background: linear-gradient(135deg, rgba(15,111,255,0.08), rgba(18,185,129,0.06));
        }
        @media print {
            body {
                background: #ffffff !important;
            }
            body * {
                visibility: hidden !important;
            }
            .print-only,
            .print-only * {
                visibility: visible !important;
            }
            .print-only {
                display: block !important;
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                padding: 0;
                margin: 0;
                background: #ffffff !important;
                color: #000000 !important;
            }
            .print-title {
                font-size: 24pt;
                line-height: 1.25;
                font-weight: 700;
                margin: 0 0 1rem 0;
                color: #000000 !important;
            }
            .print-content {
                white-space: pre-wrap;
                font-size: 11pt;
                line-height: 1.5;
                color: #000000 !important;
                background: #ffffff !important;
                border: none !important;
                padding: 0 !important;
                margin: 0 !important;
            }
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="print-only d-none">
        <h1 class="print-title">${detail.title}</h1>
        <pre class="print-content"><code><c:out value="${detail.content}" /></code></pre>
    </div>

    <div class="container my-5 detail-shell">
        <c:if test="${empty sessionScope.user}">
            <div class="guest-banner rounded-4 p-4 mb-4 shadow-sm">
                <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
                    <div>
                        <div class="small text-uppercase fw-bold text-primary mb-2">Guest Preview Mode</div>
                        <h2 class="h5 fw-bold mb-1">You can view this snippet without logging in.</h2>
                        <p class="text-muted mb-0">Sign in when you want to bookmark, rate, comment, report, edit, or create your own content.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-primary px-4" data-bs-toggle="modal" data-bs-target="#loginModal">Login to interact</button>
                        <button type="button" class="btn btn-outline-primary px-4" data-bs-toggle="modal" data-bs-target="#registerModal">Create account</button>
                    </div>
                </div>
            </div>
        </c:if>
        <div class="row justify-content-center">
            <div class="col-lg-9">
                
                <div class="card detail-card shadow-sm border-0 mb-4" style="background-color: ${detail.bgColor}; font-family: ${detail.fontFamily};">
                    <div class="card-body p-4">
                        
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <small class="text-uppercase fw-bold detail-kicker">
                                ${detail.categoryName} <i class="bi bi-chevron-right mx-1"></i> ${detail.topic}
                            </small>

                            <div class="d-flex align-items-center">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <button class="btn btn-link text-danger p-0 border-0 me-3" type="button" 
                                                onclick="toggleBookmark('${detail.sheetId}')" title="Bookmark this">
                                            <i id="bookmarkIcon" class="bi ${isBookmarked ? 'bi-heart-fill' : 'bi-heart'} fs-5"></i>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-link text-danger p-0 border-0 me-3" type="button" 
                                                onclick="requireLogin('bookmark snippets')" title="Login to bookmark">
                                            <i id="bookmarkIcon" class="bi bi-heart fs-5"></i>
                                        </button>
                                    </c:otherwise>
                                </c:choose>

                                <div class="detail-summary text-warning me-3">
                                    <i class="bi bi-star-fill"></i> ${rate.rating != null ? rate.rating : '0.0'} 
                                    <span class="detail-summary-count small">(${rate.userCounts!= null ? rate.userCounts : '0'})</span>
                                </div>

                                <div class="dropdown">
                                    <button class="btn btn-link detail-menu-btn p-0 border-0" type="button" 
                                            id="snippetMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-three-dots-vertical fs-5"></i>
                                    </button>
<ul class="dropdown-menu dropdown-menu-end shadow border-0">
    <c:if test="${not empty sessionScope.user && sessionScope.user.id == detail.userId}"> 
        <li>
            <a class="dropdown-item text-primary" href="edit?id=${detail.sheetId}">
                <i class="bi bi-pencil-square me-2"></i> Edit Snippet
            </a>
        </li>
        <li>
            <a class="dropdown-item text-danger" href="javascript:void(0);" 
               onclick="requestDelete('${detail.sheetId}')">
                <i class="bi bi-trash me-2"></i> Delete
            </a>
        </li>
        <li><hr class="dropdown-divider"></li>
    </c:if>

<li>
    <a class="dropdown-item" href="#" onclick="printSnippetOnly(); return false;">
        <i class="bi bi-printer me-2"></i> Print Snippet
    </a>
</li>

    <c:if test="${not empty sessionScope.user && sessionScope.user.id != detail.userId}">
        <li>
            <a class="dropdown-item text-warning" href="javascript:void(0);" 
               data-bs-toggle="modal" data-bs-target="#reportModal">
                <i class="bi bi-flag me-2"></i> Report
            </a>
        </li>
    </c:if>
    <c:if test="${empty sessionScope.user}">
        <li>
            <button type="button" class="dropdown-item text-primary" onclick="requireLogin('report snippets')">
                <i class="bi bi-lock me-2"></i> Login to report
            </button>
        </li>
    </c:if>
</ul>
                                </div>
                            </div>
                        </div>

                        <h1 class="fw-bold mb-3" style="font-family: inherit;">${detail.title}</h1>
                        <hr class="detail-divider">
                        
				    <div class="code-container">
				    <button class="btn btn-sm btn-outline-secondary copy-btn position-absolute top-0 end-0 mt-2 me-2 opacity-75 hover-opacity-100 dynamic-btn" 
				            onclick="copyCode()" id="copyBtn">
				        <i class="bi bi-clipboard"></i> Copy
				    </button>
				    
				    <pre id="snippetCode" class="p-4 rounded border dynamic-code-block" 
				         style="white-space: pre-wrap; font-family: ${detail.fontFamily}, monospace; background-color: ${detail.bgColor};"><code><c:out value="${detail.content}" /></code></pre>
				</div>
                        
                        <div class="mt-4 pt-3 border-top d-flex justify-content-between detail-meta small opacity-75">
                            <span><i class="bi bi-person"></i> ${detail.createdBy}</span>
                            <span><i class="bi bi-calendar3"></i> ${detail.createdAt}</span>
                            <span><i class="bi bi-eye"></i> ${detail.viewCount} views</span>
                        </div>
                    </div>
                </div>

                <div class="mb-4 bg-white p-3 rounded shadow-sm border">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                        <div>
                            <label class="form-label fw-bold text-dark mb-1">Your Rating</label>
                            <div class="small text-muted">Save your rating once you're signed in.</div>
                        </div>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <form action="rate" method="post" class="d-inline ms-0 ms-md-2">
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
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn btn-outline-warning" onclick="requireLogin('rate snippets')">
                                    <i class="bi bi-star me-2"></i>Login to rate
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <h4 class="fw-bold mb-4">Discussion</h4>

                        <c:if test="${not empty sessionScope.success}">
                            <div class="alert alert-success py-2 small">${sessionScope.success}</div>
                            <c:remove var="success" scope="session" />
                        </c:if>

                        <div class="mb-5">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <form action="post-comment" method="post">
                                        <input type="hidden" name="snippetId" value="${detail.sheetId}">
                                        <div class="mb-3">                  
                                            <textarea name="commentText" class="form-control" rows="3" placeholder="Join the discussion..." required></textarea>
                                        </div>
                                        <div class="text-end">
                                            <button type="submit" class="btn btn-primary fw-bold px-4">Post Comment</button>
                                        </div>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="border rounded-4 p-4 guest-banner">
                                        <h5 class="fw-bold mb-2">Discussion is open after login</h5>
                                        <p class="text-muted mb-3">Guests can read every comment here, but posting and replying require an account.</p>
                                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#loginModal">Login to comment</button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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

    <div class="toast-container position-fixed bottom-0 start-50 translate-middle-x p-3" style="z-index: 1055;">
        <div id="deleteToast" class="toast align-items-center text-white bg-dark border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex p-2">
                <div class="toast-body">
                    <i class="bi bi-trash3 me-2 text-danger"></i> 
                    <span>Snippet moving to trash. </span>
                    <span id="snippetCountdown" class="text-warning fw-bold ms-1">(10s remaining)</span>
                    <button type="button" class="btn btn-sm btn-warning ms-3 fw-bold text-uppercase" onclick="undoDelete('${detail.sheetId}')">
                        Undo
                    </button>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>
    <div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title fw-bold" id="reportModalLabel">
                    <i class="bi bi-flag-fill me-2"></i> Report Content
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <form action="submit-report" method="post">
                <div class="modal-body p-4">
                    <p class="text-muted small mb-4">Help us keep our community platform safe. Please select the most appropriate reason for your report.</p>
                    
                   <input type="hidden" name="targetId" id="modalTargetId" value="${detail.sheetId}">
                   <input type="hidden" name="targetType" id="modalTargetType" value="snippet">

                    <div class="mb-3">
                        <label for="reasonSelect" class="form-label fw-bold text-dark">Reason for Report</label>
                        <select class="form-select" id="reasonSelect" name="presetReason" onchange="handleReportReasonChange(this)" required>
                            <option value="" disabled selected>Choose a category...</option>
                            <option value="Inaccurate Content">Inaccurate / Broken Code</option>
                            <option value="Spam or Promo">Spam or Advertising</option>
                            <option value="Copyright/Plagiarism">Plagiarism / Copyright Infringement</option>
                            <option value="Inappropriate Profile">Inappropriate Category / Topic</option>
                            <option value="Other">Other (Write custom details below)</option>
                        </select>
                    </div>

                    <div class="mb-2 d-none" id="customReasonWrapper">
                        <label for="customDescription" class="form-label fw-bold text-dark">Additional Details / Custom Reason</label>
                        <textarea class="form-control" id="customDescription" name="customDetails" rows="4" 
                                  placeholder="Provide context to help the admin review this item..."></textarea>
                    </div>
                </div>
                
                <div class="modal-footer bg-light border-top-0 d-flex justify-content-between p-3">
                    <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger px-4 fw-bold">Submit Report</button>
                </div>
            </form>
            
        </div>
    </div>
</div>
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro - Coding made easier.</p>
        </div>
    </footer>

<script>
// ==========================================
// 1. GLOBAL TRACKING MAPS FOR TIMERS
// ==========================================
let activeCommentTimers = {};
let activeCommentIntervals = {};
let snippetUndoTimeout;
let snippetUndoInterval;

// ==========================================
// 2. COMMENT SOFT-DELETE & UNDO LOGIC
// ==========================================
function initiateCommentDelete(commentId) {
    const cardElement = document.getElementById('commentCard-' + commentId);
    const alertElement = document.getElementById('commentUndoAlert-' + commentId);
    const countdownElement = document.getElementById('commentCountdown-' + commentId);
    
    cardElement.classList.add('d-none');
    alertElement.classList.remove('d-none');
    alertElement.classList.add('d-flex');

    let timeLeft = 10;
    countdownElement.innerText = "(" + timeLeft + "s remaining)";
    
    activeCommentIntervals[commentId] = setInterval(function() {
        timeLeft--;
        if (timeLeft > 0) {
            countdownElement.innerText = "(" + timeLeft + "s remaining)";
        } else {
            clearInterval(activeCommentIntervals[commentId]);
            delete activeCommentIntervals[commentId];
        }
    }, 1000);

    activeCommentTimers[commentId] = setTimeout(function() {
        executeCommentDatabaseAction(commentId, 'delete');
        
        const wrapper = document.getElementById('commentWrapper-' + commentId);
        if (wrapper) wrapper.remove();
        
        delete activeCommentTimers[commentId];
        if (activeCommentIntervals[commentId]) {
            clearInterval(activeCommentIntervals[commentId]);
            delete activeCommentIntervals[commentId];
        }
    }, 10000); 
}

function undoCommentDelete(commentId) {
    if (activeCommentTimers[commentId]) {
        clearTimeout(activeCommentTimers[commentId]);
        delete activeCommentTimers[commentId];
    }
    
    if (activeCommentIntervals[commentId]) {
        clearInterval(activeCommentIntervals[commentId]);
        delete activeCommentIntervals[commentId];
    }
    
    const cardElement = document.getElementById('commentCard-' + commentId);
    const alertElement = document.getElementById('commentUndoAlert-' + commentId);
    
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
    const card = document.querySelector('.card.shadow-sm.mb-4');
    card.style.transition = 'opacity 0.5s';
    card.style.opacity = '0.2';
    card.style.pointerEvents = 'none';

    const countdownElement = document.getElementById('snippetCountdown');
    const toastEl = document.getElementById('deleteToast');
    const toast = new bootstrap.Toast(toastEl, { autohide: false });
    
    let timeLeft = 10;
    countdownElement.innerText = "(" + timeLeft + "s remaining)";
    toast.show();

    snippetUndoInterval = setInterval(function() {
        timeLeft--;
        if (timeLeft > 0) {
            countdownElement.innerText = "(" + timeLeft + "s remaining)";
        } else {
            clearInterval(snippetUndoInterval);
        }
    }, 1000);

    snippetUndoTimeout = setTimeout(() => {
        let params = new URLSearchParams();
        params.append('id', snippetId);
        params.append('action', 'delete');

        fetch('modify-cheatsheet', { 
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                window.location.href = 'home?msg=Deleted';
            } else {
                console.error("Failed to soft-delete snippet on server.");
            }
        })
        .catch(error => console.error("Network sync error during snippet deletion:", error));
    }, 10000);
}

function undoDelete(snippetId) {
    clearTimeout(snippetUndoTimeout);
    clearInterval(snippetUndoInterval);
    
    const toastEl = document.getElementById('deleteToast');
    const toast = bootstrap.Toast.getInstance(toastEl);
    if (toast) toast.hide();

    const card = document.querySelector('.card.shadow-sm.mb-4');
    card.style.opacity = '1';
    card.style.pointerEvents = 'auto';
    
    let params = new URLSearchParams();
    params.append('id', snippetId);
    params.append('action', 'restore');

    fetch('modify-cheatsheet', { 
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
    });
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

function requireLogin(actionName) {
    const modalElement = document.getElementById('loginModal');
    const message = actionName ? 'Please login to ' + actionName + '.' : 'Please login first.';

    if (modalElement) {
        const alertHost = modalElement.querySelector('.modal-body');
        if (alertHost) {
            let notice = document.getElementById('loginActionNotice');
            if (!notice) {
                notice = document.createElement('div');
                notice.id = 'loginActionNotice';
                notice.className = 'alert alert-info py-2 px-3 small mb-3 border-0 shadow-sm';
                alertHost.prepend(notice);
            }
            notice.innerHTML = '<i class="bi bi-info-circle-fill me-2"></i>' + message;
        }

        const loginModal = new bootstrap.Modal(modalElement);
        loginModal.show();
        return;
    }

    alert(message);
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

function printSnippetOnly() {
    window.print();
}

function handleReportReasonChange(selectElement) {
    const wrapper = document.getElementById('customReasonWrapper');
    const textarea = document.getElementById('customDescription');
    
    if (selectElement.value === "Other") {
        // Reveal the textarea and make it required
        wrapper.classList.remove('d-none');
        wrapper.classList.add('d-block');
        textarea.setAttribute('required', 'required');
        textarea.placeholder = "Please write your custom reason here (Required to submit)...";
        textarea.focus();
    } else {
        // Hide the textarea and remove validation restrictions
        wrapper.classList.remove('d-block');
        wrapper.classList.add('d-none');
        textarea.removeAttribute('required');
        textarea.value = ""; // Clear out any text they typed before switching options
    }
}
//Function called when reporting a comment
function openCommentReportModal(commentId) {
    // 1. Change the hidden parameters to target the comment instead
    document.getElementById('modalTargetId').value = commentId;
    document.getElementById('modalTargetType').value = 'comment';
    
    // 2. Update the modal title visually for the user
    document.getElementById('reportModalLabel').innerHTML = '<i class="bi bi-flag-fill me-2"></i> Report Comment';
    
    // 3. Open the modal programmatically
    const reportModal = new bootstrap.Modal(document.getElementById('reportModal'));
    reportModal.show();
}

// Reset the modal inputs back to 'snippet' default whenever the modal is hidden
// This ensures that if they close it and click the main cheat sheet report later, it works perfectly!
document.getElementById('reportModal').addEventListener('hidden.bs.modal', function () {
    document.getElementById('modalTargetId').value = "${detail.sheetId}";
    document.getElementById('modalTargetType').value = 'snippet';
    document.getElementById('reportModalLabel').innerHTML = '<i class="bi bi-flag-fill me-2"></i> Report Content';
    
    // Reset form elements
    document.getElementById('reasonSelect').value = "";
    const wrapper = document.getElementById('customReasonWrapper');
    const textarea = document.getElementById('customDescription');
    wrapper.classList.remove('d-block');
    wrapper.classList.add('d-none');
    textarea.removeAttribute('required');
    textarea.value = "";
});
</script>
</body>
</html>
