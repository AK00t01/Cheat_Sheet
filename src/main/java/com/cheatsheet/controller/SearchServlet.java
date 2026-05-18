package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.repository.SearchCheatSheetRepository;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SearchCheatSheetRepository searchRepo = new SearchCheatSheetRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String query = request.getParameter("query");

	// Sanitize input
	if (query != null) {
	    query = query.trim();
	}

	// Fetch matching snippets using your existing Repository method
	List<SnippetsBean> searchResults = searchRepo.searchSnippets(query);

	// Pass the query string back so the input field can display what they searched
	// for
	request.setAttribute("searchQuery", query);
	request.setAttribute("resultsList", searchResults);

	request.getRequestDispatcher("search-results.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	doGet(request, response);
    }
}