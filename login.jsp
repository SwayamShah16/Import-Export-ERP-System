<!DOCTYPE html>
<html>
<head>
<title>Login-Secure Portal</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
    font-family:cursive;
    background-color: beige;
	background-repeat: no-repeat;
	background-size: cover;
	background-position: center;
	min-height: 90%;
}
</style>
</head>
<body>
	<div class="container">
		<div class="row min-vh-100 d-flex justify-content-center align-items-center">
			<div class="col-md-4">
				<div class="card p-4 rounded-4 ">
					<h3 class="mb-3 text-center">Login</h3>
					<form action="UserServlet" method="post">
						<input type="hidden" name="action" value="login">
						<div class=" form-floating mb-3">
							<input type="text" class="form-control" name="port_id"
								placeholder="" /> <label for="port_id">Port ID</label>

						</div>
						<div class=" form-floating mb-3">
							<input type="password" class="form-control" name="password"
								placeholder="" /> <label for="password">Password</label>
						</div>
						<button class="btn btn-success w-100">Login</button>
					</form>
					<div class="text-center mt-3">
						New user? <a href="register.jsp">Register</a>
					</div>
					<%
					if ("1".equals(request.getParameter("error"))) {
					%>
					<div class="alert alert-danger mt-3">Invalid Port ID or
						Password</div>
					<%
					}
					%>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
