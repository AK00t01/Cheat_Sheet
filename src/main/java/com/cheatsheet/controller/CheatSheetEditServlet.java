package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.CategoriesBean;
import com.cheatsheet.model.DetailCheatSheetBean;
import com.cheatsheet.repository.CheatSheetRepository;
import com.cheatsheet.repository.DetailCheatSheetRepository;
import com.cheatsheet.repository.EditAndDeleteCheatsheetsRepository;

/**
 * Servlet implementation class CheatSheetEditServlet
 */
@WebServlet("/edit")
public class CheatSheetEditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    DetailCheatSheetRepository detailRepo = new DetailCheatSheetRepository();
    CheatSheetRepository cRepo = new CheatSheetRepository();
    EditAndDeleteCheatsheetsRepository edRepo = new EditAndDeleteCheatsheetsRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public CheatSheetEditServlet() {
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
	// Fetch the existing snippet details
	DetailCheatSheetBean detail = detailRepo.getCheatSheetById(id);
	// Also fetch categories so the user can change the topic if they want
	List<CategoriesBean> categories = cRepo.getMainCategories();

	request.setAttribute("detail", detail);
	request.setAttribute("categories", categories);
	request.getRequestDispatcher("edit_cheatsheet.jsp").forward(request, response);

    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	DetailCheatSheetBean snippet = new DetailCheatSheetBean();
	String topicName = request.getParameter("topicName");
	String parent_id = request.getParameter("categoryId");

	snippet.setTopic(request.getParameter("topicName"));

	String categoryId = edRepo.getOrCreateCategoryId(topicName, parent_id);
	snippet.setSheetId(request.getParameter("id"));
	snippet.setCategoryId(categoryId);
	snippet.setTitle(request.getParameter("title"));
	snippet.setContent(request.getParameter("content"));
	snippet.setBgColor(request.getParameter("bgColor"));
	snippet.setFontFamily(request.getParameter("fontFamily"));

	if (edRepo.updateSnippet(snippet)) {
	    response.sendRedirect("view?id="
				  + snippet.getSheetId());
	} else {
	    request.setAttribute("error", "Update failed.");
	    doGet(request, response);
	}
    }
}
