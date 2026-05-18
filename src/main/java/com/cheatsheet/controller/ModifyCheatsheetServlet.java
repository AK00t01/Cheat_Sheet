package com.cheatsheet.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.model.DetailCheatSheetBean;
import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.EditAndDeleteCheatsheetsRepository;

/**
 * Servlet implementation class ModifyCheatsheetServlet
 */
@WebServlet("/modify-cheatsheet")
public class ModifyCheatsheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    EditAndDeleteCheatsheetsRepository repo = new EditAndDeleteCheatsheetsRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ModifyCheatsheetServlet() {
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

	String sheetId = request.getParameter("id");
	String action = request.getParameter("action");
	UserBean user = (UserBean) request.getSession().getAttribute("user");
	String userId = user.getId();

	response.setContentType("application/json");
	PrintWriter out = response.getWriter();

	if (user == null || sheetId == null || action == null) {
	    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	    out.print("{\"success\": false, \"error\": \"Invalid Session or Parameters\"}");
	    return;
	}

	DetailCheatSheetBean obj = new DetailCheatSheetBean();
	obj.setSheetId(sheetId);
	obj.setCreatedBy(userId);

	boolean result;
	if ("delete".equalsIgnoreCase(action)) {
	    result = repo.softDeleteCheatSheet(obj);

	} else {
	    result = repo.restoreCheatSheet(obj);
	}
	out.print("{\"success\":" + result + "}");
	out.flush();

    }

}
