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

	response.sendRedirect("Register.jsp");
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

	if (userName == null || userName.isBlank()) {
	    request.setAttribute("error", "Username is required.");
	    request.getRequestDispatcher("Register.jsp").forward(request, response);
	    return;
	}

	if (email == null || email.isBlank()) {
	    request.setAttribute("error", "Email is required.");
	    request.getRequestDispatcher("Register.jsp").forward(request, response);
	    return;
	}

	if (password == null || password.length() < 8 || !password.matches(".*[a-zA-Z].*")) {
	    request.setAttribute("error",
		    "Password must be at least 8 characters long and contain at least one letter.");
	    request.getRequestDispatcher("Register.jsp").forward(request, response);
	    return;
	}

	if (!password.equals(confirmPassword)) {
	    request.setAttribute("error", "Passwords do not match.");
	    request.getRequestDispatcher("Register.jsp").forward(request, response);
	    return;
	}
	if (userRepo.isEmailRegistered(email)) {
	    request.setAttribute("error", "Email is already registered.");
	    request.getRequestDispatcher("Register.jsp").forward(request, response);
	    return;
	}

	try {

	    String hashedPassword = PasswordConfig.hashPassword(password);

	    System.out.println("reg pass" + password);
	    userRepo.registerUser(userName, email, hashedPassword);

	    // 3. Success Response
	    // We use redirect here so if the user refreshes the page,
	    // it doesn't submit the form again (Post/Redirect/Get pattern).
	    HttpSession session = request.getSession();
	    session.setAttribute("regSuccess", "Registration successful! You can now login.");

	    // Redirect back to home
	    response.sendRedirect("home");
	    return;

	} catch (Exception e) {
	    e.printStackTrace();
	    request.setAttribute("error", "Registration failed.");
	    request.getRequestDispatcher("Register.jsp").forward(request, response);
	}
    }
}