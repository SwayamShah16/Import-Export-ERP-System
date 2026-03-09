<!DOCTYPE html>
<html>
<head>
<title>Registration</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	font-family: cursive; background-color : beige;
	background-repeat: no-repeat;
	background-size: cover;
	background-position: center;
	min-height: 90vh;
	background-color: beige;
}
</style>
</head>
<body class="d-flex align-items-center">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-md-5">
				<div class="card shadow p-4 rounded-4">
					<h3 class="mb-3 text-center">Registration</h3>
					<form action="UserServlet" method="post">
						<input type="hidden" name="action" value="register">
						<div class="form-floating my-3">
							<input type="text" class="form-control" name="port_id"
								id="formId1" placeholder="" /> <label
								for="formId1">Port ID</label>
						</div>
						<div class="form-floating my-3">
							<input type="password" class="form-control" name="password"
								id="formId1" placeholder="" /> <label
								for="password">Password</label>
						</div>
						<div class="form-floating my-3">
							<input type="text" class="form-control" name="location"
								id="formId1" placeholder="" /> <label
								for="formId1">Location</label>
						</div>
						<div class="form-floating my-3">
							<input type="text" class="form-control" name="Name" id="formId1"
								placeholder="" /> <label for="formId1">Name</label>
						</div>
						<div class="form-floating my-3">
							<input type="email" class="form-control" name="email"
								id="formId1" placeholder="" /> <label
								for="formId1">Email</label>
						</div>
						<button class="btn btn-primary w-100">Register</button>
					</form>
					<div class="text-center mt-3">
						Already have an account? <a href="login.jsp">Login</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
