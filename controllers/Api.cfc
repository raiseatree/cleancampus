<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<cfset super.init()>
		
		<!--- Run all the API calls through the filter 
		<cfset filters(through="checkAPIToken", only="firstRun")>--->
		
	</cffunction>

	<cffunction name="firstRun">
	
		<!--- Make sure UDID was sent --->
		<cfif IsDefined("params.udid")>
			
			<!--- Check if we need to add the user (or if they're already in the DB)--->
			<cfset rtn.reporter = model("reporter").add(params)>
		
			<!--- Get list of universities --->
			<cfset rtn.universities = model("universities").findAll(order="uniName")>
			
			<!--- Get a list of problem types (for caching on the app) --->
			<cfset rtn.problemtypes = model("problemtype").findAll(order="typeLabel")>
		
			<!--- Get a list of problem effects (again for caching on the app) --->
			<cfset rtn.problemeffects = model("problemeffect").findAll(order="effectLabel")>
		
		<cfelse>
			<!--- No UDID sent - return error message --->
			<cfset rtn.result = false>
			<cfset rtn.message = "No UDID sent - please try again">
		</cfif>

		<!--- Check if we're dealing with JSON Format (EG Web service call) 
		<cfif IsDefined("params.format") AND params.format EQ 'json'>--->
			<cfset renderWith(rtn)>
		<!---<cfelse>
			<cfreturn rtn>
		</cfif>--->
		
	</cffunction>
	
</cfcomponent>