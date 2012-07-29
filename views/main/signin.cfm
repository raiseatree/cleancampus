<cfparam name="data">
<cfoutput>
	
<section id="main">
	<h1>Welcome to Clean Campus</h1>
	<div class="mapIndex">
		<div class="signIn">
			<div class="register">
				<h2>About Clean Campus</h2>
				<h3>Clean Campus is revolutionising the way problems are reported, monitored and fixed across campus.</h3>
				<h3>Sign up on the right to receive updates on our quest to make universities around the world cleaner.</h3>
				<a href="##" class="inactiveButton">Learn More</a>
				<a href="##" id="register" class="activeButton">Register</a>
			</div>
			<div class="login">
				<h2>Login</h2>
				#startFormTag(controller="user", action="login")#
					#errorMessagesFor("data.user")#
					<p>#textField(objectName="data.user", property="email", label="", class="textfield", placeholder="Email Address")#</p>
					<p>#passwordField(objectName="data.user", property="password", label="", class="textfield", placeholder="Password")#</p>
					<p>#checkboxTag(name="cookie", label="Remember Me", labelPlacement="after", class="checkbox")#</p>
					<p>#submitTag(name="submit", class="activeButton loginButton", value="Sign In")#</p>
				#endFormTag()#
			</div>
		</div>
	</div>
</section>
</cfoutput>