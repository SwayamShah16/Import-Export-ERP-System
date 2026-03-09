<%@ page import="java.sql.*"%>
<%@ page import="connection.GetConnection"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%
HttpSession mySession = request.getSession(false);
if (mySession == null || mySession.getAttribute("port_id") == null) {
	response.sendRedirect("login.jsp");
	return;
}
String sellerId = (String) mySession.getAttribute("port_id");
%>
<!DOCTYPE html>
<html>
<head>
<title>Reported Products</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<style>
:root {
	--primary-color: #4e73df;
	--sidebar-width: 250px;
}

body {
	font-family: cursive;
	margin: 0;
	padding: 0;
}

body {
	background-repeat: no-repeat;
	background-size: cover;
	background-blend-mode: multiply;
	background-position: center;
	min-height: 100vh;
	padding-top: 80px;
	font-family: cursive;
}

.navbar {
	background: rgba(0, 0, 0, 0.7);
	backdrop-filter: blur(8px);
	position: fixed;
	top: 0;
	width: 100%;
	z-index: 1030;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

.navbar-brand img {
	height: 60px;
	transition: transform 0.3s;
}

.navbar-brand img:hover {
	transform: scale(1.1);
}

.navbar-brand, .nav-link {
	color: #fff !important;
	font-weight: 500;
}

.main-content .navbar {
	margin-left: 0; /* already handled by .main-content */
}

.sidebar {
	width: var(--sidebar-width);
	height: 100vh;
	position: fixed;
	left: 0;
	top: 0;
	background-color: var(--primary-color);
	color: white;
	transition: all 0.3s;
	z-index: 1000;
}

.sidebar-header {
	padding: 1.5rem;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.sidebar-menu {
	padding: 1rem 0;
}

.sidebar-menu .nav-link {
	color: rgba(255, 255, 255, 0.8);
	padding: 0.75rem 1.5rem;
	margin-bottom: 0.5rem;
	border-left: 3px solid transparent;
}

.sidebar-menu .nav-link:hover, .sidebar-menu .nav-link.active {
	color: white;
	background-color: rgba(255, 255, 255, 0.1);
	border-left: 3px solid white;
}

.sidebar-menu .nav-link i {
	margin-right: 10px;
	font-size: 1.1rem;
}

.main-content {
	margin-left: var(--sidebar-width);
	min-height: 100vh;
	transition: all 0.3s;
	background-color: #f8f9fc;
}

@media ( max-width : 768px) {
	.sidebar {
		margin-left: -250px;
	}
	.sidebar.active {
		margin-left: 0;
	}
	.main-content {
		margin-left: 0;
	}
	.main-content.active {
		margin-left: 250px;
	}
}

.card {
	border-radius: 16px;
	background: rgba(255, 255, 255, 0.95);
	transition: 0.3s;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.card:hover {
	transform: scale(1.03);
	box-shadow: 0 12px 25px rgba(0, 0, 0, 0.25);
}

button.btn-danger {
	background: linear-gradient(135deg, #ff4d4d, #ff1a1a);
	border: none;
	transition: transform 0.2s, box-shadow 0.2s;
}

button.btn-danger:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

button.btn-success {
	background: linear-gradient(135deg, #4CAF50, #2E7D32);
	border: none;
	transition: transform 0.2s, box-shadow 0.2s;
}

button.btn-success:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

table {
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

table thead {
	background: linear-gradient(90deg, #ff4d4d, #ff1a1a);
	color: #fff;
}

table tbody td:hover {
	background-color: cornsilk;
	transition: 0.2s;
	border-radius: cover;
	padding: 10px;
}

h3 {
	text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
	color: #fff;
}

a.btn-secondary {
	background: linear-gradient(135deg, #757575, #424242);
	border: none;
	color: #fff;
	transition: transform 0.2s, box-shadow 0.2s;
}

a.btn-secondary:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}
</style>

</head>
<body>
	<!-- Sidebar -->
	<div class="sidebar" id="sidebar">
		<div
			class="sidebar-header d-flex justify-content-between align-items-center">
			<h4 class="mb-0">Seller Dashboard</h4>
			<button class="btn btn-sm btn-outline-light d-md-none"
				id="sidebarToggle">
				<i class="bi bi-x"></i>
			</button>
		</div>
		<div class="sidebar-menu">
			<ul class="nav flex-column">
				<li class="nav-item"><a class="nav-link " href="product.jsp">
						<i class="bi bi-speedometer2"></i> Products
				</a></li>
				<li class="nav-item"><a class="nav-link" href="orders.jsp">
						<i class="bi bi-cart3"></i> Orders
				</a></li>
				<li class="nav-item"><a class="nav-link active"
					href="reports.jsp"> <i
						class="bi bi-exclamation-triangle"></i> Reported Products
				</a></li>
				<li class="nav-item"><a class="nav-link" href="profile.jsp">
						<i class="bi bi-person"></i> Profile
				</a></li>
				<li class="nav-item"><a class="nav-link " href="aiml.jsp">
						<i class="bi bi-robot"></i> Artificial Intelligence
				</a></li>
				<li class="nav-item"><a class="nav-link " href="chatbot.jsp">
						<i class="bi bi-chat-dots"></i> Chatbot
				</a></li>

			</ul>
		</div>
	</div>
	<!-- Navbar -->
	<div class="main-content">
		<nav class="navbar navbar-expand-lg">
			<div class="container-fluid text-center">
				<a class="navbar-brand" href="profile.jsp"> TechnoTronics </a> <span
					class="me-3 text-white">Logged in: <b class="bi bi-person">
						<%=sellerId%></b></span>
				<form action="UserServlet" method="post">
					<input type="hidden" name="action" value="logout">
					<button class="btn btn-light btn-sm">Logout</button>
				</form>

			</div>
		</nav>



		<div class="container py-4 text-center">
			<h3 class="mb-3 text-dark text-bold text-center">Reported
				Products</h3>

			<!-- Report Form -->
			<div class="card p-3 mb-4">
				<form action="ReportServlet" method="post" class="row g-2">
					<input type="hidden" name="action" value="add">
					<div class="col-md-2">
						<input type="number" class="form-control" name="product_id"
							placeholder="Product ID" required>
					</div>
					<div class="col-md-3">
						<input class="form-control" name="reporter_id"
							placeholder="Reporter ID" required>
					</div>
					<div class="col-md-5 text-highlight ">
						<input class="form-control" name="reason" placeholder="Reason">
					</div>
					<div class="col-md-2">
						<button class="btn btn-danger w-100">Report</button>
					</div>
				</form>
			</div>

			<!-- Reported Products Table -->
			<table class="table table-striped table-bordered bg-white">
				<thead>
					<tr>
						<th>Report ID</th>
						<th>Product ID</th>
						<th>Reporter</th>
						<th>Reason</th>
						<th>Status</th>
						<th>Actions</th>

					</tr>
				</thead>
				<tbody>
					<%
					try (Connection con = GetConnection.getCon()) {
						PreparedStatement ps = con.prepareStatement(
						"SELECT * FROM reported_products WHERE product_id IN (SELECT product_id FROM products WHERE seller_port_id=?) ORDER BY report_id DESC");
						ps.setString(1, sellerId);
						ResultSet rs = ps.executeQuery();
						while (rs.next()) {
					%>
					<tr>
						<td><%=rs.getInt("report_id")%></td>
						<td><%=rs.getInt("product_id")%></td>
						<td><%=rs.getString("reporter_id")%></td>
						<td><%=rs.getString("reason")%></td>
						<td><%=rs.getString("status")%></td>
						<td class="d-flex text-center">
							<form action="ReportServlet" method="post">
								<input type="hidden" name="action" value="resolve"> <input
									type="hidden" name="report_id"
									value="<%=rs.getInt("report_id")%>">
								<button class="btn btn-success btn-sm"
									<%="resolved".equals(rs.getString("status")) ? "disabled" : ""%>>
									Resolved</button>
							</form>
						</td>
					</tr>
					<%
					}
					} catch (Exception e) {
					e.printStackTrace();
					}
					%>
				</tbody>
			</table>


		</div>
		<footer class="text-center mt-5 pt-4 pb-3 "">
			<!-- place footer here -->
			&copy; TechnoTronics Company Pvt Ltd. All rights reserved.
		</footer>
	</div>
</body>
</html>
