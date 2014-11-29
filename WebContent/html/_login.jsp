<form id="login" role="form" autocomplete="on" method="post"
	action="login">
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
				<input class="form-control" type="text" id="userName"
					name="userName" placeholder="username" />
			</div>
		</div>
		<div class="form-group">
			<div class="">
				<input class="form-control" type="password" id="password"
					name="password" placeholder="password" /> <input type="submit"
					value="&#xf054;">
			</div>
		</div>
	</fieldset>
</form>