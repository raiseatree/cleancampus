<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	
		<!--- Make sure we run API calls through the API Token Checker in controller.cfc --->
		<cfset filters(through="checkAPIToken", only="add")>
	
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

</cfcomponent>