package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import connection.GetConnection;

public class ProfileServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("port_id") == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		String action = request.getParameter("action");
		String port_id = (String) session.getAttribute("port_id");

		try (Connection con = GetConnection.getCon()) {
			if ("update".equals(action)) {
				PreparedStatement ps = con
						.prepareStatement("UPDATE users SET password=?, location=?, name=?, email=? WHERE port_id=?");
				ps.setString(1, request.getParameter("password"));
				ps.setString(2, request.getParameter("location"));
				ps.setString(3, request.getParameter("name"));
				ps.setString(4, request.getParameter("email"));
				ps.setString(5, port_id);
				ps.executeUpdate();
				response.sendRedirect("profile.jsp?success=1");

			} else if ("delete".equals(action)) {
				PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE port_id=?");
				ps.setString(1, port_id);
				ps.executeUpdate();
				session.invalidate();
				response.sendRedirect("register.jsp?deleted=1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("profile.jsp?error=1");
		}
	}
}
