<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="mb-3" id="commentWrapper-${currentComment.id}">
    
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
            <div class="bg-light p-3 rounded shadow-sm border">
                
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <div>
                        <span class="fw-bold text-dark">@${currentComment.username}</span>
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
                                <li><hr class="dropdown-divider"></li>
                            </c:if>
                            <li>
                                <a class="dropdown-item text-danger" href="report-comment?id=${currentComment.id}">
                                    <i class="bi bi-flag me-2"></i> Report
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <p class="mb-2 text-secondary" style="white-space: pre-wrap;">${currentComment.commentText}</p>
                
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
            </div>

            <c:if test="${not empty currentComment.replies}">
                <div class="ms-2 mt-2 border-start ps-3" style="border-color: #dee2e6 !important;">
                    <c:forEach var="reply" items="${currentComment.replies}">
                        <c:set var="currentComment" value="${reply}" scope="request" />
                        <jsp:include page="comment_item.jsp" />
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>
</div>