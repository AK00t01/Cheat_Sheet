package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.CheatSheetRepository;

/**
 * Servlet implementation class RateServlet
 */
@WebServlet("/rate")
public class RateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    CheatSheetRepository cRepo = new CheatSheetRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RateServlet() {
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
	String snippetsId = request.getParameter("snippetId");
	int rating = Integer.parseInt(request.getParameter("rating"));
	UserBean user = (UserBean) request.getSession().getAttribute("user");
	String userId = user.getId();

	cRepo.saveOrUpdateRating(userId, snippetsId, rating);
	response.sendRedirect("view?id=" + snippetsId);

    }

}
