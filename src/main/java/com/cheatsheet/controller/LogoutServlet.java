package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LogoutServlet
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogoutServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	HttpSession session = request.getSession(false); // Get session if it exists
	if (session != null) {
	    session.invalidate(); // Clears all attributes (like "user")
	}

	// 2. Delete the "Remember Me" Cookie
	// To delete a cookie, we send a new one with the same name and maxAge = 0
	Cookie killCookie = new Cookie("remember_user", "");
	killCookie.setMaxAge(0); // This tells the browser to delete it immediately
	killCookie.setPath("/"); // Must match the path used when the cookie was created
	response.addCookie(killCookie);

	// 3. Redirect to home page
	// We use a new session to show a logout success message
	request.getSession().setAttribute("successMsg", "You have been logged out successfully.");
	response.sendRedirect("home");
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
