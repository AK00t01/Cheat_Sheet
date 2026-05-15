package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.CategoriesBean;
import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.repository.CheatSheetRepository;

/**
 * Servlet implementation class MainPage
 */
@WebServlet("/home")
public class HomePageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    CheatSheetRepository cRepo = new CheatSheetRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public HomePageServlet() {
	super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	List<SnippetsBean> sheetList = cRepo.getSixSheets();
	List<CategoriesBean> catList = cRepo.getMainCategories();

	HttpSession session = request.getSession();
	session.setAttribute("categories", catList);
	request.setAttribute("cheatsheet", sheetList);
	request.getRequestDispatcher("Home.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
    }

}
