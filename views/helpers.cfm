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

<cffunction name="loadImage" hint="Processes and converts images from the DB byte array for displaying">
	<cfargument name="image" type="any" required="yes">
	
	<cfif IsArray(ARGUMENTS.image)>
		<cfset tmp.fileName = CreateUUID() & '.jpg'>
		<cfset fullPath = ExpandPath("images/temp/") & tmp.fileName>
		
		<cffile action="write" file="#fullPath#" output="#ARGUMENTS.image#" addNewLine="Yes" nameconflict="overwrite" />

	<cfelse>
		<cfset tmp.fileName = 'no-image.png'>
	</cfif>
	
	<cfoutput>
		<a href="/images/temp/#tmp.fileName#" class="lightbox">#imageTag(source='temp/#tmp.fileName#', class="dashImage")#</a>
	
	</cfoutput>
	
</cffunction>
