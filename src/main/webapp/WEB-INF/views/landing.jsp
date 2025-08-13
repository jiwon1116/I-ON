<%@ page contentType="text/html;charset=UTF-8"%>
<%
String ctx = request.getContextPath();
%>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Instant</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
	background: #0b0705;
	color: #fff
}

.cta {
	position: fixed;
	top: 16px;
	right: 16px
}
</style>
</head>
<body>
	<a class="btn btn-warning btn-sm cta" href="<%=ctx%>/login">Get Started</a>

	<div class="container text-center mt-5">
		<h1 class="display-5 fw-bold">
			Transform Your Workflow With <span style="text-decoration: underline">Advanced Analytics</span>
		</h1>
		<p class="mt-3 text-secondary">Our platform helps you enhance productivity…</p>

		<div class="mt-4">
			<a class="btn btn-warning btn-lg" href="${pageContext.request.contextPath}/login">Get Started</a> <a class="btn btn-outline-light btn-lg ms-2" href="#demo">Watch a Quick Demo</a>
		</div>
	</div>
</body>
</html>
