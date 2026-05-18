package com.cheatsheet.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Adjust this import path to match your actual project structure
import com.cheatsheet.utils.DBConnection;
import com.cheatsheet.utils.PasswordConfig;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 1. Handle displaying the form when the user clicks the link inside their
    // email
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String token = request.getParameter("token");
	HttpSession session = request.getSession();

	if (token == null || token.isBlank()) {
	    session.setAttribute("error", "Invalid or missing token link.");
	    response.sendRedirect("forgot-password.jsp");
	    return;
	}

	// Forward the request directly to your reset-password view form page
	request.getRequestDispatcher("reset-password.jsp").forward(request, response);
    }

    // 2. Handle updating the password when the form is submitted
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String token = request.getParameter("token");
	String newPassword = request.getParameter("password");
	HttpSession session = request.getSession();

	if (token == null || token.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
	    session.setAttribute("error", "All fields are required.");
	    response.sendRedirect("forgot-password.jsp");
	    return;
	}
	String hashCodedPassword = PasswordConfig.hashPassword(newPassword.trim());

	/*
	 * This query enforces two strict business rules simultaneously: - Matches the
	 * user based on the secret unique token string. - Ensures the current database
	 * system time is LESS than the stored token_expiry timestamp.
	 */
	String sql = "UPDATE users SET password = ?, reset_token = NULL, token_expiry = NULL "
		     + "WHERE reset_token = ? AND token_expiry > ?";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    // NOTE: If you hash your registration passwords (e.g., via BCrypt),
	    // make sure to hash 'newPassword' here before binding it!
	    ps.setString(1, hashCodedPassword);
	    ps.setString(2, token.trim());

	    // Pass the current server execution timestamp
	    ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

	    int rowsUpdated = ps.executeUpdate();

	    if (rowsUpdated > 0) {
		// Password was successfully updated and tokens were cleared
		session.setAttribute("success",
			"Password updated successfully! Please login with your new credentials.");
		response.sendRedirect("home"); // Adjust if your login page route is named differently
		return;
	    } else {
		// Token was either fake, already used once, or the 30-minute window closed
		session.setAttribute("error",
			"The password reset link is invalid or has expired. Please request a new one.");
	    }

	} catch (SQLException e) {
	    e.printStackTrace();
	    session.setAttribute("error", "An internal database validation error occurred.");
	}

	// If something goes wrong, bounce them back to the start of the recovery loop
	response.sendRedirect("forgot-password.jsp");
    }
}