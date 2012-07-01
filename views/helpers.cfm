<cffunction name="loadLoggedInHeader">
	<cfoutput>
		<!--- Display logged-in header, if logged in --->
		<cfif IsUserLoggedIn()>
			<header class="topNav">
				#linkTo(route="home", text="Home", class="homeLink")#
				#linkTo(controller="account", action="index", text="Manage Account", class="homeLink last")#
				<div class="loginStatus">Logged in as <span class="green"><strong>#GetAuthUser()#</strong></span> - #linkTo(route="logout", text="logout")#</a></div>
			</header>
		</cfif>	
	</cfoutput>
</cffunction>
