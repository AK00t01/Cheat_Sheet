package com.cheatsheet.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.repository.SearchCheatSheetRepository;

/**
 * Servlet implementation class LiveSearchServlet
 */
@WebServlet("/live-search")
public class LiveSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    SearchCheatSheetRepository searchRepo = new SearchCheatSheetRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LiveSearchServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String query = request.getParameter("query");
	response.setContentType("text/html;charset=UTF-8");

	// Fetch matching snippets using standard JDBC LIKE queries
	List<SnippetsBean> results = searchRepo.searchSnippets(query);

	PrintWriter out = response.getWriter();
	if (results == null || results.isEmpty()) {
	    out.print(
		    "<div class='list-group-item small text-muted text-center py-3'>No matching snippets found</div>");
	} else {
	    for (SnippetsBean s : results) {
		// Apply highlighting to the title and category
		String highlightedTitle = highlight(s.getTitle(), query);
		String highlightedCategory = highlight(s.getCategoryName(), query);
		String highlightedContent = highlight(s.getContent(), query);

		out.print("<a href='view?id=" + s.getId() + "' class='list-group-item list-group-item-action'>");
		out.print("<div class='d-flex justify-content-between align-items-center'>");
		out.print("<div>");
		out.print("<h6 class='mb-0 small fw-bold'>" + highlightedTitle + "</h6>");
		out.print("<small class='text-primary' style='font-size:0.7rem;'>" + highlightedCategory
			+ "</small><br>");
		out.print("<small class='text-primary' style='font-size:0.7rem;'>" + highlightedContent + "</small>");

		out.print("</div>");
		out.print("<i class='bi bi-chevron-right small text-muted'></i>");
		out.print("</div></a>");
	    }
	}
    }

    /**
     * Helper method to wrap the search term in a <mark> tag. Uses regex (?i) for
     * case-insensitivity.
     */
    private String highlight(String text, String query) {
	if (query == null || query.isBlank() || text == null) {
	    return text;
	}
	// "$0" preserves the original case of the matched text
	return text.replaceAll("(?i)" + query, "<mark class='p-0'>$0</mark>");
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
