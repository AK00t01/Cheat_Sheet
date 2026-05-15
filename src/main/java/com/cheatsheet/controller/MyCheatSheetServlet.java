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
@WebServlet("/my-cheatsheets")
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

	UserBean user = (UserBean) request.getSession().getAttribute("user");
	String userId = user.getId();
	List<DetailCheatSheetBean> list = myCSRepo.getCheatSheetsByUserId(userId);
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
