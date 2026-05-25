package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.repository.CheatSheetRepository;
import com.cheatsheet.repository.CommentsRepository;
import com.cheatsheet.repository.CreateCategoryRepository;
import com.cheatsheet.repository.ReportRepository;

/**
 * Servlet implementation class AdminActionServlet
 */
@WebServlet("/admin-action")
public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReportRepository rRepo = new ReportRepository();
    private CheatSheetRepository sRepo = new CheatSheetRepository();
    private CommentsRepository cRepo = new CommentsRepository();
    CreateCategoryRepository ccRepo = new CreateCategoryRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminActionServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	response.sendRedirect("admin-dashboard");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	HttpSession session = request.getSession();
	String action = trimToNull(request.getParameter("action"));
	String reportId = trimToNull(request.getParameter("reportId"));
	String targetId = trimToNull(request.getParameter("targetId"));
	String catName = trimToNull(request.getParameter("catName"));
	String adminReason = trimToNull(request.getParameter("adminReason"));

	if ("resolveReport".equalsIgnoreCase(action)) {
	    if (reportId == null) {
		session.setAttribute("error", "Missing report identifier.");
	    } else if (rRepo.updateReportStatusByReportId(reportId, rRepo.getResolvedStatus(), adminReason)) {
		session.setAttribute("success", "Violation ticket dismissed successfully.");
	    } else {
		session.setAttribute("error", "Unable to dismiss the selected report.");
	    }

	} else if ("deleteSnippet".equalsIgnoreCase(action)) {
	    if (reportId == null || targetId == null) {
		session.setAttribute("error", "Missing snippet moderation details.");
	    } else {
		boolean dbSnippetDropped = sRepo.adminBanSnippet(targetId);
		boolean reportsResolved = rRepo.updatePendingReportsStatusByTargetId(targetId, rRepo.getResolvedStatus(), adminReason);

		if (dbSnippetDropped && reportsResolved) {
		    session.setAttribute("success", "Target snippet removed and all related pending reports were resolved.");
		} else {
		    session.setAttribute("error", "Unable to remove the snippet or resolve its related reports.");
		}
	    }

	} else if ("deleteComment".equalsIgnoreCase(action)) {
	    if (reportId == null || targetId == null) {
		session.setAttribute("error", "Missing comment moderation details.");
	    } else {
		boolean dbCommentDropped = cRepo.adminSoftDeleteComment(targetId);
		boolean reportsResolved = rRepo.updatePendingReportsStatusByTargetId(targetId, rRepo.getResolvedStatus(), adminReason);

		if (dbCommentDropped && reportsResolved) {
		    session.setAttribute("success", "Target comment block purged and all related pending reports were resolved.");
		} else {
		    session.setAttribute("error", "Unable to purge the comment or resolve its related reports.");
		}
	    }
	} else if ("createCategory".equalsIgnoreCase(action)) {
	    if (catName != null) {
		if (ccRepo.createCategory(catName)) {
		    session.setAttribute("success", "Category '" + catName + "' created successfully.");
		} else {
		    session.setAttribute("error", "Category already exists or could not be created.");
		}
	    } else {
		session.setAttribute("error", "Category name cannot be empty.");
	    }
	} else {
	    session.setAttribute("error", "Unknown admin action.");

	}

	response.sendRedirect("admin-dashboard");
    }

    private String trimToNull(String value) {
	if (value == null) {
	    return null;
	}

	String trimmed = value.trim();
	return trimmed.isEmpty() ? null : trimmed;
    }

}
