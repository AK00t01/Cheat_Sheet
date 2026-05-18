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

@WebServlet("/live-search")
public class LiveSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    SearchCheatSheetRepository searchRepo = new SearchCheatSheetRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String query = request.getParameter("query");
	response.setContentType("text/html;charset=UTF-8");

	List<SnippetsBean> results = searchRepo.searchSnippets(query);

	PrintWriter out = response.getWriter();
	if (results == null || results.isEmpty()) {
	    out.print(
		    "<div class='list-group-item small text-muted text-center py-3'>No matching snippets or users found</div>");
	    return;
	}

	java.util.Set<String> displayedUsers = new java.util.HashSet<>();

	for (SnippetsBean s : results) {
	    String authorName = s.getCreatedBy();

	    if (query != null && !query.isBlank() && authorName != null
		    && authorName.toLowerCase().contains(query.toLowerCase().trim())) {

		if (!displayedUsers.contains(authorName.toLowerCase())) {
		    String highlightedUser = highlight(authorName, query);

		    // FIXED: Changed 'profile' to 'my-cheatsheets' to match your profile engine
		    out.print("<a href='profile?userId=" + s.getUserId()
			      + "' class='list-group-item list-group-item-action bg-light bg-opacity-50'>");
		    out.print("<div class='d-flex justify-content-between align-items-center'>");
		    out.print("  <div>");
		    out.print(
			    "    <span class='badge bg-info text-dark me-2 small'><i class='bi bi-person-fill'></i> User</span>");
		    out.print("    <span class='fw-bold text-dark small'>" + highlightedUser + "</span>");
		    out.print(
			    "    <br><small class='text-muted' style='font-size:0.7rem;'>View author contributions profile</small>");
		    out.print("  </div>");
		    out.print("  <i class='bi bi-arrow-right-short text-muted'></i>");
		    out.print("</div></a>");

		    displayedUsers.add(authorName.toLowerCase());
		}
	    }

	    String highlightedTitle = highlight(s.getTitle(), query);
	    String highlightedCategory = highlight(s.getCategoryName(), query);
	    String highlightedContent = highlight(s.getContent(), query);

	    out.print("<a href='view?id=" + s.getId() + "' class='list-group-item list-group-item-action'>");
	    out.print("<div class='d-flex justify-content-between align-items-center'>");
	    out.print("  <div>");
	    out.print("    <h6 class='mb-0 small fw-bold text-dark'>" + highlightedTitle + "</h6>");
	    out.print("    <small class='text-secondary' style='font-size:0.7rem;'>" + highlightedCategory
		      + "</small>");
	    if (highlightedContent != null && !highlightedContent.isBlank()) {
		out.print(
			"    <br><small class='text-muted text-truncate d-block' style='font-size:0.7rem; max-width: 280px;'>"
			  + highlightedContent
			  + "</small>");
	    }
	    out.print("  </div>");
	    out.print("  <i class='bi bi-chevron-right small text-muted'></i>");
	    out.print("</div></a>");
	}
    }

    private String highlight(String text, String query) {
	if (query == null || query.isBlank() || text == null) {
	    return text;
	}
	String escapedQuery = java.util.regex.Pattern.quote(query.trim());
	return text.replaceAll("(?i)" + escapedQuery, "<mark class='p-0 bg-warning text-dark'>$0</mark>");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	// Safe fallback: redirect post methods into the live endpoint stream natively
	doGet(request, response);
    }
}