package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.UserRepository;
import com.cheatsheet.utils.PasswordConfig;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    UserRepository userRepo = new UserRepository();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	response.sendRedirect("home");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String email = request.getParameter("email");
	String password = request.getParameter("password");

	// 1. Basic Validation
	if (email == null || email.isBlank() || password == null || password.isBlank()) {
	    request.getSession().setAttribute("error", "Email and Password are required.");
	    response.sendRedirect("home");
	    return;
	}
	if (userRepo.isEmailRegistered(email) == false) {
	    request.getSession().setAttribute("error", "Email is not registered.");
	    response.sendRedirect("home");
	    return;

	}

	// 2. Fetch User from Repo
	UserBean user = userRepo.loginUser(email);

	// 3. Verify Identity

	if (user != null) {

	    // Compare the raw password with the hashed password from DB
	    if (PasswordConfig.checkPassword(password, user.getHashedPassword())) {
		String rememberMe = request.getParameter("rememberMe");
//		System.out.println(rememberMe);

		if ("true".equals(rememberMe)) {
		    Cookie userCookie = new Cookie("remember_user", user.getId());
		    userCookie.setMaxAge(60 * 60 * 24 * 30); // 30 days in seconds
		    userCookie.setPath("/"); // Accessible everywhere in your app
		    response.addCookie(userCookie);
//		    System.out.println("userId" + user.getId());
		}

		// Success: Create Session
		HttpSession session = request.getSession();
		session.setAttribute("user", user);
		session.removeAttribute("error");
		if ("user".equalsIgnoreCase(user.getRole())) {
		    response.sendRedirect("home");
		    return;
		}
		response.sendRedirect("admin-dashboard");
		return;
	    }
	}
	request.getSession().setAttribute("error", "Invalid email or password.");
	response.sendRedirect("home");
    }

}
