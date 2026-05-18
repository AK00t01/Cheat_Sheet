package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.DetailCheatSheetBean;
import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.MyCheatSheetRepository;

/**
 * Servlet implementation class MyCheatSheetServlet
 */
@WebServlet("/profile")
public class MyCheatSheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    MyCheatSheetRepository myCSRepo = new MyCheatSheetRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public MyCheatSheetServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String targetUserId = request.getParameter("userId");
	UserBean sessionUser = (UserBean) request.getSession().getAttribute("user");

	// Fallback default: if no user param is present in URL, view the logged-in
	// user's own profile dashboard
	if (targetUserId == null || targetUserId.trim().isEmpty()) {
	    if (sessionUser == null) {
		response.sendRedirect("login.jsp");
		return;
	    }
	    targetUserId = sessionUser.getId();
	}

	// 2. Fetch the corresponding sheets for whoever the target user is
	List<DetailCheatSheetBean> list = myCSRepo.getCheatSheetsByUserId(targetUserId);
	request.setAttribute("myList", list);

	request.getRequestDispatcher("my-cheatsheet.jsp").forward(request, response);
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
