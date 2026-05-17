package com.cheatsheet.controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.CommentsBean;
import com.cheatsheet.model.DetailCheatSheetBean;
import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.BookmarksRepository;
import com.cheatsheet.repository.CheatSheetRepository;
import com.cheatsheet.repository.CommentsRepository;
import com.cheatsheet.repository.DetailCheatSheetRepository;

/**
 * Servlet implementation class ViewDetailServlet
 */
@WebServlet("/view")
public class ViewDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    DetailCheatSheetRepository detailRepo = new DetailCheatSheetRepository();
    CommentsRepository commentRepo = new CommentsRepository();
    CheatSheetRepository cRepo = new CheatSheetRepository();
    BookmarksRepository bRepo = new BookmarksRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewDetailServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String id = request.getParameter("id");

	UserBean user = (UserBean) request.getSession().getAttribute("user");
	String userId = user.getId();

	HttpSession session = request.getSession();

	if (id != null && !id.isBlank()) {
	    if (id != null && !id.isEmpty()) {
		// 1. Get or create a Set of viewed snippet IDs from the session
		@SuppressWarnings("unchecked")
		Set<String> viewedSnippets = (Set<String>) session.getAttribute("viewedSnippets");

		if (viewedSnippets == null) {
		    viewedSnippets = new HashSet<>();
		    session.setAttribute("viewedSnippets", viewedSnippets);
		}

		// 2. Only increment if the user hasn't seen this snippet in this session
		if (!viewedSnippets.contains(id)) {
		    detailRepo.addViewCounts(id); // Repository call
		    viewedSnippets.add(id); // Mark as viewed
		}
	    }

	    DetailCheatSheetBean dObj = detailRepo.getCheatSheetById(id);
	    List<CommentsBean> cObj = commentRepo.getCommentsForSnippetById(id);
	    DetailCheatSheetBean rate = detailRepo.getRatings(id);
	    int userSelectedRating = cRepo.getRatingByUserIdAndSheetId(userId, id);
	    boolean bookmark = bRepo.isBookmarked(id, userId);
	    System.out.println("bookmark"
			       + bookmark);

	    if (dObj != null) {
		request.setAttribute("detail", dObj);
		request.setAttribute("comments", cObj);
		request.setAttribute("rate", rate);
		request.setAttribute("userRating", userSelectedRating);
		request.setAttribute("isBookmarked", bookmark);

		request.getRequestDispatcher("ViewCheatSheet.jsp").forward(request, response);
	    } else {
		response.sendRedirect("home?error=SnippetNotFound");
	    }
	} else {
	    response.sendRedirect("home");
	}

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
