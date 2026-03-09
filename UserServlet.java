package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import connection.GetConnection;

public class UserServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		try (Connection con = GetConnection.getCon()) {
			if ("register".equals(action)) {
				PreparedStatement ps = con.prepareStatement("INSERT INTO users VALUES(?,?,?,?,?)");
				ps.setString(1, request.getParameter("port_id"));
				ps.setString(2, request.getParameter("password")); 
				ps.setString(3, request.getParameter("location"));
				ps.setString(4, request.getParameter("name"));
				ps.setString(5, request.getParameter("email"));
				ps.executeUpdate();
				response.sendRedirect("login.jsp?registered=1");

			} else if ("login".equals(action)) {
				PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE port_id=? AND password=?");
				ps.setString(1, request.getParameter("port_id"));
				ps.setString(2, request.getParameter("password"));
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
					HttpSession session = request.getSession();
					session.setAttribute("port_id", rs.getString("port_id"));
					response.sendRedirect("profile.jsp");
				} else {
					response.sendRedirect("login.jsp?error=1");
				}
			} else if ("logout".equals(action)) {
				HttpSession session = request.getSession(false);
				if (session != null)
					session.invalidate();
				response.sendRedirect("login.jsp");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("login.jsp?error=2");
		}
	}
}
