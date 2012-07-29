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

<cffunction name="showProblems">
	<cfargument name="data" type="any" required="yes">
	<cfargument name="colour" type="string" required="yes">
	<cfargument name="showDetail" type="boolean" required="yes">

	<cfoutput>
	
		<cfif ARGUMENTS.data.RecordCount GT 0>
			<cfloop query="ARGUMENTS.data">
				<div class="overflow problem">
					<h2 class="itemTitle overflow"><a href="##" class="tag #ARGUMENTS.colour#">#typeLabel#</a> <span class="fr">#timeAgoInWords(createdAt)# ago</span></h2>
					<p><cfif IsDefined("image") AND image GT '' AND FileExists('/images/dropzone/#image#')><a href="/images/dropzone/#image#" class="lightbox">#imageTag(source='dropzone/thumbs/#image#', class="dashImage")#</a><cfelse>#imageTag(source='no-image.png', class="dashImage")#</cfif> #description#</p>
					<p class="itemMap">
						<span>Click map to enlarge</span>
						<a href="http://maps.googleapis.com/maps/api/staticmap?maptype=satellite&center=#latitude#,#longitude#&zoom=17&&size=320x240&scale=2&markers=color:red%7C#latitude#,#longitude#&sensor=false" class="lightbox">
							<img src="http://maps.googleapis.com/maps/api/staticmap?center=#latitude#,#longitude#&zoom=15&&size=490x100&markers=color:red%7C#latitude#,#longitude#&sensor=false">
						</a>
					</p>
					<cfif ARGUMENTS.showDetail EQ true>
						<p class="cb overflow">
							#linkTo(controller="problem", action="investigate", params="ID=#ID#", text="View Problem", class="fl activeButton")#
						</p>
					<cfelse>
						<p class="cb overflow">
							<a href="##" class="fl activeButton fixButton">Fix Problem</a>
							<!---<cfif ARGUMENTS.data.statusLabel EQ 'Unassigned'>
								<a href="##" class="fl amberButton assignButton">Assign Problem</a>
							</cfif>--->
							<a href="##" class="fl redButton rejectButton">Reject Problem</a>
							<!---<a href="##" class="fr inactiveButton addComment">Add Comment</a>--->
						</p>
					</cfif>
				</div>
			</cfloop>
		<cfelse>
			<p>WooHoo! No problems in this category right now.</p>
		</cfif>
	
	</cfoutput>


</cffunction>