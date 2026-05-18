<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${empty requestScope.commentDepth}">
    <c:set var="commentDepth" value="0" scope="request" />
</c:if>

<div class="mb-3 ${requestScope.commentDepth > 0 ? 'ms-md-4 ms-2 ps-3 border-start border-2' : ''}" id="commentWrapper-${currentComment.id}" style="${requestScope.commentDepth > 0 ? 'border-color: rgba(15, 111, 255, 0.18) !important;' : ''}">
    
<div id="commentUndoAlert-${currentComment.id}" class="alert alert-secondary py-2 px-3 d-none align-items-center justify-content-between shadow-sm border small">
    <div>
        <i class="bi bi-trash3 me-1"></i> 
        <span>Comment deleted. </span>
        <span id="commentCountdown-${currentComment.id}" class="text-danger fw-bold ms-1">(10s remaining)</span>
    </div>
    <button class="btn btn-sm btn-link text-primary fw-bold text-decoration-none p-0" 
            onclick="undoCommentDelete('${currentComment.id}')">
        Undo
    </button>
</div>

    <div class="d-flex align-items-start" id="commentCard-${currentComment.id}">
        <div class="flex-shrink-0">
            <i class="bi bi-person-circle fs-3 text-secondary"></i>
        </div>
        
        <div class="flex-grow-1 ms-3">
            <div class="bg-light p-3 rounded shadow-sm border ${requestScope.commentDepth > 0 ? 'bg-white' : ''}">
                
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <div>
				<a href="profile?userId=${currentComment.userId}" 
				   class="fw-bold text-dark text-decoration-none hover-profile-link">
				    @<c:out value="${currentComment.username}" />
				</a>
                        <c:if test="${requestScope.commentDepth > 0}">
                            <span class="badge bg-primary-subtle text-primary border ms-2">Reply</span>
                        </c:if>
                        <span class="text-muted ms-2 small" style="font-size: 0.75rem;">
                            <i class="bi bi-clock"></i> ${currentComment.timeAgo}
                        </span>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-link text-muted p-0 border-0" type="button" 
                                id="commentMenu${currentComment.id}" data-bs-toggle="dropdown">
                            <i class="bi bi-three-dots-vertical"></i>
                        </button>
<ul class="dropdown-menu dropdown-menu-end shadow border-0">
    <c:choose>
        <%-- CONDITION 1: User IS logged in --%>
        <c:when test="${not empty sessionScope.user}">
            
            <%-- Sub-case A: The logged-in user owns this comment --%>
            <c:if test="${sessionScope.user.id == currentComment.userId}">
                <li>
                    <a class="dropdown-item text-primary" href="edit-comment?id=${currentComment.id}">
                        <i class="bi bi-pencil-square me-2"></i> Edit
                    </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item text-danger" href="javascript:void(0);" 
                       onclick="initiateCommentDelete('${currentComment.id}')">
                        <i class="bi bi-trash me-2"></i> Delete
                    </a>
                </li>
            </c:if>
            
            <%-- Sub-case B: The logged-in user does NOT own this comment --%>
            <c:if test="${sessionScope.user.id != currentComment.userId}">
                <li>
                    <a class="dropdown-item text-warning btn-sm" href="javascript:void(0);" 
                       onclick="openCommentReportModal('${currentComment.id}')">
                        <i class="bi bi-flag me-2"></i> Report Comment
                    </a>
                </li>
            </c:if>
            
        </c:when>

        <%-- CONDITION 2: User is a GUEST (Not Logged In) --%>
        <c:otherwise>
            <li>
                <a class="dropdown-item text-secondary fw-semibold small" href="#" 
                   data-bs-toggle="modal" data-bs-target="#loginModal">
                    <i class="bi bi-box-arrow-in-right me-2 text-primary"></i> Login to interact
                </a>
            </li>
        </c:otherwise>
    </c:choose>
</ul>
                    </div>
                </div>

                <p class="mb-2 text-secondary" style="white-space: pre-wrap;">${currentComment.commentText}</p>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="text-start">         
                            <a href="javascript:void(0)" 
                               onclick="toggleReplyForm('${currentComment.id}')" 
                               class="small text-decoration-none text-primary fw-bold">
                                <i class="bi bi-reply"></i> Reply
                            </a>
                        </div>
                        
                        <div id="replyForm-${currentComment.id}" class="mt-3 d-none">
                            <form action="post-comment" method="post">
                                <input type="hidden" name="snippetId" value="${currentComment.snippetsId}">
                                <input type="hidden" name="parentId" value="${currentComment.id}">
                                
                                <div class="input-group input-group-sm">
                                    <input type="text" name="commentText" class="form-control" 
                                           placeholder="Write a reply..." required>
                                    <button class="btn btn-primary" type="submit">Post</button>
                                    <button class="btn btn-outline-secondary" type="button" 
                                            onclick="toggleReplyForm('${currentComment.id}')">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-start">
                            <button type="button" class="btn btn-link text-decoration-none small fw-bold px-0" onclick="requireLogin('reply to comments')">
                                <i class="bi bi-lock me-1"></i> Sign in to reply
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty currentComment.replies}">
                <div class="mt-3">
                    <c:set var="parentDepth" value="${requestScope.commentDepth}" scope="request" />
                    <c:set var="commentDepth" value="${requestScope.commentDepth + 1}" scope="request" />
                    <c:forEach var="reply" items="${currentComment.replies}">
                        <c:set var="currentComment" value="${reply}" scope="request" />
                        <jsp:include page="comment_item.jsp" />
                    </c:forEach>
                    <c:set var="commentDepth" value="${parentDepth}" scope="request" />
                </div>
            </c:if>
        </div>
    </div>
</div>
