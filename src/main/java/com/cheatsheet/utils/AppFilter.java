package com.cheatsheet.utils;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.model.UserBean;
import com.cheatsheet.repository.UserRepository;

@WebFilter("/*")
public class AppFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
	    throws IOException, ServletException {

	HttpServletRequest req = (HttpServletRequest) request;
	HttpServletResponse res = (HttpServletResponse) response;
	HttpSession session = req.getSession();

	UserBean user = (UserBean) session.getAttribute("user");
	// 1. If user is NOT in session, check Cookies for "Remember Me"
	if (user == null) {
	    Cookie[] cookies = req.getCookies();
	    if (cookies != null) {
//		System.out.println("is cookies error");
		for (Cookie c : cookies) {
//		    System.out.println("cookie" + c.getName());
		    if ("remember_user".equals(c.getName())) {
			String userId = c.getValue();
//			System.out.println("filter" + userId);

			// Call your repository to get the user by ID
			UserRepository repo = new UserRepository();
			user = repo.getUserById(userId);

			if (user != null) {
			    session.setAttribute("user", user);
			}
			break;
		    }
		}
	    }
	}

	// 2. Security Logic: Protect specific pages
	String path = req.getServletPath();

	// Allow access to home, CSS, JS, and Login/Register without being logged in
	boolean isPublicPage = path.equals("/home") || path.endsWith(".css") || path.endsWith(".js")
		|| path.equals("/register") || path.equals("/login");

	if (isPublicPage || user != null) {
	    chain.doFilter(request, response); // Allow access
	} else {
	    session.setAttribute("error", "Please login first!");
	    res.sendRedirect("home"); // Kick back to home to show login popup
	}
    }
}
