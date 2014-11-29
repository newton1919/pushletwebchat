<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
	name="viewport">
<title>Register user</title>
<link rel="stylesheet" href="html/css/bootstrap.min.css">
<link rel="stylesheet" href="html/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="html/css/font-awesome.css">
<link rel="stylesheet" href="html/css/style.css">


<script src="html/js/jquery-2.1.1.js" type="text/javascript"></script>
<script src="html/js/bootstrap.min.js" type="text/javascript"></script>
</head>
<body>
	<div class="login-wraper">
		<div class="login-container active">
			<div class="logo-brand">
				<a href="/"><i class="icon-windows"></i> <span><strong>register</strong></span></a>
			</div>
			<form id="login" role="form" autocomplete="on" method="post"
				action="register">
				<fieldset>
					<%
						if (request.getAttribute("error") != null) {
					%>
						<div class="alert alert-message alert-danger">
						<%=request.getAttribute("error")%>
						</div>
					<%
						}
					%>
					<div class="form-group">
						<div class="">
							<input class="form-control" type="text" id="userName" name="userName"
								placeholder="username" />
						</div>
					</div>
					<div class="form-group">
						<div class="">
							<input class="form-control" type="password" id="password"
								name="password" placeholder="password" />
						</div>
					</div>
					<div class="form-group">
						<div class="">
							<input class="form-control" type="password" id="password2"
								name="password2" placeholder="password again" /> <input type="submit"
								value="&#xf054;">
						</div>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
</body>
</html>