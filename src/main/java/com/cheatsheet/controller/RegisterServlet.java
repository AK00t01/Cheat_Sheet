package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.repository.UserRepository;
import com.cheatsheet.utils.PasswordConfig;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    UserRepository userRepo = new UserRepository();

    public RegisterServlet() {
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

	String userName = request.getParameter("username");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	String confirmPassword = request.getParameter("confirmPassword");

	// Get the session up front so we can save attributes that survive a redirect
	HttpSession session = request.getSession();
	String contextPath = request.getContextPath();

	if (userName == null || userName.isBlank()) {
	    session.setAttribute("error", "Username is required.");
	    response.sendRedirect(contextPath + "/home");
	    return;
	}

	if (email == null || email.isBlank()) {
	    session.setAttribute("error", "Email is required.");
	    response.sendRedirect(contextPath + "/home");
	    return;
	}

	if (password == null || password.length() < 6 || !password.matches(".*[a-zA-Z].*")) {
	    session.setAttribute("error",
		    "Password must be at least 8 characters long and contain at least one letter.");
	    response.sendRedirect(contextPath + "/home");
	    return;
	}

	if (!password.equals(confirmPassword)) {
	    session.setAttribute("error", "Passwords do not match.");
	    response.sendRedirect(contextPath + "/home");
	    return;
	}

	if (userRepo.isEmailRegistered(email)) {
	    session.setAttribute("error", "Email is already registered.");
	    response.sendRedirect(contextPath + "/home");
	    return;
	}

	try {
	    String hashedPassword = PasswordConfig.hashPassword(password);

	    System.out.println("Registering user: " + userName + " with hashed password.");
	    userRepo.registerUser(userName, email, hashedPassword);

	    // Success Response - Lives in session, will survive the redirect perfectly!
	    session.setAttribute("regSuccess", "Registration successful! You can now login.");
	    response.sendRedirect(contextPath + "/home");

	} catch (Exception e) {
	    e.printStackTrace();
	    session.setAttribute("error", "Registration failed due to a system error.");
	    response.sendRedirect(contextPath + "/home");
	}
    }
}