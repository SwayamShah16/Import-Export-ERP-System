<%@ page import="java.sql.*"%>
<%@ page import="connection.GetConnection"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>

<%
HttpSession mySession = request.getSession(false);
if (mySession == null || mySession.getAttribute("port_id") == null) {
	response.sendRedirect("login.jsp?error=Session expired,Please Login Again");
	return;
}
String sellerId = (String) mySession.getAttribute("port_id");
%>
<!DOCTYPE html>
<html>
<head>
<title>Profile</title>
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

body.maincontent {
	background-color: beige;
	background-size: cover;
	background-position: center;
	min-height: 100vh;
	padding-top: 80px;
	font-family: cursive
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
}

.card {
	border-radius: 12px;
	background: rgba(255, 255, 255, 0.95);
	transition: transform 0.2s ease, box-shadow 0.2s ease;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.card:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
}

.form-label {
	font-weight: 600;
}

.btn-warning {
	background-color: #ff9800;
	border: none;
	font-weight: 500;
}

.btn-warning:hover {
	background-color: #e68900;
}

.btn-danger {
	font-weight: 600;
}

.btn-secondary {
	font-weight: 500;
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
				<li class="nav-item"><a class="nav-link" href="reports.jsp">
						<i class="bi bi-exclamation-triangle"></i> Reported Products
				</a></li>
				<li class="nav-item"><a class="nav-link active"
					href="profile.jsp"> <i class="bi bi-person"></i> Profile
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
					class="me-3 text-white">Logged in: <b class="bi bi-person"> <%=sellerId%></b></span>
				<form action="UserServlet" method="post">
					<input type="hidden" name="action" value="logout">
					<button class="btn btn-light btn-sm">Logout</button>
				</form>

			</div>
		</nav>




		<div class="container py-5">
			<h3 class="mb-4 text-center text-dark mt-4">Profile</h3>
			<%
			try (Connection con = GetConnection.getCon()) {
				PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE port_id=?");
				ps.setString(1, sellerId);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
			%>
			<div class="row justify-content-center">
				<div class="col-md-6">
					<!-- Update Profile Card -->
					<div class="card p-4 mb-3">
						<h5 class="mb-3 text-center">Profile</h5>
						<form action="ProfileServlet" method="post" class="text-center">
							<input type="hidden" name="action" value="update">
							<div class=" form-floating mb-2">
								<input type="password" class="form-control" name="password"
									id="formId1" placeholder=""
									value="<%=rs.getString("password")%>" /> <label for="password">Password</label>
							</div>
							<div class="form-floating mb-2">
								<input type="location" class="form-control" name="location"
									id="formId1" placeholder=""
									value="<%=rs.getString("location")%>" /> <label for="location">Location</label>
							</div>
							<div class="form-floating mb-2">
								<input type="text" class="form-control" name="name" id="name"
									placeholder="" value="<%=rs.getString("name")%>" /> <label
									for="name">Name</label>
							</div>
							<div class="form-floating mb-3">
								<input type="email" class="form-control" name="email" id="email"
									placeholder="" value="<%=rs.getString("email")%>" /> <label
									for="email">Email</label>
							</div>

							<div class="d-flex justify-content-center gap-2 mb-2">
								<button class="btn btn-success">Save Changes</button>
							</div>
						</form>
						<div class="text-center">
							<form action="ProfileServlet" method="post"
								class="text-center justify-content-center mb-2"
								onsubmit="return confirm('Delete your account? This cannot be undone!')">
								<input type="hidden" name="action" value="delete">
								<button class="btn btn-warning w-30">Delete Account</button>
							</form>

							<form action="UserServlet" method="post"
								class="text-center justify-content-center mb-2"
								onsubmit="return confirm('Logout your Account?')"
								class=" d-inline">
								<input type="hidden" name="action" value="logout">
								<button class="btn btn-danger w-30">Logout</button>
							</form>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			} catch (Exception e) {
			e.printStackTrace();
			}
			%>
		</div>
		<footer class="text-center pt-4 pb-3 "">
			<!-- place footer here -->
			&copy; TechnoTronics Company Pvt Ltd. All rights reserved.
		</footer>
	</div>
</body>
</html>
