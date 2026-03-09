package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import connection.GetConnection;

public class OrderServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		try (Connection con = GetConnection.getCon()) {
			 if ("status".equals(action)) {
				PreparedStatement ps = con.prepareStatement("UPDATE orders SET status=? WHERE order_id=?");
				ps.setString(1, request.getParameter("status"));
				ps.setInt(2, Integer.parseInt(request.getParameter("order_id")));
				ps.executeUpdate();
				response.sendRedirect("orders.jsp?updated=1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("orders.jsp?error=1");
		}
	}
}
