package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import pojo.Report_pojo;

import java.sql.*;
import java.util.List;

import connection.GetConnection;
import dao.ReportDAO;

public class ReportServlet extends HttpServlet {
	
	private final ReportDAO dao = new ReportDAO();
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		try (Connection con = GetConnection.getCon()) {
			if ("add".equals(action)) {
				PreparedStatement ps = con.prepareStatement(
						"INSERT INTO reported_products(product_id,reporter_id,reason,status) VALUES(?,?,?,?)");
				ps.setInt(1, Integer.parseInt(request.getParameter("product_id")));
				ps.setString(2, request.getParameter("reporter_id"));
				ps.setString(3, request.getParameter("reason"));
				ps.setString(4, "open");
				ps.executeUpdate();
				response.sendRedirect("reports.jsp?added=1");

			} else if ("resolve".equals(action)) {
				PreparedStatement ps = con
						.prepareStatement("UPDATE reported_products SET status='resolved' WHERE report_id=?");
				ps.setInt(1, Integer.parseInt(request.getParameter("report_id")));
				ps.executeUpdate();
				response.sendRedirect("reports.jsp?resolved=1");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("reports.jsp?error=1");
		}
	}


private void view(HttpServletRequest req, HttpServletResponse resp, String seller)
        throws ServletException, IOException {
    int id = parseInt(req.getParameter("id"), 0);
    try {
        Report_pojo r = dao.findOne(id, seller);
        if (r == null) { resp.sendError(404); return; }
        req.setAttribute("report", r);
        req.getRequestDispatcher("/report_view.jsp").forward(req, resp);
    } catch (SQLException e) {
        throw new ServletException(e);
    }
}

private static int parseInt(String s, int def) {
    try { return Integer.parseInt(s); } catch (Exception e) { return def; }
}
private static String defaultStr(String s, String d) { return (s == null) ? d : s; }
}

