package com.cheatsheet.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.BookmarksRepository;

/**
 * Servlet implementation class BookmarkServlet
 */
@WebServlet("/bookmark")
public class BookmarkServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    BookmarksRepository bRepo = new BookmarksRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookmarkServlet() {
	super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String id = request.getParameter("id");
	UserBean user = (UserBean) request.getSession().getAttribute("user");
	System.err.println(id);
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();

	String userId = user.getId();
	boolean isNowBookmarked = bRepo.toggleBookmark(id, userId);

	// Return JSON so AJAX can update the heart icon
	if (isNowBookmarked) {
	    out.print("{\"status\": \"added\"}");
	} else {
	    out.print("{\"status\": \"removed\"}");
	}
	out.flush();

    }

}
