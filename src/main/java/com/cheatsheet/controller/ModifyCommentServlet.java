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

@WebServlet("/modify-comment")
public class ModifyCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    CommentsRepository cRepo = new CommentsRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String commentId = request.getParameter("id");
	String action = request.getParameter("action"); // "delete" or "restore"
	UserBean user = (UserBean) request.getSession().getAttribute("user");

	response.setContentType("application/json");

	if (user == null || commentId == null || commentId.isBlank()) {
	    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	    response.getWriter().print("{\"success\": false, \"error\": \"Unauthorized\"}");
	    return;
	}

	CommentsBean obj = new CommentsBean();
	obj.setId(commentId);
	obj.setUserId(user.getId());

	int result = 0;
	if ("restore".equals(action)) {
	    result = cRepo.restoreComment(obj);
	} else {
	    result = cRepo.softDeleteComment(obj);
	}

	response.getWriter().print("{\"success\": " + (result > 0) + "}");
    }
}