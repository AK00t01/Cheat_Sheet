package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.CategoriesBean;
import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.repository.CheatSheetRepository;

/**
 * Servlet implementation class TopicServlet
 */
@WebServlet("/categories")
public class CategoriesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    CheatSheetRepository cRepo = new CheatSheetRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public CategoriesServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String categoryId = request.getParameter("id");

	List<SnippetsBean> sheets = cRepo.getSheetByCategoryId(categoryId);
	List<CategoriesBean> topicList = cRepo.getSubCategories(categoryId);

	request.setAttribute("topic", topicList);
	request.setAttribute("sheets", sheets);
	request.getRequestDispatcher("explore.jsp").forward(request, response);
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
