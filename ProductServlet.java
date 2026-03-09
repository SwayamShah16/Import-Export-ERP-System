package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import connection.GetConnection;

public class ProductServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		try (Connection con = GetConnection.getCon()) {
			if ("add".equals(action)) {
				PreparedStatement ps = con.prepareStatement(
						"INSERT INTO products(seller_port_id,product_name,description,quantity,price) VALUES(?,?,?,?,?)");
				ps.setString(1, request.getParameter("seller_port_id"));
				ps.setString(2, request.getParameter("product_name"));
				ps.setString(3, request.getParameter("description"));
				ps.setInt(4, Integer.parseInt(request.getParameter("quantity")));
				ps.setDouble(5, Double.parseDouble(request.getParameter("price")));
				ps.executeUpdate();
				response.sendRedirect("product.jsp?added=1");

			} else if ("update".equals(action)) {
				PreparedStatement ps = con.prepareStatement(
						"UPDATE products SET product_name=?, description=?, quantity=?, price=? WHERE product_id=?");
				ps.setString(1, request.getParameter("product_name"));
				ps.setString(2, request.getParameter("description"));
				ps.setInt(3, Integer.parseInt(request.getParameter("quantity")));
				ps.setDouble(4, Double.parseDouble(request.getParameter("price")));
				ps.setInt(5, Integer.parseInt(request.getParameter("product_id")));
				ps.executeUpdate();
				response.sendRedirect("product.jsp?updated=1");

			} else if ("delete".equals(action)) {
				PreparedStatement ps = con.prepareStatement("DELETE FROM products WHERE product_id=?");
				ps.setInt(1, Integer.parseInt(request.getParameter("product_id")));
				ps.executeUpdate();
				response.sendRedirect("product.jsp?deleted=1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("product.jsp?error=1");
		}
	}
}
