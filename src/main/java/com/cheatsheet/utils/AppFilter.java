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

	// 1. Check Cookies for "Remember Me"
	if (user == null) {
	    Cookie[] cookies = req.getCookies();
	    if (cookies != null) {
		for (Cookie c : cookies) {
		    if ("remember_user".equals(c.getName())) {
			String userId = c.getValue();
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

	// 2. Clear Path Extraction Logic
	String path = req.getServletPath();
	System.out.println(path);

	// Check if the file requested is a static asset (CSS, JS, Images)
	boolean isStaticAsset = path.endsWith(".css") || path.endsWith(".js") || path.contains("/css/")
		|| path.contains("/js/") || path.contains("/images/");

	// Public pages that guests can access without authentication
	boolean isPublicPage = path.equals("/") || path.equals("/home") || path.equals("/register")
		|| path.equals("/login") || path.equals("/logout") || path.equals("/random-snippet")
		|| path.equals("/view") || path.equals("/live-search") || path.contains("/forgot-password")
		|| path.contains("/reset-password");

	boolean isAdminPage = path.equals("/admin-dashboard") || path.startsWith("/admin");

	// 3. Execution Processing Flow Strategy
	if (isStaticAsset || isPublicPage) {
	    chain.doFilter(request, response);
	} else if (user != null) {
	    if (isAdminPage) {
		if ("admin".equalsIgnoreCase(user.getRole())) {
		    chain.doFilter(request, response);
		} else {
		    session.setAttribute("authError", "Access Denied: Admin privileges required.");
		    res.sendRedirect(req.getContextPath() + "/home"); // Absolute redirect path
		}
	    } else {
		chain.doFilter(request, response);
	    }
	} else {
	    System.out.println("Intercepted unauthorized access to path: " + path);
	    session.setAttribute("error", "Login first!");
	    res.sendRedirect(req.getContextPath() + "/home"); // Absolute redirect path
	}
    }
}
