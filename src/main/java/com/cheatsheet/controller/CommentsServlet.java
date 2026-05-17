package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.CommentsBean;
import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.CommentsRepository;

/**
 * Servlet implementation class CommentsServlet
 */
@WebServlet("/post-comment")
public class CommentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    CommentsRepository commentRepo = new CommentsRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public CommentsServlet() {
	super();
	// TODO Auto-generated constructor stub
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

	String commentText = request.getParameter("commentText");
	String snippetsId = request.getParameter("snippetId");
	String parentId = request.getParameter("parentId");
	int i = 0;
	if (commentText == null || commentText.isBlank()) {
	    request.getSession().setAttribute("error", "Comment cannot be empty.");
	    response.sendRedirect("view?id=" + snippetsId);
	    return;
	}

	UserBean user = (UserBean) request.getSession().getAttribute("user");

	CommentsBean obj = new CommentsBean();
	obj.setUserId(user.getId());
	obj.setCommentText(commentText);
	obj.setSnippetsId(snippetsId);
	obj.setParentCommentsId(parentId);

	// Use a single method that handles both, or use an if-else
	if (parentId != null && !parentId.isEmpty()) {
	    i = commentRepo.postComment(obj); // The repo logic handles the parentId column
	} else {
	    obj.setParentCommentsId(null); // Explicitly ensure it's null for top-level
	    i = commentRepo.postComment(obj);
	}

	if (i > 0) {
	    // Note: Use sessionScope for messages if you are using sendRedirect
	    request.getSession().setAttribute("success", "Comment posted successfully!");
	} else {
	    request.getSession().setAttribute("error", "Failed to post comment.");
	}

	response.sendRedirect("view?id=" + snippetsId);

    }
}