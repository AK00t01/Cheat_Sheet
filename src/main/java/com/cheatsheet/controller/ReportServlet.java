package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.ReportBean;
import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.ReportRepository;

/**
 * Servlet implementation class ReportServlet
 */
@WebServlet("/submit-report")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    ReportRepository rRepo = new ReportRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReportServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	// TODO Auto-generated method stub
	response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String targetId = request.getParameter("targetId");
	String targetType = request.getParameter("targetType");
	String presetReason = request.getParameter("presetReason");
	String customDetails = request.getParameter("customDetails");

	UserBean user = (UserBean) request.getSession().getAttribute("user");
	String userId = user.getId();

	// 1. Generate a secure unique UUID matching your varchar(36) ID primary key
	// schema system

	ReportBean obj = new ReportBean();
	obj.setTargetId(targetId);
	obj.setTargetType(targetType);
	obj.setUserId(userId);

	// 2. Dynamic Reason Consolidation Logic
	if ("Other".equalsIgnoreCase(presetReason)) {
	    // If they selected 'Other', save the custom message they typed out
	    obj.setReason(customDetails);
	} else {
	    // If they selected a preset reason but also added extra notes, combine them
	    // cleanly
	    if (customDetails != null && !customDetails.isBlank()) {
		obj.setReason(presetReason + " - Notes: " + customDetails);
	    } else {
		obj.setReason(presetReason);
	    }
	}

	// 3. Process database save and execute precise redirects (Fixed the missing '='
	// sign!)
	if (rRepo.insertReport(obj)) {
	    request.getSession().setAttribute("success", "Successfully reported.");
	    response.sendRedirect("view?id=" + targetId);
	} else {
	    request.getSession().setAttribute("error", "An error occurred. Please try again.");
	    response.sendRedirect("view?id=" + targetId);
	}
    }

}
