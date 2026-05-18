package com.cheatsheet.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Properties;
import java.util.UUID;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Make sure your DBConnection utility matches your actual package path
import com.cheatsheet.utils.DBConnection;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handle displaying the page if accessed via GET
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    // Handle the form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String email = request.getParameter("email");
	HttpSession session = request.getSession();

	if (email == null || email.trim().isEmpty()) {
	    session.setAttribute("error", "Email field cannot be empty.");
	    response.sendRedirect("forgot-password.jsp");
	    return;
	}

	// 1. Generate unique random token and set 30-minute expiration timeframe
	String token = UUID.randomUUID().toString();
	Timestamp expiry = new Timestamp(System.currentTimeMillis() + (30 * 60 * 1000));

	// SQL query updates token only if the email actually exists in your system
	String sql = "UPDATE users SET reset_token = ?, token_expiry = ? WHERE email = ?";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    ps.setString(1, token);
	    ps.setTimestamp(2, expiry);
	    ps.setString(3, email.trim());

	    int rowsUpdated = ps.executeUpdate();

	    if (rowsUpdated > 0) {
		// 2. Build the absolute dynamic reset URL link targeting your reset-password
		// servlet
		String appUrl = request.getRequestURL().toString();
		String resetLink = appUrl.replace("forgot-password", "reset-password") + "?token=" + token;

		// 3. Dispatch the message over SMTP network wires
		sendResetEmail(email.trim(), resetLink);
	    }

	    // Security Best Practice: Always show a vague success message even if the email
	    // doesn't exist
	    // to prevent malicious hackers from harvesting active user email addresses.
	    session.setAttribute("success", "If that email matches an account, a secure reset link has been sent.");

	} catch (SQLException e) {
	    e.printStackTrace();
	    session.setAttribute("error", "An internal database error occurred. Please try again.");
	}

	response.sendRedirect("forgot-password.jsp");
    }

    // Separate transactional execution routing layer built explicitly for
    // javax.mail
    private void sendResetEmail(String toEmail, String resetLink) {
	// Change these to your actual active credentials
	final String fromEmail = "maungagkyawthu@gmail.com";
	final String appPassword = "guxs butt xzur dyfq"; // MUST use an App Password if using Gmail/Outlook
	final String smtpHost = "smtp.gmail.com";
	final String smtpPort = "587";

	Properties props = new Properties();
	props.put("mail.smtp.auth", "true");
	props.put("mail.smtp.starttls.enable", "true");
	props.put("mail.smtp.host", smtpHost);
	props.put("mail.smtp.port", smtpPort);
	props.put("mail.smtp.ssl.protocols", "TLSv1.2");

	// Session authentication context mapping via javax.mail namespaces
	Session session = Session.getInstance(props, new Authenticator() {
	    @Override
	    protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication(fromEmail, appPassword);
	    }
	});

	try {
	    Message message = new MimeMessage(session);
	    message.setFrom(new InternetAddress(fromEmail));
	    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
	    message.setSubject("Password Reset Request - CheatSheet Pro");

	    // Premium HTML rich layout structure for email inbox display layout
	    String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333; max-width: 600px; border: 1px solid #eee; border-radius: 8px;'>"
				 + "  <h2 style='color: #0f6fff; margin-bottom: 10px;'>Reset Your Password</h2>"
				 + "  <p>We received a request to reset your password for your CheatSheet Pro account. Click the button below to configure your new credentials:</p>"
				 + "  <div style='margin: 30px 0; text-align: center;'>"
				 + "    <a href='"
				 + resetLink
				 + "' style='background: linear-gradient(135deg, #0f6fff 0%, #12b981 100%); color: white; padding: 12px 25px; text-decoration: none; border-radius: 25px; font-weight: bold; display: inline-block; box-shadow: 0 4px 6px rgba(0,0,0,0.1);'>Reset Password</a>"
				 + "  </div>"
				 + "  <p style='color: #666; font-size: 0.9em;'><strong>Note:</strong> This temporary secure link is valid for the next 30 minutes only. If you did not make this request, you can safely ignore this email.</p>"
				 + "  <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>"
				 + "  <p style='font-size: 0.8em; color: #999;'>If the button above does not work, copy and paste this link directly into your browser URL taskbar:<br>"
				 + "  <a href='"
				 + resetLink
				 + "' style='color: #12b981;'>"
				 + resetLink
				 + "</a></p>"
				 + "</div>";

	    message.setContent(htmlContent, "text/html; charset=utf-8");

	    Transport.send(message);
	    System.out.println("Email processing completed successfully to: " + toEmail);

	} catch (MessagingException e) {
	    System.err.println("SMTP Network error: Unable to complete email transmission routing.");
	    e.printStackTrace();
	}
    }
}