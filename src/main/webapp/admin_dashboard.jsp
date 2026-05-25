<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="Header.jsp" %>
    <title>Admin Dashboard</title>
    <style>
        .dashboard-hero {
            background: linear-gradient(135deg, rgba(15,111,255,0.12), rgba(18,185,129,0.08));
            border: 1px solid rgba(15, 23, 42, 0.08);
        }
        .dashboard-shell {
            max-width: 1440px;
        }
        .stat-card, .action-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover, .action-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 18px 38px rgba(15,23,42,0.12) !important;
        }
        .stat-label {
            letter-spacing: 0.08em;
        }
        .queue-card {
            overflow: hidden;
        }
        .queue-tabs .nav-link {
            border-radius: 999px;
            padding: 0.65rem 1rem;
            color: #5f6f86;
            font-weight: 700;
            border: 1px solid transparent;
        }
        .queue-tabs .nav-link.active {
            background: linear-gradient(135deg, #0f6fff 0%, #0948b3 100%);
            color: #ffffff;
            box-shadow: 0 10px 22px rgba(15, 111, 255, 0.18);
        }
        .queue-summary {
            background: linear-gradient(135deg, rgba(15,111,255,0.06), rgba(18,185,129,0.06));
            border: 1px solid rgba(15, 23, 42, 0.06);
        }
        .moderation-table thead th {
            font-size: 0.76rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #6b7280;
            border-bottom: 1px solid rgba(15, 23, 42, 0.08);
            padding-top: 1rem;
            padding-bottom: 1rem;
        }
        .moderation-table tbody td {
            padding-top: 1rem;
            padding-bottom: 1rem;
            border-color: rgba(15, 23, 42, 0.06);
            vertical-align: top;
        }
        .moderation-table tbody tr:hover {
            background: rgba(15, 111, 255, 0.03);
        }
        .reporter-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.45rem 0.75rem;
            background: rgba(15, 23, 42, 0.04);
            border-radius: 999px;
            color: #1f2937;
            font-weight: 700;
        }
        .reason-chip {
            display: inline-flex;
            align-items: flex-start;
            gap: 0.45rem;
            padding: 0.6rem 0.8rem;
            border-radius: 14px;
            background: rgba(239, 68, 68, 0.08);
            color: #991b1b;
            border: 1px solid rgba(239, 68, 68, 0.12);
        }
        .status-pill {
            border-radius: 999px;
            padding: 0.5rem 0.8rem;
            font-weight: 700;
        }
        .action-stack {
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .empty-state {
            padding: 3rem 1.5rem;
        }
        @media (max-width: 767.98px) {
            .action-stack {
                justify-content: flex-start;
            }
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="Topbar.jsp" %>

    <div class="container-fluid dashboard-shell">
        <div class="row">
            
            <main class="col-md-12 ms-sm-auto col-lg-12 px-md-4 py-4">
                
                <div class="dashboard-hero rounded-4 p-4 p-lg-5 mb-4 shadow-sm">
                    <div class="d-flex justify-content-between flex-wrap align-items-center gap-3">
                        <div>
                            <div class="small text-uppercase fw-bold text-primary mb-2">Moderation Center</div>
                            <h1 class="h2 fw-bold text-dark mb-2"><i class="bi bi-speedometer2 me-2"></i>Control Center Dashboard</h1>
                            <p class="text-muted mb-0">Review reports quickly, keep the queue moving, and monitor platform health from one place.</p>
                        </div>
                        <span class="badge bg-primary px-3 py-2 fs-6 rounded-pill">Admin Status Active</span>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <div class="row g-3 mb-4">
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="card stat-card border-0 shadow-sm bg-white text-dark p-3 rounded">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted text-uppercase small fw-bold stat-label">Pending Incident Reports</h6>
                                    <h2 class="fw-bold mb-0">${pendingReportsCount != null ? pendingReportsCount : '0'}</h2>
                                    <div class="small text-muted mt-2">Items still waiting on an admin decision</div>
                                </div>
                                <div class="bg-danger bg-opacity-10 text-danger p-3 rounded-circle">
                                    <i class="bi bi-exclamation-triangle fs-3"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="card stat-card border-0 shadow-sm bg-white text-dark p-3 rounded">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted text-uppercase small fw-bold stat-label">Active Platform CheatSheets</h6>
                                    <h2 class="fw-bold mb-0">${totalSnippetsCount != null ? totalSnippetsCount : '0'}</h2>
                                    <div class="small text-muted mt-2">Published snippets currently visible to users</div>
                                </div>
                                <div class="bg-success bg-opacity-10 text-success p-3 rounded-circle">
                                    <i class="bi bi-file-earmark-code fs-3"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-4">
                        <div class="card stat-card border-0 shadow-sm bg-white text-dark p-3 rounded">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted text-uppercase small fw-bold stat-label">Registered Users</h6>
                                    <h2 class="fw-bold mb-0">${totalUsersCount != null ? totalUsersCount : '0'}</h2>
                                    <div class="small text-muted mt-2">Accounts currently participating on the platform</div>
                                </div>
                                <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-circle">
                                    <i class="bi bi-people fs-3"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card action-card border-0 shadow-sm bg-white rounded-3">
                            <div class="card-body p-4">
                                <h5 class="fw-bold text-dark mb-2"><i class="bi bi-folder-plus me-2 text-primary"></i>Global Category Management</h5>
                                <p class="text-muted small mb-3">Add a new category classification to the platform. This option will scale across user creation screens instantly.</p>
                                
                                <form action="admin-action" method="post" class="row g-3 align-items-center">
                                    <input type="hidden" name="action" value="createCategory">
                                    
                                    <div class="col-12 col-md-8 col-lg-6">
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-tags"></i></span>
                                            <input type="text" class="form-control" name="catName" id="catName" 
                                                   placeholder="e.g., Backend Frameworks, DevOps, Python Tools" required>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-4 col-lg-3">
                                        <button type="submit" class="btn btn-primary fw-bold w-100">
                                            <i class="bi bi-plus-lg me-1"></i>Publish Category
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card queue-card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white py-3 border-0">
                        <div class="d-flex justify-content-between align-items-center flex-wrap">
                            <h5 class="fw-bold text-dark mb-0"><i class="bi bi-shield-fill-check me-2 text-warning"></i>Moderation Queue</h5>
                            
                            <ul class="nav nav-pills queue-tabs card-header-pills mt-2 mt-sm-0" id="reportTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="snippets-tab" data-bs-toggle="pill" data-bs-target="#snippetReports" type="button" role="tab">
                                        Cheatsheet Violations
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="comments-tab" data-bs-toggle="pill" data-bs-target="#commentReports" type="button" role="tab">
                                        Comment Violations
                                    </button>
                                </li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="card-body p-0">
                        <div class="queue-summary px-4 py-3 border-bottom">
                            <div class="row g-3 align-items-center">
                                <div class="col-lg-8">
                                    <div class="fw-semibold text-dark">Handle the highest-risk content first.</div>
                                    <div class="small text-muted">Open the target, review the reason, then either remove the item or dismiss the report as resolved.</div>
                                </div>
                                <div class="col-lg-4 text-lg-end">
                                    <span class="badge rounded-pill bg-danger-subtle text-danger border px-3 py-2">Open Queue: ${pendingReportsCount != null ? pendingReportsCount : '0'}</span>
                                </div>
                            </div>
                        </div>
                        <div class="tab-content" id="reportTabsContent">
                            
                            <div class="tab-pane fade show active" id="snippetReports" role="tabpanel">
                                <div class="table-responsive">
                                    <table class="table moderation-table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th class="ps-4">Reporter Name</th>
                                                <th>Target Cheatsheet Link</th>
                                                <th>Reported Infraction / Reason</th>
                                                <th>Submitted On</th>
                                                <th>Status</th>
                                                <th>Admin Reason</th>
                                                <th class="text-end pe-4">System Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty snippetReportsList}">
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted fst-italic empty-state">
                                                            <i class="bi bi-check2-circle d-block fs-2 text-success mb-2"></i>
                                                            No active snippet reports pending review.
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="report" items="${snippetReportsList}">
                                                        <tr>
                                                            <td class="ps-4">
                                                                <div class="reporter-pill">
                                                                    <i class="bi bi-person-circle"></i>
                                                                    <span>${report.userName}</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <a href="view?id=${report.targetId}" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill py-1 px-3">
                                                                    <i class="bi bi-box-arrow-up-right me-1"></i>Inspect Code
                                                                </a>
                                                            </td>
                                                            <td>
                                                                <span class="reason-chip">
                                                                    <i class="bi bi-flag-fill mt-1"></i>
                                                                    <span class="text-wrap">${report.reason}</span>
                                                                </span>
                                                            </td>
                                                            <td class="small text-muted">${report.createdAt}</td>
                                                            <td><span class="badge status-pill bg-warning text-dark">${report.status}</span></td>
                                                            <td>
                                                                <form id="snippet-review-${report.id}" action="admin-action" method="post">
                                                                    <input type="hidden" name="reportId" value="${report.id}">
                                                                    <input type="hidden" name="targetId" value="${report.targetId}">
                                                                    <textarea class="form-control form-control-sm" name="adminReason" rows="2" placeholder="Optional internal note or resolution reason"></textarea>
                                                                </form>
                                                            </td>
                                                            <td class="text-end pe-4">
                                                                <div class="action-stack">
                                                                    <button type="submit" form="snippet-review-${report.id}" name="action" value="deleteSnippet"
                                                                       class="btn btn-sm btn-danger rounded-pill px-3" onclick="return confirm('Confirm permanent deletion filter on this item?')">
                                                                        <i class="bi bi-trash-fill me-1"></i> Drop Snippet
                                                                    </button>
                                                                    <button type="submit" form="snippet-review-${report.id}" name="action" value="resolveReport" class="btn btn-sm btn-outline-success rounded-pill px-3">
                                                                        <i class="bi bi-check-lg me-1"></i> Dismiss
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            
                            <div class="tab-pane fade" id="commentReports" role="tabpanel">
                                <div class="table-responsive">
                                    <table class="table moderation-table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th class="ps-4">Reporter Name</th>
                                                <th>Infraction Reason</th>
                                                <th>Reported Comment</th>
                                                <th>Submitted On</th>
                                                <th>Status</th>
                                                <th>Admin Reason</th>
                                                <th class="text-end pe-4">System Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty commentReportsList}">
                                                    <tr>
                                                        <td colspan="6" class="text-center text-muted fst-italic empty-state">
                                                            <i class="bi bi-chat-square-heart d-block fs-2 text-success mb-2"></i>
                                                            No active comment reports pending review.
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="report" items="${commentReportsList}">
                                                        <tr>
                                                            <td class="ps-4">
                                                                <div class="reporter-pill">
                                                                    <i class="bi bi-person-circle"></i>
                                                                    <span>${report.userName}</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="reason-chip">
                                                                    <i class="bi bi-flag-fill mt-1"></i>
                                                                    <span class="text-wrap">${report.reason}</span>
                                                                </span>
                                                            </td>
                                                                      <td>
                                                                <span class="reason-chip">
                                                                    <i class="bi bi-chat-left-quote text-info fs-6"></i>
                                                                    <span class="text-wrap">${report.commentText}</span>
                                                                </span>
                                                            </td>
                                                            <td class="small text-muted">${report.createdAt}</td>
                                                            <td><span class="badge status-pill bg-warning text-dark">${report.status}</span></td>
                                                            <td>
                                                                <form id="comment-review-${report.id}" action="admin-action" method="post">
                                                                    <input type="hidden" name="reportId" value="${report.id}">
                                                                    <input type="hidden" name="targetId" value="${report.targetId}">
                                                                    <textarea class="form-control form-control-sm" name="adminReason" rows="2" placeholder="Optional internal note or resolution reason"></textarea>
                                                                </form>
                                                            </td>
                                                            <td class="text-end pe-4">
                                                                <div class="action-stack">
                                                                    <button type="submit" form="comment-review-${report.id}" name="action" value="deleteComment"
                                                                       class="btn btn-sm btn-danger rounded-pill px-3" onclick="return confirm('Purge this comment block permanently?')">
                                                                        <i class="bi bi-chat-square-x-fill me-1"></i> Purge Comment
                                                                    </button>
                                                                    <button type="submit" form="comment-review-${report.id}" name="action" value="resolveReport" class="btn btn-sm btn-outline-success rounded-pill px-3">
                                                                        <i class="bi bi-check-lg me-1"></i> Dismiss
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>
        <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 opacity-50">&copy; 2026 CheatSheet Pro - Coding made easier.</p>
        </div>
    </footer>
</body>
</html>
