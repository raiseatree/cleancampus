<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	
		<!--- Associations --->
		<cfset belongsTo("university")>
		<cfset belongsTo("problemtype")>
		<cfset belongsTo("problemeffect")>
		<cfset belongsTo("reporter")>
		<cfset belongsTo("status")>
		
		<cfset hasMany("problemcomment")>
	
	</cffunction>

	<cffunction name="sendEmails" hint="Sends emails to the relavant people after problem is created">
	
		<!--- Create a return struct --->
		<cfset rtn = StructNew()>
	
		<!--- Load all the users to be alerted --->
		<cfset users = model("user").findAll(
				where="universityID=#this.universityID# AND problemTypeID=#this.problemTypeID#", 
				include="userproblemtype(problemtype)")>

		<!--- Loop through the users and send them each an email --->
		<cfloop query="users">
		
			<cfmail to="#users.email#" from="#LoadEmailFrom()#" subject="#LoadSiteTitle()# - New Problem" type="html">
				<p>A new problem has been reported on your campus and you have been assigned!</p>
				<p><img src="#LoadSiteURL()#/images/dropzone/#this.image#"></p>
				<p>Please log in to #LoadSiteTitle()# to view full details of the problem and to action it.</p>
				<p><a href="#LoadSiteURL()#">#LoadSiteTitle()# Login</a></p>
			</cfmail>
		
		</cfloop>
		
		<!--- If we sent it to at least one person the problem has been assigned --->
		<cfif users.RecordCount GT 0>
			<cfset rtn.status = 'assigned'>
		</cfif>
		
		<cfreturn rtn>
	
	</cffunction>

</cfcomponent>