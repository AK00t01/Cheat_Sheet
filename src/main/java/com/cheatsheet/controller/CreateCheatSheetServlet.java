package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.CreateCheatSheetRepository;

/**
 * Servlet implementation class CreateCheatSheetServlet
 */
@WebServlet("/creat-sheet")
public class CreateCheatSheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateCheatSheetServlet() {
	super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
//	HttpSession session = request.getSession();
//	UserBean user = (UserBean) session.getAttribute("user");
//	if (user != null) {
//	    request.getRequestDispatcher("CreateCheatSheet.jsp").forward(request, response);
//	    return;
//	}
//	session.setAttribute("error", "Please login to create a cheat sheet.");
//	response.sendRedirect("home");
//	return;

	request.getRequestDispatcher("CreateCheatSheet.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	// 1. Force UTF-8 encoding for special characters in code snippets
	request.setCharacterEncoding("UTF-8");

	// 2. Security Check: Ensure user is logged in
	HttpSession session = request.getSession();
	UserBean user = (UserBean) session.getAttribute("user");
//
//	if (user == null) {
//	    session.setAttribute("error", "Please login first");
//	    response.sendRedirect("home");
//	    return;
//	}

	// 3. Extract Parameters from JSP
	String title = request.getParameter("title");
	String topicName = request.getParameter("topicName");
	String content = request.getParameter("content");
	String bgColor = request.getParameter("bgColor");
	String fontFamily = request.getParameter("fontFamily");
	String categoryId = request.getParameter("categoryId");

	// 4. Wrap data into Bean
	SnippetsBean obj = new SnippetsBean();
	obj.setTitle(title);
	obj.setTopicName(topicName.toUpperCase());
	obj.setContent(content);
	obj.setCreatedBy(user.getId());
	obj.setCategoryId(categoryId);
	obj.setBgColor(bgColor);
	obj.setFontFamily(fontFamily);

	// 5. Call Repository to save
	CreateCheatSheetRepository repo = new CreateCheatSheetRepository();
	int result = repo.saveCheatSheet(obj);

	if (result > 0) {
	    // SUCCESS: Redirect to home with a success message
	    session.setAttribute("successMsg", "Snippet '"
					       + title
					       + "' created successfully!");
	    response.sendRedirect("home");
	} else {
	    // FAILURE: Send back to form with error
	    request.setAttribute("error", "Database error: Could not save your snippet.");
	    request.getRequestDispatcher("CreateCheatSheet.jsp").forward(request, response);
	}
    }

}
