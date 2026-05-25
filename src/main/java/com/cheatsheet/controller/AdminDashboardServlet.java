package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.ReportBean;
import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.ReportRepository;
import com.cheatsheet.repository.UserRepository;

/**
 * Servlet implementation class AdminDashboardServlet
 */
@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    ReportRepository rRepo = new ReportRepository();
    UserRepository uRepo = new UserRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminDashboardServlet() {
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
	UserBean user = (UserBean) session.getAttribute("user");
	if (user != null) {
	    UserBean uObj = uRepo.getUserById(user.getId());
	    request.setAttribute("user", uObj);
	}

	int pendingReportsCount = rRepo.countPendingReports();
	int totalSnippets = rRepo.countActiveSnippets();
	int totalUsers = rRepo.countTotalUsers();

	List<ReportBean> snippetReports = rRepo.getReportsByTargetType("snippet");
	List<ReportBean> commentReports = rRepo.getReportsByTargetType("comment");

	request.setAttribute("pendingReportsCount", pendingReportsCount);
	request.setAttribute("totalSnippetsCount", totalSnippets);
	request.setAttribute("totalUsersCount", totalUsers);
	request.setAttribute("snippetReportsList", snippetReports);
	request.setAttribute("commentReportsList", commentReports);

	request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
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
