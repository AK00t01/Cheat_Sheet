package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.repository.CommentsRepository;

/**
 * Servlet implementation class ReplyCommentsServlet
 */
@WebServlet("/delete-comment")
public class DeleteCommentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    CommentsRepository cRepo = new CommentsRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteCommentsServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	String parentId = request.getParameter("parentId");
	String snippetId = request.getParameter("snippetId");
//	cRepo.replyComments();

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
