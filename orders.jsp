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
<title>Orders</title>
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
	background-size: cover;
	background-position: center;
	background-repeat: no-repeat;
	min-height: 100vh;
	padding-top: 80px;
	font-family: cursive;
}

.navbar {
	background: rgba(0, 0, 0, 0.75);
	backdrop-filter: blur(6px);
	position: fixed;
	top: 0;
	width: 100%;
	z-index: 1030;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
}

.navbar-brand img {
	height: 60px;
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

h3 {
	color: white;
	text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6);
	font-weight: 600;
}

.card {
	border-radius: 15px;
	background: rgba(255, 255, 255, 0.95);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
}

table {
	border-radius: 8px;
	overflow: hidden;
}

tr:nth-child(odd) {
	background-color: grey;
}

tr:nth-last-child(even) {
	background-color: white;
}

thead th {
	background-color: #212529;
	color: white;
}

table tbody td:hover {
	background-color: cornsilk;
	transition: 0.2s;
	border-radius: cover;
	padding: 10px;
}

.form-label {
	font-weight: 600;
}

.btn-success {
	font-weight: 500;
}

.btn-success:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.btn-warning {
	font-weight: 500;
}

.btn-warning:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.btn-secondary {
	font-weight: 500;
}

.btn-secondary:hover {
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
				<li class="nav-item"><a class="nav-link active"
					href="orders.jsp"> <i class="bi bi-cart3"></i> Orders
				</a></li>
				<li class="nav-item"><a class="nav-link" href="reports.jsp">
						<i class="bi bi-exclamation-triangle"></i> Reported Products
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
	<div class="main-content">
		<!-- Navbar -->
		<nav class="navbar navbar-expand-lg">
			<div class="container-fluid text-center">
				<a class="navbar-brand" href="profile.jsp"> TechnoTronics </a> <span
					class="me-3 text-white">Logged in:  <b class="bi bi-person"> <%=sellerId%></b></span>
				<form action="UserServlet" method="post">
					<input type="hidden" name="action" value="logout">
					<button class="btn btn-light btn-sm">Logout</button>
				</form>

			</div>
		</nav>


		<div class="container py-4">
			<h3 class="mb-4 text-center text-dark">Orders</h3>



			<!-- Orders Table -->
			<div class="card p-3">
				<table class="table table-striped table-bordered mb-0 text-center">
					<thead class="table-dark">
						<tr>
							<th>ID</th>
							<th>Buyer</th>
							<th>Total</th>
							<th>Status</th>
							<th>Address</th>
							<th>Update</th>
						</tr>
					</thead>
					<tbody>
						<%
						try (Connection con = GetConnection.getCon()) {
							PreparedStatement ps = con.prepareStatement("SELECT * FROM orders WHERE seller_port_id=? ORDER BY order_id DESC");
							ps.setString(1, sellerId);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
						%>
						<tr>
							<td><%=rs.getInt("order_id")%></td>
							<td><%=rs.getString("buyer_id")%></td>
							<td><%=rs.getDouble("total_amount")%></td>
							<td><%=rs.getString("status")%></td>
							<td><%=rs.getString("delivery_address")%></td>
							<td>
								<form action="OrderServlet" method="post" class="d-flex gap-2">
									<input type="hidden" name="action" value="status"> <input
										type="hidden" name="order_id"
										value="<%=rs.getInt("order_id")%>"> <select
										class="form-select form-select-sm" name="status">
										<option
											<%="pending".equals(rs.getString("status")) ? " selected" : ""%>>pending</option>
										<option
											<%="shipped".equals(rs.getString("status")) ? " selected" : ""%>>shipped</option>
										<option
											<%="delivered".equals(rs.getString("status")) ? " selected" : ""%>>delivered</option>
										<option
											<%="cancelled".equals(rs.getString("status")) ? " selected" : ""%>>cancelled</option>
									</select>
									<button class="btn btn-warning btn-sm">Save</button>
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

			
		</div>
		<footer class="text-center mt-5 pt-4 pb-3 "">
			<!-- place footer here -->
			&copy; TechnoTronics Company Pvt Ltd. All rights reserved.
		</footer>
		<script
			src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
			integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
			crossorigin="anonymous"></script>

		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"
			integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+"
			crossorigin="anonymous"></script>

	</div>
</body>
</html>
