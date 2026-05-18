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

	HttpSession session = request.getSession();
	String action = request.getParameter("action");
	String reportId = request.getParameter("reportId");
	String targetId = request.getParameter("targetId");
	String catName = request.getParameter("catName");
	boolean outcome = false;

	if ("resolveReport".equalsIgnoreCase(action)) {
	    // Dismiss report: Simply change status flag to 'RESOLVED'
	    outcome = rRepo.updateReportStatus(reportId, "RESOLVED");
	    session.setAttribute("success", "Violation ticket dismissed successfully.");

	} else if ("deleteSnippet".equalsIgnoreCase(action)) {
	    // Admin Action: Soft-delete snippet violation and mark ticket resolved
	    boolean dbSnippetDropped = sRepo.adminSoftDeleteSnippet(targetId);
	    boolean ticketResolved = rRepo.updateReportStatus(reportId, "RESOLVED");
	    outcome = dbSnippetDropped && ticketResolved;
	    session.setAttribute("success", "Target snippet removed and ticket resolved.");

	} else if ("deleteComment".equalsIgnoreCase(action)) {
	    // Admin Action: Cascade purge reported bad comment block
	    boolean dbCommentDropped = cRepo.adminSoftDeleteComment(targetId);
	    boolean ticketResolved = rRepo.updateReportStatus(reportId, "RESOLVED");
	    outcome = dbCommentDropped && ticketResolved;
	    session.setAttribute("success", "Target comment block purged and ticket resolved.");
	} else if ("createCategory".equalsIgnoreCase(action)) {
	    if (catName != null && !catName.isBlank()) {
		ccRepo.createCategory(catName.trim());
		session.setAttribute("success", "Category '" + catName.trim() + "' created successfully.");
	    } else {
		session.setAttribute("error", "Category name cannot be empty.");
	    }

	}

	// Send administrator cleanly back to dashboard interface tracking screen
	response.sendRedirect("admin-dashboard");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	// TODO Auto-generated method stub
	doGet(request, response);
    }

}
