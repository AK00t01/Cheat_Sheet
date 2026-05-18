package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.repository.CheatSheetRepository;

/**
 * Servlet implementation class RandonCheatsheetServlet
 */
@WebServlet("/random-snippet")
public class RandonCheatsheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    CheatSheetRepository cRepo = new CheatSheetRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RandonCheatsheetServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	String randomId = cRepo.getRandomSnippetId();

	if (randomId != null) {
	    // Redirect smoothly to your dynamic cheat sheet detail view page
	    response.sendRedirect("view?id=" + randomId);
	} else {
	    // Fallback: If no snippets exist, redirect back home with an error message
	    request.getSession().setAttribute("error", "No cheat sheets available at the moment!");
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
