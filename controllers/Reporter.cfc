<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<!--- Declare that we provide multiple formats (HTML and JSON) --->
		<cfset provides("html,json")>
	
		<!--- Make sure we run API calls through the API Token Checker in controller.cfc --->
		<cfset filters(through="checkAPIToken", only="add,setPush")>
	
	</cffunction>

	<cffunction name="add">
		
		<cfif IsPost()>
		
			<!--- Call the Model Add method --->
			<cfset rtn = model("reporter").add( params )>
			
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Request was not a POST'>
		</cfif>
		
		<!--- Render the message back to the user --->
		<cfset renderWith(rtn)>
		
	</cffunction>

	<cffunction name="setPush">
	
		<!--- Create return --->
		<cfset local.rtn = StructNew()>
	
		<cfif IsDefined("params.ID") AND IsDefined("params.pushUUID")>
		
			<!--- Find the reporter --->
			<cfset reporterID = decrypt(params.ID, GetReporterKey(), "CFMX_COMPAT", "Hex")>
			<cfset reporter = model("reporter").findOneByID(reporterID)>
			
			<!--- Check if we found a reporter --->
			<cfif IsObject(reporter)>
				
				<!--- Update the reporter with their PUSH UUID --->
				<cfset result = reporter.update( pushUUID=params.pushUUID )>
				
				<!--- Check the result --->
				<cfif result EQ true>
					<cfset local.rtn.result = true>
					<cfset local.rtn.message = 'Updated PUSH UUID successfully'>
				<cfelse>
					<cfset local.rtn.result = false>
					<cfset local.rtn.message = 'Error updating PUSH UUID'>
				</cfif>
				
			<cfelse>
				<!--- Reporter not found --->
				<cfset local.rtn.result = false>
				<cfset local.rtn.message = 'Reporter ID not found'>
			</cfif>
			
		<cfelse>
			<!--- Incorrect params - return error --->
			<cfset local.rtn.result = false>
			<cfset local.rtn.message = 'Incorrect input params - need ID and pushUUID'>
		</cfif>
		
		<!--- Render how the user wants it --->
		<cfset renderWith(local.rtn)>
	
	</cffunction>

</cfcomponent>